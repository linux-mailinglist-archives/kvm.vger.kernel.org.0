Return-Path: <kvm+bounces-16917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6298BEBEF
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFAD31C2368D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCD416DEC2;
	Tue,  7 May 2024 18:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="gl6jwBF6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hmK9x3dO"
X-Original-To: kvm@vger.kernel.org
Received: from wfhigh2-smtp.messagingengine.com (wfhigh2-smtp.messagingengine.com [64.147.123.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D6E16D9B7;
	Tue,  7 May 2024 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715107893; cv=none; b=pS9zSnawHB5q0i0VxBN5ipTQNQ/pHVeYc4Jhb/4hRH8UwS2w5FnSenOY3sy3iSb3FIiiUTyS5yXS8QTa8IasIIO+VXwqTINS8LJJ7sGxiCeyfjjBODFPW+xEEok4CO4NKDQPZ19jjoeW77GzeEICImM+OCU9L9GKznt/8JIcCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715107893; c=relaxed/simple;
	bh=5ffs84l0W4DH7LDClMfPZZbVMp6HzHYo0bO60hFm+vk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VXMC2IWJ7oTdpgN3Xa2/pJaWUVzY79fYv8IP2gyg9jQtQUDV5vn8+MXYMLoPKQjX6Wf33DWhomWs74db4GD6BMRN+yf1U7DGg4sNJDCGgLwHDpXstkHtN5T28HleeE58hFyBAqYfsGq/RA/SUWJnza9M7Vh6LhT1GuShL30XZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=gl6jwBF6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hmK9x3dO; arc=none smtp.client-ip=64.147.123.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.west.internal (Postfix) with ESMTP id 3C6BE18000BD;
	Tue,  7 May 2024 14:51:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 07 May 2024 14:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1715107889;
	 x=1715194289; bh=c3T+T6In3bjtGWkRxYC6/7ih81Fbjv3sPp4ApyqJg/8=; b=
	gl6jwBF6CFsb1+3/o5fqi1mUnzeayqiHD0rhChWAmgPGbLV/6vkFdoxEJXSC6AzW
	da0ik3FghOuXYloJIN8eNwwuxYx6VnmWc3VP1rprEvBNxjulM+Gftp9b9tG9rMA6
	kRHDHhX63xqWxQu8ogK2N3JIeYrmMTZQeI5BmdugRelk+O1lQ9EJ+dK9/SzvwXMC
	HM/XINhrRffeD0e7WiX1GyTYG1hsz6Cxpj6Vex/ZnQnoKV8gIGMHVjaq4qds54NE
	yTJ6AbfIY2sG3eCp8H9l/n55j4Q4nQNDWIxs3tXP531QVyLi/287AaX6HXlKQ7LZ
	NEH3jlEYZmSMXGooI+eG8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1715107889; x=
	1715194289; bh=c3T+T6In3bjtGWkRxYC6/7ih81Fbjv3sPp4ApyqJg/8=; b=h
	mK9x3dOckj9Uo4dCwOT6ETb5u+38tClipXT3K2fqlopQHFIy7DSyW9+HBibTlECF
	2wsh1fp2meqoZ59vnCVHBqvYQvmyHouN7Xcaf/eFEVSuckmQsJtyyUe1YpJL8unz
	YWHFv7GVOQwWfSk2bmP7suhG55iYTmFwqJB8RSqacr3bS2BBH3qfFUdwU8JlxklY
	aRXt9ahwgEmJqXYfgHs127Webny/VyHTKQQq/Xr/AzjxOxSjK7cvIyz7nAw8/rKn
	+8KZH74dEi4o7w9mB/OBmufCN9QWOfsAbnQWgZWdVigqbnZs1Z8SY1PRVVzuS7gA
	TNRidWZ9EjcF7+DH6DCTw==
X-ME-Sender: <xms:MXg6ZllDMKSqt3X6vGkXJq0CjgwNF-c1mEb0c3B_TiG0CQH_0HB7cg>
    <xme:MXg6Zg2_ENH3uV4lQKm-YlhUNw65uEpd-Lp0aZZZNqbtv5faLHMBn76RnGJAEIDdc
    KMXVNKT5xWbgBZRmbE>
X-ME-Received: <xmr:MXg6ZrpeI23W-WTTQyh_e-x6v0xY-VHuQ-xFqiW4TlhkAcHa7st0PRM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvkedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffugggtgffkfhgjvfevofesthekredtredtjeenucfhrhhomheplfhi
    rgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpeevveetheeggfegjeekjedttdetueeludehveejgfejtedv
    hfdugeetgfelhfevkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:MXg6ZlndhSP-P0DtMlgIne8SQ8ot20rSlOOHNZle8TcICAO9eHhK8g>
    <xmx:MXg6Zj35LN1xYMV65j6Jn3FUwoQd8731f2Mx5H8ud7f9G5MWNwFRJw>
    <xmx:MXg6ZkuJNb_3Ld4skieWXrx6lFhDDTRrce9tLiTVS2QMPvx2Alzp7A>
    <xmx:MXg6ZnVo5pD4etDNAh158_HU985SWI_hV58nxV1XbdY2BOsHpKAqvQ>
    <xmx:MXg6ZhNwAXMytXvBevP3yoi7gjIIdz6huRnbe2m9oIjBVLnuSLYRPyZC>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 14:51:28 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Tue, 07 May 2024 19:51:19 +0100
Subject: [PATCH 1/4] MIPS: kvm: Declare prototype for kvm_init_loongson_ipi
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240507-loongson64-warnings-v1-1-2cad88344e9e@flygoat.com>
References: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
In-Reply-To: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1825;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=5ffs84l0W4DH7LDClMfPZZbVMp6HzHYo0bO60hFm+vk=;
 b=owGbwMvMwCHmXMhTe71c8zDjabUkhjSrCt3eiSbHbvWJ5HpZzVVlObxs3+IYvy79rOZbp/+8P
 Zz1tJOzo5SFQYyDQVZMkSVEQKlvQ+PFBdcfZP2BmcPKBDKEgYtTACZy6DjDf88l3C9Mf+jYBf0p
 uMyydGVb0bu/FwUm/GS+3JGmUrE7to+R4V/D6dOqi+ZK7Y+KjRZKC169f/qnvl18leuCLlx6+/z
 SGQYA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Declear prototype for kvm_init_loongson_ipi in interrupt.h.

Fix warning:
arch/mips/kvm/loongson_ipi.c:190:6: warning: no previous prototype for ‘kvm_init_loongson_ipi’ [-Wmissing-prototypes]
  190 | void kvm_init_loongson_ipi(struct kvm *kvm)
      |      ^~~~~~~~~~~~~~~~~~~~~

Fixes: f21db3090de2 ("KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/interrupt.h    | 4 ++++
 arch/mips/kvm/loongson_ipi.c | 2 ++
 arch/mips/kvm/mips.c         | 2 --
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/interrupt.h b/arch/mips/kvm/interrupt.h
index e529ea2bb34b..07bc0160bc94 100644
--- a/arch/mips/kvm/interrupt.h
+++ b/arch/mips/kvm/interrupt.h
@@ -37,3 +37,7 @@ u32 kvm_irq_to_priority(u32 irq);
 int kvm_mips_pending_timer(struct kvm_vcpu *vcpu);
 
 void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause);
+
+#ifdef CONFIG_CPU_LOONGSON64
+extern void kvm_init_loongson_ipi(struct kvm *kvm);
+#endif
diff --git a/arch/mips/kvm/loongson_ipi.c b/arch/mips/kvm/loongson_ipi.c
index 5d53f32d837c..6ac83a31148c 100644
--- a/arch/mips/kvm/loongson_ipi.c
+++ b/arch/mips/kvm/loongson_ipi.c
@@ -10,6 +10,8 @@
 
 #include <linux/kvm_host.h>
 
+#include "interrupt.h"
+
 #define IPI_BASE            0x3ff01000ULL
 
 #define CORE0_STATUS_OFF       0x000
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 231ac052b506..56fedfbe9455 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -135,8 +135,6 @@ void kvm_arch_hardware_disable(void)
 	kvm_mips_callbacks->hardware_disable();
 }
 
-extern void kvm_init_loongson_ipi(struct kvm *kvm);
-
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	switch (type) {

-- 
2.34.1


