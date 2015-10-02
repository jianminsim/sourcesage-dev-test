/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.app.Fragment;

import com.nelaupe.qanda.MainActivity;

import fr.nelaupe.NavigationFragmentHandler;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public abstract class BaseFragment extends Fragment {

    public NavigationFragmentHandler<Fragment> navigationFragmentHandler() {
        return activity().getNavigationHandler();
    }

    public MainActivity activity() {
        return (MainActivity) getActivity();
    }

}
