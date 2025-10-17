Return-Path: <kvm+bounces-60298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D52BE83C3
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25FC6E9700
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA1F0329C49;
	Fri, 17 Oct 2025 10:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="fnu37x7m"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster3-host6-snip4-10.eps.apple.com [57.103.77.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D602231D73F
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 10:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.77.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698601; cv=none; b=MRWVLZjoBjFDjkzREcTdILkJQC8kNlxtGX/UFy313PVEmsVPDZXDOaqUe+QN91uhPmsO3Nif5fIpvzrbJJYTqe6nA8u6XJ55CIosCuH4RKSruX4I/T0X3XcZXa/SMYRatG2eho5NOa4U7KPwpbyNhx7BsOCCU2ybulsrEF1VOl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698601; c=relaxed/simple;
	bh=vF1GaK7WYs32tzG9X+aOFxs95mgw5O/OaYYSamcEdfo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eFRyxSTaySsuA5j8vO3FdOfEt5xmEu+nixBvliHXZ7RtEIhI8g3RLI1FASOhA62gKcSDXTVBw0sesfKZMbPjQOl3nMNxZ9GeiWVRuYXGTzo+qIBE3VEwDO8RfqDvfgtTB2psnWAFp1UZOQxEP91FSUXys61TuVA0v1Zv6XfM3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=fnu37x7m; arc=none smtp.client-ip=57.103.77.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-0 (Postfix) with ESMTPS id ACE5F1800D56;
	Fri, 17 Oct 2025 10:56:30 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=vF1GaK7WYs32tzG9X+aOFxs95mgw5O/OaYYSamcEdfo=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=fnu37x7m/xKug0WRgBSF5fu2TThB0WnNPWi9VFelHwRlPGgVimQ51MZ3IX2uH7pl0+NUAUSVhkwRq/fOTmhAHUi7UZa6s+pIK/5lNpKqg/kZigmpqKeWK9UZnD/8cKGBPO/0bFMunNbhS0PpQQDmKUQfaFcltc2si6aT9U21WvX76VHVxBI5Hc5Q/5weMUKoSfmYSBCf2FuUxnw0uN4flBGMt1b26owPOI1JfmlOoSIpAAF8LVqascGVsNtp2dCnH3sRpiYdBIJ59sCwYbNqbH/g25DTNgw+EHas4/dDNEdSBd0iuRIjwFFxWR54ElYIjZl9FY5KuQUDWDq53Zl9hQ==
mail-alias-created-date: 1752046281608
Received: from smtpclient.apple (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-0 (Postfix) with ESMTPSA id 9E6971800121;
	Fri, 17 Oct 2025 10:56:26 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v7 00/24] WHPX support for Arm
From: Mohamed Mediouni <mohamed@unpredictable.fr>
In-Reply-To: <CAFEAcA9VWiQoOytHh9PbbQZVXm4ET7Ud9eLQP0C0njOO8R8qzA@mail.gmail.com>
Date: Fri, 17 Oct 2025 12:56:14 +0200
Cc: qemu-devel@nongnu.org,
 Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>,
 Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org,
 =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 kvm@vger.kernel.org,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?utf-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3C1B04B2-75AB-4EE4-93AD-8C76EEEDA73C@unpredictable.fr>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <CAFEAcA9VWiQoOytHh9PbbQZVXm4ET7Ud9eLQP0C0njOO8R8qzA@mail.gmail.com>
To: Peter Maydell <peter.maydell@linaro.org>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Proofpoint-GUID: COHrM0wKK2z-Y-ubsreiZJ4VTOiuC4xO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE3MDA4MSBTYWx0ZWRfX1xzUrn+FZl93
 O7ralrla+j7yGDk4/LDoEFMqCaspyDad04cofHx/1uw4YYLjyYJ9k5Cwe0hJAdRWskqdvzMPvJb
 b85LZ9N5UaxBVqHR3Pp9hDOFVAuQOt+Qdi8btHG8tcZ2mFejKKYJUIcNiAUaVun2t2Rv3d2nbS/
 BAvHOMD/8NNWfYgPDrZYHTMuXRtfRE/q8onZJ/vn/rNU58JM7l1rsC4hA4Pai6K/YkJMW//tWVT
 8Mi/UqloLrz2ojOTKNkSOETc9jS3qlnJUgW5tQZFxvFk8cJl7n2pah/FQqhk9ZuyiPrln7ZoI=
X-Proofpoint-ORIG-GUID: COHrM0wKK2z-Y-ubsreiZJ4VTOiuC4xO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510170081
X-JNJ: AAAAAAABAYrxi4EnHCsKcJi5Cn5YI6Jwvc4g3o3GixEaxAxfLeERwUcm+GAlW5y8aBcimEis6EsgpdRreTkQzuUFKoJ9EX9JNRdnFyZXV/ICcSTs5T45BeF17Pu93HRdosTIjQNUadqyc/yGT7IdAvcutaFccZQqnp3LYEG02kf98QmEL1IU9jeUXrt+0ioo0vBhdqvBto4KrPkPqVoL+5gQdIKFNCa8F4hcSdCFBtay9EJJcV2UU5nOnphpuUWtZX3sNxrIuZ8qHtdn9iw47GrGu7tnRydSRwQjvZCQOctSQGL5gMm+qrs3QYzwCcYS1jlLQJAhkpXANMOb7SQD7AoV25io7CWH6JqEv4/Sn/oFQz6c7T9IJXa5W7qFnLjO5StXCGCJwx9rnWH3dMC1LnE/QL1ke7x9UObj/RUqKIBVzO0hsYa/WxlZ/IGX97xr6so7V5ossI/0mEpxWCdiV7nmFaHVHVbI/QNaDMtAtD0ZRnn/K4wCkDZ8z9k5yLFTGqD2QdrBVG0wmfe9blv7ozQKwbW5tMW5TDNF0s4qZwxLYE5M7LNeUA8Lq+YHxfjlY28nvMAVzeiCKhVqdVlZNbTY2y4qJcywwW0Fovda82Mo83HESRswcUqV4Vjnggsv6RwMSr5DpHWGo9IbzQmikn0tM0DsnTgjAXOgewM5JwjU4SKhPinNx1K6x43SVJF2i0Sgcza0m27QRXLmISTZqHtMYOEAYqUr3f9eTKcepvY7PwRzUzT+lqZ1ub8LfnykZp6L4fIvftkO7nx/ixOHR4dNbf+M/Lmhk9mwOCmH6ERfY03JYiA05BebDHN/H+X8uN+QLUzINDd8qQXeXvHCa69ITq3VlaUTJBe2tegRGOME0ro4+nCRGDbB5f/p1tWuBCQGKWVPFnIFWxa81wv/A6lEC4OsTsy8WLs0TVv0bek1JKxxG+eLWPF1jaA3Cx9/lQ==



> On 17. Oct 2025, at 11:59, Peter Maydell <peter.maydell@linaro.org> =
wrote:
>=20
> On Thu, 16 Oct 2025 at 17:56, Mohamed Mediouni =
<mohamed@unpredictable.fr> wrote:
>>=20
>> Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this =
submission: whpx-v6)
>>=20
>> Missing features:
>> - PSCI state sync with Hyper-V
>> - Interrupt controller save-restore
>> - SVE register sync
>=20
> The interrupt-controller save-state we can probably live
> without if we have a migration-blocker for it, but the
> SVE and PSCI state sync missing seems like it would be
> a source of bugs?
For SVE it=E2=80=99s dealt with by disabling it. There=E2=80=99s no =
consumer Windows on arm64 hardware with SVE available for sale right now =
unfortunately - but it=E2=80=99s coming in Q1 next year.=20

For PSCI state sync it=E2=80=99s=E2=80=A6 well, brittle on the Hyper-V =
side (with opaque, currently undocumented flags). Doing it would fix =
reboots though.

Note that Hyper-V doesn't cause VM exits for PSCI calls today, even if =
it=E2=80=99s to bring up a CPU.

>> Known bugs:
>> - reboots when multiple cores are enabled are currently broken
>> - U-Boot still doesn't work (hangs when trying to parse firmware) but =
EDK2 does.
>=20
> You need to fix your known bugs before we take this, I think...

I can try to address the first one/on the cards but the second one would =
probably come later (if it=E2=80=99s not actually due to a platform =
bug=E2=80=A6) .

-Mohamed
> thanks
> -- PMM
>=20


