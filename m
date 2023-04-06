Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88B76D9D02
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbjDFQFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239851AbjDFQFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:05:21 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA5A5F8;
        Thu,  6 Apr 2023 09:05:19 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2a61e14f505so257281fa.0;
        Thu, 06 Apr 2023 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680797118; x=1683389118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2GPbJMRjjze8bzXYIxTv+yMQ+IEXnke2fZ/6Fpmlf4=;
        b=Opwj5wgiXbWyvcrKRgJj6ADTxldO7MDF9jkco1D9NgcxzZ2yQjO+ILQQCHn5k4wpI2
         69KHNAs/HQ1z0mcnF+4AX/D2WsJPlpeDQdccE9ApTfgsdrLuyJv6t1xzraKHACistx8y
         6KQlAsovWgYM7wxK290CMZyopkKxMYpUG32TqRIVLUCE+8tgSUc+uJGcsLdBNn1HIA1R
         HumAwS+DCMCeC4i8YddXcDK8EtcIl6wSWG+Gr/qf5IQozGFcT+Oe1QPjJeKgcEhgNtxn
         xZr6ls81x0iVLr4ZSUWwCc6eoHea/DYS+ftUCAK3Imwn96H4lh3RbQGmqYoaIgYxTdfC
         Wopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797118; x=1683389118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2GPbJMRjjze8bzXYIxTv+yMQ+IEXnke2fZ/6Fpmlf4=;
        b=LJsmAARa/qrF8htJ1z0TP2+0I5bvg4L3me6TSWy46K+8PBge1JDaW0jL6gQ28XVQmx
         xH1LZdBVdjh8+cCzIAtswUCZms4Nrll5fjIBmhjLDiUpIjjXpgZZEi6cxXaMpOC2cfn0
         QaiifK78rcVh8/vLapLZGr2s6Ef1IZkZnEmllsILyBWmhwwESE8L9Wgu2C7RRImLAEIO
         H9ZBXDPnt4eb9M4kYAcXBdN1E7p+KTga5dxn/myZdLDDd3UU2/Xy4CR1priG00e1b7bM
         K833XmL93FUhaC0IlPTYQaK/Msv0U5bBy8gT5DiPSncQdEVnZ1UTIQVCDjjpevNm46rF
         XtuA==
X-Gm-Message-State: AAQBX9dqnJWaX9adnxIQ9ObxouxiDnX72TmfLaxX1P5ShJuTR63cN+Pc
        dM874720zMfdvw2eF8NP5x8=
X-Google-Smtp-Source: AKy350YyWxoCDPSLCsGc8ba7UyP7461tsONqTQe22r69cZWMu5uDUuwnvX7TlhPcmw9SLqFWBMf3Sg==
X-Received: by 2002:ac2:4469:0:b0:4d2:c70a:fe0a with SMTP id y9-20020ac24469000000b004d2c70afe0amr1604448lfl.2.1680797117898;
        Thu, 06 Apr 2023 09:05:17 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id z5-20020ac24f85000000b004d85789cef1sm318793lfs.49.2023.04.06.09.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 09:05:17 -0700 (PDT)
Date:   Thu, 6 Apr 2023 19:04:51 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230406190451.000031b1.zhi.wang.linux@gmail.com>
In-Reply-To: <20230405181618.GG1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
        <20230326140936.00003397@gmail.com>
        <20230330010153.GB1112017@ls.amr.corp.intel.com>
        <20230402114158.00000543@gmail.com>
        <20230405181618.GG1112017@ls.amr.corp.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 11:16:18 -0700
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Sun, Apr 02, 2023 at 11:41:58AM +0300,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > > +{
> > > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > > +	cpumask_var_t packages;
> > > > > +	bool cpumask_allocated;
> > > > > +	u64 err;
> > > > > +	int ret;
> > > > > +	int i;
> > > > > +
> > > > > +	if (!is_hkid_assigned(kvm_tdx))
> > > > > +		return;
> > > > > +
> > > > > +	if (!is_td_created(kvm_tdx))
> > > > > +		goto free_hkid;
> > > > > +
> > > > > +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > > > > +	cpus_read_lock();
> > > > > +	for_each_online_cpu(i) {
> > > > > +		if (cpumask_allocated &&
> > > > > +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > > > > +						packages))
> > > > > +			continue;
> > > > 
> > > > Is this necessary to check cpumask_allocated in the while loop? if cpumask
> > > > is not succefully allocated, wouldn't it be better to bail out just after
> > > > it?
> > > 
> > > No because we can't return error here.  It's better to do in-efficiently freeing
> > > resources instead of leak.
> > > 
> > > We can move the check out of loop. But it would be ugly
> > > (if () {cpu loop} else {cpu loop} ) and this function isn't performance
> > > critical.  Also I think it's okay to depend on compiler optimization for loop
> > > invariant. My compiler didn't optimize it in this case, though.
> > > 
> > 
> > Do you mean the tdh_mng_key_freeid() is still required if failing to allocate
> > the cpumask var and do TDH.PHYMEM_CACHE_WB(WBINVD) on each CPU?
> 
> > 
> > Out of curiosity, I took a look on the TDX module source code [1], it seems TDX
> > module has an additional check in TDH.MNG.KEY.FREEID. TDH.MNG.VPFLUSHDONE [2]
> > will mark the pending wbinvd in a bitmap:
> > 
> > ...
> > /**
> >      * Create the WBINVD_BITMAP per-package.
> >      * Set to 1 num_of_pkgs bits from the LSB
> >      */
> >     global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap = global_data_ptr->pkg_config_bitmap; /* <----HERE */
> > 
> >     // Set new TD life cycle state
> >     tdr_ptr->management_fields.lifecycle_state = TD_BLOCKED;
> > 
> >     // Set the proper new KOT entry state
> >     global_data_ptr->kot.entries[curr_hkid].state = (uint8_t)KOT_STATE_HKID_FLUSHED; 
> > ...
> > 
> > And TDH.MNG.KEY.FREEID [3] will check if the pending WBINVD has been performed:
> > 
> > ...
> >     /**
> >      * If TDH_PHYMEM_CACHE_WB was executed on all packages/cores,
> >      * set the KOT entry, set the KOT entry state to HKID_FREE.
> >      */
> >     curr_hkid = tdr_ptr->key_management_fields.hkid;
> >     tdx_debug_assert(global_data_ptr->kot.entr/ies[curr_hkid].state == KOT_STATE_HKID_FLUSHED);
> >     if (global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap != 0) /* HERE */
> >     {
> >         TDX_ERROR("CACHEWB is not complete for this HKID (=%x)\n", curr_hkid);
> >         return_val = TDX_WBCACHE_NOT_COMPLETE;
> >         goto EXIT;
> >     }
> > ...
> > 
> > Guess the conclusion is: if TDH.PHYMEM.CACHE.WB is not performed on each
> > required CPU correctly, TDH.MNG.KEY.FREEID will fail as well. A leak seems
> > the only option (none of us likes a leak, but...).
> 
> Why do we need to leak key?  If we fails to allocate cpumask, we can issue
> TDH.PHYMEM.CACHE.WB on all pCPUs instead of all packages.
> If we call TDH.PHYMEM.CACHE.WB multiple times on the same package, it may return
> error. It's benign.  It is suboptimal, but it's much better than leaking hkid.

I guess I misunderstood the following sentence in the previous email. Now I
get it. It is a combination of failure-resolving and normal-resolving.

> > We can move the check out of loop. But it would be ugly
> > (if () {cpu loop} else {cpu loop} ) and this function isn't performance
> > critical.
