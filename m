Return-Path: <kvm+bounces-68553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A97D3C006
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6A56E3851F2
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 06:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86ED2E6CC2;
	Tue, 20 Jan 2026 06:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iAA5iIAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E44A30DEA6;
	Tue, 20 Jan 2026 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892247; cv=none; b=MTkNENiouZtfkX5bLDl7q+YjPaw4qvaFaOaYfOeu5oV9hR9vXO5JTy0B2eZJDWBFkH3N6H7SOe4qxA85/7IQWXy/a3t1BB7QgqCJ9dR53NTy13Pk3fr2dj5X5dxvtaSWUdexHMQoHzCXPd83otVkRfth9Dl2eA+KoSDpwh9HFLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892247; c=relaxed/simple;
	bh=3Iut3vWBR4ORWGRTckLdfnkoVnRmJ3Ea3o7FsYVU4iE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=meKuD6o7pjuH4sOGJyH1pDTx4BKzMDryn8T0RyJBw7C1Ic7+s2IZcugo9lqIuqEjjCby1to9F9TcqYaJNL8uwgWaio1EhFOsYMXLU4nEL5GukTIx/vknPsvGdTowqJ99LJ2rQuat58vDkgdlnkvnE/1cnAGtu/C9MtuLupx9Mrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iAA5iIAx; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60K6ueNx3503645
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Jan 2026 22:56:40 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60K6ueNx3503645
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768892202;
	bh=3Iut3vWBR4ORWGRTckLdfnkoVnRmJ3Ea3o7FsYVU4iE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=iAA5iIAxtvT/7WYoWaMOSg5I7o+LVEwPByGsfL8bulkOSaAtMG2yi5nPFREBY029w
	 4fftLudPh61VpCTWWO8Ru/+ibyb2pXYyd/DO8osaE5/wh5IMQ5urGINei2LspA0rh5
	 jH7ROv3U6Fk1UYktKD/2OxbHScfC9gwEGtudWHM+yQ2VtCJvBp3ZFX7y11kc7pcqiS
	 AZBMuTHoxwCZ7H6jaVhNRRFqACnuOfkqXrkGFTR83syxcnUd7nMj7jWiMA33Zx8jZK
	 Kjz0AkzUU1giY63LIwcPYJ+R5hqpKhNdv27HFbtt8tLLwTBjgpLIvamObHNfRVdMI2
	 D150vjmt8+wVQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
From: Xin Li <xin@zytor.com>
In-Reply-To: <aRQ3ngRvif/0QRTC@intel.com>
Date: Mon, 19 Jan 2026 22:56:29 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com> <aRQ3ngRvif/0QRTC@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)



> On Nov 11, 2025, at 11:30=E2=80=AFPM, Chao Gao <chao.gao@intel.com> =
wrote:
>=20
> I'm not sure if AMD CPUs support FRED, but just in case, we can clear =
FRED
> i.e., kvm_cpu_cap_clear(X86_FEATURE_FRED) in svm_set_cpu_caps().

AMD will support FRED, with ISA level compatibility:

=
https://www.amd.com/en/blogs/2025/amd-and-intel-celebrate-first-anniversar=
y-of-x86-ecosys.html

Thus we don=E2=80=99t need to clear the bit.



