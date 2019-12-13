Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B308F11EE75
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 00:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLMX02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 18:26:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMX02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 18:26:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDN9UU5006257;
        Fri, 13 Dec 2019 23:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=yx6b25cPhJ8B9QAerrwlE7WQ3QAiR9yRYl99EEdfPZ8=;
 b=NfmgbwALSdq2Xh6kY1Bwird84VbSEvKAUUkGl5ZN9Lli7H8Z/+YP0IspGQ+LK2m/FwFF
 hEt1nHdqV02T2Qjd3TYdrT/cnps1rZOfhM3MJsqvdK+jxC3BhTWcVLrPj70uG2mg/2hl
 Y+SUiwX0/pX+ukni1hf10F1csfIbcr6VIi3teuYpZzuTkqmJhOyWyAjohG+gjSTiE29u
 YvifLH99LYd1lxRhiLzj01ql0o1dMeBZzqKmKq8M2FWt/34Gna1Sr/e0zMeO/f2dp9Xz
 Jzd7VD4bvHYkts6UNac/+qyZSbm8ztT7emALMokMlezZ93PIXNF9OThzfVhDY7S/f/i5 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4nrmvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 23:26:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDN9LSg126152;
        Fri, 13 Dec 2019 23:26:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wvdtvgvaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 23:26:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBDNQGBJ017733;
        Fri, 13 Dec 2019 23:26:16 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 15:26:16 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191213231646.88015-1-jmattson@google.com>
Date:   Sat, 14 Dec 2019 01:26:12 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <52043F85-F9D7-4EED-B5EB-999CE5CA2065@oracle.com>
References: <20191213231646.88015-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 Dec 2019, at 1:16, Jim Mattson <jmattson@google.com> wrote:
>=20
> More often than not, a failed VM-entry in a production environment is
> the result of a defective CPU (at least, insofar as Intel x86 is
> concerned). To aid in identifying the bad hardware, add the logical
> CPU to the information provided to userspace on a KVM exit with reason
> KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
> indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
> Documentation/virt/kvm/api.txt | 1 +
> arch/x86/kvm/svm.c             | 1 +
> arch/x86/kvm/vmx/vmx.c         | 2 ++
> arch/x86/kvm/x86.c             | 1 +
> include/uapi/linux/kvm.h       | 2 ++
> 5 files changed, 7 insertions(+)
>=20
> diff --git a/Documentation/virt/kvm/api.txt =
b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..6e5d92406b65 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4245,6 +4245,7 @@ hardware_exit_reason.
> 		/* KVM_EXIT_FAIL_ENTRY */
> 		struct {
> 			__u64 hardware_entry_failure_reason;
> +			__u32 cpu; /* if KVM_CAP_FAILED_ENTRY_CPU */
> 		} fail_entry;
>=20
> If exit_reason is KVM_EXIT_FAIL_ENTRY, the vcpu could not be run due
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122d4ce3b1ab..4d06b2413c63 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4980,6 +4980,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
> 		kvm_run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		kvm_run->fail_entry.hardware_entry_failure_reason
> 			=3D svm->vmcb->control.exit_code;
> +		kvm_run->fail_entry.cpu =3D raw_smp_processor_id();

Why not just use vcpu->cpu?
Same for vmx_handle_exit() to be consistent.

> 		dump_vmcb(vcpu);
> 		return 0;
> 	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3394c839dea..4d540b1c08e0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5846,6 +5846,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		vcpu->run->fail_entry.hardware_entry_failure_reason
> 			=3D exit_reason;
> +		vcpu->run->fail_entry.cpu =3D vmx->loaded_vmcs->cpu;
> 		return 0;
> 	}
>=20
> @@ -5854,6 +5855,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		vcpu->run->fail_entry.hardware_entry_failure_reason
> 			=3D vmcs_read32(VM_INSTRUCTION_ERROR);
> +		vcpu->run->fail_entry.cpu =3D vmx->loaded_vmcs->cpu;
> 		return 0;
> 	}
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf917139de6b..9e89a32056d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3273,6 +3273,7 @@ int kvm_vm_ioctl_check_extension(struct kvm =
*kvm, long ext)
> 	case KVM_CAP_GET_MSR_FEATURES:
> 	case KVM_CAP_MSR_PLATFORM_INFO:
> 	case KVM_CAP_EXCEPTION_PAYLOAD:
> +	case KVM_CAP_FAILED_ENTRY_CPU:
> 		r =3D 1;
> 		break;
> 	case KVM_CAP_SYNC_REGS:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f0a16b4adbbd..09ba7174456d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -277,6 +277,7 @@ struct kvm_run {
> 		/* KVM_EXIT_FAIL_ENTRY */
> 		struct {
> 			__u64 hardware_entry_failure_reason;
> +			__u32 cpu;
> 		} fail_entry;
> 		/* KVM_EXIT_EXCEPTION */
> 		struct {
> @@ -1009,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
> #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
> #define KVM_CAP_ARM_NISV_TO_USER 177
> #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> +#define KVM_CAP_FAILED_ENTRY_CPU 179
>=20
> #ifdef KVM_CAP_IRQ_ROUTING
>=20
> --=20
> 2.24.1.735.g03f4e72817-goog
>=20

