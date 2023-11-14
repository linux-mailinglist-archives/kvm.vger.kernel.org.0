Return-Path: <kvm+bounces-1683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCC87EB399
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43E701C20AA5
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7515741761;
	Tue, 14 Nov 2023 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R37YxD+2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CFA41234
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:31:30 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DDB130
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=kI8asQVhOaGuY/UltcD2EIrkJh3iOIJyA9g6wBOXluk=; b=R37YxD+21q3rf7xOFOp0slG+f9
	+xj/jKvNgv2ak6vgeuM+oEd2TkBIrpwWMJy0gnQcercjtVz0+mTVGvTGDNWhjq4sdt8mS8vT2l7kc
	cCVXqCeU4NDM74DxDlIgJqP/GLCUxRQSTOl+PT+Z35apucO6sEy7bPEf49aVglTMc2pLE3I+kOydB
	J4App7NzjOK0V0Snxpc2LLxYHcNIJDg0zhJ6Coc8TLNESIe2d73wUUsvlMLbUNqirlTy35l/Zljmx
	PjXYgavZnBmkovcuK4k/jZK6a20DhrEPQC04p8avEnhGf2OC45ZjGUXflE0pqgHzZwBJEKOjwrhXB
	zZOQGefw==;
Received: from [31.94.7.206] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2vNT-002WtI-0X;
	Tue, 14 Nov 2023 15:30:59 +0000
Date: Tue, 14 Nov 2023 10:30:48 -0500
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
 Thomas Huth <thuth@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH-for-9=2E0_v2_?= =?US-ASCII?Q?09/19=5D_hw/block/xen=5Fblkif=3A?= =?US-ASCII?Q?_Align_structs_with_QEMU=5FA?= =?US-ASCII?Q?LIGNED=28=29_instead_of_=23pragma?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-10-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-10-philmd@linaro.org>
Message-ID: <292FEC54-80CC-4C17-8027-F1CB3609FDF5@infradead.org>
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

On 14 November 2023 09:38:05 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>Except imported source files, QEMU code base uses
>the QEMU_ALIGNED() macro to align its structures=2E
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Can we have a BUILD_BUG_ON(sizeof=3D=3D) for these please?



