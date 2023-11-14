Return-Path: <kvm+bounces-1673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF457EB2D4
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0083B20A50
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A25441236;
	Tue, 14 Nov 2023 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U/CUMp0T"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835641215
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:52:46 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDE5122
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=ICHewS3Ac/ijiK+ks360OQMk79lzoLRKl9is1vU3rIo=; b=U/CUMp0TGxLvfnFsfS6JM/cNfY
	5wmBRW+E/1KIVJf20V5+jE5hpQoIcX1ntDj6CtV56TFeY35OnTNbWKI5T7TT0iusmxdyY4RQCoN6O
	8Ip7i0xzvikC5ImMhtcy/PdvZnNB5arsCne2k1TIYXV4PWFX0AcSsCK4OejpSHOklM/U3JvNlk9AJ
	xbs4LlptfNvnJtxX2h0FDT7d05kYqCiqBpVerZMMBj2s115qnRA9XGkM+p4HCMOticwQ/2VpprjWX
	iM+ol5pmxESEpBoFUrpDzg9qUko74mhma5Oy7pNE6vKjBY94rSAmlpK6Q+HDrf3aHgarnsIvOzmlR
	YMNWRmZQ==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r2um4-008XpM-3f; Tue, 14 Nov 2023 14:52:20 +0000
Date: Tue, 14 Nov 2023 09:50:06 -0500
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
 Thomas Huth <thuth@redhat.com>, Cleber Rosa <crosa@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Beraldo Leal <bleal@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_01/19=5D_tests/avocado=3A_A?= =?US-ASCII?Q?dd_=27guest=3Axen=27_tag_to_tests_running_Xen_guest?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-2-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-2-philmd@linaro.org>
Message-ID: <94D9484A-917D-4970-98DE-35B84BEDA1DC@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On 14 November 2023 09:37:57 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>Add a tag to run all Xen-specific tests using:
>
>  $ make check-avocado AVOCADO_TAGS=3D'guest:xen'
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>
>---
> tests/avocado/boot_xen=2Epy      | 3 +++
> tests/avocado/kvm_xen_guest=2Epy | 1 +
> 2 files changed, 4 insertions(+)

Those two are very different=2E One runs on Xen, the other on KVM=2E Do we=
 want to use the same tag for both?


