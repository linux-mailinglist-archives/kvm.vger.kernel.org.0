Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216E76173F8
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiKCCCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKCCCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:02:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886BF11A13;
        Wed,  2 Nov 2022 19:02:00 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q9so345980pfg.5;
        Wed, 02 Nov 2022 19:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AhiKMneB+1lhS/iYLvGakhai0XjHdXNkrt6W7AkLusI=;
        b=FleTjVRg9+YfwgDqvllOxYqyYjjafOOhCNsAnfPI0cZAha/oYebPrkkTIQkkoLWDDP
         DkEvbLtCdqSg9E6M+b46sIgT4LsYwPX4Ui5zDdilOQGSUcX1p53K6SdaS3BtWWqGQh98
         pvXRHzKpzbtDJNuT0+CTinoe812MdPGbZTMp7OQMyqlCQggE77EuJZ5HMx6bNYhfIgsT
         ifPydfqRCYgM/pVzWqz9RlNi4h31+0nPF8w+jnzE71YmQCFoUtUaiY1+EF404EBFcQz/
         wfJk+rVjbNT0rpBupPDQWx/JzVFCe7YzmTlA3mJvmp8ezgDBAMLSewPDE14OPNKstxtK
         UyaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhiKMneB+1lhS/iYLvGakhai0XjHdXNkrt6W7AkLusI=;
        b=AkK0WZTNgOjDyOUVO+n78UZTb4aCMNiHSbAyxxUpqVXZ17vtCtl/tYGs6EEWWp8M2x
         Gxru2FMoE0PEneSWh/cDCGZwhhJU9LfCa2ZVXuXfTi+zvy3Fl2Wb6VnymHXzQBbvfiua
         +QxCRMpqhmy+BGIah6wx9zNRE/G+4wvj3W3HF1NzDCeGIpOUtHrUqZLWg1YmTh6sXURG
         iZASFKLZOTy4I8+36pf3nix11RsS2+fu9gXJm0nW5ohlGBGXiIzIpap+AwF43u5msLyM
         lp0oCi9+VAavZTZGIkRiSgaNiEapTNja1el5X/gQsNmd5Wdz03+k0Ib7oVzw5TO5hF6x
         9nUA==
X-Gm-Message-State: ACrzQf3Fu4OWdlYahO6KWaMbrFOq/iLsMuHZWtnPQ55yCYQSZv2Ql8a6
        JJFTwYoOrXZhTTZTMzcEIV0=
X-Google-Smtp-Source: AMsMyM5VCcOvBdc8bNnzVYj5Dfx9GdTX5OQ8X3mWYKjZpxv41Lb0A4VCMi1XAFLCagiVR4Ztc9d4WQ==
X-Received: by 2002:a05:6a02:282:b0:439:7a97:ccd with SMTP id bk2-20020a056a02028200b004397a970ccdmr24634681pgb.297.1667440915180;
        Wed, 02 Nov 2022 19:01:55 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s4-20020a17090a2f0400b001fd76f7a0d1sm2086392pjd.54.2022.11.02.19.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 19:01:54 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:01:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 060/108] KVM: Add functions to set GFN to private or
 shared
Message-ID: <20221103020154.GD954260@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <c834432220f04c39a8dfa6ac3838446e6c06c9e9.1667110240.git.isaku.yamahata@intel.com>
 <36cde6d6-128d-884e-1447-09b08bb5de3d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36cde6d6-128d-884e-1447-09b08bb5de3d@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 06:21:26PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX KVM support needs to track whether GFN is private or shared.  Introduce
> > functions to set whether GFN is private or shared and pre-allocate memory
> > for xarray.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   include/linux/kvm_host.h | 11 ++++++
> >   virt/kvm/kvm_main.c      | 74 ++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 85 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index a0b64308d240..fac07886ab39 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2307,9 +2307,20 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
> >   #define KVM_MEM_ATTR_PRIVATE	0x0002
> >   #ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
> > +/* memory attr on [start, end) */
> > +int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end);
> >   void kvm_arch_update_mem_attr(struct kvm *kvm, struct kvm_memory_slot *slot,
> >   			      unsigned int attr, gfn_t start, gfn_t end);
> >   #else
> > +static inline int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +static inline int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> >   static inline void kvm_arch_update_mem_attr(struct kvm *kvm,
> >   					    struct kvm_memory_slot *slot,
> >   					    unsigned int attr,
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9f82b03a8118..f0e77b65939b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1121,6 +1121,80 @@ static inline void kvm_restrictedmem_unregister(struct kvm_memory_slot *slot)
> >   					  &slot->notifier);
> >   }
> > +/*
> > + * Reserve memory for [start, end) so that the next set oepration won't fail
> > + * with -ENOMEM.
> > + */
> > +int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +	int r = 0;
> > +	gfn_t gfn;
> > +
> > +	xa_lock(&kvm->mem_attr_array);
> > +	for (gfn = start; gfn < end; gfn++) {
> > +		r = __xa_insert(&kvm->mem_attr_array, gfn, NULL, GFP_KERNEL_ACCOUNT);
> > +		if (r == -EBUSY)
> > +			r = 0;
> > +		if (r)
> > +			break;
> > +	}
> > +	xa_unlock(&kvm->mem_attr_array);
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_vm_reserve_mem_attr);
> > +
> > +/* Set memory attr for [start, end) */
> > +int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
> > +{
> > +	void *entry;
> > +	gfn_t gfn;
> > +	int r;
> > +	int i;
> > +
> > +	/* By default, the entry is private. */
> > +	switch (attr) {
> > +	case KVM_MEM_ATTR_PRIVATE:
> > +		entry = NULL;
> > +		break;
> > +	case KVM_MEM_ATTR_SHARED:
> > +		entry = xa_mk_value(KVM_MEM_ATTR_SHARED);
> > +		break;
> > +	default:
> > +		WARN_ON_ONCE(1);
> > +		return -EINVAL;
> > +	}
> > +
> > +	WARN_ON_ONCE(start >= end);
> > +	for (gfn = start; gfn < end; gfn++) {
> > +		r = xa_err(xa_store(&kvm->mem_attr_array, gfn, entry,
> > +				    GFP_KERNEL_ACCOUNT));
> > +		if (r)
> > +			break;
> > +	}
> > +	if (start >= gfn)
> > +		return r;
> > +
> > +	end = gfn;
> > +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > +		struct kvm_memslot_iter iter;
> > +		struct kvm_memory_slot *slot;
> > +		struct kvm_memslots *slots;
> > +
> > +		slots = __kvm_memslots(kvm, i);
> > +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
> 
> slot needs to be set as
> 
> 			slot = iter.slot;
> 

Thanks, will fix it.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
