Return-Path: <kvm+bounces-1687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0557EB41E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB5F81C20ACD
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5174177D;
	Tue, 14 Nov 2023 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g+J9KwGd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C6C4176E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:49:26 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94686FE
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=wtURPiisGS2Hb9OQNj9FuNG7UceqKqAuVLVYS7MTruU=; b=g+J9KwGdZRYI4g0BjPhX3Wej4V
	qgf4G1p2wAcN0ZPSKlJTDLbDa6XzWqI79m4La+5Xg542iql0TG4Aa2bBhd1bNXq47iauucD6/Ws01
	q39MFSqTiOOKtNXKYVedMaF39zDxCwXjwSxbPqoJ4wo8wyGRIa0FUIS6KScaI3gUS1ZE8683oG0xC
	0ZZCj6wcHEVFbZshtzBfxKDTM3DRbHiSS4qoRs2Ik4XoXV5MhW23iSr5JRBMh6eY5DSxYJppv7H+a
	5/rO5817qfDyFhoFlUiiNymrxo7+awx/ceo7QpxfhIdD7b6B72zUl9AqNCaLHNVbi24MNccaGsAPq
	Ah78wSow==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2vf5-002XJc-28;
	Tue, 14 Nov 2023 15:49:12 +0000
Date: Tue, 14 Nov 2023 10:49:07 -0500
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
 Thomas Huth <thuth@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_10/19=5D_hw/xen=3A_Rename_?= =?US-ASCII?Q?=27ram=5Fmemory=27_global_variable_as_=27xen=5Fmemory=27?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-11-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-11-philmd@linaro.org>
Message-ID: <84F1C2D8-4963-4815-8079-B44081234D41@infradead.org>
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

On 14 November 2023 09:38:06 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>To avoid a potential global variable shadow in
>hw/i386/pc_piix=2Ec::pc_init1(), rename Xen's
>"ram_memory" as "xen_memory"=2E
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Well OK, but aren't you going to be coming back later to eliminate global =
variables which are actually per-VM?

Or is that the point, because *then* the conflicting name will actually ma=
tter?

Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>


