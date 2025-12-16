Return-Path: <kvm+bounces-66075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87495CC40B9
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A8D930D69FF
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1C92DC34D;
	Tue, 16 Dec 2025 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iPE0VLcT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E51D2C0F9A;
	Tue, 16 Dec 2025 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765899225; cv=none; b=BMC/RY4TEMRkiVhy0ob4za9S6AZ5qzj/Q71HsdUWzPXKdAcjGa05O15XMVHuHgpurC8S04HfXrg4nY/24LY7w12LNE3G/bqHtYB/w2MZyejYuagzNyFvdpny2ms0oM7ht4lbSdKlPJwQNHENv/K6K7k6sGwUWqmIarVZEEXkAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765899225; c=relaxed/simple;
	bh=YwoMyqqb7FoPpi5NJyyaera2Ovv71yIWvzL6plb5cBY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=IEWrNCiTaXNiuUXBMO4xeHJcJToQ/UiLyBc1P/WUPfytbI2WSPkyBC6A/aHkPSb+2ofWDJf31yjbQGzWiJRPDyJ/3Kp0SIRIstDoPdSyCpDvekJFU0EwwDTZVYeaYF2dekZfdbZTqmo4hSYWW+qig2iHgeViEZwsGnw9dQy6Njo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iPE0VLcT; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGFWClL2179001
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 16 Dec 2025 07:32:13 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGFWClL2179001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765899134;
	bh=YwoMyqqb7FoPpi5NJyyaera2Ovv71yIWvzL6plb5cBY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=iPE0VLcTgNWTSt5Tet9JM219GeC7iYNuOcfvkIUd5nEKG/cdvOJwPNBuC1E+DFzIi
	 SHqu/oogV01S+Vdi/eeDP9MVA/VMd+IORcg8rzelWylaDU7RwlyiRxoXkzNUdlA+49
	 9a2JqdulmrlQrzXpJXZcHiVRWtWWYGm4vTlgsvktLtFFJNi1LESdKBVzyuTMqbcRTd
	 bM2x846MlS7boYnZ7dfj6rnowELPFA5PBJghox2dJ8Bq8DfbpSSEai1LJie29QbzBq
	 ekqe/HtqGC1nCUgMXLOxWd2SgknFZP/ynGzpZ0XgkulTqNVUOmsDcdrJ8/SaabjQy9
	 7VLOQi94US1rA==
Date: Tue, 16 Dec 2025 07:32:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ajay Kaher <ajay.kaher@broadcom.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
User-Agent: K-9 Mail for Android
In-Reply-To: <b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com>
References: <20251126162018.5676-1-jgross@suse.com> <aT5vtaefuHwLVsqy@gmail.com> <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com> <aUFjRDqbfWMsXvvS@gmail.com> <b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com>
Message-ID: <14EF14B1-8889-4037-8E7B-C8446299B1E9@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 16, 2025 5:55:54 AM PST, "J=C3=BCrgen Gro=C3=9F" <jgross@suse=
=2Ecom> wrote:
>On 16=2E12=2E25 14:48, Ingo Molnar wrote:
>>=20
>> * J=C3=BCrgen Gro=C3=9F <jgross@suse=2Ecom> wrote:
>>=20
>>>> CPUs anymore=2E Should it cause any regressions, it's easy to bisect =
to=2E
>>>> There's been enough changes around all these facilities that the
>>>> original timings are probably way off already, so we've just been
>>>> cargo-cult porting these to newer kernels essentially=2E
>>>=20
>>> Fine with me=2E
>>>=20
>>> Which path to removal of io_delay would you (and others) prefer?
>>>=20
>>> 1=2E Ripping it out immediately=2E
>>=20
>> I'd just rip it out immediately, and see who complains=2E :-)
>
>I figured this might be a little bit too evil=2E :-)
>
>I've just sent V2 defaulting to have no delay, so anyone hit by that
>can still fix it by applying the "io_delay" boot parameter=2E
>
>I'll do the ripping out for kernel 6=2E21 (or whatever it will be called)=
=2E
>
>
>Juergen

Ok, I'm going to veto ripping it out from the real-mode init code, because=
 I actually know why it is there :) =2E=2E=2E and that code is pre-UEFI leg=
acy these days anyway=2E

Other places=2E=2E=2E I don't care :)

