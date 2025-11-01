Return-Path: <kvm+bounces-61749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5BEC28644
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 20:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 300F2346A81
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 19:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B393002AA;
	Sat,  1 Nov 2025 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=msa.hinet.net header.i=@msa.hinet.net header.b="MoJhbmHA"
X-Original-To: kvm@vger.kernel.org
Received: from cdmsr2.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2422FC895
	for <kvm@vger.kernel.org>; Sat,  1 Nov 2025 19:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762025197; cv=none; b=lTzbT4Db0VSEXnBKYbEdxZPMTHkRBjxyoBGCdhgt3UfLykOfRs6RCcSHAL3MKZd9dPoQ9C5b1UtLYX9yyrXxjkX4/ugTG/rlLn0Znx2H3ulMurCVFsnnq426UOjwiyFO7OZM3ijj8hojHWweQMVyFpanvhvoWsnRy7QKY09nPZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762025197; c=relaxed/simple;
	bh=i9y67ZuCVLy1wfb7oxK3zraTatp6784r3aO4vG9diwo=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=otgOxqR0GVnCWpI2pvKjPELFHogVkU3IUrYux/jfgX57Z3MK2xcvohnvxjOoYzlTgpZlB5ie0UGh0C4aLxW7XPokK0+vAkYH1CngJStG3TZhK2cMiUYvw86mMmLAM72vkg1pXJCZtQP7irufMwiih7owwVxEqmqkvqLTIYZMKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=msa.hinet.net; spf=pass smtp.mailfrom=msa.hinet.net; dkim=pass (1024-bit key) header.d=msa.hinet.net header.i=@msa.hinet.net header.b=MoJhbmHA; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=msa.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=msa.hinet.net
Received: from cmsr1.hinet.net ([10.199.216.80])
	by cdmsr2.hinet.net (8.15.2/8.15.2) with ESMTPS id 5A1JQVlO701383
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Sun, 2 Nov 2025 03:26:32 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=msa.hinet.net;
	s=default; t=1762025192; bh=mb4aXsx7NAmt9wkSJCp/wkdL1yE=;
	h=From:To:Subject:Date;
	b=MoJhbmHAyyGmztozpfxRcIS7toXIbMMj/tWLpprdDciHdrUcPJ/FokX+Whxnd6eNV
	 wDPQoc6AzLfVh22YW8pSSlboyTgm8D7D4bNOtFp56v8y7d4rxyxvikxeZeRFcGBgmW
	 KDiM/jl3J0UhXZlEsNjQs82CwI1OYyNN5G9qfmZk=
Received: from [127.0.0.1] (114-36-234-193.dynamic-ip.hinet.net [114.36.234.193])
	by cmsr1.hinet.net (8.15.2/8.15.2) with ESMTPS id 5A1JJqrf211919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Sun, 2 Nov 2025 03:22:59 +0800
From: Procurement 47026 <Kvm@msa.hinet.net>
To: kvm@vger.kernel.org
Reply-To: Procurement <purchase@pathnsithu.com>
Subject: =?UTF-8?B?TkVXIFBPIDE1OTIyIFNhdHVyZGF5LCBOb3ZlbWJlciAxLCAyMDI1IGF0IDA4OjIyOjU3IFBN?=
Message-ID: <07f2a8ae-5c6b-0c99-232c-53ac0245ba9b@msa.hinet.net>
Content-Transfer-Encoding: 7bit
Date: Sat, 01 Nov 2025 19:22:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=DN4s4DNb c=1 sm=1 tr=0 ts=69065e14
	a=sVP2MhYLCzvKoYeaj3IYvQ==:117 a=IkcTkHD0fZMA:10 a=5KLPUuaC_9wA:10
	a=JG2AqlFJdoGlI2ckZIoA:9 a=QEXdDO2ut3YA:10

Hi Kvm,

Please provide a quote for your products:

Include:
1.Pricing (per unit)
2.Delivery cost & timeline
3.Quote expiry date

Deadline: October

Thanks!

Danny Peddinti

PathnSitu Trading

