Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F989B145
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbfHWNsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:48:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfHWNsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:48:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDi8VK077850;
        Fri, 23 Aug 2019 13:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=4xCfLNK2wN3hPijM+vMM5ZVmeko4jot4h3NeZzL1u2A=;
 b=O/Fl63Jt422X/PY7uqXkb6Iz/+QRa8D+z7ngT/K/+Wqw5V1bfwC4mjtRuiuEeZ/5YvIz
 y3OT+st3kfjXJ3qqyAMai0vhDhqK8s3Nf7dzU/EpIB3LnUHWCDNH/W2sGBwCr5Xz0tF5
 qtM00YdrcJ1ZAQBRH7kDtmQDtEWqtFclVbf58V4eowbpkQQICEs5BtNiB8TSP7qDgHSb
 GzYGLsrDEDmLkyPUTRqi9iCn+RPR/Pmf35ySUhJKtb0Jm0e/Oosiaexr60LJJGCaPK0s
 uv0JklV+NyrAdQC0a3NS4bKyc8rlV3PMnO7qMBlsF7wsg+SVf6AaXAivC8+WeDLpjYh2 Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ue9hq4rt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:47:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NDcgD8040205;
        Fri, 23 Aug 2019 13:47:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uj8kqcn0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 13:47:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NDlIwG004344;
        Fri, 23 Aug 2019 13:47:19 GMT
Received: from [192.168.14.112] (/109.64.228.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 06:47:18 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RESEND PATCH 07/13] KVM: x86: Add explicit flag for forced
 emulation on #UD
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190823010709.24879-8-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:47:14 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E01A06E-FD3E-4D43-9FFE-6FFE3BAC269A@oracle.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-8-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Aug 2019, at 4:07, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Add an explicit emulation type for forced #UD emulation and use it to
> detect that KVM should unconditionally inject a #UD instead of falling
> into its standard emulation failure handling.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

The name "forced emulation on #UD" is not clear to me.

If I understand correctly, EMULTYPE_TRAP_UD is currently used to =
indicate
that in case the x86 emulator fails to decode instruction, the caller =
would like
the x86 emulator to fail early such that it can handle this condition =
properly.
Thus, I would rename it EMULTYPE_TRAP_DECODE_FAILURE.

But this new flag seems to do the same. So I=E2=80=99m left confused.
I=E2=80=99m probably missing something trivial here.

-Liran

> ---
> arch/x86/include/asm/kvm_host.h | 1 +
> arch/x86/kvm/x86.c              | 5 +++--
> 2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index d1d5b5ca1195..a38c93362945 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,6 +1318,7 @@ enum emulation_result {
> #define EMULTYPE_TRAP_UD	    (1 << 1)
> #define EMULTYPE_SKIP		    (1 << 2)
> #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> +#define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
> #define EMULTYPE_VMWARE_GP	    (1 << 5)
> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int =
emulation_type);
> int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 228ca71d5b01..a1f9e36b2d58 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5337,7 +5337,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
> 				sig, sizeof(sig), &e) =3D=3D 0 &&
> 	    memcmp(sig, "\xf\xbkvm", sizeof(sig)) =3D=3D 0) {
> 		kvm_rip_write(vcpu, kvm_rip_read(vcpu) + sizeof(sig));
> -		emul_type =3D 0;
> +		emul_type =3D EMULTYPE_TRAP_UD_FORCED;
> 	}
>=20
> 	er =3D kvm_emulate_instruction(vcpu, emul_type);
> @@ -6532,7 +6532,8 @@ int x86_emulate_instruction(struct kvm_vcpu =
*vcpu,
> 		trace_kvm_emulate_insn_start(vcpu);
> 		++vcpu->stat.insn_emulation;
> 		if (r !=3D EMULATION_OK)  {
> -			if (emulation_type & EMULTYPE_TRAP_UD)
> +			if ((emulation_type & EMULTYPE_TRAP_UD) ||
> +			    (emulation_type & EMULTYPE_TRAP_UD_FORCED))
> 				return EMULATE_FAIL;
> 			if (reexecute_instruction(vcpu, cr2, =
write_fault_to_spt,
> 						emulation_type))
> --=20
> 2.22.0
>=20

