Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505273E4A80
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhHIRGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 13:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhHIRGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 13:06:18 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297A5C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 10:05:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a5so1426932plh.5
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N7MkMqODLMj3T1NXlpOTDzU2vHrNeFZAgg8Mo4BnxXs=;
        b=iy704fzF1WuCsB5tcbjR5QKsPL5hnZbfbqDjSUv26AmmK3U/Cj6l40QO2XS5/nmLn/
         9UGYJ/rkqg5vfjA98pwFWK00HWvBsrVlTBQiR65UYgqvQVFvsqdFKZQZLjkTuExlTABE
         KJbsozSvF1dSjr425fOHT4GqpgkKXm/Eidpsm38eYaJZe5L4HOpXfPzS604gMQXKPk6H
         qW/P69tl1K4QM6HQGQi4vlKjyfQnC+nAVXNxPyi7YSHyRKbvhDiH77tW1CMpyHXbNde2
         zKA6rrSsdVpgkN3CHqYttXeXxfzirGKs1yMR0LOg9QF1lEn8+GjvtEeQA2XSm75Nmfgq
         peWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N7MkMqODLMj3T1NXlpOTDzU2vHrNeFZAgg8Mo4BnxXs=;
        b=RE9l2GYV9bGnqwPr6AsZVv6YWEGgJzF1uMGuFUSXPeYZa6Zlgnn9tUI7LYxniWqq0y
         rG1Tg2DsjkMt0c+PRKReupM2Rqx3NPCFqgdnBtFuuSWUnbObrrcgpsji4l1eOTOmBPW0
         mikYOX/0WP8HAVSF2dd6zVj9Wjna3YuzEbYdr2n+RXAy0cIkl4Zk0LmXTXT6uHj5TAJp
         orbElDKw5TxjwvmP60Z1O+8kb14wmKdZ1i4K/Mlr5berEsazx/bNhjIwQjLG/rbBeXCB
         3RK39tVoqqaNBjmTF/resJ0vyyOGA49MerRUzL1mMgaIukwSpyDZq8v3zytLcxob8CQG
         u7hQ==
X-Gm-Message-State: AOAM532Q24nBt1Hi5iUSDkr51X75EuydBZxnDhUmzSm6MW+dR/wRltP1
        OEZ6YRcoKFK5ysKMVTuRbGgR7Y7tyvufQw==
X-Google-Smtp-Source: ABdhPJyKqEllVhCXTU2xATl7Pge82E/AWpZaqZpmLpH5NGgCRl654KTZF6HN2xqA5KEsvfIcQkSe/w==
X-Received: by 2002:a63:4c0e:: with SMTP id z14mr251057pga.427.1628528756567;
        Mon, 09 Aug 2021 10:05:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a8sm24541915pgd.50.2021.08.09.10.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 10:05:55 -0700 (PDT)
Date:   Mon, 9 Aug 2021 17:05:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: x86: remove dead initialization
Message-ID: <YRFgb5AbeL8fprgc@google.com>
References: <20210809110120.3237065-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809110120.3237065-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Paolo Bonzini wrote:
> hv_vcpu is initialized again a dozen lines below, so remove the
> initializer.

Eewwww.  It's not just dead code, it's code that could potentially lead to
dereferncing a NULL pointer and/or a stale pointer.  The second initialization
of the local hv_vcpu happens after a conditional call to kvm_hv_vcpu_init().

Maybe update the changelog to clarify why the second initialization absolutely
must be kept?

For the code:

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e9582db29a99..2da21e45da99 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1968,7 +1968,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *entry;
> -	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_vcpu_hv *hv_vcpu;
>  
>  	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
>  	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX) {
> -- 
> 2.27.0
> 
