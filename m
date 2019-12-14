Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2311F0DC
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 09:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfLNINj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 03:13:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53682 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfLNINj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 03:13:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE0uPks053683;
        Sat, 14 Dec 2019 01:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=bZRzVXC1A2mQlyRmK7P/0EUj8XT3R/nW+ZLzlRiU8PU=;
 b=Ey4LU3d//I4ZiH8padOxxy1Hice50cFjdE5MAlO77l68b8757fek5dNaqiT7HPpLxoDU
 rOZ1t+Su9yJKYgIgry46NeUu/OwaOJD/tjlK293OzgryLz4oKTe3xD1lwT4QMsH+9MAm
 W9zbNrirgLob6We3kff9hv4bS5L0NeXiaHF3s7HVSdKcxlYdTKdHLOTOUmxgBMqOlZKh
 46Y4GJQf0Gocdb486lyrFUikESeDH6aIvuM/bs6DrJpirarCacxfppo9d6uxPTc9rX8/
 ezJ5ZtGoE3FuzanAvVNOvNYplV4+2hu+wZHMTTaxj+eqw1Eik4irD7EjKLJJR8jHXKSx Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wr4qs3vfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 01:10:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE0rxmT092146;
        Sat, 14 Dec 2019 01:10:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wvd1hax2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 01:10:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBE1AOsK025861;
        Sat, 14 Dec 2019 01:10:25 GMT
Received: from [192.168.14.112] (/109.65.223.49)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 17:10:24 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191214002014.144430-1-jmattson@google.com>
Date:   Sat, 14 Dec 2019 03:10:21 +0200
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <81C338F8-851B-471C-8707-646283167D57@oracle.com>
References: <20191214002014.144430-1-jmattson@google.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14 Dec 2019, at 2:20, Jim Mattson <jmattson@google.com> wrote:
>=20
> More often than not, a failed VM-entry in a production environment is
> the result of a defective CPU (at least, insofar as Intel x86 is
> concerned). To aid in identifying the bad hardware, add the logical
> CPU to the information provided to userspace on a KVM exit with reason
> KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
> indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

BTW, one could argue that receiving an unexpected exit-reason (i.e. =
KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON)
could also only occur in production either from a KVM bug or from a =
defective CPU. Similar to failed VM-entry.
Should we add similar behaviour to that as-well?

-Liran

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
> index 122d4ce3b1ab..e07c5ce3ac93 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4980,6 +4980,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
> 		kvm_run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		kvm_run->fail_entry.hardware_entry_failure_reason
> 			=3D svm->vmcb->control.exit_code;
> +		kvm_run->fail_entry.cpu =3D vcpu->cpu;
> 		dump_vmcb(vcpu);
> 		return 0;
> 	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3394c839dea..17d1a1676fc0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5846,6 +5846,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		vcpu->run->fail_entry.hardware_entry_failure_reason
> 			=3D exit_reason;
> +		vcpu->run->fail_entry.cpu =3D vcpu->cpu;
> 		return 0;
> 	}
>=20
> @@ -5854,6 +5855,7 @@ static int vmx_handle_exit(struct kvm_vcpu =
*vcpu)
> 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> 		vcpu->run->fail_entry.hardware_entry_failure_reason
> 			=3D vmcs_read32(VM_INSTRUCTION_ERROR);
> +		vcpu->run->fail_entry.cpu =3D vcpu->cpu;
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

