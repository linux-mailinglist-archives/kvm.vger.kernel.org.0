Return-Path: <kvm+bounces-68592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D36D3C334
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7957B4E762A
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1023BF2EC;
	Tue, 20 Jan 2026 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DPThlz90"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC623BB9FB;
	Tue, 20 Jan 2026 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900220; cv=none; b=XTnqRk0R2fGCg84d7q6fNVAb3CoMXiujeruJwZZ7ggIBcvhEkL/QvO74TvIEErVOEU6abXVTTd8y4C3q0JiyLGatVRiRIF568NUZItZteMzYaK7OhWCKUDepotS4A5VCwq4JK3a0LAZeLAf2KLJtVXshL8GFerT880t+xjY40I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900220; c=relaxed/simple;
	bh=INWriyqgU8K5z5tavmStfbwrpGA/bQ2dhB63CYeeg+U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ya9W/VKq6IM0H6FavuKAx/OTw3n2Mvtsea2Fl60YV3v4Tx1oSnLnD55hJo/xO6i19goLVqeKaEZYEtbYRSRkFrmT/1kEG/BLfqq1YG2QYUq0qXtXj6Zw9Ce9rkitexo5nZPFgBmTLDuED83f7peBGtFKZw1r5xa0qZ8sm5ixSQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DPThlz90; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60K99blX3564407
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 20 Jan 2026 01:09:38 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60K99blX3564407
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768900179;
	bh=INWriyqgU8K5z5tavmStfbwrpGA/bQ2dhB63CYeeg+U=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=DPThlz90mXRExrFVls06gcRHiiYwXZRSTUEQYNuOga+6skrbb8DihoaoS4YFodhqz
	 jFhXmhw36tt8Hi8m5ZhdObFoX3QGfyD1y25Z7YRiuwLm3RiiyRgIXonFWT9O/+yC7d
	 pWchnPchIjcexYram0t4JrdGDifmy4CKb/prVFKykH+7v3qFn3IQCGHwkwivqIkHop
	 9OzfVKzUE9b3mGgCNEQ7dFxDOaw+s5RXcyZm5PnmkTUyoZdTGf6gFKvBM1VFNl4JZk
	 ywmoyC0SsYYax7ZGtiEkQNwagZHo19H6EPk1twXOO+ei0IGkrhaQMzkythMmhvQmTz
	 NWXlhpE3r8bBg==
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
In-Reply-To: <aW83vbC2KB6CZDvl@intel.com>
Date: Tue, 20 Jan 2026 01:09:27 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C3F658E2-BB0D-4461-8412-F4BC5BCB2298@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com> <aRQ3ngRvif/0QRTC@intel.com>
 <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com> <aW83vbC2KB6CZDvl@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)



> On Jan 20, 2026, at 12:07=E2=80=AFAM, Chao Gao <chao.gao@intel.com> =
wrote:
>=20
> On Mon, Jan 19, 2026 at 10:56:29PM -0800, Xin Li wrote:
>>=20
>>=20
>>> On Nov 11, 2025, at 11:30=E2=80=AFPM, Chao Gao <chao.gao@intel.com> =
wrote:
>>>=20
>>> I'm not sure if AMD CPUs support FRED, but just in case, we can =
clear FRED
>>> i.e., kvm_cpu_cap_clear(X86_FEATURE_FRED) in svm_set_cpu_caps().
>>=20
>> AMD will support FRED, with ISA level compatibility:
>>=20
>> =
https://www.amd.com/en/blogs/2025/amd-and-intel-celebrate-first-anniversar=
y-of-x86-ecosys.html
>>=20
>> Thus we don=E2=80=99t need to clear the bit.
>=20
> In this case, we need to clear FRED for AMD.
>=20
> The concern is that before AMD's FRED KVM support is implemented, FRED =
will be
> exposed to userspace on AMD FRED-capable hardware. This may cause =
issues.

Hmm, I think it=E2=80=99s Qemu does that.

We have 2 filters, one in Qemu and one in KVM, only both are set a =
feature is enabled.

What I have missed?=

