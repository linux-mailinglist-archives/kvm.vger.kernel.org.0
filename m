Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20E83743D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfFFMgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:36:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36480 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfFFMgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:36:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56COEgk181929;
        Thu, 6 Jun 2019 12:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=lkkkxiOaBzEF+ZYZuPKKuq0YiuBz8Pp9BBn1w75FoCs=;
 b=tmnQjVCTpzZLctTUB09JyWgPcckrM/E2Y3Xf/YVGVnXWRAoVnzYCtajB/dhOgXSkIAgt
 Nsd0fskUhEih7bu8yYCGZCv1qa5ppImk8Vjp6iufeYCAqhTkmBDFowU3xuVZk0/idu+u
 qNzbmPq1tEgVMDZsYsjNAT9y3RVJo4FvwDXbIgLt1yxTsrx7UV5ncO2JJuGH9zPGKUGy
 HzVtrqLNaOrWaNe8K3uZwKzL9ETdogUaSFr9PjCX0pvCGPF3OFSeGJPlZr2JCi02hzsm
 JQ8/hwps40O+c6kTZz5f4KcmBs2gLnHnzrY9Mjf5HujcfTcvTJ1ksN2I7+Om6FSJYisx ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstr509-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 12:36:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56CYY0p153197;
        Thu, 6 Jun 2019 12:36:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2swnhaqta4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 12:36:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x56CaDWr020265;
        Thu, 6 Jun 2019 12:36:13 GMT
Received: from [10.30.3.6] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 05:36:13 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: x86: move MSR_IA32_POWER_CTL handling to common code
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1559824417-74835-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 6 Jun 2019 15:36:09 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <811D43D4-8E85-4681-ABA7-EEA209228164@oracle.com>
References: <1559824417-74835-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 6 Jun 2019, at 15:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> Make it available to AMD hosts as well, just in case someone is trying
> to use an Intel processor's CPUID setup.

I=E2=80=99m actually quite surprised that such a setup works properly.

>=20
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/include/asm/kvm_host.h | 1 +
> arch/x86/kvm/vmx/vmx.c          | 6 ------
> arch/x86/kvm/vmx/vmx.h          | 2 --
> arch/x86/kvm/x86.c              | 6 ++++++
> 4 files changed, 7 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h =
b/arch/x86/include/asm/kvm_host.h
> index a86026969b19..35e7937cc9ac 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
> 	u32 virtual_tsc_mult;
> 	u32 virtual_tsc_khz;
> 	s64 ia32_tsc_adjust_msr;
> +	u64 msr_ia32_power_ctl;
> 	u64 tsc_scaling_ratio;
>=20
> 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cccf73a91e88..5d903f8909d1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1695,9 +1695,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 	case MSR_IA32_SYSENTER_ESP:
> 		msr_info->data =3D vmcs_readl(GUEST_SYSENTER_ESP);
> 		break;
> -	case MSR_IA32_POWER_CTL:
> -		msr_info->data =3D vmx->msr_ia32_power_ctl;
> -		break;
> 	case MSR_IA32_BNDCFGS:
> 		if (!kvm_mpx_supported() ||
> 		    (!msr_info->host_initiated &&
> @@ -1828,9 +1825,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 	case MSR_IA32_SYSENTER_ESP:
> 		vmcs_writel(GUEST_SYSENTER_ESP, data);
> 		break;
> -	case MSR_IA32_POWER_CTL:
> -		vmx->msr_ia32_power_ctl =3D data;
> -		break;
> 	case MSR_IA32_BNDCFGS:
> 		if (!kvm_mpx_supported() ||
> 		    (!msr_info->host_initiated &&
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 61128b48c503..1cdaa5af8245 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -260,8 +260,6 @@ struct vcpu_vmx {
>=20
> 	unsigned long host_debugctlmsr;
>=20
> -	u64 msr_ia32_power_ctl;
> -
> 	/*
> 	 * Only bits masked by msr_ia32_feature_control_valid_bits can =
be set in
> 	 * msr_ia32_feature_control. FEATURE_CONTROL_LOCKED is always =
included
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 145df9778ed0..5ec87ded17db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2563,6 +2563,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 			return 1;
> 		vcpu->arch.smbase =3D data;
> 		break;
> +	case MSR_IA32_POWER_CTL:
> +		vcpu->arch.msr_ia32_power_ctl =3D data;
> +		break;
> 	case MSR_IA32_TSC:
> 		kvm_write_tsc(vcpu, msr_info);
> 		break;
> @@ -2822,6 +2825,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> 			return 1;
> 		msr_info->data =3D vcpu->arch.arch_capabilities;
> 		break;
> +	case MSR_IA32_POWER_CTL:
> +		msr_info->data =3D vcpu->arch.msr_ia32_power_ctl;
> +		break;
> 	case MSR_IA32_TSC:
> 		msr_info->data =3D kvm_scale_tsc(vcpu, rdtsc()) + =
vcpu->arch.tsc_offset;
> 		break;
> --=20
> 1.8.3.1
>=20

