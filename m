Return-Path: <kvm+bounces-60865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 94201BFE7C5
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 01:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3262C4EFC84
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 23:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C812FB0A4;
	Wed, 22 Oct 2025 23:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="eSn+P9hz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44F826C3B6;
	Wed, 22 Oct 2025 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761174736; cv=none; b=ahAAuMzzg7faWCmIggAbLPZTpZ3FeaFg8ZvbTNbQ+cIapbfzgFekJ5AypBiPOfJUU2j392/CrbOETfl9uiuzIZcqw7dzdqcettm9rcTkhLDJAK8P9jy/8bKqBWNWFv2y8Lv1ogAIRIBjXeqYXMxznkFQte2+Pxno7stvIsYzOTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761174736; c=relaxed/simple;
	bh=Ny9Vv0XZRe1xrbXUAAN3BHx1gSrcR+R+qHNizl+/IM8=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=p4KpiFAmJmajIDOh+xbbidzLjyGIkhkilc6mUTREInWZ+vHiGjO7nXktoFwmo/VWkOtYNeV8VKLtU2L3vy92Aqjc6mEccoQldg/5rxD3ddVUlwvdaewaQ6D4cfloVEFB0gWL4Ip1uKc3TnXdG+56qVwVTT3kf+4PAdDLBGuTqjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=eSn+P9hz; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59MNB6UH2490590
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 22 Oct 2025 16:11:07 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59MNB6UH2490590
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1761174669;
	bh=Ny9Vv0XZRe1xrbXUAAN3BHx1gSrcR+R+qHNizl+/IM8=;
	h=From:Subject:Date:References:Cc:In-Reply-To:To:From;
	b=eSn+P9hz7aQ7xsoCRDDBCM9rplsKSoKiOM1+T7MyEJaGNZpf0t1/RzHsGK1a0JX4r
	 U6TFlkX223rzMPf/pKTTqDAcUSmkV8lJCq/BNx5m9xyBxZfOuVGyP5aV45guy4qk5a
	 7QVlilpezhL4pD5Sw1aNqoxRNk/rJxeXGuKa13is+slc8I9a3Eya/l3kSUE9I9Zim0
	 QFXFMIHKngoTfRzHinw/qN7qCAgHFFCf1WNYcay/Lcn9CXnjhv21YKPEjce8Mnbmo7
	 JcGDamfuufu9fcLZPt7XLC2ixd6XhMTmTZVylpRHQH3i5Tu1gwgyLdkkZt9z9Lfb1q
	 KDP5w56vfmY5A==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From: Xin Li <xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX context handling
Date: Wed, 22 Oct 2025 16:10:55 -0700
Message-Id: <038ACE82-AF8C-40E3-919D-03D9824C25B3@zytor.com>
References: <7f33ee53-1569-4a47-8018-fd48e9c65901@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org
In-Reply-To: <7f33ee53-1569-4a47-8018-fd48e9c65901@zytor.com>
To: Gao Chao <chao.gao@intel.com>
X-Mailer: iPhone Mail (23A355)


> You're right, I wanted to avoid unnecessary checking, but this caught me.
>=20
> Will fix it with a v8A patch.

There is a conflict in patch 13 when I rebase onto kvm-x86/next, so It looks=
 better to send a new v9 on kvm-x86/next.=


