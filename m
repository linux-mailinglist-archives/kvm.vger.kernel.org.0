Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2BBF0425
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 18:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbfKERd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 12:33:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387776AbfKERd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 12:33:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5HTPgJ163977;
        Tue, 5 Nov 2019 17:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=+jXKsk4LzmNdCLOc7WhrSH5LgFrZn7/lR2mmWUUlAzA=;
 b=k0v7ZW7kRHJg7U0KCLiryiPgc9dMpkxOH945C8w8m4NsvcU6+sFDx1s3hm0wmpdJaqXb
 iKBQyzWvxmpAfpaSAJTytK+jSF/rCBf46PRdFOgEtOjp9X/gybDqC9WfDke5hq7/p2jA
 wO/pNeNz5fRoLsvSb/FrF0Btvs5nGWPqcajnZvBFXb+xp12n3/KFyXnHh3bITlIk+czX
 jaoQvp77l1F4jamCf7QE/eADLbocL8mLwKMEIlnd+IIcMTuVmsHWhjq+/X7++FJggWpR
 Xtc6uBeZ0ih1Ed8mmX66MMrN8Uz9NJY+CUkMkJtI9vqg0D6oFQJP2FhYKy9OxEyJSUql 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117u07f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 17:32:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5HSNpf038236;
        Tue, 5 Nov 2019 17:30:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w35ppa140-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 17:30:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA5HUhHk029366;
        Tue, 5 Nov 2019 17:30:43 GMT
Received: from [192.168.14.112] (/79.180.234.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 09:30:43 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <83B55424-13A9-4395-98E8-466FFF4C698E@oracle.com>
Date:   Tue, 5 Nov 2019 19:30:38 +0200
Cc:     kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D00B364F-BB9D-40A2-9092-D79EBD0B4135@oracle.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <83B55424-13A9-4395-98E8-466FFF4C698E@oracle.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Nov 2019, at 19:17, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 5 Nov 2019, at 18:17, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>=20
>> Virtualized guests may pick a different strategy to mitigate hardware
>> vulnerabilities when it comes to hyper-threading: disable SMT =
completely,
>> use core scheduling, or, for example, opt in for STIBP. Making the
>> decision, however, requires an extra bit of information which is =
currently
>> missing: does the topology the guest see match hardware or if it is =
'fake'
>> and two vCPUs which look like different cores from guest's =
perspective can
>> actually be scheduled on the same physical core. Disabling SMT or =
doing
>> core scheduling only makes sense when the topology is trustworthy.
>=20
> This is not only related to vulnerability mitigations.
> It=E2=80=99s also important for guest to know if it=E2=80=99s SMT =
topology is trustworthy for various optimisation algorithms.
> E.g. Should it attempt to run tasks that share memory on same NUMA =
node?
>=20
>>=20
>> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the =
meaning
>> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the =
exposed SMT
>> topology is actually trustworthy. It would, of course, be possible to =
get
>> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose =
backwards
>> compatibility but the current approach looks more straightforward.
>=20
> Agree.
>=20
>>=20
>> There were some offline discussions on whether this new feature bit =
should
>> be complemented with a 're-enlightenment' mechanism for live =
migration (so
>> it can change in guest's lifetime) but it doesn't seem to be very
>> practical: what a sane guest is supposed to do if it's told that SMT
>> topology is about to become fake other than kill itself? Also, it =
seems to
>> make little sense to do e.g. CPU pinning on the source but not on the
>> destination.
>=20
> Agree.
>=20
>>=20
>> There is also one additional piece of the information missing. A VM =
can be
>> sharing physical cores with other VMs (or other userspace tasks on =
the
>> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the =
case or
>> not? It is unclear if this changes anything and can probably be left =
out
>> of scope (just don't do that).
>=20
> I don=E2=80=99t think KVM_FEATURE_TRUSTWORTHY_SMT should indicate to =
guest whether it=E2=80=99s vCPU shares a CPU core with another guest.
> It should only expose to guest the fact that he can rely on it=E2=80=99s=
 virtual SMT topology. i.e. That there is a relation between virtual SMT =
topology
> to which physical logical processors run which vCPUs.
>=20
> Guest have nothing to do with the fact that he is now aware host =
doesn=E2=80=99t guarantee to him that one of it=E2=80=99s vCPU shares a =
CPU core with another guest vCPU.
> I don=E2=80=99t think we should have a CPUID bit that expose this =
information to guest.
>=20
>>=20
>> Similar to the already existent 'NoNonArchitecturalCoreSharing' =
Hyper-V
>> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set =
to
>> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to =
guest's
>> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do =
some
>> extra work (like CPU pinning and exposing the correct topology) =
before
>> passing '1' to the guest.
>=20
> Hmm=E2=80=A6 I=E2=80=99m not sure this is correct.
> For example, it is possible to expose in virtual SMT topology that =
guest have 2 vCPUs running on single NUMA node,
> while in reality each vCPU task can be scheduled to run on different =
NUMA nodes. Therefore, making virtual SMT topology not trustworthy.
> i.e. Disabling SMT on host doesn=E2=80=99t mean that virtual SMT =
topology is reliable.
>=20
> I think this CPUID bit should just be set from userspace when admin =
have guaranteed to guest that it have set vCPU task affinity properly.
> Without KVM attempting to set this bit by itself.
>=20
> Note that we defined above KVM_HINTS_TRUSTWORTHY_SMT bit differently =
than =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D.
> =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D guarantees to guest =
that vCPUs of guest won=E2=80=99t share a physical CPU core unless they =
are defined as virtual SMT siblings.
> In contrast, KVM_HINTS_TRUSTWORTHY_SMT bit attempts to state that =
virtual SMT topology is a subset of how vCPUs are scheduled on physical =
SMT topology.
> i.e. It seems that Hyper-V bit is indeed only attempting to provide =
guest information related to security mitigations. While newly proposed =
KVM bit attempts to also
> assist guest to determine how to perform it=E2=80=99s internal =
scheduling decisions.
>=20
> -Liran

Oh I later saw below that you defined KVM_HINTS_TRUSTWORTHY_SMT indeed =
as Microsoft defined =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D.
If you plan to go with this direction, than I suggest renaming to =
similar name as Hyper-V.
But I think having a general vSMT topology is trustworthy is also =
useful.
Maybe we should have separate bits for each.

-Liran

>=20
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>> arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>> arch/x86/kvm/cpuid.c                 |  7 ++++++-
>> 3 files changed, 27 insertions(+), 9 deletions(-)
>>=20
>> diff --git a/Documentation/virt/kvm/cpuid.rst =
b/Documentation/virt/kvm/cpuid.rst
>> index 01b081f6e7ea..64b94103fc90 100644
>> --- a/Documentation/virt/kvm/cpuid.rst
>> +++ b/Documentation/virt/kvm/cpuid.rst
>> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          =
guest checks this feature bit
>>                                              before using =
paravirtualized
>>                                              sched yield.
>>=20
>> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports =
'SMT
>> +                                              topology is =
trustworthy' hint
>> +                                              =
(KVM_HINTS_TRUSTWORTHY_SMT).
>> +
>> KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no =
guest-side
>>                                              per-cpu warps are =
expeced in
>>                                              kvmclock
>> @@ -97,11 +101,18 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          =
host will warn if no guest-side
>>=20
>> Where ``flag`` here is defined as below:
>>=20
>> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> -flag               value        meaning
>> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> -KVM_HINTS_REALTIME 0            guest checks this feature bit to
>> -                                determine that vCPUs are never
>> -                                preempted for an unlimited time
>> -                                allowing optimizations
>> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>> +flag                              value       meaning
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>> +KVM_HINTS_REALTIME                0           guest checks this =
feature bit to
>> +                                              determine that vCPUs =
are never
>> +                                              preempted for an =
unlimited time
>> +                                              allowing optimizations
>> +
>> +KVM_HINTS_TRUSTWORTHY_SMT         1           the bit is set when =
the exposed
>> +                                              SMT topology is =
trustworthy, this
>> +                                              means that two guest =
vCPUs will
>> +                                              never share a physical =
core
>> +                                              unless they are =
exposed as SMT
>> +                                              threads.
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h =
b/arch/x86/include/uapi/asm/kvm_para.h
>> index 2a8e0b6b9805..183239d5dfad 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -31,8 +31,10 @@
>> #define KVM_FEATURE_PV_SEND_IPI	11
>> #define KVM_FEATURE_POLL_CONTROL	12
>> #define KVM_FEATURE_PV_SCHED_YIELD	13
>> +#define KVM_FEATURE_TRUSTWORTHY_SMT	14
>>=20
>> #define KVM_HINTS_REALTIME      0
>> +#define KVM_HINTS_TRUSTWORTHY_SMT	1
>>=20
>> /* The last 8 bits are used to indicate how to interpret the flags =
field
>> * in pvclock structure. If no bits are set, all flags are ignored.
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index f68c0c753c38..dab527a7081f 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct =
kvm_cpuid_entry2 *entry, u32 function,
>> 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
>> 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>> 			     (1 << KVM_FEATURE_POLL_CONTROL) |
>> -			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
>> +			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
>> +			     (1 << KVM_FEATURE_TRUSTWORTHY_SMT);
>>=20
>> 		if (sched_info_on())
>> 			entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
>> @@ -720,6 +721,10 @@ static inline int __do_cpuid_func(struct =
kvm_cpuid_entry2 *entry, u32 function,
>> 		entry->ebx =3D 0;
>> 		entry->ecx =3D 0;
>> 		entry->edx =3D 0;
>> +
>> +		if (!cpu_smt_possible())
>> +			entry->edx |=3D (1 << =
KVM_HINTS_TRUSTWORTHY_SMT);
>> +
>> 		break;
>> 	case 0x80000000:
>> 		entry->eax =3D min(entry->eax, 0x8000001f);
>> --=20
>> 2.20.1
>>=20
>=20

