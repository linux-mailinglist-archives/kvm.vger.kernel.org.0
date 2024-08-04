Return-Path: <kvm+bounces-23180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 373E3947195
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 01:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F5441C2090B
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 23:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513F213B58C;
	Sun,  4 Aug 2024 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="fWGwXuIb"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE61755C
	for <kvm@vger.kernel.org>; Sun,  4 Aug 2024 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722813339; cv=none; b=u8vMfPeDF4FQ51VqiYkshVptcO9lBY9fOd6zOAE5cgzwxW9yLViiQpa2ECQgegpFG5pEBEa1QnE3BwLW5sG8DtOf2Ki79D+hd5DP1mW6AwJ/fZmZhkNQCWQXbQvZbG0pcTUhNMU6yyD52n1gj9Qhs5ImowVT8+5afs/b9My9YJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722813339; c=relaxed/simple;
	bh=YWxHk9IDgSNkiPoGB8JRDRK3zA4zdbH2L7NZLBS95Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzXB3JGkmHzzTxFGhVPGxIhbAYoM1lm/XDT0QQC3lT8CcajhQggrftfMHr6GWSgypsCmFEbBoUfTPRYawcAjM5spd4OmAN26urylYIUoiSZY1kx44k7tUJs/YroyumWqRkytRd5r/cbKUxx3703Ojt+0tPAsIqmqapyhi8U+GUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=fWGwXuIb; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722813328; x=1723418128; i=j.neuschaefer@gmx.net;
	bh=YWxHk9IDgSNkiPoGB8JRDRK3zA4zdbH2L7NZLBS95Bw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fWGwXuIbMZMiJqcruVNWrIvp7miuXxpKmwIMlEHiACHZKduOYqCCADHKrQf8fmNc
	 ZfvAgqZMHiWiHqANKEKGS99a0UyChyYVIH+NV52Eezp6LGLb3x3M0Alui0A9+g2s+
	 Q4Cp6glltubIEJrYKAz34pWRCraL/nsyCc4OGL45EEyHkPvyfMmd2+PdYjKXbbNLq
	 qz2b+RGm+aCeZ6mSCEM/daFfoACZUyHjncMZqdA5A8NCxRyDVpC9oRLStby2KVZm7
	 Z3WHCxPwQzOLhAA5LBpQ4j9cU7ob6ml44CgHu/wZ3GeckFE1zEIIBUpo2k2GwSY+d
	 YoJEywqFQrKiwFKzuQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.0.46.195]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MSKuA-1slqHn3hqy-00JiDr; Mon, 05
 Aug 2024 01:15:27 +0200
Date: Mon, 5 Aug 2024 01:15:27 +0200
From: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	J =?utf-8?Q?=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: Re: [PATCH kvmtool] remove wordsize.h inclusion (for musl
 compatibility)
Message-ID: <ZrALjzvENZLJqhLv@probook>
References: <20240801111054.818765-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240801111054.818765-1-andre.przywara@arm.com>
X-Provags-ID: V03:K1:Iya9RNc6CGOrqi00G/4P8EWDjFMHIu/d24YUoWZ0zuhOLKZBM08
 IBhLwjcRl2NDDFLqb1Jw2M3Sq8H2QbHwetzyQQvNlIBwpI5PAfSjPBYtX1bGV0cFU4q5acC
 lVRsZuqGj8URDWhmFO18EyMZJgPQoe+1RZleH1KL/IifA14UNSs0lOIkPhHPWiwp6iwNDCs
 P0kzEeKMhtqTh5QDk5tgQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+sIAvZsYAQY=;DhRd8P2f9rYu0o146zkMdagLgSt
 yRnbZ8xDRxTeZB6MgVefiPJ2SQK70tOGSnDzdyPWFwC+AZjWLg6WnbCuBZR7dG4xyAUIq/ZR4
 86fT+/pGRAwvhOxWeKUR3hwNcxw1130+iFFmoXtzKaI3+P6yChm6H0QiYv/cRJg1A7ejdNL20
 kKd8EQatPx/zO705wtOC1SQs9WbMYlz9enqfd9rWMXOQk0dXeYg8ljRhXfpCbCyb5UEVoue1b
 stvUjtZVRUkmK3ien5GPDsyN51FTffzx+pbGQc5MHo1F6o2zZRNPu/vXXmUKPhKHKVS4Vh4Wp
 npqh1T6zpZOhl20wAMWGKQRSb4+PEUXNdFBa3Vaytr+6DeocefK8iGHO3rfnViCy/s5CGa8Ci
 ZOdk/x2+Pw9UTOWsf12urFPL+Y87tXRS6Q5R7x78K+tTnvf0Gw9XqW47qmiCd2ZZxIRvVEhlC
 SJL8R8vCp+PCrDUJEtjHrGcCAj5qHjukW+JdJ382oiJDAO9mUjZpXHk6R/oLDmCEVUW+Kacqy
 BLnxW59Ww4DY6a+zWta9PkFJ6V5t2Cbtb+Q+TaaANnKMjNWdKuHhPLZQA5rE1DJoLoAgo0veo
 QXr5bUeVFAVi5NaK8sNxm6pCul7bC/SiackPmaxWcLU3u/erDV+jBkV3LzCNMnXdgfMG1g5VC
 9oMx7WZhlqvC6+/3slsJJXMfTMObuO0EjOh4g/DjBscUeMG01rs3wsU/v+DOvPbb00QMEO+TU
 Zd799jMINTrLIN8XyyznwBf/kt7UEnvYBlU1cBJUac9UKQzzOUIrXSSd8amhfL4OE5XuAae6D
 337SAUGFecmocORfRtdzcCcA==

On Thu, Aug 01, 2024 at 12:10:54PM +0100, Andre Przywara wrote:
> The wordsize.h header file and the __WORDSIZE definition do not seem
> to be universal, the musl libc for instance has the definition in a
> different header file. This breaks compilation of kvmtool against musl.
>
> The two leading underscores suggest a compiler-internal symbol anyway, s=
o
> let's just remove that particular macro usage entirely, and replace it
> with the number we really want: the size of a "long" type.
>
> Reported-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
>
> can someone test this on a proper/pure musl installation? I tested this
> with Ubuntu's musl-gcc wrapper, but this didn't show the problem before,
> so I guess there are subtle differences.

Compile-tested successfully on Alpine Linux 3.21 (gcc 13.2.1, musl 1.2.5).

Thanks a lot!
=2D- jn

