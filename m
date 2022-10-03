Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F105F35FF
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 20:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJCS6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 14:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJCS6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 14:58:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14441D0FA
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 11:58:36 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w2so11000705pfb.0
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 11:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=U+hUVd9ByjBUS5JuWqj6DjyYoQUc5j00+fB0E6Qcl0w=;
        b=YPwekCDTZqZ50JHBJ7FkC21O1ZFU4QQZGh+XwL5D2mgVTsYxJnwOHz24smFtu4zYSm
         /mo7dRWtmMacackLsaI18ILHnA9LMBOXIH0a1RjwqVBR5YQlaTliLZwOyFu59aakwy7f
         9sm6DY7JVSrHQov2rJbx1knnbk6svVuL86M/S4CrisV2ruxkhnWh1TETm7DwdFjwDA69
         N61VrqTQcNPhE8hn3jEpre1Nb30RsclgmzTRbOwDOKyvNZdkWVb9F3atLyCrCVsGDLbD
         I5SC30Tpk5J27dyhBBqn+LfSOef/ilbdZ3gw2pSaSxInMckSjC+wMqv5uGzxMWuihcpJ
         ZckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=U+hUVd9ByjBUS5JuWqj6DjyYoQUc5j00+fB0E6Qcl0w=;
        b=zRRln7hc0Agx9siIlmQqV4gkXj6fqEz6Cc9HWgmOm2paaHgZUUtEF3wmtd50JyX8zj
         eriNyFtnhDL7HGwW1u92VZjeKgrH0KaFw7q7X/wsp6wu/iO4pLGA98NDUbs+TRGedArT
         9qcUsSUlhP5Jp7jK7CVKMDI2tKNLHAs3wvMY+QRotavMMnOQJQAgNgR2uE+NrwgM4azs
         w8qdn1evTuQ6yHzzdTX0SzqXN2tQSBTgkn0u60j7e+mJHG1zmQnrt0gy7ecuUxX6Wv0Z
         zRF3+HAv+TYhHxxYwtdfW2OBMweE9cN+a5jvxu1CAu0rxu/wM2fOdu8UyHJSPmx4mIsA
         oFBg==
X-Gm-Message-State: ACrzQf1KQ4iSjUPpfCPCtrg62Ik0csOZ6W4xnUJBR+/iVXtL1phlcQ7r
        1bBg+AOrgSW6blCzOvoccZI=
X-Google-Smtp-Source: AMsMyM5y42wkKIMz1DGbLPWt7sm7nvTn8iTQp6BZU0PWFi8gFSuPjgHDb1S06qTqsvWMEl4UroY0Ig==
X-Received: by 2002:a05:6a00:1ad0:b0:545:b61b:fe7 with SMTP id f16-20020a056a001ad000b00545b61b0fe7mr23718592pfv.25.1664823516134;
        Mon, 03 Oct 2022 11:58:36 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id n124-20020a622782000000b0053653c6b9f9sm7759038pfn.204.2022.10.03.11.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 11:58:35 -0700 (PDT)
Date:   Mon, 3 Oct 2022 11:58:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Message-ID: <20221003185834.GA2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-2-dmatlack@google.com>
 <1c5a14aa61d31178071565896c4f394018e83aaa.camel@intel.com>
 <CALzav=d1wheG3bCKvjZ--HRipaehtaGPqJsDz031aohFjpcmjA@mail.gmail.com>
 <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fde43a93b5139137c4783d1efe03a1c50311abc1.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 09:10:43PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2022-09-27 at 09:14 -0700, David Matlack wrote:
> > On Tue, Sep 27, 2022 at 2:19 AM Huang, Kai <kai.huang@intel.com> wrote:
> > > 
> > > 
> > > > 
> > > > +bool __ro_after_init tdp_mmu_allowed;
> > > > +
> > > 
> > > [...]
> > > 
> > > > @@ -5662,6 +5669,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> > > >       tdp_root_level = tdp_forced_root_level;
> > > >       max_tdp_level = tdp_max_root_level;
> > > > 
> > > > +#ifdef CONFIG_X86_64
> > > > +     tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
> > > > +#endif
> > > > 
> > > 
> > > [...]
> > > 
> > > > @@ -6661,6 +6671,13 @@ void __init kvm_mmu_x86_module_init(void)
> > > >       if (nx_huge_pages == -1)
> > > >               __set_nx_huge_pages(get_nx_auto_mode());
> > > > 
> > > > +     /*
> > > > +      * Snapshot userspace's desire to enable the TDP MMU. Whether or not the
> > > > +      * TDP MMU is actually enabled is determined in kvm_configure_mmu()
> > > > +      * when the vendor module is loaded.
> > > > +      */
> > > > +     tdp_mmu_allowed = tdp_mmu_enabled;
> > > > +
> > > >       kvm_mmu_spte_module_init();
> > > >  }
> > > > 
> > > 
> > > Sorry last time I didn't review deeply, but I am wondering why do we need
> > > 'tdp_mmu_allowed' at all?  The purpose of having 'allow_mmio_caching' is because
> > > kvm_mmu_set_mmio_spte_mask() is called twice, and 'enable_mmio_caching' can be
> > > disabled in the first call, so it can be against user's desire in the second
> > > call.  However it appears for 'tdp_mmu_enabled' we don't need 'tdp_mmu_allowed',
> > > as kvm_configure_mmu() is only called once by VMX or SVM, if I read correctly.
> > 
> > tdp_mmu_allowed is needed because kvm_intel and kvm_amd are separate
> > modules from kvm. So kvm_configure_mmu() can be called multiple times
> > (each time kvm_intel or kvm_amd is loaded).
> > 
> > 
> 
> Indeed. :)
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>

kvm_arch_init() which is called early during the module initialization before
kvm_configure_mmu() via kvm_arch_hardware_setup() checks if the vendor module
(kvm_intel or kvm_amd) was already loaded.  If yes, it results in -EEXIST.

So kvm_configure_mmu() won't be called twice.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
