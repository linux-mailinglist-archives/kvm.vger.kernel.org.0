Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72336F31E9
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 16:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfKGPDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 10:03:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGPDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 10:03:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7EiQQf050951;
        Thu, 7 Nov 2019 15:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=WIrFjT89+Gu5N4D3hmBKexKVwTCS1SDwd3tM6/hO4o4=;
 b=Y5YC+/pSrp7sYP+/eudVtCqXnEXyWhvFJX5hW5Z5b9kAbLphFmM3cAxSIIcLJIqmUp6s
 Ee/R5jK2gZCgBz3FILobpIxrkRN4cTUz2en9wOT74i5ZBzCAdmEVJCzf79pf20dOmCLu
 7jhRoQ/Psrc/Yf2D4n20RKyrxx2/EFVj3COe+3//SihJwC5f67ZdifrPEaIzMdur5YC0
 RResaZS9Edmvzy2r6tWCwIvYyipTk8z1/y66uZ2Q+viVO7Ngjtv8iuPFZHxmcUXSXp3H
 y/sM2sSELo2G5q1F6i8gJiRgWkBv4IUAtbB6R3YrvNfMdF+49eDFdG30FDHuvvpm/iQ/ AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w16s7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 15:02:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Eia3k131529;
        Thu, 7 Nov 2019 15:02:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k2vee2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 15:02:36 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA7F2WhJ024079;
        Thu, 7 Nov 2019 15:02:34 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 07:02:32 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <943488A8-2DD7-4471-B3C7-9F21A0B0BCF9@dinechin.org>
Date:   Thu, 7 Nov 2019 17:02:26 +0200
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <713ECF67-6A6C-4956-8AC6-7F4C05961328@oracle.com>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105193749.GA20225@linux.intel.com>
 <20191105232500.GA25887@linux.intel.com>
 <943488A8-2DD7-4471-B3C7-9F21A0B0BCF9@dinechin.org>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 7 Nov 2019, at 16:00, Christophe de Dinechin =
<christophe.de.dinechin@gmail.com> wrote:
>=20
>=20
>=20
>> On 6 Nov 2019, at 00:25, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>=20
>> On Tue, Nov 05, 2019 at 11:37:50AM -0800, Sean Christopherson wrote:
>>> On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
>>>> Virtualized guests may pick a different strategy to mitigate =
hardware
>>>> vulnerabilities when it comes to hyper-threading: disable SMT =
completely,
>>>> use core scheduling, or, for example, opt in for STIBP. Making the
>>>> decision, however, requires an extra bit of information which is =
currently
>>>> missing: does the topology the guest see match hardware or if it is =
'fake'
>>>> and two vCPUs which look like different cores from guest's =
perspective can
>>>> actually be scheduled on the same physical core. Disabling SMT or =
doing
>>>> core scheduling only makes sense when the topology is trustworthy.
>>>>=20
>>>> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the =
meaning
>>>> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the =
exposed SMT
>>>> topology is actually trustworthy. It would, of course, be possible =
to get
>>>> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose =
backwards
>>>> compatibility but the current approach looks more straightforward.
>>>=20
>>> I'd stay away from "trustworthy", especially if this is controlled =
by
>>> userspace.  Whether or not the hint is trustworthy is purely up to =
the
>>> guest.  Right now it doesn't really matter, but that will change as =
we
>>> start moving pieces of the host out of the guest's TCB.
>>>=20
>>> It may make sense to split the two (or even three?) cases, e.g.
>>> KVM_FEATURE_NO_SMT and KVM_FEATURE_ACCURATE_TOPOLOGY.  KVM can =
easily
>>> enforce NO_SMT _today_, i.e. allow it to be set if and only if SMT =
is
>>> truly disabled.  Verifying that the topology exposed to the guest is =
legit
>>> is a completely different beast.
>>=20
>> Scratch the ACCURATE_TOPOLOGY idea, I doubt there's a real use case =
for
>> setting ACCURATE_TOPOLOGY and not KVM_HINTS_REALTIME.  A feature flag =
to
>> state that SMT is disabled seems simple and useful.

A bit such as NoNonArchitecturalCoreSharing can be set even when host =
SMT is enabled.
For example, when host use core-scheduling to group together vCPUs that =
run as sibling hyperthreads.
Therefore, I wouldn=E2=80=99t want to tie the feature-flag semantics to =
host SMT being enabled/disabled.
It=E2=80=99s just true that this bit can be set when host SMT is =
disabled.

>=20
> I share that concern about the naming, although I do see some
> value in exposing the cpu_smt_possible() result. I think it=E2=80=99s =
easier
> to state that something does not work than to state something does
> work.
>=20
> Also, with respect to mitigation, we may want to split the two cases
> that Paolo outlined, i.e. have KVM_HINTS_REALTIME,
> KVM_HINTS_CORES_CROSSTALK and
> KVM_HINTS_CORES_LEAKING,
> where CORES_CROSSTALKS indicates there may be some
> cross-talk between what the guest thinks are isolated cores,
> and CORES_LEAKING indicates that cores may leak data
> to some other guest.
>=20
> The problem with my approach is that it is shouting =E2=80=9Cdon=E2=80=99=
t trust me=E2=80=9D
> a bit too loudly.

I don=E2=80=99t see a value in exposing CORES_LEAKING to guest. As guest =
have nothing to do with it.

-Liran









