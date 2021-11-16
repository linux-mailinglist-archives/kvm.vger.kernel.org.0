Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C3453165
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhKPLyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhKPLyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 06:54:24 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A41C0613B9;
        Tue, 16 Nov 2021 03:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yWZTSFEcMQzXm3g2QNc13LIwZBP4vIj1OJKIB2I3CoQ=; b=MtTrLPWZF8/Jdg7SAie8fPWQ3c
        7x7L1nfIc3ANGifiOZnxcp4Bj2N+h4+gCZB/4MpZCtN9cD5kgTnl9iCEOjeA/oFjmX8mgImnMlnIk
        oEfyxzI4ypvJCTj6zznTCgXIXgk60CbJTW0EYgiKsvE66U3ab4bmjvrW1DP8JNl2CoGufDNviSGFh
        kAyf2zFYkpGkmmrF4Ve02UfPNO2w0Uc5Y+LJVGt8HqeJuZ9/coIlYvFxyekL+FP9EiouH/j037rJ5
        CFWTzOBd09ZYbgUAetRPMgicg4nGdf5PQqnPmVhX2qYGOdaPkua84OyoOSySkERXPoyxAdiRn688r
        fuBQFCkw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmwzD-00GJ7C-Qh; Tue, 16 Nov 2021 11:50:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmwzD-000VDn-FA; Tue, 16 Nov 2021 11:50:51 +0000
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
Subject: [PATCH 5/7] KVM: RISC-V: Use Makefile.kvm for common files
Date:   Tue, 16 Nov 2021 11:50:49 +0000
Message-Id: <20211116115051.119956-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116115051.119956-1-dwmw2@infradead.org>
References: <5047c2591310e503491850ef683f251395247d50.camel@infradead.org>
 <20211116115051.119956-1-dwmw2@infradead.org>
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
 arch/riscv/kvm/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 30cdd1df0098..300590225348 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -5,14 +5,10 @@
 
 ccflags-y += -I $(srctree)/$(src)
 
-KVM := ../../../virt/kvm
+include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
 
-kvm-y += $(KVM)/kvm_main.o
-kvm-y += $(KVM)/coalesced_mmio.o
-kvm-y += $(KVM)/binary_stats.o
-kvm-y += $(KVM)/eventfd.o
 kvm-y += main.o
 kvm-y += vm.o
 kvm-y += vmid.o
-- 
2.31.1

