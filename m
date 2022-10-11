Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF5D5FA963
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 02:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiJKAhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 20:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJKAhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 20:37:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739C52CE38
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 17:37:09 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso224381pjq.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 17:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kxb8pGdW2nayALFt/9whqYjINHOcpwy73ePibfHmy2Q=;
        b=s8KIq1DW57Y0CLdCIApECW60JD5hJQTnyaWgRmtqLAbgwTWaz2T1i32OrL0W1VAUvr
         5Y2KecYSIuznDp+m6TAlBV40sZJI+XnwSxcn/mfcPDmB0UfLHc4IUaktt7Avu2PPTT7c
         aEJfVU0giVOPQgNlqs2jBXIVztsI6dfRcQzA/bY/bd3qqi9YzjpjVu5brHCYKHoopzqS
         emWp61r1B1AckflZghShNdoOtYeX2N8D5qfp8JhO7uYVxv+5YnGNGvikbPAKRewra0ji
         v5MpsLXZl1a/pMtsBG/aoYDut/O7/zgkqfbnTZ386HdX6JHecqUQJruVEWl3c+sarFQS
         j9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kxb8pGdW2nayALFt/9whqYjINHOcpwy73ePibfHmy2Q=;
        b=QTjXvb3vkgUQnphNtUw6Obs8IV/6j6x4fCZleDkwGHZ44G/INthSO5RjHXughIFvYH
         GdjFAQSz/gSuCSIeMzRxmQ//cnb8k42GXz8yscsAxfDRLCiq9BeeyoQGefKcrq3e5+tY
         RU/zqq0fSYw3dJcLSPFqS1nE/FsaF9v8kyclkskYA77PHcstW++YGkNN/XCgW5RRgkFr
         9QKukFxdx2J9VY7BZrAFQ19nHvyyjSPxN0rwKtcPTM5vxTfhAD7SsLyQUQKDoj0f6mGt
         Qes3ItqLYHa15SCm/4taYb2mlBPrBEqO3Z/FvXBSWXOgNvEPDajLN8d4E0R7sOVu34Om
         BXAQ==
X-Gm-Message-State: ACrzQf3IznZtXyNWVUYkn8sAf/+hzuXmdFC820NkBN3FAex5E+MASSQu
        t8uHlgikDgE3dzoeRGLMhAuqLA==
X-Google-Smtp-Source: AMsMyM6d+VJaFByKbIzTJqLRU6zKQepoqa344Zk3fryzn6cCTyWc7UJ7JzFjcMJF6CsRn/bnrb981g==
X-Received: by 2002:a17:903:2691:b0:181:2875:9d6 with SMTP id jf17-20020a170903269100b00181287509d6mr14357689plb.105.1665448628848;
        Mon, 10 Oct 2022 17:37:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x9-20020aa79569000000b005626ef1a48bsm7521922pfq.197.2022.10.10.17.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 17:37:08 -0700 (PDT)
Date:   Tue, 11 Oct 2022 00:37:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 4/8] KVM: x86: Store immutable gfn_to_pfn_cache properties
Message-ID: <Y0S6sATV40i7IOAH@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-5-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921020140.3240092-5-mhal@rbox.co>
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

On Wed, Sep 21, 2022, Michal Luczaj wrote:
> Move the assignment of immutable properties @kvm, @vcpu, @usage, @len
> to the initializer.  Make _init(), _activate() and _deactivate() use
> stored values.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> @@ -1818,9 +1810,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
>  
>  	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
>  
> -	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
> -	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
> -	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
> +	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
> +		     KVM_HOST_USES_PFN, sizeof(struct vcpu_runstate_info));
> +	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
> +		     KVM_HOST_USES_PFN, sizeof(struct vcpu_info));

Argh, KVM Xen doesn't actually treat these two as immutable values.  I suspect
you encountered this as well since check() and refresh() didn't drop @len.  I'm
99% certain we can still make the length immutable, it'll just require a bit of
massaging, i.e. extra patches.

The vcpu_info_cache length is effectively immutable, the use of the common helper
kvm_setup_guest_pvclock() just makes it less obvious.  This can be addressed by
making the param a "max_len" or "max_size" or whatever, e.g. so that accessing a
subset still verifies the cache as a whole.

The runstate_cache is messier since it actually consumes two different sizes, but
that's arguably a bug that was introduced by commit a795cd43c5b5 ("KVM: x86/xen:
Use gfn_to_pfn_cache for runstate area").  Prior to that, KVM always used the larger
non-compat size.  And KVM still uses the larger size during activation, i.e. KVM
will "fail" activation but allow a sneaky 32-bit guest to access a rejected struct
sitting at the very end of the page.  I'm pretty sure that hole can be fixed without
breaking KVM's ABI.

With those addressed, the max length becomes immutable and @len can be dropped.
I'll fiddle with this tomorrow and hopefully include patches for that in v2.

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b2be60c6efa4..9e79ef2cca99 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -212,10 +212,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
        if (!vx->runstate_cache.active)
                return;
 
-       if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
-               user_len = sizeof(struct vcpu_runstate_info);
-       else
-               user_len = sizeof(struct compat_vcpu_runstate_info);
+       user_len = sizeof(struct vcpu_runstate_info);
 
        read_lock_irqsave(&gpc->lock, flags);
        while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
