Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F178D667AA8
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjALQWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbjALQWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:22:00 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAB433D
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:17:59 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m3so13584603wmq.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yZgCr+2z0xrDv88x9ZTkSd2hgvuNbo4TZmy0bXcMaJw=;
        b=HBNX4Ha22/UzbWsk72gUVP7o8bpSd+nFmCExthzLNRBHHHVxz6P3nImjBLhjrD8/Ui
         G6FAbEIA2hrNzzJZvAy3bDoVGQHSTqsK5D4/MXJ3qc4rozmiWCA1YwBrXgXK5ElPrnOg
         fuCknK7vmwhxC+yRiSyxxDkZ+x2089gaYxb5SKcvQPAOQdNiwTbvUaa96nazBGZkcbR+
         uIs1wM6nj7PjOsJILPxM6Qec9sd+2Ox8Y8o5eFsyZboQlhcQHBD+l5YcuAqQFSWfVUoh
         IbBp+dXPy8r3uYk7/Kyruh/fzZHhQF7/DAZ1JVch6XqlDxkPE7tp3GZM3LMWS4WOsdRU
         S+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZgCr+2z0xrDv88x9ZTkSd2hgvuNbo4TZmy0bXcMaJw=;
        b=59zYvivom4nrW7J2Bc+NVeDHoFxMIsAq9RTl+oeAfIs8gUWZcn585L681/ls4SwL4O
         0z3Wh1dd3MzXNe5tCeMFOz3YXL2RCQIZAQdGsKJHTR4mtunakflAUXuFQcL2DFDKdqis
         Mu4pU4/Pd5C8ELJl4zj0173q1cZlqRuX/V3CEWhsGZ83NHwn5nLTu/D/Y26dweSIgY39
         /NdwufIgW8bCpI7SL8iTiwR13SzOmUp7TUpI3qz8rbfPrNImMBKXWq9Vi0l0Z0C+NR9W
         2E+as4bxiP0cFE1aYzn+fUVpY2OL0GtdwDi2+HMFEMo7JkvHyiQF8Ie2mnEulXCqhw8+
         ZFlg==
X-Gm-Message-State: AFqh2kqagRhayRlflEa208/ipB2YXUsntXn7l82niwLJMwapj6ILxrkN
        lEKY2UuJ1qKP1wxy4yMCZLk=
X-Google-Smtp-Source: AMrXdXv/O7g7z9HYH7EAGWCioZhOcCebIyHxPbSBoYAIKuvkMmN2YU2FPNDxVyLOb/2acDYXpFkuvQ==
X-Received: by 2002:a05:600c:600a:b0:3d1:ed41:57c0 with SMTP id az10-20020a05600c600a00b003d1ed4157c0mr59691845wmb.30.1673540277571;
        Thu, 12 Jan 2023 08:17:57 -0800 (PST)
Received: from [10.85.34.175] (54-240-197-225.amazon.com. [54.240.197.225])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c351300b003d9a86a13bfsm24320443wmq.28.2023.01.12.08.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:17:57 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <64cf2539-6f78-1ec4-15ad-8fc5ca8353c1@xen.org>
Date:   Thu, 12 Jan 2023 16:17:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 2/4] KVM: x86/xen: Fix potential deadlock in
 kvm_xen_update_runstate_guest()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
 <20230111180651.14394-2-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20230111180651.14394-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/2023 18:06, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The kvm_xen_update_runstate_guest() function can be called when the vCPU
> is being scheduled out, from a preempt notifier. It *opportunistically*
> updates the runstate area in the guest memory, if the gfn_to_pfn_cache
> which caches the appropriate address is still valid.
> 
> If there is *contention* when it attempts to obtain gpc->lock, then
> locking inside the priority inheritance checks may cause a deadlock.
> Lockdep reports:
> 
> [13890.148997] Chain exists of:
>                   &gpc->lock --> &p->pi_lock --> &rq->__lock
> 
> [13890.149002]  Possible unsafe locking scenario:
> 
> [13890.149003]        CPU0                    CPU1
> [13890.149004]        ----                    ----
> [13890.149005]   lock(&rq->__lock);
> [13890.149007]                                lock(&p->pi_lock);
> [13890.149009]                                lock(&rq->__lock);
> [13890.149011]   lock(&gpc->lock);
> [13890.149013]
>                  *** DEADLOCK ***
> 
> In the general case, if there's contention for a read lock on gpc->lock,
> that's going to be because something else is either invalidating or
> revalidating the cache. Either way, we've raced with seeing it in an
> invalid state, in which case we would have aborted the opportunistic
> update anyway.
> 
> So in the 'atomic' case when called from the preempt notifier, just
> switch to using read_trylock() and avoid the PI handling altogether.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)

Reviewed-by: Paul Durrant <paul@xen.org>

... with one suggestion below.

> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 07e61cc9881e..809b82bdb9c3 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -272,7 +272,15 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>   	 * Attempt to obtain the GPC lock on *both* (if there are two)
>   	 * gfn_to_pfn caches that cover the region.
>   	 */
> -	read_lock_irqsave(&gpc1->lock, flags);
> +	if (atomic) {
> +		local_irq_save(flags);
> +		if (!read_trylock(&gpc1->lock)) {
> +			local_irq_restore(flags);
> +			return;
> +		}
> +	} else {
> +		read_lock_irqsave(&gpc1->lock, flags);
> +	}
>   	while (!kvm_gpc_check(gpc1, user_len1)) {
>   		read_unlock_irqrestore(&gpc1->lock, flags);
>   
> @@ -309,7 +317,14 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>   		 * gpc1 lock to make lockdep shut up about it.
>   		 */
>   		lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
> -		read_lock(&gpc2->lock);
> +		if (atomic) {
> +			if (!read_trylock(&gpc2->lock)) {

You could avoid the nesting in this case with:

if (atomic && !read_trylock(&gpc2->lock))

> +				read_unlock_irqrestore(&gpc1->lock, flags);
> +				return;
> +			}
> +		} else {
> +			read_lock(&gpc2->lock);
> +		}
>   
>   		if (!kvm_gpc_check(gpc2, user_len2)) {
>   			read_unlock(&gpc2->lock);

