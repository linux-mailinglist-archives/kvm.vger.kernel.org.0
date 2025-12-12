Return-Path: <kvm+bounces-65820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4337ACB89C3
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 11:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05C263063394
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 10:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3EA31A542;
	Fri, 12 Dec 2025 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="WV12Cl4h";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="C2d/IU6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail187-17.suw11.mandrillapp.com (mail187-17.suw11.mandrillapp.com [198.2.187.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89D31A54A
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.187.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534749; cv=none; b=BkLBh4reMUAgljI7Sa7XY/iPCluvoB0rRiZGurfliiXOz0RxoS/cFdm9jXqBmyeefDf0gpE6+g08fZiw14xcnJJ6bKE1wqX1LlVTmSdrTUV9GFgM7kIZKmz3Uc6xFMG6X5p+/vJsPP3Ezt/xboFbFxmi60vj5o0Q5BXOyPByiP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534749; c=relaxed/simple;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=W8E0MpfoHK9oojOyoWWF37avhjxoSKBwt/PiFLzdyx3KNFnfL+8zxeZhndbcr0C+ArYgP4EokQWV6XuuPqFJoOg2/hO4V2a+YimYcWxS4kt23W4h0z4l2wf/x5qLDjgCsPgSCaDVMpW33+A1WD46aWoTJccB1KpNAWP+FfBTpbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=WV12Cl4h; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=C2d/IU6Q; arc=none smtp.client-ip=198.2.187.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1765534746; x=1765804746;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=WV12Cl4hEbL3K/JtwR9WVqXJmPDaATEvpvuHnygzTqg/zysXI+Yf7umsFAq1K7/44
	 pYzxCjKUsh5A7xPdLo3DIyCx/Wv4HlhWvxxAlN+Cb3gzKM/Y78m2PXrl8flTuASBLy
	 zK1+7p5ZmUhHKlQ5s/eyknnHyWd/zC/r3tsDb5bRwPWXWiw6V9lWmnkc/7AQIChU+j
	 QLsESpWLIzVDNMKBQX5htaaLv7dh95crnbEKdtGQT71RZIEM4DrVDmtvvBoqlJt9sa
	 s5eWhKVve7lgnp5FBGAWW/TflfaAOnJSWsjY6GQqlLid1v4GCGuDmJ845Xg60UgR5/
	 wy7qzXBmErosQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1765534746; x=1765795246; i=thomas.courrege@vates.tech;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=C2d/IU6Qb888M/Z33jwVO2Ydw0fHsLKaX/fTJKXtqo8pR7XPbVHgOhpI5VGqKQi3N
	 a6yMs5Ge9Zch5tZEL42CPyTn78ErXWFmbK4+GYA/owujv9v0dviaRjaR6TbF4uH4Ua
	 C/IbX3816E5V9o3ATpPkkJ7841IclfMbj3b4wqk/LkaP/AkZWA29uvgVlRA/NitmTW
	 Dh9aliVCFiguRfcAOZqYBh8aNOChEm01Sx1r0866dJ1l8NeuUdvVibds0REKp2SR+P
	 6q14mgAbTyoghMTr8XaDIIQoGdoGC4wCKryXTAe9+znE5Wczi9/F7tB+74DvMKpWUX
	 LrRMX2sx6liRQ==
Received: from pmta09.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail187-17.suw11.mandrillapp.com (Mailchimp) with ESMTP id 4dSQRG0kJvzRKMCtM
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:19:06 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v2]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id f43a7fa3e2cb4d88be2094f220282fef; Fri, 12 Dec 2025 10:19:06 +0000
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1765534743899
Message-Id: <4fa34bbd-ca16-4f19-8822-d72297375c7d@vates.tech>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech> <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com> <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech> <7b3c264c-03bb-4dc5-b5c6-24fb0bd179cf@amd.com>
In-Reply-To: <7b3c264c-03bb-4dc5-b5c6-24fb0bd179cf@amd.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.f43a7fa3e2cb4d88be2094f220282fef?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251212:md
Date: Fri, 12 Dec 2025 10:19:06 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 12/5/25 3:28 PM, Tom Lendacky wrote:
> On 12/4/25 07:21, Thomas Courrege wrote:
>> On 12/2/25 8:29 PM, Tom Lendacky wrote:
>>
>>>> +
>>>> +e_free_rsp:
>>>> +=09/* contains sensitive data */
>>>> +=09memzero_explicit(report_rsp, PAGE_SIZE);
>>> Does it? What is sensitive that needs to be cleared?
>> Combine with others reports, it could allow to do an inventory of the gu=
ests,
>> which ones share the same author, measurement, policy...
>> It is not needed, but generating a report is not a common operation so
>> performance is not an issue here. What do you think is the best to do ?
> Can't userspace do that just by generating/requesting reports? If there
> are no keys, IVs, secrets, etc. in the memory, I don't see what the
> memzero_explicit() is accomplishing. Maybe I'm missing something here and
> others may have different advice.
You're right, and there's no warranty the userspace will memzero the report
And the SEV report isn't memzero too

Thanks,=C2=A0
Thomas


