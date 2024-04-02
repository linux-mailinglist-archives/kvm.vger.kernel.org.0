Return-Path: <kvm+bounces-13366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2828895095
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 12:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8316AB248AE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 10:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E5A5F84F;
	Tue,  2 Apr 2024 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="ie1knSeZ"
X-Original-To: kvm@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DD758AB2;
	Tue,  2 Apr 2024 10:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712054590; cv=none; b=jAkQkfFQ4+RKsTMUxsBkySFhgR8KOs6MJQQCtvZmyGtB7x4O20CuioPTk9PvxMXcAt7M/zra0TjvP2f/RHhmCMQtsIUXDSso6sN7XU9l5ocJ2unRTYIxwuS1XiIB5m6t8iH0oyR2LemY6IyviJEx+Zyam64iB0x2323+1Yx2mHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712054590; c=relaxed/simple;
	bh=5X/RCnWgW7Me0UMaw2a54c5PJ7QgmEA+BiHGMby2/AE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UPP0Xu1hd6usyG6r8PRgOYDrevfpjeqeqsoilY4q8CXDxPAMW6qXnj91H8oMCBGibxxlAPqdicnde4A0BejGUSpRpfTEQb6V4eu6IhE34Qs98OP6Fgni+d7ZD/Du+/ywK4G0RD0Z2Nb3k9Gbfg+aV1UQCRg2a1B2QKEYnfAFH+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=ie1knSeZ; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1712054588;
	bh=5X/RCnWgW7Me0UMaw2a54c5PJ7QgmEA+BiHGMby2/AE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ie1knSeZV6WxXfXRehWyULWzizmu//36sf/jGZSc3uuar4e8vx9iVOFmzmhBAteIj
	 Faauyw/etLmyyayzivwSQdu1mkkgrbYGXnMW+e9c8EEWba05qlJxbeK4V+eTwczq1G
	 yYavjHtvykqQoYVIXtNDAi+fofMbYcuTgK2953vQ=
Received: from [192.168.124.9] (unknown [113.200.174.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 9054266FF7;
	Tue,  2 Apr 2024 06:43:06 -0400 (EDT)
Message-ID: <453b49801d789523f7366507d1620728315b1097.camel@xry111.site>
Subject: Re: [PATCH] LoongArch: KVM: Remove useless MODULE macro for
 MODULE_DEVICE_TABLE
From: Xi Ruoyao <xry111@xry111.site>
To: Wentao Guan <guanwentao@uniontech.com>, zhaotianrui@loongson.cn
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, Yuli Wang
	 <wangyuli@uniontech.com>, kvm@vger.kernel.org
Date: Tue, 02 Apr 2024 18:43:04 +0800
In-Reply-To: <20240402103942.20049-1-guanwentao@uniontech.com>
References: <20240402103942.20049-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

This should be Cc'ed to the KVM list.

On Tue, 2024-04-02 at 18:39 +0800, Wentao Guan wrote:
> MODULE_DEVICE_TABLE use ifdef MODULE macro in module.h,
> just clean it up.
>=20
> Suggested-by: Yuli Wang <wangyuli@uniontech.com>
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> ---
> =C2=A0arch/loongarch/kvm/main.c | 2 --
> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 86a2f2d0cb27..7f2bd9a0814c 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -410,10 +410,8 @@ static void kvm_loongarch_exit(void)
> =C2=A0module_init(kvm_loongarch_init);
> =C2=A0module_exit(kvm_loongarch_exit);
> =C2=A0
> -#ifdef MODULE
> =C2=A0static const struct cpu_feature kvm_feature[] =3D {
> =C2=A0	{ .feature =3D cpu_feature(LOONGARCH_LVZ) },
> =C2=A0	{},
> =C2=A0};
> =C2=A0MODULE_DEVICE_TABLE(cpu, kvm_feature);
> -#endif

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

