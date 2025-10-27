Return-Path: <kvm+bounces-61197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D58C0F77F
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B9611891AD0
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61CC30BBBF;
	Mon, 27 Oct 2025 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="VSb28ZDz"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster4-host2-snip4-10.eps.apple.com [57.103.84.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824FD2641C6
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761584034; cv=none; b=eMZ/qXs4NWhaIdXaGpXZezMatV0217ExVAZLngp0FQtwmbmG4QcQqq+6F/hAvjgqTXBHe3e+q7y1MlnOpMgCzkncdEJu1oFaQFV3QcE56bpUeR4zM3KBcUqGaPrxBK8rvMwmvhTjWN28XGxP45ONwIUwLbb5E0jZjF15hXXkglQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761584034; c=relaxed/simple;
	bh=xtg/dxSg3/dk8JnV89zTjEwvwdOBHfz6RsEf89vqW1I=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qbOcO87mJMSujx5qfy8VED+FwtaD46ehGDYByNO6R01Fj310yHL8a+2/jyc7GsVmMpN7w4Nz+NODUPnKxqsw+pBnQ8RbE5UnYoO3MPbRtvwwFVZuMhn/l651tfe6DnMC26Juu0S18RRmJVjpk4ipXZHv3lG1AyQuQpQx/Qcun5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=VSb28ZDz; arc=none smtp.client-ip=57.103.84.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPS id A9CE31800D46;
	Mon, 27 Oct 2025 16:53:43 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=MYj/Dk/0C6gDkNXUfpGaHLUrcKvYkq7hl58vOeSRyYc=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=VSb28ZDzz72IxU37djTbFX5VGNUHc0EeZDkmhYLKJVbhZufrQVvjn6V+bU63w/V1V1x/j0bxGiyMOguzJdjf2ELn8mvseK4o3i+kBSEfXHUcpoU72v4Di4RakxCE/6epV98dF+2DOWE21F56dhuXccVCk2Fsx8MhSzVLziguZ4G6Sr5Gt+VUk5R9Lasxk3d5aNyYl7ZrRRAZfcHjQU9o+XlQWXpbW8RoIW+Pl9MuhSFoqTGN6Gu8AiQPa9+sDXrO/Etlj+MLOAoU7dJWRnyjSsnmAOSVVqjZeIQllr7FvhCPqj2aOMSxGauiv4bKO3dS/YD5+9AES3S2X9cLp5JEog==
mail-alias-created-date: 1752046281608
Received: from smtpclient.apple (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-5 (Postfix) with ESMTPSA id 41FE31800122;
	Mon, 27 Oct 2025 16:53:40 +0000 (UTC)
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
In-Reply-To: <CAFEAcA93e6GL9agaCBZ2AabB21JrS6KS6MsbRHGPwdc_vj7xDQ@mail.gmail.com>
Date: Mon, 27 Oct 2025 17:53:27 +0100
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
Message-Id: <890B1091-0ADB-459F-B1C9-173EC32DDADA@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-4-mohamed@unpredictable.fr>
 <CAFEAcA-398ZMeLUbHWyUw4np81mLikEn2PkQnFQMY4oY_iWRFA@mail.gmail.com>
 <29E39B1C-40D3-4BBA-8B0B-C39594BA9B29@unpredictable.fr>
 <CAFEAcA93e6GL9agaCBZ2AabB21JrS6KS6MsbRHGPwdc_vj7xDQ@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Proofpoint-ORIG-GUID: 57m3XyZL_tlmaqwuCqdWO9wsWmZuWTLa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE1NyBTYWx0ZWRfX30uawxhrc/hi
 V2uJvIa13zgoDR1Yefo5iroT9CO8+TLWVVKx2SlLbBY8ZnQg2xATekURtIMuBEUwC8V/8ZIDob2
 /zOl34GtzfXXd7SHSQmL0eptJX/x5QKbanDhfbB3gItf9AW101jgZwtCTrkv1CUt1+GSQmqwuSi
 gx3mwr7lgQC/xvkGZrQx1hMhbOjPkrARe49rv2KqXnyrjS9puj9xjTyERss2BuD7bwoet3dnX8b
 XFQpkVaCeMU3J7hDmdyEtEHu/Wta2OfZJviqqXirIAhiBmA260CaLGC0exEr1jx07WoObgtFQ=
X-Proofpoint-GUID: 57m3XyZL_tlmaqwuCqdWO9wsWmZuWTLa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1030 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2510270157
X-JNJ: AAAAAAABlOpZ5rcRCI6duR/UNBrJ08p6gXb/7P1m3EBeP28//7z+bNtqspI5QDCVkxQQ0mub2CyAqUIuijKD/TJ7kcYDFYxDPXwkh18ftCIbY+Ptqg4ZNW+8Guke31VHw48m77D1kHmlJ5aufukj/bOj874sIZRqcyb/bmC1NaumV4VWvRPQD/xAXSEGYigCZ3Zw1KAcSXtfISzLYPiOVaYC3hmK3oC/wiCEh3fr30Xt4u5SNnJanLY0Atv3rAHuHfk7oGsSfVh+EMewkMITWGbmIh3WZbNNvqVsmlV/rTwyk7+mzj8wvVxu7AALRiAR9WX2p7+BsFMDy5Mg1BsbYg/DfV9Dh9exwPR2zVMHyEFc4546MPbkx7rZM8pNF0VmoHXYw9gOVPqAtizMw/k0GfXHEmZbwQgkbUrpaGUBCXp03vCpJDhtwTxRSg/vpHYXvba0yhW4SltIpjb1czkmd7bjy9VigxPbNvj/GMVIGJx2O0yvYvUG86Wol4dc/G9KXLwD1KU9uwdCBWOd3cQ99QrV34tehtdk6vrqvMDVl/tWl1+d3w0cNmvI0p4EC9nquYZUf69b3qgCkYZvCKho516ad3paj+g7DYvHR46GRFLY1+IZQbnvq8z2cUkzk/OAkKMAeTyZa/jUoaCPxUUXyhljYoXCvd9PVNlze4bF77KUE2Va79gt+DY2HM/RUUIUztK6EtIlecYVZ0w0AKvGNOFBL0Ky0PY+a0b7gtiH6/RQj2AlWhQ6hQZSDr+IS94qXmUaax8Kkc68DUpfGoCIHXpU/HUdBgu5ev11w/8JTOMboRLqx43BOydSyL45rPPGeDFKHpybCFisnvIoNYj0w75J1atbfk/+EYMRMRMe4RU9JCCbVgpZCcyR43oLEWuCbhXazw9PjRWYi58f79ZJp02JpWhzgFFh27HHmrRyElmj28dtfI33sj815M3NNoQ9pY0HfebJbSqNbhf7HwjaiD/DX+gt52n
 GfHStA9CiHHPamK1m



> On 27. Oct 2025, at 17:03, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>=20
> On Thu, 2 Oct 2025 at 05:30, Mohamed Mediouni =
<mohamed@unpredictable.fr> wrote:
>>=20
>>=20
>>=20
>>> On 25. Sep 2025, at 18:24, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>>>=20
>>> On Sat, 20 Sept 2025 at 15:02, Mohamed Mediouni
>>> <mohamed@unpredictable.fr> wrote:
>>>>=20
>>>> On Hypervisor.framework for macOS and WHPX for Windows, the =
provided environment is a GICv3 without ITS.
>>>>=20
>>>> As such, support a GICv3 w/ GICv2m for that scenario.
>>>>=20
>>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>>>>=20
>>>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>> hw/arm/virt-acpi-build.c | 4 +++-
>>>> hw/arm/virt.c            | 8 ++++++++
>>>> include/hw/arm/virt.h    | 2 ++
>>>> 3 files changed, 13 insertions(+), 1 deletion(-)
>>>=20
>>> Looking at this I find myself wondering whether we need the
>>> old-version back compat handling. The cases I think we have
>>> at the moment are:
>>>=20
>>> (1) TCG, virt-6.1 and earlier: no_tcg_its is set
>>>  -- you can have a gicv2 (always with a gicv2m)
>>>  -- if you specify gic-version=3D3 you get a GICv3 without ITS
>>> (2) TCG, virt-6.2 and later:
>>>  -- gic-version=3D2 still has gicv2m
>>>  -- gic-version=3D3 by default gives you an ITS; if you also
>>>     say its=3Doff you get GICv3 with no ITS
>>>  -- there is no case where we provide a GICv3 and are
>>>     unable to provide an ITS for it
>>> (3) KVM (any version):
>>>  -- gic-version=3D2 has a gicv2m
>>>  -- gic-version=3D3 gives you an ITS by default; its=3Doff
>>>     will remove it
>>>  -- there is no case where we provide a GICv3 and are
>>>     unable to provide an ITS for it
>>> (4) HVF:
>>>  -- only gic-version=3D2 works, you get a gicv2m
>>>=20
>>> and I think what we want is:
>>> (a) if you explicitly disable the ITS (with its=3Doff or via
>>>    no_tcg_its) you get no ITS (and no gicv2m)
>>> (b) if you explicitly enable the ITS you should get an
>>>    actual ITS or an error message
>>> (c) the default should be its=3Dauto which gives
>>>    you "ITS if we can, gicv2m if we can't".
>>>    This is repurposing the its=3D property as "message signaled
>>>    interrupt support", which is a little bit of a hack
>>>    but I think OK if we're clear about it in the docs.
>>>    (We could rename the property to "msi=3D(off,its,gicv2m,auto)"
>>>    with back-compat support for "its=3D" but I don't know if
>>>    that's worth the effort.)
>>>=20
>>> And then that doesn't need any back-compat handling for pre-10.2
>>> machine types or a "no_gicv3_with_gicv2m" flag, because for
>>> 10.1 and earlier there is no case that currently works and
>>> which falls into category (c) and which doesn't give you an ITS.
>>> (because we don't yet have hvf gicv3 implemented: that's a new
>>> feature that never worked in 10.1.)
>>>=20
>>> What do you think?
>>=20
>> Would it be wanted to provide MSI-X support in all scenarios
>> even with its=3Doff?
>=20
> We should prefer to provide MSI-X support. If the user
> explicitly asks for a config that doesn't give MSI-X
> support, that's their choice to make.
>=20
>> And there=E2=80=99s the consequence of that making GICv3 + GICv2m =
only
>> testable with auto and not with TCG or kvm, which doesn=E2=80=99t =
sound ideal.
>=20
> I guess that would be an argument for the "give the property
> the right name so we can say "msi=3D(off,its,gicv2m,auto)". Then
> you could say
> -accel tcg -machine gic-version=3D3,msi=3Dgicv2m
>=20
> to test that setup.

Is there guidance around renaming properties?

Would it be proper to do:
- if its=3Dauto, consider the new msi property
- otherwise, use the its property

Thank you,
-Mohamed
> thanks
> -- PMM
>=20


