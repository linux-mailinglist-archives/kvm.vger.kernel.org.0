Return-Path: <kvm+bounces-1674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4907EB2ED
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 706A01C2086F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A6A41233;
	Tue, 14 Nov 2023 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E/PEXjvt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68FF41215
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:59:49 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA5114
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=2V2aN1FlolnINR1l3YlTw25qRr0vJF7wJ6RIq/GchL0=; b=E/PEXjvt0+RnUlYrN++xmBLgjc
	HuCaeTYOVkOefp8uy3ZSz/P6HEQekbeWntiUJxH7m1YR/R9+NhRL2luaaOdAWWsfGwCj9vF7sfChu
	J4kSiafVKeRtFjBPxiuFAo6xu2mHULfx5cUzZjHFsJkKJXM2LkwTPWm94lP3pXzh+8dAXVF2IOAFF
	fSfV1upQceel86/fLJuSmWwADzoC+KPOtbAHed77Z6tkpuV9iEklSCO+Alm8btl+EphB5Pfn4Mzlg
	mK4N8HkJxJMjd+3+0P+LbO2K/yb2HegPlM96HCDpOt/n8/RjcauHGDBym2kUbXZSjBDzkYQJXKD0P
	jq+BiHiQ==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r2ut1-008aJs-S4; Tue, 14 Nov 2023 14:59:32 +0000
Date: Tue, 14 Nov 2023 09:59:29 -0500
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
 Thomas Huth <thuth@redhat.com>, Peter Xu <peterx@redhat.com>,
 David Hildenbrand <david@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_04/19=5D_system/physmem=3A_D?= =?US-ASCII?Q?o_not_include_=27hw/xen/xen=2Eh=27_but_=27sysemu/xen=2Eh=27?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-5-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-5-philmd@linaro.org>
Message-ID: <2D88622C-9DFB-4DB6-8F9C-E45850FB1DCD@infradead.org>
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

On 14 November 2023 09:38:00 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>physmem=2Ec doesn't use any declaration from "hw/xen/xen=2Eh",
>it only requires "sysemu/xen=2Eh" and "system/xen-mapcache=2Eh"=2E
>
>Suggested-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>


