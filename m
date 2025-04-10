Return-Path: <kvm+bounces-43081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DFFA8402C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 12:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B34961B823DF
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6243626B955;
	Thu, 10 Apr 2025 10:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=proton.me header.i=@proton.me header.b="jz0UmgOx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-10696.protonmail.ch (mail-10696.protonmail.ch [79.135.106.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F1726B2C5
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 10:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744279555; cv=none; b=dKZJh7a8o+7hVSDyqeGWQzhtgmJhXIYL/wSp9nASFwSTzcrloQUAUPJnvdRZxgfRJ5lnv5nk1hMt2Ic2j6HCyad7FREyVuXyWl3rG02vP5tjEF9CtsYgA8Z4ZvpAEgD2ymEMo3evx6qu/m3MOp9CSuI8SZYRJ13X8jNrG4rq6H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744279555; c=relaxed/simple;
	bh=J3fb56fK1B3gbUj2pzfyp50//yjK+KnrcziWvaCJB6c=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TELy9S0Y8k8+OPKKO+PfZ/De9ofq2PED4qiZmJxolqw2d/gv3wpgxItAQW8+3+l/+w7vshVlOsURoK2V1iR+Xksa3tGQ2l82yS+ciQtROJfq1MmmN6TfNvI4BjVWNmc1pUjmvRlxnboS8PuHUd/mxdOrPK5tPI2VIlF2YFTxQGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=jz0UmgOx; arc=none smtp.client-ip=79.135.106.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=7giegmf7kjdlhnpqpulaenm6im.protonmail; t=1744279543; x=1744538743;
	bh=LWZWX8CmYnjGqKew7oQ/owkId4RwazrHJ+HYjtd+24g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=jz0UmgOxaJbA5Yf6bup/ILmwTZy1MJvqUwNYc/q87S6gb1e73rI3uVJnHfkZDxNJE
	 7/TvtgZYT1RsOo2mmBWa0pb35zWJeVrjlDIizgsev1twmcIXumrVP82N74M0NaCtyW
	 DEG1iBqrkGUsc80lPrP+TVD2jJk361SC2l3F8rMJIGyWPEvi4cDdeNQr2s8cX8AWzZ
	 B+c75ocKFc6cHM7gl6qaDH0leM59hNSyR7BWTdO3dHmACdyO04VrKsZ8RjxIINxi8m
	 OBcMT0ondHWbFVm2uFo6JWETuAsVGDhlGNK1UOgH8u24unoyAU9XaWEVm2epucf1Ho
	 Wp1mHCu8nS0dA==
Date: Thu, 10 Apr 2025 10:05:38 +0000
To: Yan Zhao <yan.y.zhao@intel.com>
From: Myrsky Lintu <myrskylintu@proton.me>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>, Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
Message-ID: <e9f762bc-d158-4b5b-86f0-8ca0de024200@proton.me>
In-Reply-To: <Z/dTIRE3NCsSM2fH@yzhao56-desk.sh.intel.com>
References: <0f37f8e5-3cfe-4efb-bec9-b0882d85ead2@proton.me> <Z/dTIRE3NCsSM2fH@yzhao56-desk.sh.intel.com>
Feedback-ID: 89599038:user:proton
X-Pm-Message-ID: bc02de826c83081390a5cd0b61733ce60d7d43fb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thank you. I will try to bring this up with QEMU developers then.

On 2025-04-10 05:12:01, Yan Zhao wrote:
> Hi,
>=20
> AFAIK, the commit c9c1e20b4c7d ("KVM: x86: Introduce Intel specific quirk
> KVM_X86_QUIRK_IGNORE_GUEST_PAT") which re-allows honoring guest PAT on In=
tel's
> platforms has been in kvm/queue now.
>=20
> However, as the quirk is enabled by default, userspace(like QEMU) needs t=
o turn
> it off by code like "kvm_vm_enable_cap(kvm_state, KVM_CAP_DISABLE_QUIRKS2=
, 0,
> KVM_X86_QUIRK_IGNORE_GUEST_PAT)" to honor guest PAT, according to the doc=
:
>=20
> KVM_X86_QUIRK_IGNORE_GUEST_PAT   ...
>                                   Userspace can disable the quirk to hono=
r
>                                   guest PAT if it knows that there is no =
such
>                                   guest software, for example if it does =
not
>                                   expose a bochs graphics device (which i=
s
>                                   known to have had a buggy driver).
>=20
> Thanks
> Yan
>=20
> On Thu, Apr 10, 2025 at 01:13:18AM +0000, Myrsky Lintu wrote:
>> Hello,
>>
>> I am completely new to and uninformed about kernel development. I was
>> pointed here from Mesa documentation for Venus (Vulkan encapsulation for
>> KVM/QEMU): https://docs.mesa3d.org/drivers/venus.html
>>
>> Based on my limited understanding of what has happened here, this patch
>> series was partially reverted due to an issue with the Bochs DRM driver.
>> A fix for that issue has been merged months ago according to the link
>> provided in an earlier message. Since then work on this detail of KVM
>> seems to have stalled.
>>
>> Is it reasonable to ask here for this patch series to be evaluated and
>> incorporated again?
>>
>> My layperson's attempt at applying the series against 6.14.1 source code
>> failed. In addition to the parts that appear to have already been
>> incorporated there are some parts of the patch series that are rejected.
>> I lack the knowledge to correct that.
>>
>> Distro kernels currently ship without it which limits the usability of
>> Venus on AMD and NVIDIA GPUs paired with Intel CPUs. Convincing
>> individual distro maintainers of the necessity of this patch series
>> without the specialized knowledge required for understanding what it
>> does and performing that evaluation is quite hard. If upstream (kernel)
>> would apply it now the distros would ship a kernel including the
>> required changes to users, including me, without that multiplicated effo=
rt.
>>
>> Thank you for your time. If this request is out of place here please
>> forgive me for engaging this mailing list without a proper understanding
>> of the list's scope.
>>
>> On 2024-10-07 14:04:24, Linux regression tracking (Thorsten Leemhuis) wr=
ote:
>>> On 07.10.24 15:38, Vitaly Kuznetsov wrote:
>>>> "Linux regression tracking (Thorsten Leemhuis)"
>>>> <regressions@leemhuis.info> writes:
>>>>
>>>>> On 30.08.24 11:35, Vitaly Kuznetsov wrote:
>>>>>> Sean Christopherson <seanjc@google.com> writes:
>>>>>>
>>>>>>> Unconditionally honor guest PAT on CPUs that support self-snoop, as
>>>>>>> Intel has confirmed that CPUs that support self-snoop always snoop =
caches
>>>>>>> and store buffers.  I.e. CPUs with self-snoop maintain cache cohere=
ncy
>>>>>>> even in the presence of aliased memtypes, thus there is no need to =
trust
>>>>>>> the guest behaves and only honor PAT as a last resort, as KVM does =
today.
>>>>>>>
>>>>>>> Honoring guest PAT is desirable for use cases where the guest has a=
ccess
>>>>>>> to non-coherent DMA _without_ bouncing through VFIO, e.g. when a vi=
rtual
>>>>>>> (mediated, for all intents and purposes) GPU is exposed to the gues=
t, along
>>>>>>> with buffers that are consumed directly by the physical GPU, i.e. w=
hich
>>>>>>> can't be proxied by the host to ensure writes from the guest are pe=
rformed
>>>>>>> with the correct memory type for the GPU.
>>>>>>
>>>>>> Necroposting!
>>>>>>
>>>>>> Turns out that this change broke "bochs-display" driver in QEMU even
>>>>>> when the guest is modern (don't ask me 'who the hell uses bochs for
>>>>>> modern guests', it was basically a configuration error :-). E.g:
>>>>>> [...]
>>>>>
>>>>> This regression made it to the list of tracked regressions. It seems
>>>>> this thread stalled a while ago. Was this ever fixed? Does not look l=
ike
>>>>> it, but I might have missed something. Or is this a regression I shou=
ld
>>>>> just ignore for one reason or another?
>>>>>
>>>>
>>>> The regression was addressed in by reverting 377b2f359d1f in 6.11
>>>>
>>>> commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
>>>> Author: Paolo Bonzini <pbonzini@redhat.com>
>>>> Date:   Sun Sep 15 02:49:33 2024 -0400
>>>>
>>>>       Revert "KVM: VMX: Always honor guest PAT on CPUs that support se=
lf-snoop"
>>>
>>> Thx. Sorry, missed that, thx for pointing me towards it. I had looked
>>> for things like that, but seems I messed up my lore query. Apologies fo=
r
>>> the noise!
>>>
>>>> Also, there's a (pending) DRM patch fixing it from the guest's side:
>>>> https://gitlab.freedesktop.org/drm/misc/kernel/-/commit/9388ccf6992522=
3223c87355a417ba39b13a5e8e
>>>
>>> Great!
>>>
>>> Ciao, Thorsten
>>>
>>> P.S.:
>>>
>>> #regzbot fix: 9d70f3fec14421e793ffbc0ec2f739b24e534900
>>>
>>>
>>>
>>
>>



