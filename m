Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83AB17E9C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfEHQzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:55:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41066 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbfEHQzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:55:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48GSprw136689;
        Wed, 8 May 2019 16:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=dvTKIepEdz0BDBgKMddzdEryHnwGHIFFSF/sGQYDa1c=;
 b=HnXdBwZumYfmzOCHDO+BUMs7Ayw4Xdq4Jf8KuB6XElMn7/BA4ZAFLpyEpANO92Pa+nSE
 PXbiA/YZpw44Cv6l3+7+Z5Ul2wlkOrEgMSiz/mjOspwoOQmaYkM6nRq8pZ0KFJ1Vcr6S
 d94n8gwTuunhetVWxS06uQsOp7w6kCBvIbBLxBV/DYDSiPTfZve/YbJAyUBESjiOJdAZ
 p8/0lWaRL/IWzyAOGJ3Ynx9ojMvxhXEU7DQINjJwcU2L8rfRhN3lQ0dGWDFiTs3JlW3R
 nJVebg3LxNQRkBNFDfsLFk6T3iEuVpyyUQ+o0AlWsnPicp/JEwcaCJFA0uxnOMRDAQRj bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s94b0wd8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 16:55:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48Gt5D4093568;
        Wed, 8 May 2019 16:55:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2s9ayfmswa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 16:55:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x48GtLI4014930;
        Wed, 8 May 2019 16:55:21 GMT
Received: from [192.168.14.112] (/109.66.243.183)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 09:55:21 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190508160819.19603-1-sean.j.christopherson@intel.com>
Date:   Wed, 8 May 2019 19:55:13 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF5B3191-09E8-488E-8748-CA9F6FAC9D7A@oracle.com>
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080103
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 8 May 2019, at 19:08, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> The RDPMC-exiting control is dependent on the existence of the RDPMC
> instruction itself, i.e. is not tied to the "Architectural Performance
> Monitoring" feature.  For all intents and purposes, the control exists
> on all CPUs with VMX support since RDPMC also exists on all VCPUs with
> VMX supported.  Per Intel's SDM:
>=20
> The RDPMC instruction was introduced into the IA-32 Architecture in
> the Pentium Pro processor and the Pentium processor with MMX =
technology.
> The earlier Pentium processors have performance-monitoring counters, =
but
> they must be read with the RDMSR instruction.
>=20
> Because RDPMC-exiting always exists, KVM requires the control and =
refuses
> to load if it's not available.  As a result, hiding the PMU from a =
guest
> breaks nested virtualization if the guest attemts to use KVM.
>=20

If I understand correctly, you mean that there were CPUs at the past =
that had performance-counters but without PMU and could have been read =
by RDMSR instead of RDPMC?
And there is no CPUID bit that expose if performance-counters even =
exists? You just need to try to RDPMC and see if it #GP?

If the answer to all above questions is =E2=80=9Cyes=E2=80=9D to all =
questions above then I=E2=80=99m sorry for my misunderstanding with this =
original commit and:
Reviewed-by: Liran Alon <liran.alon@oracle.com>

> While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
> check for RDPMC-exiting follows standard fault vs. VM-Exit =
prioritization
> for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
> checks, but before the counter referenced in ECX is checked for =
validity.
>=20
> In other words, the original KVM behavior of injecting a #GP was =
correct,
> and the KVM unit test needs to be adjusted accordingly, e.g. eat the =
#GP
> when the unit test guest (L3 in this case) executes RDPMC without
> RDPMC-exiting set in the unit test host (L2).
>=20
> This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.
>=20
> Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest =
supports PMU")
> Reported-by: David Hill <hilld@binarystorm.net>
> Cc: Saar Amar <saaramar@microsoft.com>
> Cc: Mihai Carabas <mihai.carabas@oracle.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> arch/x86/kvm/vmx/vmx.c | 25 -------------------------
> 1 file changed, 25 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 60306f19105d..0db7ded18951 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6866,30 +6866,6 @@ static void =
nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> 	}
> }
>=20
> -static bool guest_cpuid_has_pmu(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_cpuid_entry2 *entry;
> -	union cpuid10_eax eax;
> -
> -	entry =3D kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry)
> -		return false;
> -
> -	eax.full =3D entry->eax;
> -	return (eax.split.version_id > 0);
> -}
> -
> -static void nested_vmx_procbased_ctls_update(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> -	bool pmu_enabled =3D guest_cpuid_has_pmu(vcpu);
> -
> -	if (pmu_enabled)
> -		vmx->nested.msrs.procbased_ctls_high |=3D =
CPU_BASED_RDPMC_EXITING;
> -	else
> -		vmx->nested.msrs.procbased_ctls_high &=3D =
~CPU_BASED_RDPMC_EXITING;
> -}
> -
> static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> @@ -6978,7 +6954,6 @@ static void vmx_cpuid_update(struct kvm_vcpu =
*vcpu)
> 	if (nested_vmx_allowed(vcpu)) {
> 		nested_vmx_cr_fixed1_bits_update(vcpu);
> 		nested_vmx_entry_exit_ctls_update(vcpu);
> -		nested_vmx_procbased_ctls_update(vcpu);
> 	}
>=20
> 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> --=20
> 2.21.0
>=20

