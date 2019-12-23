Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFE129B82
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfLWWuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 17:50:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfLWWuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 17:50:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNMnZkG133840;
        Mon, 23 Dec 2019 22:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=MG6/+eOFC/gL/G3lyv/CZY2BToEa9KjPjUs7viw5xuA=;
 b=V5QhnzHwuIBSkKeibqwaq3fXNN9JY1hav6Sh539PpM/efcfbPjm3xY0g80nLiIXUI6YU
 PQeqYjn1iV24EEmJNsriCSeb6iFv67G9ffynjpHZsJ63iJ0FRY3E2sI4ajaztdpTizFp
 NtcFi2ggNpQnaUqiicimJH0j0gV8Y7X104Fxzt/Uv6WoVtmblU2PCf40xZlMKGfEpU3i
 qXvqfRHWYHVnFJFQLxqTDjepZrmUspjMy7Jin1t+s/+InW/GitrHKJTe+A6vqmn0fQNB
 Jw6LDAtu6jG4aiVjINEn4avHNio6VGJNNAJhqMvFh/8bMlxzG0jVG1n60QKmenOzniDp 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x1c1qs1ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 22:49:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBNMnYIp149531;
        Mon, 23 Dec 2019 22:49:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x1wj9jy9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 22:49:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBNMnSvA002736;
        Mon, 23 Dec 2019 22:49:28 GMT
Received: from [192.168.14.112] (/109.64.214.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Dec 2019 14:49:28 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <f4d3d392-8edf-54b2-1b90-417447240e22@redhat.com>
Date:   Tue, 24 Dec 2019 00:49:22 +0200
Cc:     John Andersen <john.s.andersen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E2D4616-83B6-41E8-8904-407F7DB33EB4@oracle.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
 <15b57d6b-0f46-01f5-1f75-b9b55db0611a@redhat.com>
 <03F5FE31-E769-4497-922B-C8613F0951FA@oracle.com>
 <f4d3d392-8edf-54b2-1b90-417447240e22@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912230199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9480 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912230199
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Dec 2019, at 19:46, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 23/12/19 18:28, Liran Alon wrote:
>>>> Why reset CR pinned MSRs by userspace instead of KVM INIT
>>>> handling?
>>> Most MSRs are not reset by INIT, are they?
>>>=20
>>> Paolo
>>>=20
>> MSR_KVM_SYSTEM_TIME saved in vcpu->arch.time is reset at
>> kvmclock_reset() which is called by kvm_vcpu_reset() (KVM INIT
>> handler). In addition, vmx_vcpu_reset(), called from
>> kvm_vcpu_reset(), also resets multiple MSRs such as:
>> MSR_IA32_SPEC_CTRL (vmx->spec_ctrl) and MSR_IA32_UMWAIT_CONTROL
>> (msr_ia32_umwait_control).
>=20
> These probably can be removed, since they are zero at startup and at
> least SPEC_CTRL is documented[1] to be unaffected by INIT.  However, I
> couldn't find information about UMWAIT_CONTROL.
>=20
>> Having said that, I see indeed that most of MSRs are being set by
>> QEMU in kvm_put_msrs() when level >=3D KVM_PUT_RESET_STATE. When is
>> triggered by qemu_system_reset() -> cpu_synchronize_all_post_reset ->
>> cpu_synchronize_post_reset() -> kvm_cpu_synchronize_post_reset().
>>=20
>> So given current design, OK I agree with you that CR pinned MSRs
>> should be zeroed by userspace VMM.
>>=20
>> It does though seems kinda weird to me that part of CPU state is
>> initialised on KVM INIT handler and part of it in userspace VMM. It
>> could lead to inconsistent (i.e. diverging from spec) CPU behaviour.
>=20
> The reason for that is the even on real hardware INIT does not touch
> most MSRs:
>=20
>  9.1 Initialization overview
>=20
>  Asserting the INIT# pin on the processor invokes a similar response =
to
>  a hardware reset. The major difference is that during an INIT, the
>  internal caches, MSRs, MTRRs, and x87 FPU state are left unchanged
>  (although, the TLBs and BTB are invalidated as with a hardware =
reset).
>  An INIT provides a method for switching from protected to =
real-address
>  mode while maintaining the contents of the internal caches.
>=20
> Paolo
>=20
> [1]
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__software.intel.com_=
security-2Dsoftware-2Dguidance_api-2Dapp_sites_default_files_336996-2DSpec=
ulative-2DExecution-2DSide-2DChannel-2DMitigations.pdf&d=3DDwICaQ&c=3DRoP1=
YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr=
-yKXPNGZbpTx0&m=3DMRhvCoZcvqLvHMhI3y3iSkpiAfitrNoCgPtWaTXhzNQ&s=3D66DAue_O=
jp-a_msxZ2W9bLtQWJB4W1p9F9GrBBQ8dnw&e=3D=20
>=20

Oh right. That=E2=80=99s true.
There is a difference between power-up and asserting RESET# pin to =
asserting INIT# pin or receiving INIT IPI.
The first does reset all the processor state while the latter reset only =
part of it as indeed Intel SDM section 9.1 describes.

So basically because KVM is only aware of INIT IPI but not on power-up =
and asserting RESET# pin events,
then the job of emulating the latter events is currently implemented in =
userspace VMM.

Having said that, one could argue that because KVM implements the vCPU, =
it should just expose a relevant ioctl
for userspace VMM to trigger =E2=80=9Cfull vCPU state reset=E2=80=9D on =
power-up or asserting RESET# pin events.
i.e. Making userspace VMM only the one which emulates the peripheral =
hardware that triggers the event,
but not implementing the vCPU emulation that responds to this event. I =
think this would have resulted in a cleaner design.

But we are diverting from original patch-series discussion so if we want =
to discuss this further, let=E2=80=99s open a separate email thread on =
that. :)

-Liran

