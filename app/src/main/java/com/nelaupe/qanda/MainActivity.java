package com.nelaupe.qanda;

import android.app.Fragment;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;

import com.nelaupe.qanda.fragment.MainFragment;

import fr.nelaupe.NavigationFragmentHandler;

public class MainActivity extends AppCompatActivity {

    private NavigationFragmentHandler<Fragment> mNavigationHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mNavigationHandler = new NavigationFragmentHandler<>(this, R.id.content);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (savedInstanceState == null) {
            // Prevent rotation
            mNavigationHandler.showMain(new MainFragment());
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public NavigationFragmentHandler<Fragment> getNavigationHandler() {
        return mNavigationHandler;
    }

    @Override
    public void onBackPressed() {
        if (mNavigationHandler.getDeepness() == 0) {
            super.onBackPressed();
        } else {
            mNavigationHandler.popCurrentFragment();
        }
    }

}