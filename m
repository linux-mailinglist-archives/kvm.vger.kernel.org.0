Return-Path: <kvm+bounces-59387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72755BB27A6
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 06:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278901C63C1
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 04:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F9D23E342;
	Thu,  2 Oct 2025 04:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="CO1jQybV"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster2-host6-snip4-2.eps.apple.com [57.103.87.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53DE15CD7E
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.87.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759379427; cv=none; b=aDPkmZ4SopfSWjBZZuQ21qry1eIR8MWm7nvWospMOKtwIBIJORTLMwHP3F3zUKbDX0zNRoCoEAxcXz00eKz0ZnrTo/+mjemh5RfLuR63ZKAiz475QSPEzgTnOEfTVWV8cqaLDvb1n+ssOe96xOxxbnxLpLjLqdDgRHyvvdhM4VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759379427; c=relaxed/simple;
	bh=C5AtIICEz0UczeBbUtdLNNiEltmWKfug7gIBwOM5a6I=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ObZ5vQV51SyCxWa+QE4RZNDteqcrh18lGNc39yU33kiFCKnwjG+numfn9kfHB4bNEkbRnwiMK84gXBAashFE4JNSrUVC3ZLsXTJT70dyXlPg9w8Eh89Pq/wdnV3yazTQbIN68hHoE0cU5jfXtUI3Qr9e/Ps57HNAeHDXCz6P8Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=CO1jQybV; arc=none smtp.client-ip=57.103.87.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-0 (Postfix) with ESMTPS id A843D1800346;
	Thu,  2 Oct 2025 04:30:15 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=AMnypSY+zGdob6ZQeFJ+VngD412wfTVoUZjiugy7xXE=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=CO1jQybVIERiU2dhddqkSq0fDKKUErWUWDJKdjPsnbXIUQcUaOhGAUubmSp0vVdG6nUIwdNItJgvOavGYhigE3E5OX44SQpHzOQV9995hg1eOFWks62NbWlgymyzkROX2oIK9qGUH3ASfgTYD759b/90t1ZcGFjEPMGLzJTw9XHYuPaWhVtf1RyxIkbtbw9+Qoi2nAJtC9H6zEKUc+faduv2HNj3xks08RY0q5JTjwN4HoGss/uIHc2Zwwf5y4mZGu7qgahvKBvz2hGD2dPWpJtpOWn68I0nf4KVSIPmdO2zVBJ4T5g1k5jTcbVhhDxK13TZPrY8Qh9T+BNTRf5EeQ==
mail-alias-created-date: 1752046281608
Received: from smtpclient.apple (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-0 (Postfix) with ESMTPSA id 4DA6718000A7;
	Thu,  2 Oct 2025 04:30:12 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v6 03/23] hw/arm: virt: add GICv2m for the case when ITS
 is not available
From: Mohamed Mediouni <mohamed@unpredictable.fr>
In-Reply-To: <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
Date: Thu, 2 Oct 2025 06:30:00 +0200
Cc: qemu-devel@nongnu.org,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
 =?utf-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Mads Ynddal <mads@ynddal.dk>,
 =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Cameron Esfahani <dirty@apple.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 kvm@vger.kernel.org,
 Igor Mammedov <imammedo@redhat.com>,
 qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>,
 Alexander Graf <agraf@csgraf.de>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Ani Sinha <anisinha@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <29E39B1C-40D3-4BBA-8B0B-C39594BA9B29@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-4-mohamed@unpredictable.fr>
 <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Proofpoint-GUID: CJFpDVIwmkAu2IlkIvD6zUEkt3yFB_Jr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDAyMDAzNiBTYWx0ZWRfX+j4lSbyT82c1
 GicabodNmbkEEp+tXIyKOa1mqlkx4ZEpi6CdQ0Uafpt8QC8RnQ5Ih6xJIInbgops15A4oC3JPkd
 FrUbYZLQhQcHC9lsCMsqHgFN37E9iLxswUDJu/SuCZ5yKkHb34aoYVbj9RKB8hgxbypkSmaYpgl
 eIfEHT5RP8MveirDjgCceDw4sMB/EWTok4Wr5G9UzOTgkm9+NGl6OedioW5Kr7SXqqyPaSlW98q
 llQR2dT3HnNI/CspZE1oo5nQnKEKj4AgRO9aul59LEaShDDWsCawndqkdoFCQ+izNQP6sJjds=
X-Proofpoint-ORIG-GUID: CJFpDVIwmkAu2IlkIvD6zUEkt3yFB_Jr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_02,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1030 adultscore=0
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510020036
X-JNJ: AAAAAAABW4m61AJpsvVrk0/fj+8K4NGZOs8trT0wgKIFbmzFZAi0PRTBsH5xx86cKOLWGb80fK+vNIgvhx9yNLpEwOGaqVlmLuzgCcSktq7ZM4OmwwG90iGtljAM9ZjIgJ9T1o58n9bWcRo//0kSDuUBx5MqvjInB+pzQE+uOsTsN3AlU2IefYsg2rqNJjGWGyRLOmrgTY+37ML5WYA+ck1tCcEHSc6j9KLYZFSj06VvOyF2abUnb7OAY8xvgXvPmcdpvzOxkLn3COYn+ZQ/ziSrpQ8AcQeikd5DtwRkEqH+h6niTL/F61xkhWOZ+BQE6Jx8sr/Abv3a0yWL5m/TbYs5oVtnxNIT5/gj+WrdxAh019+V+fqfnuwlt1r51BpYgZwTlNvkPGMNcyN21Z/c5Xs+LHG9Lfa1wa/fqEFg/rUxBliV+HwSH28tLO2MUUMKeFu7NG6B44gQe+uzi87XC/pTCZWoP1DYfoUGnGmMNX0Mg0B1TSu9La01FglVuD0yrPOTVOQTplEzvsAGTTmsLQW+9DUsrQw7zoqDbKeQWmYIWDjsrgqlO+D/OtX3v3h/p6EHVO+UQZlVfjwEG5ZOAI3xnUqjdJ9vQpVtacjBXYzy2+Y5Fdy5zcwkA02XEJ4KAWso8lBDLuXVr8Rz5NSZjsQp7uVXkTtHTyP4fN9Eyf3YW5gcJLQsoaLTlPQu/5Wm7H92xHwjwzIQOAagEd8X9EtqKcW7CnDo1LWqBrDiaIaxotiRdpNHGCaMQwU1jDnPsxzoDYWlcQ3lY9AKLUp90kH0//z8G+klFbx3Q0VwExukrG9T/M4hmIwMcNs7mTD5Pnz2UWhUvYBedO0vFaQD5KB5IHhpHwz6Tsy0xbnVBkDr7DyM8XC4TEvA7BY4/DrZ4lUhZgCHZ7WOdgP4mDsEOewVhEnFdJbRdjUuDVJ9+WVJ058fY+5I1DDgBNuLmDtGvPcgEs5+rrwKWDqHzQY=



> On 25. Sep 2025, at 18:24, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>=20
> On Sat, 20 Sept 2025 at 15:02, Mohamed Mediouni
> <mohamed@unpredictable.fr> wrote:
>>=20
>> On Hypervisor.framework for macOS and WHPX for Windows, the provided =
environment is a GICv3 without ITS.
>>=20
>> As such, support a GICv3 w/ GICv2m for that scenario.
>>=20
>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>>=20
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>> hw/arm/virt-acpi-build.c | 4 +++-
>> hw/arm/virt.c            | 8 ++++++++
>> include/hw/arm/virt.h    | 2 ++
>> 3 files changed, 13 insertions(+), 1 deletion(-)
>=20
> Looking at this I find myself wondering whether we need the
> old-version back compat handling. The cases I think we have
> at the moment are:
>=20
> (1) TCG, virt-6.1 and earlier: no_tcg_its is set
>   -- you can have a gicv2 (always with a gicv2m)
>   -- if you specify gic-version=3D3 you get a GICv3 without ITS
> (2) TCG, virt-6.2 and later:
>   -- gic-version=3D2 still has gicv2m
>   -- gic-version=3D3 by default gives you an ITS; if you also
>      say its=3Doff you get GICv3 with no ITS
>   -- there is no case where we provide a GICv3 and are
>      unable to provide an ITS for it
> (3) KVM (any version):
>   -- gic-version=3D2 has a gicv2m
>   -- gic-version=3D3 gives you an ITS by default; its=3Doff
>      will remove it
>   -- there is no case where we provide a GICv3 and are
>      unable to provide an ITS for it
> (4) HVF:
>   -- only gic-version=3D2 works, you get a gicv2m
>=20
> and I think what we want is:
> (a) if you explicitly disable the ITS (with its=3Doff or via
>     no_tcg_its) you get no ITS (and no gicv2m)
> (b) if you explicitly enable the ITS you should get an
>     actual ITS or an error message
> (c) the default should be its=3Dauto which gives
>     you "ITS if we can, gicv2m if we can't".
>     This is repurposing the its=3D property as "message signaled
>     interrupt support", which is a little bit of a hack
>     but I think OK if we're clear about it in the docs.
>     (We could rename the property to "msi=3D(off,its,gicv2m,auto)"
>     with back-compat support for "its=3D" but I don't know if
>     that's worth the effort.)
>=20
> And then that doesn't need any back-compat handling for pre-10.2
> machine types or a "no_gicv3_with_gicv2m" flag, because for
> 10.1 and earlier there is no case that currently works and
> which falls into category (c) and which doesn't give you an ITS.
> (because we don't yet have hvf gicv3 implemented: that's a new
> feature that never worked in 10.1.)
>=20
> What do you think?

Would it be wanted to provide MSI-X support in all scenarios even with =
its=3Doff?
And there=E2=80=99s the consequence of that making GICv3 + GICv2m only =
testable with auto and not with TCG or kvm, which doesn=E2=80=99t sound =
ideal.

Thanks,
> thanks
> -- PMM


