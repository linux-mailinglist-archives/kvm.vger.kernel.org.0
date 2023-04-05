Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2536D85CB
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjDESQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDESQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:16:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8249A659B;
        Wed,  5 Apr 2023 11:16:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id d22so22285631pgw.2;
        Wed, 05 Apr 2023 11:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680718581; x=1683310581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZHK4aGRVhFnY6NcH5+15nBOfRFUXM0rvRmFZC+ICfo=;
        b=a5RkMZRahnPfsXfeRYnYj5gb+AMW2gJvfd7au3Oc9cGAA7i5Siy5JjOWOIgdPFGRQT
         fpGksFrFOpblOYVvw+80Cy0pPo7gpORkzseprf7Z+qJ1I35BcbtMeMpOoLsAkikEUx9U
         pwEjrICQhSEIdXGL5atO2bQ0j7SUGrUg/rX2YljD6681joVLEx9s7+m14F2gujc2YIG6
         nUUkI8zk7wC+97BaiX+nA1YkQ9MTtgmea7eGywUKMCaq2P6dykqipmDmgCkH03ELxhLA
         wTgRjjzBkfMERMegaHko3ibYHpKG4cqfqSamYlH7aKlkACKKuh1gkt1UntfzRohRmU2B
         3Jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718581; x=1683310581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZHK4aGRVhFnY6NcH5+15nBOfRFUXM0rvRmFZC+ICfo=;
        b=6oay6n16H+y9VwJiwbs9HCQ5IKWKZ4piT87jJr7cP/77IJmtqERo4+ZWoNfvNgfrkb
         rid0spypR36MvBWe/gZfFKJ4QipBsYLmHCvCS9sVLEMwVlrwy5fr60/q1fX+VbrzaGJW
         blbkoM9KWn+Y6Gdd5aynTKILIMir2dqawLtOY4EOUsNtdzwWchBMYIncx7f7lhXptHNC
         ogkJweQOMjYNNFiQkPKmhmBbm5bEGg2/0XEOqd1QEh7iml+7BA68bB2FMxmi62Hh8d/O
         bkfQWZ2kAIqk25N9AhRlJwB5dzLOD/UqK3WTRiIP02qbI5BTEK9tc/i/xwA/ECE/zr5n
         K7FQ==
X-Gm-Message-State: AAQBX9dk6wRPl6vWmsuqB4juRcY3echaGDKiRcRy5FZNFP/HPorJPXr3
        Fdbjrz0TJ23R9wX0SoqwXvVMgaKFNPY=
X-Google-Smtp-Source: AKy350ZnS4HA+8waEy+VSw7ffmkNKg5ZQSVdbWSaiHhPY8X2C1NXzKPRjGrwQ3sJCWHXe7l0+hzVFQ==
X-Received: by 2002:aa7:9f48:0:b0:627:eece:5ca5 with SMTP id h8-20020aa79f48000000b00627eece5ca5mr6246199pfr.18.1680718580641;
        Wed, 05 Apr 2023 11:16:20 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k26-20020aa792da000000b00593e4e6516csm10939356pfa.124.2023.04.05.11.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:16:20 -0700 (PDT)
Date:   Wed, 5 Apr 2023 11:16:18 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230405181618.GG1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
 <20230326140936.00003397@gmail.com>
 <20230330010153.GB1112017@ls.amr.corp.intel.com>
 <20230402114158.00000543@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230402114158.00000543@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 02, 2023 at 11:41:58AM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > +{
> > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > +	cpumask_var_t packages;
> > > > +	bool cpumask_allocated;
> > > > +	u64 err;
> > > > +	int ret;
> > > > +	int i;
> > > > +
> > > > +	if (!is_hkid_assigned(kvm_tdx))
> > > > +		return;
> > > > +
> > > > +	if (!is_td_created(kvm_tdx))
> > > > +		goto free_hkid;
> > > > +
> > > > +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > > > +	cpus_read_lock();
> > > > +	for_each_online_cpu(i) {
> > > > +		if (cpumask_allocated &&
> > > > +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > > > +						packages))
> > > > +			continue;
> > > 
> > > Is this necessary to check cpumask_allocated in the while loop? if cpumask
> > > is not succefully allocated, wouldn't it be better to bail out just after
> > > it?
> > 
> > No because we can't return error here.  It's better to do in-efficiently freeing
> > resources instead of leak.
> > 
> > We can move the check out of loop. But it would be ugly
> > (if () {cpu loop} else {cpu loop} ) and this function isn't performance
> > critical.  Also I think it's okay to depend on compiler optimization for loop
> > invariant. My compiler didn't optimize it in this case, though.
> > 
> 
> Do you mean the tdh_mng_key_freeid() is still required if failing to allocate
> the cpumask var and do TDH.PHYMEM_CACHE_WB(WBINVD) on each CPU?

> 
> Out of curiosity, I took a look on the TDX module source code [1], it seems TDX
> module has an additional check in TDH.MNG.KEY.FREEID. TDH.MNG.VPFLUSHDONE [2]
> will mark the pending wbinvd in a bitmap:
> 
> ...
> /**
>      * Create the WBINVD_BITMAP per-package.
>      * Set to 1 num_of_pkgs bits from the LSB
>      */
>     global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap = global_data_ptr->pkg_config_bitmap; /* <----HERE */
> 
>     // Set new TD life cycle state
>     tdr_ptr->management_fields.lifecycle_state = TD_BLOCKED;
> 
>     // Set the proper new KOT entry state
>     global_data_ptr->kot.entries[curr_hkid].state = (uint8_t)KOT_STATE_HKID_FLUSHED; 
> ...
> 
> And TDH.MNG.KEY.FREEID [3] will check if the pending WBINVD has been performed:
> 
> ...
>     /**
>      * If TDH_PHYMEM_CACHE_WB was executed on all packages/cores,
>      * set the KOT entry, set the KOT entry state to HKID_FREE.
>      */
>     curr_hkid = tdr_ptr->key_management_fields.hkid;
>     tdx_debug_assert(global_data_ptr->kot.entr/ies[curr_hkid].state == KOT_STATE_HKID_FLUSHED);
>     if (global_data_ptr->kot.entries[curr_hkid].wbinvd_bitmap != 0) /* HERE */
>     {
>         TDX_ERROR("CACHEWB is not complete for this HKID (=%x)\n", curr_hkid);
>         return_val = TDX_WBCACHE_NOT_COMPLETE;
>         goto EXIT;
>     }
> ...
> 
> Guess the conclusion is: if TDH.PHYMEM.CACHE.WB is not performed on each
> required CPU correctly, TDH.MNG.KEY.FREEID will fail as well. A leak seems
> the only option (none of us likes a leak, but...).

Why do we need to leak key?  If we fails to allocate cpumask, we can issue
TDH.PHYMEM.CACHE.WB on all pCPUs instead of all packages.
If we call TDH.PHYMEM.CACHE.WB multiple times on the same package, it may return
error. It's benign.  It is suboptimal, but it's much better than leaking hkid.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
