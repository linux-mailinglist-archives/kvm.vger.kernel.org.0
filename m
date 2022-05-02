Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD3517AD1
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiEBXfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiEBXcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:32:04 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357CF220E2
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:28:26 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 15so12785453pgf.4
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rPjrDRwO5KosjOnImj/z4MRletegr75jesrITgtYrUU=;
        b=gFxJyjPHuwDa5lBExgWcs+YKNOQlm6CUSphgINWc4WpJzZa3qBx4cQ7BsJNMiwwddJ
         4CdOrqQcPaoyHWmVnyBqYK4a8YCi4+muCTF39LdI4fLoqEXN7aBEFW20Ck7Jf30lSTkz
         lyEIZkj5QN0uxByrLxqyezJi/Qa1HVv1WY8dtHMN3vsYmjwf1y2F8XTc/lthWZ2ZSmZZ
         Ktqvw0aLuI83/M4+atr8uv1ur/MdhwOsD7lhKdtPKL7U3J1yHE6Wh0qeDwN5cKATeQNa
         P05/k4WPWd25BanQR7zdY9baAxrVvZ/PyscborBSpbe6UzxHklvd7X/msYXJLvE9D23Q
         JSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rPjrDRwO5KosjOnImj/z4MRletegr75jesrITgtYrUU=;
        b=VnJeXB2ZUY7JXt6vVxncZ5AH+RFsU5GkO2Ovw8pIXcZTw7VKAQygy1Mc8PkRzcXFS5
         zeHmW+B7co5ky3IYewAgB5k9cOPKjNrA04PZDm/rNpQegQoXytZznL1XaDsKd+bOWMs7
         JP/i+J6qgfczqXXis21ZrGdvHHlMVP4gZsd8aIzbmS95GOWKtnyHLJsAj7u8uAdHkldd
         Kvwv5AwA1qQ3o9sP91TJCgWCj+qqraMPqnTD00ppazFrtPEBhgK4YERb9YTHgiBecpI+
         KJ2XbAQRwL+Jskkgoj07Vw6P0I3KPrNGIhLlBXc1iFzWl3JRqPoIHxM6TlbLHfn7JS4T
         Zmjw==
X-Gm-Message-State: AOAM533Dzt6ncf/jxVGOfe5BAYfJQlCAuuiozVOFgUEFw+iDn1M0z0yS
        fnLvRQEX19j3vQKcjL6BImX+CA==
X-Google-Smtp-Source: ABdhPJztP6F/Csi8V/RgbaPSInH7tj//E/cf+Ts8PKujPxb0JSDPDzUTtUzy1cWZXlxuCsPuWgP8sg==
X-Received: by 2002:a63:f44f:0:b0:3c1:ed4f:b066 with SMTP id p15-20020a63f44f000000b003c1ed4fb066mr8903508pgk.334.1651534104724;
        Mon, 02 May 2022 16:28:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m67-20020a632646000000b003c14af505f1sm12226714pgm.9.2022.05.02.16.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 16:28:24 -0700 (PDT)
Date:   Mon, 2 May 2022 23:28:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Break the 'vmx' monolith into
 multiple tests
Message-ID: <YnBpFIo5pnZWAuj1@google.com>
References: <20220502164004.1298575-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502164004.1298575-1-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022, Aaron Lewis wrote:
> Break 'vmx' into multiple tests to reduce the number of tests run at
> once.  This will help get a better signal up front on failure with them
> broken up into categories.  This will also do a better job of not
> disguising new failures if one of the tests is already failing.
> 
> One side effect of breaking this test up is any new test added will
> have to be manually added to a categorized test.  It will not
> automatically be picked up by 'vmx'.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/unittests.cfg | 42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index b48c98b..0d90413 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -254,13 +254,49 @@ extra_params = -cpu qemu64,+umip
>  file = la57.flat
>  arch = i386
>  
> -[vmx]
> +[vmx_legacy]
>  file = vmx.flat
> -extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
> +extra_params = -cpu max,+vmx -append "null vmenter preemption_timer control_field_PAT control_field_EFER CR_shadowing I/O_bitmap instruction_intercept EPT_A/D_disabled EPT_A/D_enabled PML interrupt nmi_hlt debug_controls MSR_switch vmmcall disable_RDTSCP int3 into invalid_msr"
>  arch = x86_64
>  groups = vmx
>  
> -[ept]
> +[vmx_basic]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "v2_null_test v2_multiple_entries_test fixture_test_case1 fixture_test_case2"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_vm_entry]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_controls_test vmx_host_state_area_test vmx_guest_state_area_test vmentry_movss_shadow_test vmentry_unrestricted_guest_test"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_apic]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_eoi_bitmap_ioapic_scan_test vmx_hlt_with_rvi_test vmx_apic_passthrough_test vmx_apic_passthrough_thread_test vmx_sipi_signal_test"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_regression]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_ldtr_test vmx_cr_load_test vmx_cr4_osxsave_test vmx_nm_test vmx_db_test vmx_nmi_window_test vmx_intr_window_test vmx_pending_event_test vmx_pending_event_hlt_test vmx_store_tsc_test"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_preemption_timer]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "vmx_preemption_timer_zero_test vmx_preemption_timer_tf_test vmx_preemption_timer_expiry_test"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_misc]
> +file = vmx.flat
> +extra_params = -cpu max,+vmx -append "invvpid_test atomic_switch_max_msrs_test rdtsc_vmexit_diff_test vmx_mtf_test vmx_mtf_pdpte_test vmx_exception_test"
> +arch = x86_64
> +groups = vmx
> +
> +[vmx_ept]
>  file = vmx.flat
>  extra_params = -cpu host,host-phys-bits,+vmx -m 2560 -append "ept_access*"
>  arch = x86_64

hmm, I don't like that there's no common criteria for the buckets.  E.g.
"regression" is a bucket for how a test came to exist, whereas "apic" is a bucket
for what a test exercises.  And the granularity ends up being odd too, e.g. the
preemption timer gets its own bucket, but "regression" has a massive variety of
tests.

My preference would be to separate tests by what they cover, which I think will be
most useful.  E.g. if I'm making changes to EPT/paging related stuff, it would be
nice to be able to run just the paging tests early on.  And when a bucket fails,
it'd also give the user a hint as to want might have gone wrong.  I'm sure there
are tests that straddle multiple buckets, so it won't be perfect, but I think we
can get something useful.

 vmx_cpu 		(don't like the name, want it to be for tests that verify CPU arch behavior)
 vmx_consistency_checks
 vmx_events 		(non-vAPIC APIC tests, timers, NMIs, IRQs, preemption timer, etc...)
 vmx_paging		(ept A/D, PML, invvpid, vmx_pf_exception_test, etc...)
 vmx_vapic		(vAPIC, VID, PI, etc...)
 ept_access 		(because they probably needs their own config, but they aren't the only EPT tests)
