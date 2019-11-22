Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE25107BBE
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 00:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVX5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 18:57:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKVX5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 18:57:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMNsWwo170980;
        Fri, 22 Nov 2019 23:57:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=U9UpCc90bYWNglmNmq98pZodpWny/LnkWvJodu+kFlE=;
 b=FkVYkbWDinh6rvilEAkV3ulWpPvyBQKSyZUvBCZ0k+bdv8ySYFbU0Z4RVEfRvoUjn/8m
 rCC+m/6EgYd24mLHSTzVMvMOwh7KY5qdp1PBwAyWLHSKVz7Ljw/AXqOtDs/W2/5OSrC5
 9xoR98VZp6E3+xu0Le77IDcLZdGZljd+bUDdw8YfASuhX5k5tbcSY4yMdCPOGpglyNch
 tZpco2cUp4xbc2cRJSQovmUCAXOM6utloM8KNlcCkMons/zpu0tadW+nWJaOcCWXG4m3
 PhZjnvte7FDdZArYEpzr02GrF5K5mw2+B+DJbIsChfQmG0m8V/YfQKL5Ia/kapOdi794 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92qdhs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 23:57:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMNsAIl145730;
        Fri, 22 Nov 2019 23:57:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wegqtppvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 23:57:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAMNvFGK024943;
        Fri, 22 Nov 2019 23:57:15 GMT
Received: from [10.0.0.14] (/79.177.63.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 15:57:15 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191122234355.174998-1-jmattson@google.com>
Date:   Sat, 23 Nov 2019 01:57:10 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
References: <20191122234355.174998-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9449 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220188
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 23 Nov 2019, at 1:43, Jim Mattson <jmattson@google.com> wrote:
>=20
> Commit 37e4c997dadf ("KVM: VMX: validate individual bits of guest
> MSR_IA32_FEATURE_CONTROL") broke the KVM_SET_MSRS ABI by instituting
> new constraints on the data values that kvm would accept for the guest
> MSR, IA32_FEATURE_CONTROL. Perhaps these constraints should have been
> opt-in via a new KVM capability, but they were applied
> indiscriminately, breaking at least one existing hypervisor.
>=20
> Relax the constraints to allow either or both of
> FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX and
> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX to be set when nVMX is
> enabled. This change is sufficient to fix the aforementioned breakage.
>=20
> Fixes: 37e4c997dadf ("KVM: VMX: validate individual bits of guest =
MSR_IA32_FEATURE_CONTROL")
> Signed-off-by: Jim Mattson <jmattson@google.com>

I suggest to also add a comment in code to clarify why we allow setting
FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX even though we expose a vCPU =
that doesn=E2=80=99t support Intel TXT.
(I think the compatibility to existing workloads that sets this blindly =
on boot is a legit reason. Just recommend documenting it.)

In addition, if the nested hypervisor which relies on this is public, =
please also mention it in commit message for reference.

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/vmx.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 04a8212704c17..9f46023451810 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7097,10 +7097,12 @@ static void vmx_cpuid_update(struct kvm_vcpu =
*vcpu)
>=20
> 	if (nested_vmx_allowed(vcpu))
> 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=3D
> +			FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
> 			FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> 	else
> 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=3D
> -			~FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> +			~(FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
> +			  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX);
>=20
> 	if (nested_vmx_allowed(vcpu)) {
> 		nested_vmx_cr_fixed1_bits_update(vcpu);
> --=20
> 2.24.0.432.g9d3f5f5b63-goog
>=20

