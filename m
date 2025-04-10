Return-Path: <kvm+bounces-43041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A16AA83580
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 03:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D79B1739BD
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 01:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A164713D521;
	Thu, 10 Apr 2025 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=proton.me header.i=@proton.me header.b="FK714v6p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2BD59B71;
	Thu, 10 Apr 2025 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744247608; cv=none; b=kpKI0BwwZ5pLsjR4KAm05+6YxDGzr99BguhgdlSgQP8GaPGgT6MrDf8ZNbYW4l5TT84//FsNKE8whrWNrBNpZ//PbR5rUPJX4tPouB7dXaZU4oxZIK6w53+1CvOFY1HS+Apm2Th+PtttJqjrR8DjlOVqqYguE9wtJS+kaEL81NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744247608; c=relaxed/simple;
	bh=YzQiks8GXtr147u0QhDm7ied2ITLaM9fgBAb0ZkvAI8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=sZ+N9jcJDkF1joO61FXw7h5mL3aCctUolCv/dT5aEdlir63dMLPPBTES/ppNDBo0yBX7DKzM60dGMRrFDdkH9M6S3T2vFKjPgUYoDY11QgwmWpD6GgD9PdIH8wSfH93oZTv4x8hqEbWDhS4Yo+DRe+C8onpyqkotlz78cNaSq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=FK714v6p; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1744247603; x=1744506803;
	bh=5IhPW6iSibHV5VNeY2F53/jyEHnH+AF5dzWCrAbv3wU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=FK714v6p6esgjwd64AXKp4Z+TaM4Dszi8BR7ru9JwMJtRrUi2kjRmAKKz8tYLQtAB
	 0U6EcTzEv5HKlPVeV+euf8sQTQm5n7Dr72vmOtdBiuD8EPYfV3FEuI1cQbsjpIog2U
	 IgyiAOiAku9KHJ3C2/uMtrYW7RveVBPT8NuxTD4fqy3c6jEIHBBqAon4Woiw/ADpSd
	 ql0WgTCReJOPe8uTJEZ71qh28blTV6yZOU3G3eGRd6BMOGkzbMdNiEmnhqEH4eDee+
	 kubeFPob7TJ/vmWs1QwAZtuuNisrMWo+XDZfRnAxj+I/6CM2sv1dLyGiokWLTsuQ8W
	 juH6y85WdcqJg==
Date: Thu, 10 Apr 2025 01:13:18 +0000
To: Linux regressions mailing list <regressions@lists.linux.dev>, Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
From: Myrsky Lintu <myrskylintu@proton.me>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
Message-ID: <0f37f8e5-3cfe-4efb-bec9-b0882d85ead2@proton.me>
Feedback-ID: 89599038:user:proton
X-Pm-Message-ID: 463996738ae8f38ea5d8024aed4a838ee2cca8ef
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I am completely new to and uninformed about kernel development. I was=20
pointed here from Mesa documentation for Venus (Vulkan encapsulation for=20
KVM/QEMU): https://docs.mesa3d.org/drivers/venus.html

Based on my limited understanding of what has happened here, this patch=20
series was partially reverted due to an issue with the Bochs DRM driver.=20
A fix for that issue has been merged months ago according to the link=20
provided in an earlier message. Since then work on this detail of KVM=20
seems to have stalled.

Is it reasonable to ask here for this patch series to be evaluated and=20
incorporated again?

My layperson's attempt at applying the series against 6.14.1 source code=20
failed. In addition to the parts that appear to have already been=20
incorporated there are some parts of the patch series that are rejected.=20
I lack the knowledge to correct that.

Distro kernels currently ship without it which limits the usability of=20
Venus on AMD and NVIDIA GPUs paired with Intel CPUs. Convincing=20
individual distro maintainers of the necessity of this patch series=20
without the specialized knowledge required for understanding what it=20
does and performing that evaluation is quite hard. If upstream (kernel)=20
would apply it now the distros would ship a kernel including the=20
required changes to users, including me, without that multiplicated effort.

Thank you for your time. If this request is out of place here please=20
forgive me for engaging this mailing list without a proper understanding=20
of the list's scope.

On 2024-10-07 14:04:24, Linux regression tracking (Thorsten Leemhuis) wrote=
:
> On 07.10.24 15:38, Vitaly Kuznetsov wrote:
>> "Linux regression tracking (Thorsten Leemhuis)"
>> <regressions@leemhuis.info> writes:
>>
>>> On 30.08.24 11:35, Vitaly Kuznetsov wrote:
>>>> Sean Christopherson <seanjc@google.com> writes:
>>>>
>>>>> Unconditionally honor guest PAT on CPUs that support self-snoop, as
>>>>> Intel has confirmed that CPUs that support self-snoop always snoop ca=
ches
>>>>> and store buffers.  I.e. CPUs with self-snoop maintain cache coherenc=
y
>>>>> even in the presence of aliased memtypes, thus there is no need to tr=
ust
>>>>> the guest behaves and only honor PAT as a last resort, as KVM does to=
day.
>>>>>
>>>>> Honoring guest PAT is desirable for use cases where the guest has acc=
ess
>>>>> to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virt=
ual
>>>>> (mediated, for all intents and purposes) GPU is exposed to the guest,=
 along
>>>>> with buffers that are consumed directly by the physical GPU, i.e. whi=
ch
>>>>> can't be proxied by the host to ensure writes from the guest are perf=
ormed
>>>>> with the correct memory type for the GPU.
>>>>
>>>> Necroposting!
>>>>
>>>> Turns out that this change broke "bochs-display" driver in QEMU even
>>>> when the guest is modern (don't ask me 'who the hell uses bochs for
>>>> modern guests', it was basically a configuration error :-). E.g:
>>>> [...]
>>>
>>> This regression made it to the list of tracked regressions. It seems
>>> this thread stalled a while ago. Was this ever fixed? Does not look lik=
e
>>> it, but I might have missed something. Or is this a regression I should
>>> just ignore for one reason or another?
>>>
>>
>> The regression was addressed in by reverting 377b2f359d1f in 6.11
>>
>> commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
>> Author: Paolo Bonzini <pbonzini@redhat.com>
>> Date:   Sun Sep 15 02:49:33 2024 -0400
>>
>>      Revert "KVM: VMX: Always honor guest PAT on CPUs that support self-=
snoop"
>=20
> Thx. Sorry, missed that, thx for pointing me towards it. I had looked
> for things like that, but seems I messed up my lore query. Apologies for
> the noise!
>=20
>> Also, there's a (pending) DRM patch fixing it from the guest's side:
>> https://gitlab.freedesktop.org/drm/misc/kernel/-/commit/9388ccf699252232=
23c87355a417ba39b13a5e8e
>=20
> Great!
>=20
> Ciao, Thorsten
>=20
> P.S.:
>=20
> #regzbot fix: 9d70f3fec14421e793ffbc0ec2f739b24e534900
>=20
>=20
>=20



