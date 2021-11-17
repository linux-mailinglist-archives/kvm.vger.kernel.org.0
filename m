Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D98454C3C
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhKQRnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhKQRn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:43:27 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A43BC061207;
        Wed, 17 Nov 2021 09:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iV/c2XVgMhEj0ZhoFj3F05pdjTjXAYKD2dhk6bn92rk=; b=ffx29lf2DoChLwxzAu1XsOIsCt
        CzSAztos84Ba1MUGFSzdq+FVUTtbjlJv69OAf8Cum4YdS5W6UFqrwj1ybUlUeKIQ6DwyOlQPUoTgY
        DoE7YyZRkmJfpuQOOu30zH2u3LPJRtbqNrcbtrjgVbFcO+nMwMAgFyTXjcOsFvd55gtxMomxFWEWu
        q4EbH5CIZTnHfS3feRhmyIhjkk43zt1cV1Ct3js6a/KSvVMmWxYkCVXIQygj5NMrdc3QhpPASEIHO
        eofEhz3221S5cHwyJFVnIM6OClaJmAD/ORn33qZ0zoBve1qaiChAAPyGgqulGMgvKMua3t042e2R4
        M6YWYgJw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnOum-00GXWa-H5; Wed, 17 Nov 2021 17:40:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnOum-001GxQ-7p; Wed, 17 Nov 2021 17:40:08 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
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
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 04/12] KVM: mips: Use Makefile.kvm for common files
Date:   Wed, 17 Nov 2021 17:39:55 +0000
Message-Id: <20211117174003.297096-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117174003.297096-1-dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/mips/kvm/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index d3710959da55..21ff75bcdbc4 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -2,9 +2,10 @@
 # Makefile for KVM support for MIPS
 #
 
+include $(srctree)/virt/kvm/Makefile.kvm
+
 ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
 
-kvm-y := $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o binary_stats.o)
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
 kvm-y +=    mips.o emulate.o entry.o \
-- 
2.31.1

