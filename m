Return-Path: <kvm+bounces-68552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 688FDD3BF56
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 477583A0E1A
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 06:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6842037E307;
	Tue, 20 Jan 2026 06:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b+3ePQ0j"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177C36C5B2;
	Tue, 20 Jan 2026 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768890687; cv=none; b=DddRIB+Kx6jitAEOIiqvgtv/AemtG4Aoh3IHaruneCXpQqMpB8vNjVy5qgdRlx4g1YSxXbE8ocKHdWmvhMMuHBCIaiiDFmrB+OgYmXwXsmnxSJDGzQDkogk/WB3z0XNgTVXnd7OQdmvKXIF+cw8/dqn6bWFV7KCufKgARAwjwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768890687; c=relaxed/simple;
	bh=ahfdh+GRBGiMNH8ZiPJWTMZ+dmy5DY77zy9WH9fo4oE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cRxEIY2ARysQZ2Nh2gY1a1ZBn1Xe1g+Frb6Rjlushu6s0GGrPtsuBzt44LIdQsdB6Y8COGNeMXjxvTJ6yy6lOoCI3YtY3y5nmag06RTwB5cPC1DCPxxe63tQXtVRYOV+8blhZ8HO4pi1r9UOSVVkVtAmfHczce7Y27doqM076uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b+3ePQ0j; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60K6UB0P3492316
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Jan 2026 22:30:11 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60K6UB0P3492316
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768890614;
	bh=dl3PQXytQYWP6N7rKAaQY8Gd40xy1cLhOHyQGILlS1w=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=b+3ePQ0jr7dR/DykkKpjdmoH6lpjp+XhtSg4UTlpOWMhDNLSSasAfpa2pPCrsX27v
	 GniCwOyKJPuVW9aKOwPsnDWYekm/Fq+Had7c7lEpW/LlElB1A/J4IRi9L4/BoUL0Qr
	 hMe2nWKV8oyvxpphRQ+Hp+L2iGCTcFD/JWqrKQuOrY+qIeCkQZuOOP9JhL1Leu5rak
	 yCFGf4w0b5+8S5Qc/y8+V2sDTEyTF711hgwABk+8GEbfNxv9GsHrmoaHMXQ/mO7nhl
	 7dkikxPs1qUwv5zdOZ5uUVMvqluJ0PywpyXeorVivlqlrFvus+ho/RNjPk5ZFpuF/q
	 /NDHK5PuEcNEg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested VMX
 context
From: Xin Li <xin@zytor.com>
In-Reply-To: <aS6H/vIdKA/rLOxu@intel.com>
Date: Mon, 19 Jan 2026 22:30:01 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F71014C-5692-4180-BC6B-CCD7D2A827BB@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-20-xin@zytor.com> <aS6H/vIdKA/rLOxu@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)



> On Dec 1, 2025, at 10:32=E2=80=AFPM, Chao Gao <chao.gao@intel.com> =
wrote:
>=20
>> +
>> + nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +  MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
>=20
> Why is only this specific MSR handled? What about other FRED MSRs?

Peter just gave a good explanation:

=
https://lore.kernel.org/lkml/f0768546-a767-4d74-956e-b40128272a09@zytor.co=
m/





