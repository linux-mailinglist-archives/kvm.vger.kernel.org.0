Return-Path: <kvm+bounces-1688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E21F67EB43B
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96B8A28125C
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F52E4177E;
	Tue, 14 Nov 2023 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CrvEHaLu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5AA41770
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:55:20 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ECFBB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=/dnm/wFvk/yv7xaMVVCi4UNXjRYnVLcTr44nudqfiig=; b=CrvEHaLu3ghKko6qCLNKnbyNbO
	H0HaiBWEDEqhiYXOyWq6L5fPwjkEEuFM/hPjw0DdPgdVBxI+hfbT8DDMqqG32wfgapci6OUoR+GwG
	LWXFGfKFNSpfzi7W13vkvR1Qk9iNGPwbn/ZvEhT0U/TFVXS1dCcIHK9YwgL7NXv7izHrZkaWioseY
	o2/3wuKNJ5fI/LnE0O+1GLlCXwFBTOIob05/Tt0QVIQ3fhqoeH6os7jaqbRUQXvuthfMe+J+5R2My
	36DqwE1AyHONfjQ2p9p3mJ2mXSIPNVvkoPDkUya1YBWKOoVp6qb5x1u+SdwdorOgU1Od+9cvf/1Ly
	pfoeq3TQ==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2vkj-002YFc-1l;
	Tue, 14 Nov 2023 15:55:05 +0000
Date: Tue, 14 Nov 2023 10:54:57 -0500
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
CC: =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH-for-9.0 v2 16/19] hw/xen/xen_pt: Add missing license
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-17-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-17-philmd@linaro.org>
Message-ID: <533319AD-DC12-4E44-8C95-D7A85D8E4241@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 14 November 2023 09:38:12 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>Commit eaab4d60d3 ("Introduce Xen PCI Passthrough, qdevice")
>introduced both xen_pt=2E[ch], but only added the license to
>xen_pt=2Ec=2E Use the same license for xen_pt=2Eh=2E
>
>Suggested-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>


Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>


