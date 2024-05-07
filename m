Return-Path: <kvm+bounces-16920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A28278BEBFB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D61C0B26F8D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CA316EBFA;
	Tue,  7 May 2024 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="kUo3SyVr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aYEDvQiN"
X-Original-To: kvm@vger.kernel.org
Received: from wfhigh2-smtp.messagingengine.com (wfhigh2-smtp.messagingengine.com [64.147.123.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2816F0CE;
	Tue,  7 May 2024 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715107903; cv=none; b=JYfzHRNfH06MnEcH+h6RNe7lW+igckb3tvZqYLL4LPIPeaSsQJ0yJCIyG0R1WhoHLERHohh0N1v3wuspFJ6THlIHjI7/FLq0mwTCBKuMUAaMYjDt0wP5BiP7Bh8fP3wZNwTg0qb6ocT64FjgtOeSgi0ia/vVjotS+rkHfXN13LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715107903; c=relaxed/simple;
	bh=NkwgO3Xx+CZsPTw6Ct6xNfXjIzDoPYKA1nrX18S20Ho=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XF8Y9Ahniz6aDfMaYo3/f4oFw2zOUAV+fbRhUPnmscoI99Ad4GeNiE5j5r/B5nBuLaWev+uu4vqwXHHXeJlle4kI8pWE5OhHXJCtyoiJuTop04eHVdgVGLHOY+paecVPS1ixMP+/xzYRDoVuzFJ3/eM1PeaaQbBS7vKDDoqKxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=kUo3SyVr; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aYEDvQiN; arc=none smtp.client-ip=64.147.123.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailfhigh.west.internal (Postfix) with ESMTP id 7EF1A180008E;
	Tue,  7 May 2024 14:51:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 07 May 2024 14:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1715107900;
	 x=1715194300; bh=jf3K4jfhVQv94P++cE/GZXhfZxx3dBPciOpFjrGUmBw=; b=
	kUo3SyVrVhaV6HJw+Mi2+XKYQz+bJgVj38c2a2j+gr2xGXsFM+obkZ0h70U9CfQU
	sXN84h3tiOW73IhJwlXVXrZxK80DYWnevDc2sU4CmWS2oJtgp3ZYhZNoEIPK41bh
	h2phgaVnnkgn8wjrXsbf8xo8L8zzM5Dx90W7brlhpmCgQLMzztu1EvQZphGrGYb3
	9XyUjIspZD4TdR+83FkLH3ZaTOXgACiT2U2YqZHUub1QyCBmHR+T8lWGftGkVCDg
	L/SQT90nCguXguta8qWG9WEKLhhk33y8HF0EWPfq0ygSORO4yXA3qffew5s0KkuE
	cCgwFwnLmj2lgqsoxasvvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1715107900; x=
	1715194300; bh=jf3K4jfhVQv94P++cE/GZXhfZxx3dBPciOpFjrGUmBw=; b=a
	YEDvQiNwF5keLlmSpuA/NggsJAF72KvQkuxwI7j74sTHFAblloqn8gU5r5BGWAet
	Co3NyboJcLAGBxOJ6QorUUre0iHTCGh758EWkYOnc5xSddERSUFmsrjdquTFrQ5p
	hr0MkA8tW44+ahDUtQclHt9SUBzhAgBTjZeZOLFQXCfFkRIhh6c7IQq+Gep9cBoN
	sDmgyJlnYgbBSQMj0veNNwdh2QjNMfT0pllHMPoQLuUlFuaM5uFsdNZlZ+aep7H+
	nz/T0uK0/YP/DQSwAJViXE+mvF5PyE7ND3wI1NwbO3LMMKUKzoyXOUKCG7gf2jfJ
	KbPiwz2slLV51cUEumjeA==
X-ME-Sender: <xms:O3g6ZlFGzOxPrZi4NEjfLcIHPf8UXBJWNhy6k22saqrfAY-d6V6fpQ>
    <xme:O3g6ZqXSyLLFOKLRo_7jXvnSo9bOWccYzCzEDS1Kmll4Yn5SM7AsWsHeGG_CZUXnz
    K--zt0ETFksLAjJ5wU>
X-ME-Received: <xmr:O3g6ZnJGPspH_e7Ssw8XmKRIMQALPR222IvKDhefgz_CAHs7E92Rq0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvkedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredtjeenucfhrhhomheplfhi
    rgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpedvkeeihfefveekueevteefleffkeegudeghfdtuddugefh
    ueevgeffgedukeejleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:O3g6ZrHWySEwmg6qZeNW4vFoOEzTdz4EehLwrL_iST4jCqVzdB0kdQ>
    <xmx:O3g6ZrUzQ18Xy-D1_etmA9yqxbK2Mr4idbJ7BRtk5GHML0T111A5Jg>
    <xmx:O3g6ZmM-1BGbwmYIYpGRlPEKPmVlun4guvxCbIGON2t1oX-8h6MNzw>
    <xmx:O3g6Zq0TTRdYHD0lFt9COPh3T_j3ByJ9bOBdzBK6BX8oFxZyTNEb6A>
    <xmx:PHg6ZktZyfUqRV-GdSlEZlQu3Tug5htDsNTV2wPo1I7WB7ESUk0OEgEH>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 14:51:38 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Tue, 07 May 2024 19:51:22 +0100
Subject: [PATCH 4/4] MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240507-loongson64-warnings-v1-4-2cad88344e9e@flygoat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4399;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=NkwgO3Xx+CZsPTw6Ct6xNfXjIzDoPYKA1nrX18S20Ho=;
 b=owGbwMvMwCHmXMhTe71c8zDjabUkhjSrCt1Ky+OVNZtkZycEOfxuE460CH8r1HhS1ezpyfOL9
 hU2LYnuKGVhEONgkBVTZAkRUOrb0HhxwfUHWX9g5rAygQxh4OIUgInYv2dk+LVD0Dv/b+xmaZNT
 SQGST+bvnVecZcpz1PBp2JnqhNZblxgZdjAkVtSUxS71Kxbk37pJuuew/cL9v56kFlQ+er1GqGo
 LGwA=
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Add various required properties to silent warnings:

arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi:116.16-297.5: Warning (interrupt_provider): /bus@10000000/pci@1a000000: '#interrupt-cells' found, but node is not an interrupt provider
arch/mips/boot/dts/loongson/loongson64_2core_2k1000.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 37 ++++++++++++++++++----
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index ee3e2153dd13..b5593f7cc383 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -118,7 +118,6 @@ pci@1a000000 {
 			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			#interrupt-cells = <2>;
 
 			reg = <0 0x1a000000 0 0x02000000>,
 				<0xfe 0x00000000 0 0x20000000>;
@@ -204,93 +203,117 @@ sata@8,0 {
 				interrupt-parent = <&liointc0>;
 			};
 
-			pci_bridge@9,0 {
+			pcie@9,0 {
 				compatible = "pci0014,7a19.0",
 						   "pci0014,7a19",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x4800 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 0 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 
-			pci_bridge@a,0 {
+			pcie@a,0 {
 				compatible = "pci0014,7a09.0",
 						   "pci0014,7a09",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x5000 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 1 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 
-			pci_bridge@b,0 {
+			pcie@b,0 {
 				compatible = "pci0014,7a09.0",
 						   "pci0014,7a09",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x5800 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 2 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 
-			pci_bridge@c,0 {
+			pcie@c,0 {
 				compatible = "pci0014,7a09.0",
 						   "pci0014,7a09",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x6000 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 3 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 
-			pci_bridge@d,0 {
+			pcie@d,0 {
 				compatible = "pci0014,7a19.0",
 						   "pci0014,7a19",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x6800 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 4 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 
-			pci_bridge@e,0 {
+			pcie@e,0 {
 				compatible = "pci0014,7a09.0",
 						   "pci0014,7a09",
 						   "pciclass060400",
 						   "pciclass0604";
 
 				reg = <0x7000 0x0 0x0 0x0 0x0>;
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &liointc1 5 IRQ_TYPE_LEVEL_LOW>;
+				ranges;
 				external-facing;
 			};
 

-- 
2.34.1


