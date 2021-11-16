Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB329453160
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhKPLyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbhKPLyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 06:54:24 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28499C061200;
        Tue, 16 Nov 2021 03:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iV/c2XVgMhEj0ZhoFj3F05pdjTjXAYKD2dhk6bn92rk=; b=SiM2tfcCkFxE4v7nfuoZ0X4YpK
        I10Aq3n+CiqTfHO8f0fwx1sAWWsN5h2cWAzQ50YbYs5PnBFOIi7xFK0EhEJRsenHzydkQy8w85N73
        v4enznaxtNLv0nclMVvUIIyGZFt4dhosvQXLvpOtK46Ba4LoB+hUwCUj6LvdI4bhG7ZmSZicjLfBf
        f22GSOrzYSkx+NRK9+2u8G+B0KGkMdLr+y0S7PQYiWcaQWDbkKTz8FYsmQHQhTBtfHnzBnfy9x99k
        PCgX/y8JYZYTfxWkAt85bPs4UQo1gjeDBtwnmVXIdJwT5zghL7ZS54JPTu3iNyQ+AyiM47mxle+At
        wXwJxlgg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmwzD-00GJ7B-OJ; Tue, 16 Nov 2021 11:50:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmwzD-000VDi-Be; Tue, 16 Nov 2021 11:50:51 +0000
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
Subject: [PATCH 4/7] KVM: mips: Use Makefile.kvm for common files
Date:   Tue, 16 Nov 2021 11:50:48 +0000
Message-Id: <20211116115051.119956-4-dwmw2@infradead.org>
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

