Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BA9B045
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403844AbfHWNBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:01:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732009AbfHWNBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:01:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NCxn5q030914;
        Fri, 23 Aug 2019 12:59:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=q1YFds1n7Qh/8LU09a4jYgqooViF70CNseso+AlkhGY=;
 b=hAwpzdDCTkBOE6635+bwzBSv311UvDTX1d5V9ezgBAyj4vbl5FTx8kD8tQ78QtObEAg0
 ZuLDE5EUqW31G+FYQ3pydtPPewh386nL6tD+VPOj4GNl3GqeM+ZX6qP9NigMDMQslPOO
 SEq31rTTHrbtqu/JIY94h67fn6+Db/TOcsdihatX2p9WfwyQdyY07mx5nALfx4+btz0M
 ebfonlwCy12tRNTcuN5swBI0luspQzi4s0/X1s9Iiq1NH85cirDnvRcHGWGfTKDDOoKX
 S6qpjeiAuGBSr7GEH0u7Ov7a6YPTP6JVTRw/qhWCutlVzxk+PNLm4HwTNhnmtgu3TCnj 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7rcm8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 12:59:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NCwqWv037826;
        Fri, 23 Aug 2019 12:59:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uj1y0g3r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 12:59:13 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NCwXl2013250;
        Fri, 23 Aug 2019 12:58:33 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 05:58:33 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 02/13] KVM: x86: Clean up
 handle_emulation_failure()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87a7c0p74i.fsf@vitty.brq.redhat.com>
Date:   Fri, 23 Aug 2019 15:58:28 +0300
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <339D775E-5B6B-4CD2-B799-3F8CC5A3E12F@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-3-sean.j.christopherson@intel.com>
 <87a7c0p74i.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 12:23, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>=20
>> When handling emulation failure, return the emulation result directly
>> instead of capturing it in a local variable.  Future patches will =
move
>> additional cases into handle_emulation_failure(), clean up the cruft
>> before so there isn't an ugly mix of setting a local variable and
>> returning directly.
>>=20
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>> arch/x86/kvm/x86.c | 10 ++++------
>> 1 file changed, 4 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cd425f54096a..c6de5bc4fa5e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6207,24 +6207,22 @@ =
EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>>=20
>> static int handle_emulation_failure(struct kvm_vcpu *vcpu, int =
emulation_type)
>> {
>> -	int r =3D EMULATE_DONE;
>> -
>> 	++vcpu->stat.insn_emulation_fail;
>> 	trace_kvm_emulate_insn_failed(vcpu);
>>=20
>> 	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
>> 		return EMULATE_FAIL;
>>=20
>> +	kvm_queue_exception(vcpu, UD_VECTOR);
>> +
>> 	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) =3D=3D 0) =
{
>> 		vcpu->run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
>> 		vcpu->run->internal.suberror =3D =
KVM_INTERNAL_ERROR_EMULATION;
>> 		vcpu->run->internal.ndata =3D 0;
>> -		r =3D EMULATE_USER_EXIT;
>> +		return EMULATE_USER_EXIT;
>> 	}
>>=20
>> -	kvm_queue_exception(vcpu, UD_VECTOR);
>> -
>> -	return r;
>> +	return EMULATE_DONE;
>> }
>>=20
>> static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
>=20
> No functional change,
>=20
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>=20
> Just for self-education, what sane userspace is supposed to do when it
> sees KVM_EXIT_INTERNAL_ERROR other than kill the guest? Why does it =
make
> sense to still prepare to inject '#UD=E2=80=99
>=20
> --=20
> Vitaly

The commit which introduced this behaviour seems to be
6d77dbfc88e3 ("KVM: inject #UD if instruction emulation fails and exit =
to userspace")

I actually agree with Vitaly. It made more sense that the ABI would be =
that
on internal emulation failure, we just return to userspace and allow it =
to handle
the scenario however it likes. If it wishes to queue #UD on vCPU and =
resume
guest in case CPL=3D=3D3 then it made sense that this logic would only =
be in userspace.
Thus, there is no need for KVM to queue a #UD from kernel on this =
scenario...

What=E2=80=99s even weirder is that this ABI was then further broken by =
2 later commits:
First, fc3a9157d314 ("KVM: X86: Don't report L2 emulation failures to =
user-space")
changed behaviour to avoid reporting emulation error in case vCPU in =
guest-mode.
Then, a2b9e6c1a35a ("KVM: x86: Don't report guest userspace emulation =
error to userspace")
Changed behaviour similarly to avoid reporting emulation error in case =
vCPU CPL!=3D0.
In both cases, only #UD is injected to guest without userspace being =
aware of it.

Problem is that if we would change this ABI to not queue #UD on =
emulation error,
we will definitely break userspace VMMs that rely on it when they =
re-enter into guest
in this scenario and expect #UD to be injected.
Therefore, the only way to change this behaviour is to introduce a new =
KVM_CAP
that needs to be explicitly enabled from userspace.
But because most likely most userspace VMMs just terminate guest in case
of emulation-failure, it=E2=80=99s probably not worth it and Sean=E2=80=99=
s commit is good enough.

For the commit itself:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran



