Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5724863FA31
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 23:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiLAWAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 17:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiLAWAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 17:00:20 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9288EC3FFD
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 14:00:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id h4-20020a1c2104000000b003d0760654d3so3683194wmh.4
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 14:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QIafPhFD9IJ7Ly0CwNSGH3i2Rs4yyu6nN9+ipEhZh0A=;
        b=jjyByQFW3CViXa2XSpO0S5OezirA8iriSGyNq1Emb3eAjXPvAcs8h/qhWZvQRHrkM7
         E4yO5aU5oCECenX1ChS/eFoKmPv0xbsgDyU0kSVTl00jl03ZBLNhtOgaVKcwhuzhfB8T
         N7R+KHdaQ76bY3Z76ec67H1IKhJ28BX8clWmhefVQ98++dEoXnF5l49Qy+3a5Cak9CFt
         EIL7cmRV6y+1rtO82GUIbFuUYJjyYdwwYbZEtJNme41VeTXnC4oIE2dnPOWtcMsSXZFG
         q6jTLuz1FCKKC86LuPzjUTBAJLTqeyAPRmVpOXM4szcQvlKMGYRA5VkbQrYDVl2oy6Mj
         mCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QIafPhFD9IJ7Ly0CwNSGH3i2Rs4yyu6nN9+ipEhZh0A=;
        b=C325KX0zjhL3st5LvNH/dYQWjxAkr8B4zWcCHy0xfFmfIsuHvA3Pd7ZacQ80rPghK3
         8i45MG97u3kCcHXwvwQKkoEa6M55KsLhK4seQtX7iF/Q0+P6sWXOaekToBOlPmL9/5yI
         gnS9FCojQnDV3gIj6pIsy+9KHaUEq96idvWy+FToFjQzxdsPjd5I7jWiVJ7YmmoswnOO
         G1hiXbjkgY+lzHZI95cy+c65QxA+6i/zAPb1mizRDcxsVzF3v5v+9XtMzUkPGvHu5kFP
         3236TqJUBraOCN/qPrvj9T3D7myvDmDtrVXSyzYoEywPZk9gyzWdSCeVeUlBmWSUFRNy
         40sA==
X-Gm-Message-State: ANoB5pnG+x6CRBLgkLniNh6xp50hVt/aIpItwCdt0u6AhAYQVecK2yR/
        FhNe+Wy5PfbRe1jHOD2fpFNXuw==
X-Google-Smtp-Source: AA0mqf6xx+vYTMkMQZD2sUVXTGHs5cp2mVsSPKIbRGdbGqnCPXkM+pX1knRmP86IOvF6J1/cipiL/g==
X-Received: by 2002:a05:600c:3495:b0:3cf:ae53:918f with SMTP id a21-20020a05600c349500b003cfae53918fmr38954917wmq.131.1669932017038;
        Thu, 01 Dec 2022 14:00:17 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id k12-20020adfe8cc000000b00241b5af8697sm5556585wrn.85.2022.12.01.14.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 14:00:16 -0800 (PST)
Message-ID: <beb697c2-dfad-780e-4638-76b229f28731@linaro.org>
Date:   Thu, 1 Dec 2022 23:00:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2 21/50] KVM: MIPS: Hardcode callbacks to hardware
 virtualization extensions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-22-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221130230934.1014142-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/22 00:09, Sean Christopherson wrote:
> Now that KVM no longer supports trap-and-emulate (see commit 45c7e8af4a5e
> "MIPS: Remove KVM_TE support"), hardcode the MIPS callbacks to the
> virtualization callbacks.
> 
> Harcoding the callbacks eliminates the technically-unnecessary check on
> non-NULL kvm_mips_callbacks in kvm_arch_init().  MIPS has never supported
> multiple in-tree modules, i.e. barring an out-of-tree module, where
> copying and renaming kvm.ko counts as "out-of-tree", KVM could never
> encounter a non-NULL set of callbacks during module init.
> 
> The callback check is also subtly broken, as it is not thread safe,
> i.e. if there were multiple modules, loading both concurrently would
> create a race between checking and setting kvm_mips_callbacks.
> 
> Given that out-of-tree shenanigans are not the kernel's responsibility,
> hardcode the callbacks to simplify the code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/mips/include/asm/kvm_host.h |  2 +-
>   arch/mips/kvm/Makefile           |  2 +-
>   arch/mips/kvm/callback.c         | 14 --------------
>   arch/mips/kvm/mips.c             |  9 ++-------
>   arch/mips/kvm/vz.c               |  7 ++++---
>   5 files changed, 8 insertions(+), 26 deletions(-)
>   delete mode 100644 arch/mips/kvm/callback.c
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 28f0ba97db71..2803c9c21ef9 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -758,7 +758,7 @@ struct kvm_mips_callbacks {
>   	void (*vcpu_reenter)(struct kvm_vcpu *vcpu);
>   };
>   extern struct kvm_mips_callbacks *kvm_mips_callbacks;

IIUC we could even constify this pointer.

Anyway,
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index af29490d9740..f0a6c245d1ff 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1012,17 +1012,12 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   
>   int kvm_arch_init(void *opaque)
>   {
> -	if (kvm_mips_callbacks) {
> -		kvm_err("kvm: module already exists\n");
> -		return -EEXIST;
> -	}
> -
> -	return kvm_mips_emulation_init(&kvm_mips_callbacks);
> +	return kvm_mips_emulation_init();
>   }
>   
>   void kvm_arch_exit(void)
>   {
> -	kvm_mips_callbacks = NULL;
> +
>   }
>   
>   int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index c706f5890a05..dafab003ea0d 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -3304,7 +3304,10 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
>   	.vcpu_reenter = kvm_vz_vcpu_reenter,
>   };
>   
> -int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
> +/* FIXME: Get rid of the callbacks now that trap-and-emulate is gone. */
> +struct kvm_mips_callbacks *kvm_mips_callbacks = &kvm_vz_callbacks;
