Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE61046F2C3
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbhLISK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237652AbhLISK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:10:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B6CC061746;
        Thu,  9 Dec 2021 10:07:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y13so21840798edd.13;
        Thu, 09 Dec 2021 10:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/BR1/2RGDScqGY9eUb2OeC+8FFb2k7htqUCGVYcL9Ck=;
        b=Lhbpmm1UKqlpxT/ebiO1Bba267s4bE94yh07WOHh4nJeWCnmE8+23Eg5C12Rhgfpsc
         0I4D6URfKKEqBAzSviybZHxAOPOACMyExokRlTYNq44nDkWCuzRtqrXLPqBLh0Q1MX+o
         Jtx1lpBHXhEr3ddLKS6N/SSGxs76Q2vWnWxLnCwJZn1OqNjqHCU0mb7ID9NFK1G/sQ7f
         QnXai4TvqSPLltPU5wh6tLAcP4ybsTybXo1I146LDMPVWG7M5ZooS0wo6QoJtRF//8Lt
         64rO/CTBMU0ZFk+JY57EO2EnzjUHgznePMSl5XKLuc96fG3MU0lOVX14FEeAcqzIaDIb
         CLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/BR1/2RGDScqGY9eUb2OeC+8FFb2k7htqUCGVYcL9Ck=;
        b=SNhgx90mmKagdH+JTqlGon0ew07q7wGGeYEY42uWlpUnNnd/ZO3UZ9Fvqajq+IaYpM
         oQwy2pfdS42JYG0DnaPE6P6KSf6T0rhr+aIh6a0DIvuvQD1H8MQgIZY6MKhPeDZcT16Z
         rPMOdT5ZRfvdSGQDM5+AzHbxCKopX1teQ5stKBgqM8ACR8FpO+5ulx6WbH0TEzEKSwsN
         IhJAmFY5O4436d60dtk7mz5vXqkMta5axIkM3kprkFOkH8O8SSmNqlWM5hA9fwiXt14I
         j4FWgByRfgFHah0nsNgoe36MATfXIwMecbrIsJjh6OAl+T5oKeo0/SfQdSLT9zgNFV/x
         6aWA==
X-Gm-Message-State: AOAM532e5yk80W353CjmDH3zUlBGCwLYFdGf9BgNBpHTe6Y6Tz8QaAzT
        sStxCHcCzT3vmCh8cshvFoE=
X-Google-Smtp-Source: ABdhPJyCcY7SoPv6aHO9XYFGu1O783sL+OxwRl4LzsOaKHe6HzGM6Aj5sR6vgOMnSD+1083Jrn4srQ==
X-Received: by 2002:a05:6402:d05:: with SMTP id eb5mr31407913edb.360.1639073154112;
        Thu, 09 Dec 2021 10:05:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id og38sm275399ejc.5.2021.12.09.10.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:05:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <048a1ef6-193a-eb82-0433-70c97e1a03e5@redhat.com>
Date:   Thu, 9 Dec 2021 19:05:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 06/12] KVM: powerpc: Use Makefile.kvm for common files
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-7-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-7-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/21 13:54, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> It's all fairly baroque but in the end, I don't think there's any reason
> for $(KVM)/irqchip.o to have been handled differently, as they all end
> up in $(kvm-y) in the end anyway, regardless of whether they get there
> via $(common-objs-y) and the CPU-specific object lists.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> ---
>   arch/powerpc/kvm/Makefile | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 583c14ef596e..245f59118413 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -4,11 +4,8 @@
>   #
>   
>   ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
> -KVM := ../../../virt/kvm
>   
> -common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> -common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
> +include $(srctree)/virt/kvm/Makefile.kvm
>   
>   common-objs-y += powerpc.o emulate_loadstore.o
>   obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
> @@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
>   kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
>   
>   kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
> -kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>   
>   kvm-objs := $(kvm-objs-m) $(kvm-objs-y)

Same here,

kvm-y += $(kvm-objs-m) $(kvm-objs-y)

would be slightly preferrable IMO.

Paolo
