Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B16E5F21
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjDRKsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDRKsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:48:19 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAF6E49
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:48:18 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso2860028wms.4
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681814896; x=1684406896;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gEwR6KtNxSbU17prGLCK7vz5h7AeZ/KD54lx3zH1Yn0=;
        b=CyRqkDHGlSZJfeiv5gznYbzxsX/+z4STQCYrBSK5fb9QLbcYECqkQ0N9UD65TZ/c71
         dJj/EDjIYPty2Axj+eW9D0HmaCIXvODujC9/NrfVyVjPrNBeFyPxoHu/nhtebmcH+bFJ
         a7GdKd9mVBgtmFy1S+Rw+4rcbAj8mtxSVAgzHrsCyed9M2Qig+s8UdaWLHtc/dUpZt1Y
         kKHU3pioFZfs1/IhjoIXHgBeasdlYx6P5P13CXDxcXonQLcrBfq14Av2GeHA3+gxnnsr
         QRo/9nCr++F8kh+Vxc2fhtcVbVJ6HwA8DAxlBXESCnzEYeYV99b+OGukhd3CmtGyuHsa
         zj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681814896; x=1684406896;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEwR6KtNxSbU17prGLCK7vz5h7AeZ/KD54lx3zH1Yn0=;
        b=RC0f9LV8jmHP3vEvDM2rMXaC1a7jVFdMJGTqTGfKlexCVV40a6BOgABKlX2D+Cn2ME
         EvzoKFghU4Ms3elj01Z9802RGm8Op2twqDlMK86V+r5sBr76yHtKWwN45mdDrrFdMXXA
         WtDwSayzS5PMGd7j5JHnPfOvDnr+2Zbx9z5Bf6A7L4OKhUkUq5i4lKgXOyY72m+lobs5
         evV87b+uC2gASvBEH+xpQIu9xyJ/m2UWMTs0OksNLkWUPRq7clzYhmd5WJ+jOHexgevH
         +vcyzRkOqHCnH4LUaicqogCBOlAPu2l1JEuGYnIGWJaLObuQjv2jIx+fNoseYDf8Sy6e
         cJ1Q==
X-Gm-Message-State: AAQBX9cvBqiWFpA+LMv7kTa+OQ7JxFGkW7fSxd6XO+4ZzDKtjfiSiJ1E
        HtLwVA3aLqmnwFkQMhFXJKo=
X-Google-Smtp-Source: AKy350YimcI2ukg3o641WnIr8Lr6SMemlR1orYLP3UKLv+tYLvHr8bMqo/hFDkyvHFRN+QnuIA9fgQ==
X-Received: by 2002:a1c:7510:0:b0:3ee:289a:43a7 with SMTP id o16-20020a1c7510000000b003ee289a43a7mr14152968wmc.22.1681814896535;
        Tue, 18 Apr 2023 03:48:16 -0700 (PDT)
Received: from [192.168.10.76] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003f080b2f9f4sm18289380wmq.27.2023.04.18.03.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 03:48:16 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <3ede838b-15ef-a987-8584-cd871959797b@xen.org>
Date:   Tue, 18 Apr 2023 11:48:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs
 hypercall
Content-Language: en-US
To:     Metin Kaya <metikaya@amazon.co.uk>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     x86@kernel.org, bp@alien8.de, dwmw@amazon.co.uk, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
 <20230418101306.98263-1-metikaya@amazon.co.uk>
Organization: Xen Project
In-Reply-To: <20230418101306.98263-1-metikaya@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/2023 11:13, Metin Kaya wrote:
> Implement in-KVM support for Xen's HVMOP_flush_tlbs hypercall, which
> allows the guest to flush all vCPU's TLBs. KVM doesn't provide an
> ioctl() to precisely flush guest TLBs, and punting to userspace would
> likely negate the performance benefits of avoiding a TLB shootdown in
> the guest.
> 
> Signed-off-by: Metin Kaya <metikaya@amazon.co.uk>
> 
> ---
> v3:
>    - Addressed comments for v2.
>    - Verified with XTF/invlpg test case.
> 
> v2:
>    - Removed an irrelevant URL from commit message.
> ---
>   arch/x86/kvm/xen.c                 | 15 +++++++++++++++
>   include/xen/interface/hvm/hvm_op.h |  3 +++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 40edf4d1974c..a63c48e8d8fa 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -21,6 +21,7 @@
>   #include <xen/interface/vcpu.h>
>   #include <xen/interface/version.h>
>   #include <xen/interface/event_channel.h>
> +#include <xen/interface/hvm/hvm_op.h>
>   #include <xen/interface/sched.h>
>   
>   #include <asm/xen/cpuid.h>
> @@ -1330,6 +1331,17 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, bool longmode,
>   	return false;
>   }
>   
> +static bool kvm_xen_hcall_hvm_op(struct kvm_vcpu *vcpu, int cmd, u64 arg, u64 *r)
> +{
> +	if (cmd == HVMOP_flush_tlbs && !arg) {
> +		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_TLB_FLUSH_GUEST);
> +		*r = 0;
> +		return true;
> +	}
> +
> +	return false;
> +}

This code structure means that arg != NULL will result in the guest 
seeing ENOSYS rather than EINVAL.

   Paul

> +
>   struct compat_vcpu_set_singleshot_timer {
>       uint64_t timeout_abs_ns;
>       uint32_t flags;
> @@ -1501,6 +1513,9 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>   			timeout |= params[1] << 32;
>   		handled = kvm_xen_hcall_set_timer_op(vcpu, timeout, &r);
>   		break;
> +	case __HYPERVISOR_hvm_op:
> +		handled = kvm_xen_hcall_hvm_op(vcpu, params[0], params[1], &r);
> +		break;
>   	}
>   	default:
>   		break;
> diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
> index 03134bf3cec1..240d8149bc04 100644
> --- a/include/xen/interface/hvm/hvm_op.h
> +++ b/include/xen/interface/hvm/hvm_op.h
> @@ -16,6 +16,9 @@ struct xen_hvm_param {
>   };
>   DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
>   
> +/* Flushes guest TLBs for all vCPUs: @arg must be 0. */
> +#define HVMOP_flush_tlbs            5
> +
>   /* Hint from PV drivers for pagetable destruction. */
>   #define HVMOP_pagetable_dying       9
>   struct xen_hvm_pagetable_dying {

