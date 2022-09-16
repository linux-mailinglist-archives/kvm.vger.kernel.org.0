Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2D45BB185
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIPRMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 13:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPRMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 13:12:50 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354F9B4E8B
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 10:12:49 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f23so5786119plr.6
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 10:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qjJnk6lzrW/uHSqN2RkoHmlWl2hLDZqkccXvgirEc2Q=;
        b=LmuGhKqqAKxRzUbMdxbqHnMAi4VR4m0MBx65u7Lpw9wfcF9PBC/xMf5yV8tp0aJmxc
         jzGdXC2WzeVY2VNwbyFFCHw80gcQS7nvxC6UTlkgktZWA5PnCfC+NPKtFuyPL8ID+JET
         qai3qRT4A1bX6qNo6A+qRUe3CjL6kkHkRuP0RzxjI7t2IFWm0Jh7U6By28Ae2qdouKHD
         ND14gREg+DiYhMUn902evP4A6bHbZwUHP7Oo2MbCf2XL8jD0Zkw5v633GgAKPXngReyG
         QEB7R0Kvaw/L+8wfthfeAs3poyCr5XBs99uurOdGWvcsM5loWq4ZdJVtM3Fh7zfW5jCh
         uRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qjJnk6lzrW/uHSqN2RkoHmlWl2hLDZqkccXvgirEc2Q=;
        b=3INoINysL4n+FpzMXKwVFjcAGUB4kH97hhE9rdjjDBO+L5AM8qKmDciTvk8w2AzLyj
         NxOA0Tt5O7lBKvfGpIwRLoiVm9LvIbRT5ouFx47daN6sJ+h5L3ihNmcP59GAe3a/B73q
         QNWZ/D7I6MjhtPUKL1Xiu/HswOqXxGM4rJNKdSsQ2n7WGAo/VxfHc5yU6qs8GwKfWYs8
         85CAZNZO8lbLTUvMnMcxXO3K3i71iFDG1yNTB2tA6lmNVOuZLFsrzkeDyJSyLme7V1DU
         xRvhKHq1TsGtbAfeCLWb3d8yZv0nZ3N8FCw7hs0dhfYjlRnygR/5UU/76c5FmhFp9ax8
         QcQA==
X-Gm-Message-State: ACrzQf1hICMbpoknQr+viKQWu4Ijr3LvmiAiqE3RcPIA0PnxLZD5xRyd
        KY1bMw+zrRttyxKkWbQGOrHASw==
X-Google-Smtp-Source: AMsMyM5uYh5xKsVICMLTZPqdhTTYoUKLACBVsHTkh1NqNMFupOENsDIHLL3cFyzb3J+lIxjxf7kukA==
X-Received: by 2002:a17:902:d4cb:b0:178:6e81:35b7 with SMTP id o11-20020a170902d4cb00b001786e8135b7mr854194plg.108.1663348368530;
        Fri, 16 Sep 2022 10:12:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a00001100b0052d4b0d0c74sm14772524pfk.70.2022.09.16.10.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 10:12:48 -0700 (PDT)
Date:   Fri, 16 Sep 2022 17:12:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org
Subject: Re: [RFC PATCH 3/4] KVM: x86/xen: Disallow gpc locks reinitialization
Message-ID: <YySujDJN2Wm3ivi/@google.com>
References: <20220916005405.2362180-1-mhal@rbox.co>
 <20220916005405.2362180-4-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916005405.2362180-4-mhal@rbox.co>
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

On Fri, Sep 16, 2022, Michal Luczaj wrote:
> There are race conditions possible due to kvm_gfn_to_pfn_cache_init()'s
> ability to _re_initialize gfn_to_pfn_cache.lock.
> 
> For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
> kvm_gfn_to_pfn_cache_init() leads to a corrupted shinfo gpc lock.
> 
>                 (thread 1)                |           (thread 2)
>                                           |
>  kvm_xen_set_evtchn_fast                  |
>   read_lock_irqsave(&gpc->lock, ...)      |
>                                           | kvm_gfn_to_pfn_cache_init
>                                           |  rwlock_init(&gpc->lock)
>   read_unlock_irqrestore(&gpc->lock, ...) |
> 

Please explicitly include a sample call stack for reaching kvm_gfn_to_pfn_cache_init().
Without that, it's difficult to understand if this is a bug in the gfn_to_pfn_cache
code, or if it's a bug in the caller.

> Introduce bool locks_initialized.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  include/linux/kvm_types.h | 1 +
>  virt/kvm/pfncache.c       | 7 +++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 3ca3db020e0e..7e7b7667cd9e 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -74,6 +74,7 @@ struct gfn_to_pfn_cache {
>  	void *khva;
>  	kvm_pfn_t pfn;
>  	enum pfn_cache_usage usage;
> +	bool locks_initialized;
>  	bool active;
>  	bool valid;
>  };
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 68ff41d39545..564607e10586 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -354,8 +354,11 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
>  	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
>  
>  	if (!gpc->active) {
> -		rwlock_init(&gpc->lock);
> -		mutex_init(&gpc->refresh_lock);
> +		if (!gpc->locks_initialized) {

Rather than add another flag, move the lock initialization to another helper and
call the new helper from e.g. kvm_xen_init_vm() and kvm_xen_init_vcpu().  There
is zero reason to initialize locks on-demand.  That way, patches 1 and 2 aren't
necessary because gpc->lock is always valid.

And then at the same time, rename "cache_init" and "cache_destroy" to
activate+deactivate to avoid implying that the cache really is destroyed/freed.
And 

Adding a true init() API will also allow for future cleanups.  @kvm, @vcpu, @len,
and @usage all should be immutable in the sense that they are properties of the
cache, i.e. can be moved into init().  The nice side effect of moving most of that
stuff into init() is that it makes it very obvious from the activate() call sites
that the gpa is the only mutable information.

I.e. as additional patches, do:

  1. Formalize "gpc" as the acronym and use it in function names to reduce line
     lengths.  Maybe keep the long name for gfn_to_pfn_cache_invalidate_start()
     though?  Since that is a very different API.

  2. Snapshot @usage during kvm_gpc_init().

  3. Add a KVM backpointer in "struct gfn_to_pfn_cache" and snapshot it during
     initialization.  The extra memory cost is negligible in the grand scheme,
     and not having to constantly provide @kvm makes the call sites prettier, and
     it avoids weirdness where @kvm is mandatory but @vcpu is not.

  4. Add a backpointer for @vcpu too, since again the memory overhead is minor,
     and taking @vcpu in "activate" implies that it's legal to share a cache
     between multiple vCPUs, which is not the case.  And opportunistically add a
     WARN to assert that @vcpu is non-NULL if KVM_GUEST_USES_PFN. 

  5. Snapshot @len during kvm_gcp_init().

so that we end up with something like (completely untested):

	bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
	int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
	void kvm_gpc_unmap(struct gfn_to_pfn_cache *gpc)

	void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
			  enum pfn_cache_usage usage, unsigned long len)
	{
		WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
		WARN_ON_ONCE((usage & KVM_GUEST_USES_PFN) && !vcpu);

		rwlock_init(&gpc->lock);
		mutex_init(&gpc->refresh_lock);

		gpc->kvm = kvm;
		gpc->vcpu = vcpu;
		gpc->usage = usage;
		gpc->len = len;
	}
	EXPORT_SYMBOL_GPL(kvm_gpc_init);

	int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
	{
		if (!gpc->active) {
			gpc->khva = NULL;
			gpc->pfn = KVM_PFN_ERR_FAULT;
			gpc->uhva = KVM_HVA_ERR_BAD;
			gpc->valid = false;
			gpc->active = true;

			spin_lock(&gcp->kvm->gpc_lock);
			list_add(&gpc->list, &gcp->kvm->gpc_list);
			spin_unlock(&gcp->kvm->gpc_lock);
		}
		return kvm_gpc_refresh(gpc, gpa);
	}
	EXPORT_SYMBOL_GPL(kvm_gpc_activate);

	void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
	{
		if (gpc->active) {
			spin_lock(&gpc->kvm->gpc_lock);
			list_del(&gpc->list);
			spin_unlock(&gpc->kvm->gpc_lock);

			kvm_gpc_unmap(gpc);
			gpc->active = false;
		}
	}
	EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);

Let me know if yout want to take on the above cleanups, if not I'll add them to
my todo list.

Thanks!
