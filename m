Return-Path: <kvm+bounces-61263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2834DC12ABC
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 03:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272891A67238
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 02:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA88271446;
	Tue, 28 Oct 2025 02:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="W9iZNDKV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D44E23C38C;
	Tue, 28 Oct 2025 02:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761618777; cv=none; b=oOm4yCefwFRrOX5fCUZ97UC2JuIUncDTsxCLAOGlVGyOryugVaAsHID8EGko8oBcTwiKgAY9QsRtn3/sQgysZC3IipOQYBmznUWgR57L9ePr54ICSQ3tR9f4N+F6GXJQOIGyhkolrxpXScA41/f0ALl+EwRHQNL+GJa4IDQ/EgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761618777; c=relaxed/simple;
	bh=5j4peJvmjdKmlcEE+4pWVsaPDl8SMVjVPzw/TO6vOZI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=stkun0Xo1xjCm6WK+WfsT+C/3j4XYxEffUaTMfaaAAigR6BjfRghWfaASFi9B+qVypC14llDsEfHDoPhT6RYStJcfcvn6qA9Y3fhkREtAn1wgo1jwQ68B9vx37slO3DknARcBgCe7hujHyDs6XxetYktiJcUPMOdlKTmdjYjSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=W9iZNDKV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59S2VZQv1211668
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 27 Oct 2025 19:31:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59S2VZQv1211668
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761618697;
	bh=5j4peJvmjdKmlcEE+4pWVsaPDl8SMVjVPzw/TO6vOZI=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=W9iZNDKVt/IH+COV/XQ0LMM5CuZvKI+YGNoNiwbh9KfTlC5iN49OnaRdR68AsXJdg
	 QFjMCVpYd0iUPWEoAcVSrh5OYDpIQfjHWlVevX2ExknG2KH52GX/d4PLLll6U7l5JU
	 RQMkiQyNR1T4yAfef4hkkGsN5/B1gF6Fc4vGUa5qDypGGhtDKxwgkZuZvzxdS+PzMt
	 DDXSYH+tHr8LwKBjUdjQez8SLvwCb/ufFU3yaayYyUe1R36poLhtUbwfzXBh8/fwNQ
	 tZ27CWDj6TpeTTHT1PEwLTfddhrmdyb3JuTWAniWRJyrhIltb5rTkMAbMuuo8tSHEF
	 d2oBkG5L2zQSw==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v9 05/22] x86/cea: Use array indexing to simplify
 exception stack access
From: Xin Li <xin@zytor.com>
In-Reply-To: <c65a332e-93e7-4329-a694-c9791ab589b2@intel.com>
Date: Mon, 27 Oct 2025 19:31:25 -0700
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F67131F-BD5D-4A4D-AAFD-81993A448D42@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-6-xin@zytor.com>
 <c65a332e-93e7-4329-a694-c9791ab589b2@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)



> On Oct 27, 2025, at 8:49=E2=80=AFAM, Dave Hansen =
<dave.hansen@intel.com> wrote:
>=20
> On 10/26/25 13:18, Xin Li (Intel) wrote:
>> Refactor struct cea_exception_stacks to leverage array indexing for
>> exception stack access, improving code clarity and eliminating the
>> need for the ESTACKS_MEMBERS() macro.
>>=20
>> Convert __this_cpu_ist_{bottom,top}_va() from macros to functions,
>> allowing removal of the now-obsolete CEA_ESTACK_BOT and =
CEA_ESTACK_TOP
>> macros.
>>=20
>> Also drop CEA_ESTACK_SIZE, which just duplicated EXCEPTION_STKSZ.
>>=20
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> ---
>>=20
>> Change in v9:
>> * Refactor first and then export in a separate patch (Dave Hansen).
>=20
> Thanks for the changes. This also removes the extra union{} that was =
in
> the last version for padding.

I would say you foresaw it because you suggested to use array indexing:

=
https://lore.kernel.org/lkml/720bc7ac-7e81-4ad9-8cc5-29ac540be283@intel.co=
m/

Thanks a lot for making it much cleaner.
Xin=

