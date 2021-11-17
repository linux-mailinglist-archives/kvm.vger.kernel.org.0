Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40445514B
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 00:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbhKQXyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 18:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhKQXxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 18:53:55 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C040C0613B9;
        Wed, 17 Nov 2021 15:50:56 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hvfnf5QFsz4xdN;
        Thu, 18 Nov 2021 10:50:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1637193050;
        bh=Y6qLtvD8c83vsgFlioCTxBI91MBKkMrwNyHMmx3iNJk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Jv/ugO0GdH1f2QhPzft9Sxm/ntmhVoKfvBJTCvlmQ6WmIVLJ2Ps9uD42n8dNSGkkg
         wfYndhQTxnNrANlIOxL6l6FdkPbh71djkG3LkipwOlTpsCGCbCaOcYQGn2Fy/ejEeW
         6kpY8zvN0vfn1DhWVYqTQ5DveIe5yaDoKLSrEg0QCzmfKLpl94IdHDQDBLvD9L4j3v
         KRtHU+3QH9SXZqUmFBx38dz1SrkWHBs5XGhAkKOmtAXIL5Wbj2db2XwIZWrAlZEIOH
         05iVEr2HKDWNdtuOaS94KFmS0qEHie53/jVZ5Zr8m5snbbknqPu11gE31EKwHUouyn
         P9oDRQBt23RFQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
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
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 06/12] KVM: powerpc: Use Makefile.kvm for common files
In-Reply-To: <20211117174003.297096-7-dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-7-dwmw2@infradead.org>
Date:   Thu, 18 Nov 2021 10:50:44 +1100
Message-ID: <871r3emje3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> It's all fairly baroque but in the end, I don't think there's any reason
> for $(KVM)/irqchip.o to have been handled differently, as they all end
> up in $(kvm-y) in the end anyway, regardless of whether they get there
> via $(common-objs-y) and the CPU-specific object lists.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/powerpc/kvm/Makefile | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 583c14ef596e..245f59118413 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -4,11 +4,8 @@
>  #
>  
>  ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
> -KVM := ../../../virt/kvm
>  
> -common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> -common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
> +include $(srctree)/virt/kvm/Makefile.kvm
>  
>  common-objs-y += powerpc.o emulate_loadstore.o
>  obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
> @@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
>  kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
>  
>  kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
> -kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  
>  kvm-objs := $(kvm-objs-m) $(kvm-objs-y)

Looks OK to me. The extra objects built in Makefile.kvm are all behind
CONFIG symbols we don't enable.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
