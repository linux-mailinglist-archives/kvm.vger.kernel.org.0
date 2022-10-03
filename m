Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E285F36CF
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 22:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJCUCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 16:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJCUCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 16:02:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B9A3AB08
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 13:02:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lx7so10839350pjb.0
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 13:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=dK3ww0FiuK2FFQtp3KCT/xxvbYeXCeimrlsj11qOP9g=;
        b=oHRaD+s7kMtTKfIPkYaUepEduOCtXDtzGrdcsld+mTEa0TeO3fsu1xp0mI2+w/J3Az
         pemqkkgbeQVUPwfqlol8P3ekrOQeVaTNNXzs7gr+UarYwYVp8NB2pEzriv0GDMG4VGnq
         mgwMisN5jHh+dNF7oHH2KxkrN8Q3NItOhXMkSemrqdfgzoI7A+KH7yhh2ZIsCxKCovzr
         Ves29eXCVb3981a99wcxZayZiPmhNAYkM03/ymV6ozRdoufG1+uKtP7UwbJuLRbO+k72
         lElYNNFajgwKmtl4Fq2AWubMUtbB0k3oTtVZxOx32/eUXo0rQxw2vXRH2QRS1U02p6p0
         mGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dK3ww0FiuK2FFQtp3KCT/xxvbYeXCeimrlsj11qOP9g=;
        b=wrg3KRu5dBZNGjpk/z0SBprn+Il50mk6vOiImc1D3QwLPIKXgkJs7znHqlCgZAvhfs
         W18MhY/HfO6+Seou3c9StacnDb2HlnZ3lkPGUe6+BzJCocKLZfnbvxDvBPW6plR5ouxi
         24YJCCFozhUkouPHLcnZA2ktTq39Ant9fUcrZfIS+wQbdRuas8PBN0N011SpWHFwhn3l
         aYjKF/vk+81QeE2YsLDS/xrHk/2NKBwP4USU0iGD6ipeYj+6L87Dk8ejydvZScpdvykE
         Hat8zaThefQ21zSMWlQiOSCcRRQ58CC/DWPg2Orfwtm2RtXIHQpQTvSjzIQbhOfXyiin
         FURg==
X-Gm-Message-State: ACrzQf2bhHytb6lVsczXDuKDSj2bOcl05u5cxzqZyWPkXJltLoR9ndt7
        MzCJk7CZ9bce2ZdOxd3YCKO3Iw==
X-Google-Smtp-Source: AMsMyM5HjVr6B8IAKHNyn7jAJYka7xl7krHcpdRPyy6IgaKqs12KRE+VwAfCndej1+ZjgVO/GK7Lbg==
X-Received: by 2002:a17:90b:3e8b:b0:202:c85d:8ffa with SMTP id rj11-20020a17090b3e8b00b00202c85d8ffamr14080896pjb.155.1664827368376;
        Mon, 03 Oct 2022 13:02:48 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s13-20020a170902ea0d00b0016d72804664sm7562746plg.205.2022.10.03.13.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 13:02:47 -0700 (PDT)
Date:   Mon, 3 Oct 2022 13:02:42 -0700
From:   David Matlack <dmatlack@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Message-ID: <Yzs/4rqWFroUNyFU@google.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-2-dmatlack@google.com>
 <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
 <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
 <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
 <20221003185834.GA2414580@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003185834.GA2414580@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03, 2022 at 11:58:34AM -0700, Isaku Yamahata wrote:
> On Tue, Sep 27, 2022 at 09:10:43PM +0000, "Huang, Kai" <kai.huang@intel.com> wrote:
> > On Tue, 2022-09-27 at 09:14 -0700, David Matlack wrote:
> > > On Tue, Sep 27, 2022 at 2:19 AM Huang, Kai <kai.huang@intel.com> wrote:
> > > > 
> > > > Sorry last time I didn't review deeply, but I am wondering why do we need
> > > > 'tdp_mmu_allowed' at all?  The purpose of having 'allow_mmio_caching' is because
> > > > kvm_mmu_set_mmio_spte_mask() is called twice, and 'enable_mmio_caching' can be
> > > > disabled in the first call, so it can be against user's desire in the second
> > > > call.  However it appears for 'tdp_mmu_enabled' we don't need 'tdp_mmu_allowed',
> > > > as kvm_configure_mmu() is only called once by VMX or SVM, if I read correctly.
> > > 
> > > tdp_mmu_allowed is needed because kvm_intel and kvm_amd are separate
> > > modules from kvm. So kvm_configure_mmu() can be called multiple times
> > > (each time kvm_intel or kvm_amd is loaded).
> > > 
> > > 
> > 
> > Indeed. :)
> > 
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> 
> kvm_arch_init() which is called early during the module initialization before
> kvm_configure_mmu() via kvm_arch_hardware_setup() checks if the vendor module
> (kvm_intel or kvm_amd) was already loaded.  If yes, it results in -EEXIST.
> 
> So kvm_configure_mmu() won't be called twice.

kvm_configure_mmu() can be called multiple times if the vendor module is
unloaded without unloading the kvm module. For example:

 $ modprobe kvm
 $ modprobe kvm_intel ept=Y  # kvm_configure_mmu(true, ...)
 $ modprobe -r kvm_intel
 $ modprobe kvm_intel ept=N  # kvm_configure_mmu(false, ...)
