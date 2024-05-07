Return-Path: <kvm+bounces-16919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9DB8BEBF8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 28F4CB26E0C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0449416EC1E;
	Tue,  7 May 2024 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="Pgvn1Lia";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AYMsDJPW"
X-Original-To: kvm@vger.kernel.org
Received: from wfhigh2-smtp.messagingengine.com (wfhigh2-smtp.messagingengine.com [64.147.123.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849316EBFA;
	Tue,  7 May 2024 18:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715107900; cv=none; b=fIeMK/lpJQvcAHjQ5t5yatYQnYZEjb+YXtLB0L4h+iCMQJIZH3IsK03LFCPp3UVcv3S+ncL/sY6lB5vheXtrmrHBt3W7tmvZ68BeXJnlBQdpgc5DWHyX+tHNfk5rMU7xijFXnJ5Texekx/csFHzy7GzMBgNiKLdt5IfqRwQo1r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715107900; c=relaxed/simple;
	bh=doDoiKRSbEFEcvi9ZrcFTFMihJG9CKo4cq0xfaJMhhc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hsRyEmn4PFY2zDYwLcUPinBnfjDXTHe65ebYdq956jdSQMIJjqKS/dWcVBC0vduq4BGYLauYzRN3Pdr6Po9yoa3YgFRutSn1Gy50O+tdPwhTREPp2hGMrqsDqN6isvCnalhHwOZMioXZdI/QdMkdvFKy7+55MX3hjW5bw34KlaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=Pgvn1Lia; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AYMsDJPW; arc=none smtp.client-ip=64.147.123.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 4BE7F180008E;
	Tue,  7 May 2024 14:51:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 07 May 2024 14:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1715107896;
	 x=1715194296; bh=82l8zExqA2QOl+3OBDsGPY7I116NkEWDViC7bkvMG1g=; b=
	Pgvn1Liat4GmjfbiaWly4uxlHpI/VPYzeuJD113Npb8pd9dlqIso3S3UFcCngYdt
	mC563XrTz403L4SBm2oM+nDZhaWcFuLQ/8Xct2WssHtOJwHD7XDzvg2C2FRRb7h/
	dULvgxFDPN/bYzS4SXFCyLymot0c6UAWSiyEBp7mBhylsakTm6TIElcPsFCuhFvm
	mNVLfzUACbhFZsHbKtAQwnT9Fk7kE9D/ri7ABVR5iG9qnPr9iuZHjZY/xzu2/ciW
	5VtykqifszQ/r1CxeUZo5ahXDdReic0p6+pbApn3WBYgoNuGBR6n8DY9Nd2nX7iZ
	zkwUDIE1W/N52OWsuwk6Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1715107896; x=
	1715194296; bh=82l8zExqA2QOl+3OBDsGPY7I116NkEWDViC7bkvMG1g=; b=A
	YMsDJPWUqeRlOpAGJLhCE/NfTfzMV+5oFrGlRdQYvO3FRwQNVp7XZTUVQMrHjdi3
	oMLidklBOSzeMh/YuN4fE4a9+NglRzBuCZWJkZnUx8AmuPbNxUWaG0j6sYpPRiXG
	1FJ6vzZf0dDH1+leTwOGZLhVxRGGIfUVOihvSjmnIxPLwEfXHjU/rChL4Jh6g/1e
	vSswyGc7N3ivWUHp8afYXwTd3Q3kEd/1FybZk7pDLQSCc+WnNkgJgljZ6t8kLjYI
	dzPKLfV055lttbw2/TaRFDK4QiQu5tChKhwssGNCoOA9e1rzzFQ+eog1Y2KFvIuE
	u2gbjnPkzNU5A4u+BcsZg==
X-ME-Sender: <xms:OHg6Zulo3wd2N8sIIC76MrDdPU2pLMoJ1_3Y5qNZRKMa42YZIEwE5A>
    <xme:OHg6Zl0dIx8_BtVuxlAruSNXzkSm3MM-2hgId2A-KazWVUl0heZqQMGLxgI8I9UL_
    wztjMUFsOAsy0OVqMQ>
X-ME-Received: <xmr:OHg6ZspmcX2imbhZ-qVVfGwyfMGMjwcxYd638odBYHJV2WWwoh6r5bo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvkedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffugggtgffkfhgjvfevofesthejredtredtjeenucfhrhhomheplfhi
    rgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpedvkeeihfefveekueevteefleffkeegudeghfdtuddugefh
    ueevgeffgedukeejleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:OHg6ZimsvX5a-RdOONA31jHwtOzLUHkGrAzWaHBLsfk1lSGXgG06dQ>
    <xmx:OHg6Zs3nft_smhVjQjea2gmC6X3dxWljlmDRN2oTDt4LDu3iD2LGZw>
    <xmx:OHg6Zpt8LSWYbWGHV2rCqxCpePKvf5-WGKL5akOsXI6gskMXBLRaeg>
    <xmx:OHg6ZoXh0m1kQHyoQ37NOT4p87LPpk0vDpH9CPpQJSQdjFSXLQTxTA>
    <xmx:OHg6ZiNNPj-qifvGy_8btpv3deYBHR9XJhSK9CO_2rfr_nNZSstLXVTr>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 14:51:34 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Tue, 07 May 2024 19:51:21 +0100
Subject: [PATCH 3/4] MIPS: Loongson64: DTS: Fix msi node for ls7a
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240507-loongson64-warnings-v1-3-2cad88344e9e@flygoat.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1245;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=doDoiKRSbEFEcvi9ZrcFTFMihJG9CKo4cq0xfaJMhhc=;
 b=owGbwMvMwCHmXMhTe71c8zDjabUkhjSrCl3b2Rw9kYeuWwU31pzNnypR9UJ/hnGdjXXVJUd5D
 VWGo54dpSwMYhwMsmKKLCECSn0bGi8uuP4g6w/MHFYmkCEMXJwCMJE/Oxn+ykWyyC6/GS2lZSfl
 nM4vyn7k8qOPv//feOAbo5G9bWa7CSPDkZcXrx2aNEv02S8edcfWZS0rBJm9nCqmFi5Kvr91nnQ
 XJwA=
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Add it to silent warning:
arch/mips/boot/dts/loongson/ls7a-pch.dtsi:68.16-416.5: Warning (interrupt_provider): /bus@10000000/pci@1a000000: '#interrupt-cells' found, but node is not an interrupt provider
arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts:32.31-40.4: Warning (interrupt_provider): /bus@10000000/msi-controller@2ff00000: Missing '#interrupt-cells' in interrupt provider
arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts b/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
index c945f8565d54..fb180cb2b8e2 100644
--- a/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
+++ b/arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dts
@@ -33,6 +33,7 @@ msi: msi-controller@2ff00000 {
 		compatible = "loongson,pch-msi-1.0";
 		reg = <0 0x2ff00000 0 0x8>;
 		interrupt-controller;
+		#interrupt-cells = <1>;
 		msi-controller;
 		loongson,msi-base-vec = <64>;
 		loongson,msi-num-vecs = <192>;

-- 
2.34.1


