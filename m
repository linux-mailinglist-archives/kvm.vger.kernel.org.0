Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B275F107C4F
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 02:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfKWBtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 20:49:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWBtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 20:49:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAN1nEeH044181;
        Sat, 23 Nov 2019 01:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=AiCaRx6eKJ3ngMMqvIE1mlhCYTjyFHil31Ak34PbNTw=;
 b=siuy5wVH5NHIQSNXwnnvOnUsUn6zpmPITMMJEaxGlg7MUASKXz6gQIQfZnzqQ11g4+uf
 Ur1ry2G0Oh4CrrsVFu+fjQo1qYpywFbPstt0FpYIzMQrWa6xwye8DK9mP19Rr2ShEkku
 onxEa6VDNqFcjoGrZnUyA59i0b9WNseI+18NxqGaoSkw4wVMhYOf14s26O3wmaUlhZwi
 76ka0CBl6ywaeHsBdBuIoOQCFgSeDPN0MltNKjIU0+UB5BSMSC9FamuJK7Bw/Qd0ZC4b
 YYecP9i2qb1AmKeExg3v+XIHGbUVXTQci6kmG2u90gGkYRj4YgvdXvEFCAa/7qGYXkZh OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92qdr1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Nov 2019 01:49:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAN1mqxo135950;
        Sat, 23 Nov 2019 01:49:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wegqu7652-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Nov 2019 01:49:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAN1nfcX030429;
        Sat, 23 Nov 2019 01:49:41 GMT
Received: from [10.0.0.14] (/79.177.63.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 17:49:41 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
Date:   Sat, 23 Nov 2019 03:49:37 +0200
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E5F51322-35EF-4EC1-AF3E-2233C6C37645@oracle.com>
References: <20191122234355.174998-1-jmattson@google.com>
 <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
 <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911230014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Nov 2019, at 2:22, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Fri, Nov 22, 2019 at 3:57 PM Liran Alon <liran.alon@oracle.com> =
wrote:
>>=20
>>=20
>>> On 23 Nov 2019, at 1:43, Jim Mattson <jmattson@google.com> wrote:
>>>=20
>>> Commit 37e4c997dadf ("KVM: VMX: validate individual bits of guest
>>> MSR_IA32_FEATURE_CONTROL") broke the KVM_SET_MSRS ABI by instituting
>>> new constraints on the data values that kvm would accept for the =
guest
>>> MSR, IA32_FEATURE_CONTROL. Perhaps these constraints should have =
been
>>> opt-in via a new KVM capability, but they were applied
>>> indiscriminately, breaking at least one existing hypervisor.
>>>=20
>>> Relax the constraints to allow either or both of
>>> FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX and
>>> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX to be set when nVMX is
>>> enabled. This change is sufficient to fix the aforementioned =
breakage.
>>>=20
>>> Fixes: 37e4c997dadf ("KVM: VMX: validate individual bits of guest =
MSR_IA32_FEATURE_CONTROL")
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>=20
>> I suggest to also add a comment in code to clarify why we allow =
setting
>> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX even though we expose a vCPU =
that doesn=E2=80=99t support Intel TXT.
>> (I think the compatibility to existing workloads that sets this =
blindly on boot is a legit reason. Just recommend documenting it.)
>>=20
>> In addition, if the nested hypervisor which relies on this is public, =
please also mention it in commit message for reference.
>=20
> It's not an L1 hypervisor that's the problem. It's Google's L0
> hypervisor. We've been incorrectly reporting IA32_FEATURE_CONTROL as 7
> to nested guests for years, and now we have thousands of running VMs
> with the bogus value. I've thought about just changing it to 5 on the
> fly (on real hardware, one could almost blame it on SMM, but the MSR
> is *locked*, after all).

If I understand correctly, you are talking about the case a VM is =
already running and you will
perform Live-Migration on it to a new host with a new kernel that it=E2=80=
=99s KVM don=E2=80=99t allow to
set FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX.

If we haven=E2=80=99t encountered yet some guest workload that blindly =
sets this bit in IA32_FEATURE_CONTROL,
then it should be sufficient for you to modify vmx_set_msr() to allow =
setting this bit in case msr_info->host_initiated
(i.e. During restore of VM state on destination) but disallow it when =
WRMSR is initiated from guest.
The behaviour of whether vmx_set_msr() allows host to set this MSR to =
unsupported can even be gated by an opt-in KVM cap
that will be set by Google=E2=80=99s userspace VMM.

That way, you won=E2=80=99t change change guest runtime semantics =
(it=E2=80=99s original locked MSR value will be preserved during =
Live-Migration),
and you will disallow newly provisioned guests from setting =
IA32_FEATURE_CONTROL to an unsupported value.

What do you think?

-Liran





