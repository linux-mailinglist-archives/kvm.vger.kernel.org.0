Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF51B9044
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 14:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgDZM7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 08:59:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgDZM7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 08:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587905982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cS6N3dz+H92wTTUjeik0cWhJVJMk8JtsySToZ32DZB8=;
        b=RF8qgCTjFnRq0jgSbHTSJ4ZBmanEBB17jJ6VsgCSqZBXmPH/lb9XEl4+Si8sOAwGLvsZ7c
        KkYAgVRMuQzIC/VQaoDwr34k1l83W7G3jUHNTUUUKUl3rrrcdH26FgHo+GeeuG30/wc/uj
        PwRYz8RUx5JMc/YfhoPBGoIewJXKqrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-L1Gr5bIyNaSAU5A4TdMIqA-1; Sun, 26 Apr 2020 08:59:40 -0400
X-MC-Unique: L1Gr5bIyNaSAU5A4TdMIqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CAF545F;
        Sun, 26 Apr 2020 12:59:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-33.ams2.redhat.com [10.36.112.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26AC460C05;
        Sun, 26 Apr 2020 12:59:19 +0000 (UTC)
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        frankja@linux.ibm.com, david@redhat.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, maz@kernel.org,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
 <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
 <20200422180403.03f60b0c.cohuck@redhat.com>
 <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
 <20200423123901.72a4c6a4.cohuck@redhat.com>
 <71344f73-c34f-a373-49d1-5d839c6be5f6@linux.alibaba.com>
 <1d73b700-4a20-3d7a-66d1-29b5afa03f4d@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <73f6ecd0-ac47-eaad-0e4f-2d41c2b34450@redhat.com>
Date:   Sun, 26 Apr 2020 14:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1d73b700-4a20-3d7a-66d1-29b5afa03f4d@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/2020 13.00, Christian Borntraeger wrote:
>=20
>=20
> On 23.04.20 12:58, Tianjia Zhang wrote:
>>
>>
>> On 2020/4/23 18:39, Cornelia Huck wrote:
>>> On Thu, 23 Apr 2020 11:01:43 +0800
>>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
>>>
>>>> On 2020/4/23 0:04, Cornelia Huck wrote:
>>>>> On Wed, 22 Apr 2020 17:58:04 +0200
>>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>>> =C2=A0=C2=A0
>>>>>> On 22.04.20 15:45, Cornelia Huck wrote:
>>>>>>> On Wed, 22 Apr 2020 20:58:04 +0800
>>>>>>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>>>>>>>> In the current kvm version, 'kvm_run' has been included in the '=
kvm_vcpu'
>>>>>>>> structure. Earlier than historical reasons, many kvm-related fun=
ction
>>>>>>>
>>>>>>> s/Earlier than/For/ ?
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
>>>>>>>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the=
 same time.
>>>>>>>> This patch does a unified cleanup of these remaining redundant p=
arameters.
>>>>>>>>
>>>>>>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>> =C2=A0=C2=A0 arch/s390/kvm/kvm-s390.c | 37 +++++++++++++++++++++=
+---------------
>>>>>>>> =C2=A0=C2=A0 1 file changed, 22 insertions(+), 15 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>>>> index e335a7e5ead7..d7bb2e7a07ff 100644
>>>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>>>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcp=
u)
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rc;
>>>>>>>> =C2=A0=C2=A0 }
>>>>>>>> =C2=A0=C2=A0 -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, =
struct kvm_run *kvm_run)
>>>>>>>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>>>>>>> =C2=A0=C2=A0 {
>>>>>>>> +=C2=A0=C2=A0=C2=A0 struct kvm_run *kvm_run =3D vcpu->run;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct runtime_instr_cb *ri=
ccb;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct gs_cb *gscb;
>>>>>>>> =C2=A0=C2=A0 @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(st=
ruct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(vcpu->arch.gs_enabled) {
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 current->thread.gs_cb =3D (struct gs_cb *)
>>>>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &vcpu->run->s.regs.gscb;
>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &kvm_run->s.regs.gscb;
>>>>>>>
>>>>>>> Not sure if these changes (vcpu->run-> =3D> kvm_run->) are really=
 worth
>>>>>>> it. (It seems they amount to at least as much as the changes adve=
rtised
>>>>>>> in the patch description.)
>>>>>>>
>>>>>>> Other opinions?
>>>>>>
>>>>>> Agreed. It feels kind of random. Maybe just do the first line (mov=
e kvm_run from the
>>>>>> function parameter list into the variable declaration)? Not sure i=
f this is better.
>>>>>> =C2=A0=20
>>>>>
>>>>> There's more in this patch that I cut... but I think just moving
>>>>> kvm_run from the parameter list would be much less disruptive.
>>>>> =C2=A0=C2=A0=20
>>>>
>>>> I think there are two kinds of code(`vcpu->run->` and `kvm_run->`), =
but
>>>> there will be more disruptive, not less.
>>>
>>> I just fail to see the benefit; sure, kvm_run-> is convenient, but th=
e
>>> current code is just fine, and any rework should be balanced against
>>> the cost (e.g. cluttering git annotate).
>>>
>>
>> cluttering git annotate ? Does it mean Fix xxxx ("comment"). Is it pos=
sible to solve this problem by splitting this patch?
>=20
> No its about breaking git blame (and bugfix backports) for just a cosme=
tic improvement.

It could be slightly more than a cosmetic improvement (depending on the
smartness of the compiler): vcpu->run-> are two dereferences, while
kvm_run-> is only one dereference. So it could be slightly more compact
and faster code.

 Thomas

