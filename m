Return-Path: <kvm+bounces-1679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B6B7EB340
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D940B20B3F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61E74174E;
	Tue, 14 Nov 2023 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CDbCkxBO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB93FB15
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:14:32 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EB9FF
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=zLWRl6fuh+QlAq2JcSTCgSqOD3rW63ZP4Laj6regjn0=; b=CDbCkxBOGqoE0okEs41cvDk5fY
	avC36PbcnvrY2oGlWB+RQPF4liPIPZGR3EmI5Av83WCkoqFq/6JecFkFY7vUWsvo7/8BmYzi44D1g
	Ws5geOrtzOEM5Q+9dgkqYhjuO8CCj0m7FwKXRyGH/otFSxezkrYf7thCJcuan3UovTroWWy1VVTp0
	pnd+C2RYiX9iD91nqIjI4v94iVedb61DZAmiijnR8rGW40PapOik1v9uw6WmF0h27udRo7vUsUI+/
	CdQBeD4lSkTeDsX/DqpzXtj+VzppGTN+wtPUM4BmDuIgnKf9HDMxmYUNaj5vpn46oYHJTmkvPF/K5
	uuDkjPBA==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r2v73-008dEf-2f; Tue, 14 Nov 2023 15:14:01 +0000
Date: Tue, 14 Nov 2023 10:13:58 -0500
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
 Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_06/19=5D_hw/pci/msi?= =?US-ASCII?Q?=3A_Restrict_xen=5Fis=5Fpirq=5Fmsi=28=29_call_to_Xen?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-7-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-7-philmd@linaro.org>
Message-ID: <EEC18CA6-88F2-4F18-BDE5-5E9AAE5778A7@infradead.org>
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

On 14 November 2023 09:38:02 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>Similarly to the restriction in hw/pci/msix=2Ec (see commit
>e1e4bf2252 "msix: fix msix_vector_masked"), restrict the
>xen_is_pirq_msi() call in msi_is_masked() to Xen=2E
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Hm, we do also support the Xen abomination of snooping on MSI table writes=
 to see if they're targeted at a Xen PIRQ, then actually unmasking the MSI =
from QEMU when the guest binds the corresponding event channel to that PIRQ=
=2E

I think this is going to break in CI as kvm_xen_guest=2Epy does deliberate=
ly exercise that use case, doesn't it?

I deliberately *didn't* switch to testing the Xen PV net device, with a co=
mment that testing MSI and irqchip permutations was far more entertaining=
=2E So I hope it should catch this?


