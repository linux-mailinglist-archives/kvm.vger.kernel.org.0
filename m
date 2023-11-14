Return-Path: <kvm+bounces-1682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D8F7EB388
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1F7DB20B86
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40284175D;
	Tue, 14 Nov 2023 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q8wLxLTE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333DE4174C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:28:19 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF95A184
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=N6lsIAvT/LEG0QMHScLeB5rAujKwbWfIcynqEX/JTgg=; b=Q8wLxLTE99gkmHRWLTsrO2SdeW
	XfdKzTjDRskRz4FgWweoVthPGWW6En3PnTPFiWPPGI0GLEqYKFCbaeUhWCc7eqRld+EkmItyFum/u
	f8mR/LaDGf97Vypg8dR70A9njyk0ujfA7GZDBcceSMpPvIfPG8ySvMi5k6XkPRB+nhXIzXfrUJtqt
	0clzgOwbYlqSSo1XvNoqUO0a+GmML4/eWxE/IEVjTty/Z4Wj8qtR55DQRxJj44VukxbGuuQxa91Un
	cEKKoaJzdph/iZGXdVUaBR1VS+02QOG0uU75aMm/LiOK4lkOlIuQpg//W3mDTgD24Mh/X3NI0TbGv
	wu90QKlA==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r2vKf-008iHm-67; Tue, 14 Nov 2023 15:28:05 +0000
Date: Tue, 14 Nov 2023 10:27:59 -0500
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_07/19=5D_hw/xen=3A_Rem?= =?US-ASCII?Q?ove_unnecessary_xen=5Fhvm=5Finject=5Fmsi=28=29_stub?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-8-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-8-philmd@linaro.org>
Message-ID: <017E3F40-47A2-4F1D-98B6-18863ABB0FD6@infradead.org>
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

On 14 November 2023 09:38:03 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>Since commit 04b0de0ee8 ("xen: factor out common functions")
>xen_hvm_inject_msi() stub is not required=2E
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>



