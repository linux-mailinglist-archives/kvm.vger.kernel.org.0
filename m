Return-Path: <kvm+bounces-17284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E6C8C39F1
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064FE1C20D91
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46D912AAEA;
	Mon, 13 May 2024 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gs63Nzl7"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745D200BF
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 01:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715564838; cv=none; b=TwHkcGknZA5UIHO/l1lHcOa12KbaiczAH1Ffwvd+gWVEcS7Itm67XoaVlSytLiUbZfk9C90clESZJVyBvv5w6WzugLanN+sV+k7IiZ8/zeXbBjkDY5Ege9kz04Nit5eD4DTjITdq0wGWM3JSdiMC5vBtnrOjpmpCIZu1/pwcD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715564838; c=relaxed/simple;
	bh=XvuUPqe4jrK1ygXuzWnjCNK2+al04GnacvOZK6Njt3c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Y6/8o71XUYnA9M305LOY3R+chRawJCh36dxluTXWFhh8r4Tsmz31GwcdBPTwTfqBCafK0/KYcl8503gUBYYzVVGY3uZr7jp6R2/V0/NziTCJ3AOILZBUYG0XAMGNcZKKSPWa3slOLY+soeMqG94rx2wBJg9HzZ3n9fHFmtXM9Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gs63Nzl7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715564833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XvuUPqe4jrK1ygXuzWnjCNK2+al04GnacvOZK6Njt3c=;
	b=Gs63Nzl7EFtz+ZdI1WGhk//6KAWCpYBCZDTwyLRG8+mLJOkOXGQyDNDKU8ycSlIi9pHVCA
	GZ7Nzrtnb2UySOOlc1MjjszZHnvGrrTJkwIaeN1iWaxEEBDrc36LxKkfyXQvfjr2zWTRB1
	1/n21eLJEEl52br9Nr3c4XesiXBJA4I=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH] Build guest_memfd_test also on arm64.
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
In-Reply-To: <E7E9D65D-1DAC-4CA5-BDA5-D515D15E50F8@linux.dev>
Date: Mon, 13 May 2024 10:46:54 +0900
Cc: Shuah Khan <shuah@kernel.org>,
 kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9804CC2E-9F3B-4A39-B91F-9C91155CC50F@linux.dev>
References: <20240222-memfd-v1-1-7d39680286f1@linux.dev>
 <CABgObfakz1KQ==Cvrxr5wS36Lq8mvF9uJtW3AWVe9m-b+0OKYA@mail.gmail.com>
 <E7E9D65D-1DAC-4CA5-BDA5-D515D15E50F8@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Migadu-Flow: FLOW_OUT



> On May 8, 2024, at 15:41, Itaru Kitayama <itaru.kitayama@linux.dev> =
wrote:
>=20
> Hi Paolo,
>=20
>> On Feb 23, 2024, at 17:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>=20
>> On Thu, Feb 22, 2024 at 12:44=E2=80=AFAM Itaru Kitayama
>> <itaru.kitayama@linux.dev> wrote:
>>> on arm64 KVM_CAP_GUEST_MEMDF capability is not enabled, but
>>> guest_memfd_test can build on arm64, let's build it on arm64 as =
well.
>>=20
>> The test will be skipped, so there's no point in compiling it.
>=20
> It=E2=80=99s not merged yet, but the Arm CCA support series V2 is out =
there, would you consider building it for arm64
> as well?

Unless KVM_CAP_GUEST_MEMFD is supported in arm64, you think it should =
not be built at all?
Then, I will build them locally for now.

Thanks,
Itaru.

>=20
> Thanks,
> Itaru.
>=20
>>=20
>> Paolo
>>=20
>>> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
>>> ---
>>> tools/testing/selftests/kvm/Makefile | 1 +
>>> 1 file changed, 1 insertion(+)
>>>=20
>>> diff --git a/tools/testing/selftests/kvm/Makefile =
b/tools/testing/selftests/kvm/Makefile
>>> index 492e937fab00..8a4f8afb81ca 100644
>>> --- a/tools/testing/selftests/kvm/Makefile
>>> +++ b/tools/testing/selftests/kvm/Makefile
>>> @@ -158,6 +158,7 @@ TEST_GEN_PROGS_aarch64 +=3D =
access_tracking_perf_test
>>> TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
>>> TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
>>> TEST_GEN_PROGS_aarch64 +=3D dirty_log_perf_test
>>> +TEST_GEN_PROGS_aarch64 +=3D guest_memfd_test
>>> TEST_GEN_PROGS_aarch64 +=3D guest_print_test
>>> TEST_GEN_PROGS_aarch64 +=3D get-reg-list
>>> TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
>>>=20
>>> ---
>>> base-commit: 39133352cbed6626956d38ed72012f49b0421e7b
>>> change-id: 20240222-memfd-7285f9564c1e
>>>=20
>>> Best regards,
>>> --
>>> Itaru Kitayama <itaru.kitayama@linux.dev>
>>>=20
>>=20
>=20


