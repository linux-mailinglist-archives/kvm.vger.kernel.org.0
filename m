Return-Path: <kvm+bounces-10022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8951B868893
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 06:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9E6A1C210F9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 05:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9F752F8B;
	Tue, 27 Feb 2024 05:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="rsmjLhHN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EBJ7ruCR"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh1-smtp.messagingengine.com (fhigh1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E2852F77;
	Tue, 27 Feb 2024 05:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709011448; cv=none; b=QJSqdeYOO+dhQEIrM8OPrR6ss7uX+EWLMl6WIclqii0UQHMusiDVmrfhvHt+c/2+ekpPDy4FoRv1AVE5Zq4z3gwerOwSFmJ+hgG94XIfk+UVTYnMduKpif4dwiBlqnK1IKNtZoYX6AgFFZzXQhkq23xnqzhGZLBkYfpWZdzUxwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709011448; c=relaxed/simple;
	bh=u4qQkPHQmIhMRJxmqmu5QD2BAGK772thENCJm+b3kno=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=N1eDzbdAm4je9dORGXzCwVKR7hGB6z9MLJHVN4GCYgKYwVBsH8P4UZoyrmmD+8CC0AsNCNFO8B2D0cbAI41Xga9UT5X7/frrMqZnQKr4Trk2fZaX8d/HDRfLgeYw8Irb/NjfFvu2/mUayR8aLbZ6R0+YzvZVs0JGON7om1nBVHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=rsmjLhHN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EBJ7ruCR; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 59B9211400D7;
	Tue, 27 Feb 2024 00:24:05 -0500 (EST)
Received: from imap44 ([10.202.2.94])
  by compute3.internal (MEProxy); Tue, 27 Feb 2024 00:24:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1709011445;
	 x=1709097845; bh=ZAscQhN7898Hcp6Y20dtK5VfrswD/2iy7Gi5PEhuA+A=; b=
	rsmjLhHNkmdfGEdtxrBZPJR4K5rkmKvR9NJlyUn/ZyMtMC32KiSIhiS0bgByYvgV
	N8iEIuks+EE8tpB417AJ6FREuJwZHQoCxB3HlhvhznZPB5SBn34WVK6EWrNkbqf3
	ONbWx8xAAwyR3yW+MQzPyNN33lGFq46yIAwaXWhj5ZLIP7qdPmQtDHWcBFWe602/
	Tajgdc1ktdicGYaz50pBzoS86QrQcaT2ajQGNdNlRuxqcIWbo6tzJ/9nekkc+JxQ
	ApivTWzMKZ5+BfOflZvWo99hI36RrF/XHohJYnV/+wTYyVNnVRn8HMSrYpQ2YTq4
	/eQbfNycHH2Jh2A0mtpiYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1709011445; x=
	1709097845; bh=ZAscQhN7898Hcp6Y20dtK5VfrswD/2iy7Gi5PEhuA+A=; b=E
	BJ7ruCRk8Ym0vAj538sBHBp3z9aAesQvacvuY4Cuq9r3touHEaGhFBX8Fu2n23r7
	gZw1iOwTVmUGsBDabm7rewd1pA7KDldfNFbg5ZsmSUw0tI1Xo+CPFglNmQXZCiqL
	B0qxUjteUjAA27yzyN/3lx/tadjFSmvnMK9mlTQoVLL/FuKwq38IuRaOo8z2xzvi
	z7YBkmsWX8iDDzfqeMvGZ+FUlqclXAUAlmABW48dD50c7WdgwyQGZVAOK7cIGOf+
	ey/BA+NR8WXX/UyklAuTiv5q3Yw/JLbNrdGoUBya6E+KJ9bc1mjDqre90DwUVNyv
	ixHnHm7jgBbhHS/FtviOw==
X-ME-Sender: <xms:9HHdZbihNyeo0I0rnOBp7YMeER8bqOir_kMyyjjIlbU2eDzz9XdQew>
    <xme:9HHdZYBHkZtQc7B89zTyRTG2OkdxwV8t5IC9-CcqLZ_L1YJQ_zwY9oUhoZ2T6jE5x
    LygKr0SfFnR9qgEuhU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgeefgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepudefgeeftedugeehffdtheefgfevffelfefghefhjeeu
    geevtefhudduvdeihefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:9HHdZbHJeKQodrWd7R7L8SwjUbwjoVtiMq7oIe7y9DUC7vsp2N9GGA>
    <xmx:9HHdZYRSsj6fvdROoUtgYpJ_7u7FsWR-BIyANC5gebdKqYArlAgdGw>
    <xmx:9HHdZYx-A64J2UeUR7MsFM22D1dwo9p2v4ceI3vcFx6Mgw7ECtvDWA>
    <xmx:9XHdZXmAIbDK470CkMwBHI-r2bZG6a5m7Tz53umSchh31rE5X8gAiw>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id C8F0736A0076; Tue, 27 Feb 2024 00:24:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-153-g7e3bb84806-fm-20240215.007-g7e3bb848
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <09c5af9b-cc79-4cf2-84f7-276bb188754a@app.fastmail.com>
In-Reply-To: <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
Date: Tue, 27 Feb 2024 05:23:31 +0000
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Bibo Mao" <maobibo@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Tianrui Zhao" <zhaotianrui@loongson.cn>,
 "Juergen Gross" <jgross@suse.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B42=E6=9C=8827=E6=97=A5=E4=BA=8C=E6=9C=88 =E4=B8=8A=E5=
=8D=883:14=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
> On 2024/2/27 =E4=B8=8A=E5=8D=884:02, Jiaxun Yang wrote:
>>=20
>>=20
>> =E5=9C=A82024=E5=B9=B42=E6=9C=8826=E6=97=A5=E4=BA=8C=E6=9C=88 =E4=B8=8A=
=E5=8D=888:04=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
>>> On 2024/2/26 =E4=B8=8B=E5=8D=882:12, Huacai Chen wrote:
>>>> On Mon, Feb 26, 2024 at 10:04=E2=80=AFAM maobibo <maobibo@loongson.=
cn> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 2024/2/24 =E4=B8=8B=E5=8D=885:13, Huacai Chen wrote:
>>>>>> Hi, Bibo,
>>>>>>
>>>>>> On Thu, Feb 22, 2024 at 11:28=E2=80=AFAM Bibo Mao <maobibo@loongs=
on.cn> wrote:
>>>>>>>
>>>>>>> Instruction cpucfg can be used to get processor features. And th=
ere
>>>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - =
20
>>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is us=
ed
>>>>>>> for KVM hypervisor to privide PV features, and the area can be e=
xtended
>>>>>>> for other hypervisors in future. This area will never be used for
>>>>>>> real HW, it is only used by software.
>>>>>> After reading and thinking, I find that the hypercall method whic=
h is
>>>>>> used in our productive kernel is better than this cpucfg method.
>>>>>> Because hypercall is more simple and straightforward, plus we don=
't
>>>>>> worry about conflicting with the real hardware.
>>>>> No, I do not think so. cpucfg is simper than hypercall, hypercall =
can
>>>>> be in effect when system runs in guest mode. In some scenario like=
 TCG
>>>>> mode, hypercall is illegal intruction, however cpucfg can work.
>>>> Nearly all architectures use hypercall except x86 for its historical
>>> Only x86 support multiple hypervisors and there is multiple hypervis=
or
>>> in x86 only. It is an advantage, not historical reason.
>>=20
>> I do believe that all those stuff should not be exposed to guest user=
 space
>> for security reasons.
> Can you add PLV checking when cpucfg 0x40000000-0x400000FF is emulated=
?=20
> if it is user mode return value is zero and it is kernel mode emulated=20
> value will be returned. It can avoid information leaking.

Please don=E2=80=99t do insane stuff here, applications are not expectin=
g exception from
cpucfg.

>
>>=20
>> Also for different implementations of hypervisors they may have diffe=
rent
>> PV features behavior, using hypcall to perform feature detection
>> can pass more information to help us cope with hypervisor diversity.
> How do different hypervisors can be detected firstly?  On x86 MSR is=20
> used for all hypervisors detection and on ARM64 hyperv used=20
> acpi_gbl_FADT and kvm use smc forcely, host mode can execute smc=20
> instruction without exception on ARM64.

That=E2=80=99s hypcall ABI design choices, those information can come fr=
om firmware
or privileged CSRs on LoongArch.

>
> I do not know why hypercall is better than cpucfg on LoongArch, cpucfg=20
> is basic intruction however hypercall is not, it is part of LVZ featur=
e.

KVM can only work with LVZ right?

>
>>>
>>>> reasons. If we use CPUCFG, then the hypervisor information is
>>>> unnecessarily leaked to userspace, and this may be a security issue.
>>>> Meanwhile, I don't think TCG mode needs PV features.
>>> Besides PV features, there is other features different with real hw =
such
>>> as virtio device, virtual interrupt controller.
>>=20
>> Those are *device* level information, they must be passed in firmware
>> interfaces to keep processor emulation sane.
> File arch/x86/hyperv/hv_apic.c can be referenced, apic features comes=20
> from ms_hyperv.hints and HYPERV_CPUID_ENLIGHTMENT_INFO cpuid info, not=20
> must be passed by firmware interface.

That=E2=80=99s not KVM, that=E2=80=99s Hyper V. At Linux Kernel we enjoy=
 the benefits of better
modularity on device abstractions, please don=E2=80=99t break it.

Thanks

>
> Regards
> Bibo Mao
>>=20
>> Thanks
>>=20
>>>
>>> Regards
>>> Bibo Mao
>>>
>>>>
>>>> I consulted with Jiaxun before, and maybe he can give some more com=
ments.
>>>>
>>>>>
>>>>> Extioi virtualization extension will be added later, cpucfg can be=
 used
>>>>> to get extioi features. It is unlikely that extioi driver depends =
on
>>>>> PARA_VIRT macro if hypercall is used to get features.
>>>> CPUCFG is per-core information, if we really need something about
>>>> extioi, it should be in iocsr (LOONGARCH_IOCSR_FEATURES).
>>>>
>>>>
>>>> Huacai
>>>>
>>>>>
>>>>> Regards
>>>>> Bibo Mao
>>>>>
>>>>>>
>>>>>> Huacai
>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>> ---
>>>>>>>     arch/loongarch/include/asm/inst.h      |  1 +
>>>>>>>     arch/loongarch/include/asm/loongarch.h | 10 ++++++
>>>>>>>     arch/loongarch/kvm/exit.c              | 46 ++++++++++++++++=
+---------
>>>>>>>     3 files changed, 41 insertions(+), 16 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/=
include/asm/inst.h
>>>>>>> index d8f637f9e400..ad120f924905 100644
>>>>>>> --- a/arch/loongarch/include/asm/inst.h
>>>>>>> +++ b/arch/loongarch/include/asm/inst.h
>>>>>>> @@ -67,6 +67,7 @@ enum reg2_op {
>>>>>>>            revhd_op        =3D 0x11,
>>>>>>>            extwh_op        =3D 0x16,
>>>>>>>            extwb_op        =3D 0x17,
>>>>>>> +       cpucfg_op       =3D 0x1b,
>>>>>>>            iocsrrdb_op     =3D 0x19200,
>>>>>>>            iocsrrdh_op     =3D 0x19201,
>>>>>>>            iocsrrdw_op     =3D 0x19202,
>>>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loong=
arch/include/asm/loongarch.h
>>>>>>> index 46366e783c84..a1d22e8b6f94 100644
>>>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>>>> @@ -158,6 +158,16 @@
>>>>>>>     #define  CPUCFG48_VFPU_CG              BIT(2)
>>>>>>>     #define  CPUCFG48_RAM_CG               BIT(3)
>>>>>>>
>>>>>>> +/*
>>>>>>> + * cpucfg index area: 0x40000000 -- 0x400000ff
>>>>>>> + * SW emulation for KVM hypervirsor
>>>>>>> + */
>>>>>>> +#define CPUCFG_KVM_BASE                        0x40000000UL
>>>>>>> +#define CPUCFG_KVM_SIZE                        0x100
>>>>>>> +#define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
>>>>>>> +#define  KVM_SIGNATURE                 "KVM\0"
>>>>>>> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>>>>>> +
>>>>>>>     #ifndef __ASSEMBLY__
>>>>>>>
>>>>>>>     /* CSR */
>>>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit=
.c
>>>>>>> index 923bbca9bd22..6a38fd59d86d 100644
>>>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>>>> @@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>>>>>>>            return EMULATE_DONE;
>>>>>>>     }
>>>>>>>
>>>>>>> -static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>> +static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst ins=
t)
>>>>>>>     {
>>>>>>>            int rd, rj;
>>>>>>>            unsigned int index;
>>>>>>> +
>>>>>>> +       rd =3D inst.reg2_format.rd;
>>>>>>> +       rj =3D inst.reg2_format.rj;
>>>>>>> +       ++vcpu->stat.cpucfg_exits;
>>>>>>> +       index =3D vcpu->arch.gprs[rj];
>>>>>>> +
>>>>>>> +       /*
>>>>>>> +        * By LoongArch Reference Manual 2.2.10.5
>>>>>>> +        * Return value is 0 for undefined cpucfg index
>>>>>>> +        */
>>>>>>> +       switch (index) {
>>>>>>> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
>>>>>>> +               vcpu->arch.gprs[rd] =3D vcpu->arch.cpucfg[index];
>>>>>>> +               break;
>>>>>>> +       case CPUCFG_KVM_SIG:
>>>>>>> +               vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIG=
NATURE;
>>>>>>> +               break;
>>>>>>> +       default:
>>>>>>> +               vcpu->arch.gprs[rd] =3D 0;
>>>>>>> +               break;
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       return EMULATE_DONE;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>>            unsigned long curr_pc;
>>>>>>>            larch_inst inst;
>>>>>>>            enum emulation_result er =3D EMULATE_DONE;
>>>>>>> @@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_=
vcpu *vcpu)
>>>>>>>            er =3D EMULATE_FAIL;
>>>>>>>            switch (((inst.word >> 24) & 0xff)) {
>>>>>>>            case 0x0: /* CPUCFG GSPR */
>>>>>>> -               if (inst.reg2_format.opcode =3D=3D 0x1B) {
>>>>>>> -                       rd =3D inst.reg2_format.rd;
>>>>>>> -                       rj =3D inst.reg2_format.rj;
>>>>>>> -                       ++vcpu->stat.cpucfg_exits;
>>>>>>> -                       index =3D vcpu->arch.gprs[rj];
>>>>>>> -                       er =3D EMULATE_DONE;
>>>>>>> -                       /*
>>>>>>> -                        * By LoongArch Reference Manual 2.2.10.5
>>>>>>> -                        * return value is 0 for undefined cpucf=
g index
>>>>>>> -                        */
>>>>>>> -                       if (index < KVM_MAX_CPUCFG_REGS)
>>>>>>> -                               vcpu->arch.gprs[rd] =3D vcpu->ar=
ch.cpucfg[index];
>>>>>>> -                       else
>>>>>>> -                               vcpu->arch.gprs[rd] =3D 0;
>>>>>>> -               }
>>>>>>> +               if (inst.reg2_format.opcode =3D=3D cpucfg_op)
>>>>>>> +                       er =3D kvm_emu_cpucfg(vcpu, inst);
>>>>>>>                    break;
>>>>>>>            case 0x4: /* CSR{RD,WR,XCHG} GSPR */
>>>>>>>                    er =3D kvm_handle_csr(vcpu, inst);
>>>>>>> --
>>>>>>> 2.39.3
>>>>>>>
>>>>>
>>>>>
>>

--=20
- Jiaxun

