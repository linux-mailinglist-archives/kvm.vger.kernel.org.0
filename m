Return-Path: <kvm+bounces-1686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C1CC7EB402
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D08C1C20A66
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F8A41771;
	Tue, 14 Nov 2023 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YqW3uEi2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86B1156C9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:44:52 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3C0126
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=bYqSajk3DW7Yh+DFyVrS+kyF4H8z8qvad3x82sz2aaI=; b=YqW3uEi2vQw3DjRK/dfzLFXO0i
	ol0JQCjTOY9WyrZiohnqK3oywKuX7QRJMv9c/r0/H1GhU4soKQE4pX546b0pOJe41eqPvQyMdlS9D
	JjZnUsoEflQBaPcSmVeZUNC6gFb/F/AHvBgGbG45q8dq2bY/HuxOsYSn1gkamlBDPKj5PLzkQCqDV
	uuRw94+TJstDMEwSJOdHSAZ/eg0fNDrCCSNDKnSVzYqIP5ATArH/AmuIAmdAFZxiZ3DzSlvU2j59z
	28GUp13EJ0Phexm3TkBaux2CJfoeKPQLkCZ3AuIEn5VUs5Vc0vPfWlCWlKWTyF5ofP/H+o4pxyRJK
	eLup9QTQ==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2vag-002XCO-0y;
	Tue, 14 Nov 2023 15:44:38 +0000
Date: Tue, 14 Nov 2023 10:44:30 -0500
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
In-Reply-To: <7fd25b34-6fd9-4f7c-90b4-e44338b2b09e@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-7-philmd@linaro.org> <EEC18CA6-88F2-4F18-BDE5-5E9AAE5778A7@infradead.org> <7fd25b34-6fd9-4f7c-90b4-e44338b2b09e@linaro.org>
Message-ID: <87CD61D3-D862-45C6-9DBC-2765D747EA58@infradead.org>
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

On 14 November 2023 10:22:23 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>On 14/11/23 16:13, David Woodhouse wrote:
>> On 14 November 2023 09:38:02 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <=
philmd@linaro=2Eorg> wrote:
>>> Similarly to the restriction in hw/pci/msix=2Ec (see commit
>>> e1e4bf2252 "msix: fix msix_vector_masked"), restrict the
>>> xen_is_pirq_msi() call in msi_is_masked() to Xen=2E
>>>=20
>>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>
>>=20
>> Hm, we do also support the Xen abomination of snooping on MSI table wri=
tes to see if they're targeted at a Xen PIRQ, then actually unmasking the M=
SI from QEMU when the guest binds the corresponding event channel to that P=
IRQ=2E
>>=20
>> I think this is going to break in CI as kvm_xen_guest=2Epy does deliber=
ately exercise that use case, doesn't it?
>
>Hmmm I see what you mean=2E
>
>So you mentioned these checks:
>
>- host Xen accel
>- Xen accel emulated to guest via KVM host accel
>
>Maybe we need here:
>
>- guest expected to run Xen
>
>  Being (
>                Xen accel emulated to guest via KVM host accel
>	OR
>                host Xen accel
>        )
>
>If so, possibly few places incorrectly check 'xen_enabled()'
>instead of this 'xen_guest()'=2E

I think xen_is_pirq_msi() had that test built in, didn't it? Adding a 'xen=
_enabled() &&' prefix was technically redundant?=20

What's the actual problem we're trying to solve here? That we had two sepa=
rate implementations of xen_is_pirq_msi() (three if you count an empty stub=
?) which are resolved at link time and prevent you from running Xen-accel a=
nd KVM-accel VMs within the same QEMU process?

>"Xen on KVM" is a tricky case=2E=2E=2E
>
>> I deliberately *didn't* switch to testing the Xen PV net device, with a=
 comment that testing MSI and irqchip permutations was far more entertainin=
g=2E So I hope it should catch this?
>
>=C2=AF\_(=E3=83=84)_/=C2=AF

I believe that if you push your branch to a gitlab tree with the right CI =
variables defined, it'll run all the CI? And I *hope* it fails with this pa=
tch=2E It's precisely the kind of thing I was *intending* to catch with the=
 testing!


