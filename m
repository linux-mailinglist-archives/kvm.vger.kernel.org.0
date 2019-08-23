Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796239B0CC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395137AbfHWNZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:25:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393315AbfHWNZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:25:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDJ8Ij027126;
        Fri, 23 Aug 2019 13:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=ir2AFnt8nALK87m73r2csPIAPLY1tgPuUkiS4h3CCPs=;
 b=I2RHgf6Hs5F2EG1hIi0iEiGcGkrlAYm8jZQN85BdDUQjwZ6y+ldrrGbV5/kjB8UpPlJM
 lQ5CCypIIT9y+iKivAysTQ2SvihgWeXjIjumO3HDLdtU22biIaLynvS6W9C+Jk679zDg
 5UNBJsIMDV6ifDe3EYMM1TCjntwHOUke4/Pi5qrvlnNlxgAfUGO0uAtpNqRehTmYVwAE
 5oid+B5ad5v+UfFx0ozmJFUMOHp8PAYwIlnL7JC/3bgaSjayyiZ1vB0HD12bvjRSklbg
 M/ykcGxCFo6pkaG24lMQJuw6lRTc5XwrQR0zpuBvj/d4QouW2/rSReDboBxX/WCCz5dG rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90u4tvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:21:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDI8vP024465;
        Fri, 23 Aug 2019 13:21:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uhusfp9ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:21:30 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NDLS7o020805;
        Fri, 23 Aug 2019 13:21:29 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:21:28 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 04/13] KVM: x86: Drop EMULTYPE_NO_UD_ON_FAIL as a
 standalone type
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-5-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:21:24 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4993FDBF-6641-43E9-BCEE-7F5FE58561E9@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-5-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> The "no #UD on fail" is used only in the VMWare case, and for the =
VMWare
> scenario it really means "#GP instead of #UD on fail".  Remove the =
flag
> in preparation for moving all fault injection into the emulation flow
> itself, which in turn will allow eliminating EMULATE_DONE and company.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

When I created the commit which introduced this
e23661712005 ("KVM: x86: Add emulation_type to not raise #UD on =
emulation failure")
I intentionally introduced a new flag to emulation_type instead of using =
EMULTYPE_VMWARE
as I thought it=E2=80=99s weird to couple this behaviour specifically =
with VMware emulation.
As it made sense to me that there could be more scenarios in which some =
VMExit handler
would like to use the x86 emulator but in case of failure want to decide =
what would be
the failure handling from the outside. I also didn=E2=80=99t want the =
x86 emulator to be aware
of VMware interception internals.

Having said that, one could argue that the x86 emulator already knows =
about the VMware
interception internals because of how x86_emulate_instruction() use =
is_vmware_backdoor_opcode()
and from the mere existence of EMULTYPE_VMWARE. So I think it=E2=80=99s =
legit to decide
that we will just move all the VMware interception logic into the x86 =
emulator. Including
handling emulation failures. But then, I would make this patch of yours =
to also
modify handle_emulation_failure() to queue #GP to guest directly instead =
of #GP intercept
in VMX/SVM to do so.
I see you do it in a later patch "KVM: x86: Move #GP injection for =
VMware into x86_emulate_instruction()"
but I think this should just be squashed with this patch to make sense.

To sum-up, I agree with your approach but I recommend you squash this =
patch and patch 6 of the series to one
and change commit message to explain that you just move entire handling =
of VMware interception into
the x86 emulator. Instead of providing explanations such as VMware =
emulation is the only one that use
=E2=80=9Cno #UD on fail=E2=80=9D.

The diff itself looks fine to me, therefore:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran


> ---
> arch/x86/include/asm/kvm_host.h | 1 -
> arch/x86/kvm/svm.c              | 3 +--
> arch/x86/kvm/vmx/vmx.c          | 3 +--
> arch/x86/kvm/x86.c              | 2 +-
> 4 files changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index 44a5ce57a905..dd6bd9ed0839 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,7 +1318,6 @@ enum emulation_result {
> #define EMULTYPE_TRAP_UD	    (1 << 1)
> #define EMULTYPE_SKIP		    (1 << 2)
> #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> -#define EMULTYPE_NO_UD_ON_FAIL	    (1 << 4)
> #define EMULTYPE_VMWARE		    (1 << 5)
> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int =
emulation_type);
> int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..5a42f9c70014 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2772,8 +2772,7 @@ static int gp_interception(struct vcpu_svm *svm)
>=20
> 	WARN_ON_ONCE(!enable_vmware_backdoor);
>=20
> -	er =3D kvm_emulate_instruction(vcpu,
> -		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> +	er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> 	if (er =3D=3D EMULATE_USER_EXIT)
> 		return 0;
> 	else if (er !=3D EMULATE_DONE)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 18286e5b5983..6ecf773825e2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4509,8 +4509,7 @@ static int handle_exception_nmi(struct kvm_vcpu =
*vcpu)
>=20
> 	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
> 		WARN_ON_ONCE(!enable_vmware_backdoor);
> -		er =3D kvm_emulate_instruction(vcpu,
> -			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> +		er =3D kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
> 		if (er =3D=3D EMULATE_USER_EXIT)
> 			return 0;
> 		else if (er !=3D EMULATE_DONE)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe847f8eb947..e0f0e14d8fac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6210,7 +6210,7 @@ static int handle_emulation_failure(struct =
kvm_vcpu *vcpu, int emulation_type)
> 	++vcpu->stat.insn_emulation_fail;
> 	trace_kvm_emulate_insn_failed(vcpu);
>=20
> -	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
> +	if (emulation_type & EMULTYPE_VMWARE)
> 		return EMULATE_FAIL;
>=20
> 	kvm_queue_exception(vcpu, UD_VECTOR);
> --=20
> 2.22.0
>=20

