Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2C6CD962
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjC2Mee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC2Med (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 08:34:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E540CB
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 05:34:31 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j24so15563849wrd.0
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680093270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Azf/QriO6xEBA+3odzgx0vqYoxFep+uxO2ElIXTQHA=;
        b=MPtsRAi6CDFL1lnMAqY98eiGHqlZ2MJDA0rc9hN7jig/gqM8Pw4wlbrtpjKKEi6qzT
         WkIw/MkUuPqZFh3RI4Bs8XTS+X8w+vTAXgBnZ9GRWi30Ktl33nlR9ATaZRsUqzrcydMp
         zyzjUHE7jc8fT4OCkXJDASeACWqlG5U0Fm+vFSp8EuHP1BshVBHFjX4VneQdOu8otcYM
         7OcmCHFr66kYMQaySv6Gniy7CRiNybjwCnVzTf4xEZyDOUrFwyajB7TVuci+etsZWYle
         LPTJiMyt4h83aIjlAzCfoKGGw47U9af/7BY/5v0daM0SF2F0UOMI9Ge0X5XZ+SjhzBcY
         6Prw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680093270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Azf/QriO6xEBA+3odzgx0vqYoxFep+uxO2ElIXTQHA=;
        b=hhB2aPKCOU2HwXLN1bySCGgvylDGelaXIR/tEk8MIu6fCtdtMHPadqQFhsGIEIxBN+
         ye5l3DBrdaaKvvo4FFn8sG8D5aaFF/y4eDANWfNmikuOPq+UiwuASPMDu/nn0nWe36sU
         8eA6vcxwmBHr/rfews1Cc1HGzxUlvQ+/YvFN3uIwvtGw7WaRCMvAufV8dRF2hIf96ixd
         joJtAMYMNJEs1TpVo70VFOEfSfsblduHmRW9htHlS2LOBoyuT9ZMYhHFStpVh7xG2PQa
         ofXp8w4YnEGKZMn8VGZIKah2rPCvrCA+MJCtgRPH/Xgm6sVs9EM3/aXFU71l2oIae/UH
         wXQg==
X-Gm-Message-State: AAQBX9fXSsLxGnCiZkddPA0RJkGcjmjt0os8s4oviRJ1t4tQjt2wLt4m
        wz6QNCOMV1zCfk3hopgiZUWqpw==
X-Google-Smtp-Source: AKy350blKcPwf4pu1qKMJdqcvhVgPxQ3B9VoVE8+8X8regBA2fLjKdxu3keY6cm9zro4ImrkQoUe7A==
X-Received: by 2002:a5d:4590:0:b0:2d8:a55e:1fd7 with SMTP id p16-20020a5d4590000000b002d8a55e1fd7mr14972537wrq.21.1680093270073;
        Wed, 29 Mar 2023 05:34:30 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id e18-20020a056000121200b002d24a188b64sm30134445wrx.112.2023.03.29.05.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 05:34:29 -0700 (PDT)
Message-ID: <1548c1a4-4681-4d98-ee43-44bc97b3bdee@linaro.org>
Date:   Wed, 29 Mar 2023 13:34:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 07/26] KVM: VMX: Move preemption timer <=> hrtimer
 dance to common x86
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Lee Jones <joneslee@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <20211208015236.1616697-8-seanjc@google.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20211208015236.1616697-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

On 12/8/21 01:52, Sean Christopherson wrote:
> Handle the switch to/from the hypervisor/software timer when a vCPU is
> blocking in common x86 instead of in VMX.  Even though VMX is the only
> user of a hypervisor timer, the logic and all functions involved are
> generic x86 (unless future CPUs do something completely different and
> implement a hypervisor timer that runs regardless of mode).
> 
> Handling the switch in common x86 will allow for the elimination of the
> pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
> timer if and only if it was in use (without additional params).  Add a
> comment explaining why the switch cannot be deferred to kvm_sched_out()
> or kvm_vcpu_block().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  6 +-----
>  arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 64932cc3e4e8..a5ba9a069f5d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7444,16 +7444,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  
>  static int vmx_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_lapic_hv_timer_in_use(vcpu))
> -		kvm_lapic_switch_to_sw_timer(vcpu);
> -
>  	return 0;
>  }
>  
>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops.set_hv_timer)
> -		kvm_lapic_switch_to_hv_timer(vcpu);
> +
>  }
>  

This patch fixes the bug reported at:
LINK:
https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605

One may find the strace at:
LINK: https://syzkaller.appspot.com/text?tag=CrashLog&x=1798b54ec80000
and the c reproducer at:
LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=10365781c80000

Since I've no experience with kvm, it would be helpful if one of you can
provide some guidance. Do you think it is worth to backport this patch
to stable (together with its prerequisite patches), or shall I try to
get familiar with the code and try to provide a less invasive fix?

Thanks!
ta
