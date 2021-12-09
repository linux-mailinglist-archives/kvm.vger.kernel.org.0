Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95AD46E88A
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 13:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhLIMkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 07:40:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhLIMkA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 07:40:00 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9CTII4001726;
        Thu, 9 Dec 2021 12:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eYsnUT8CxnNqTWIOCodRrhgr7woZ3r4qw9cfRjzgwYg=;
 b=hN/gA6a05rqGHSRmhF9m1McxjeV2rAC0UA0Lmx7KZW2kOd+zQ9gP9S225Fm6mEUqc+ep
 iwL24gJajthhRqlicHsnvnD19/JlZ3VcMKo4A4KN+YiOeMsZSnAsnG5i2HQxA4ftN1A6
 +/+KxO8j4dDvMbi7d727DIN704qdmI3nCFfTrbvK9Sb4ogdq3y5mn6uS+lMBf1OUv6W3
 ZjUC82fZVEbXw4Y1rVm33i0t3e98SP8m1rPJay7t7hiL+APxJeSf7f6UnyJvTuG4kFd4
 8b0yTAiUDsnvpyH3ojdswo3tPZTJZIHcsAKPURUs9TTNM9+HSHkFTbCrl9V1iRDX/GSh dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhucg494-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 12:36:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9CUR2N008321;
        Thu, 9 Dec 2021 12:36:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cuhucg48m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 12:36:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9CXQY2002596;
        Thu, 9 Dec 2021 12:36:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb9741-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 12:36:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9CaKEr28049754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 12:36:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3482DA4060;
        Thu,  9 Dec 2021 12:36:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A930A4066;
        Thu,  9 Dec 2021 12:36:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.115])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 12:36:19 +0000 (GMT)
Date:   Thu, 9 Dec 2021 13:36:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Message-ID: <20211209133616.650491fd@p-imbrenda>
In-Reply-To: <20211122131443.66632-2-pmorel@linux.ibm.com>
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
        <20211122131443.66632-2-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wpQDPhSlrF5oVharX90oEFm9fnDp1FAv
X-Proofpoint-ORIG-GUID: 7ddCB-cTLiM81KFnWBDQ1U92chBi_g6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Nov 2021 14:14:43 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We let the userland hypervisor know if the machine support the CPU
> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> The PTF instruction will report a topology change if there is any change
> with a previous STSI_15_1_2 SYSIB.
> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
> inside the CPU Topology List Entry CPU mask field, which happens with
> changes in CPU polarization, dedication, CPU types and adding or
> removing CPUs in a socket.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> To check if the topology has been modified we use a new field of the
> arch vCPU to save the previous real CPU ID at the end of a schedule
> and verify on next schedule that the CPU used is in the same socket.
> 
> We assume in this patch:
> - no polarization change: only horizontal polarization is currently
>   used in linux.
> - no CPU Type change: only IFL Type are supported in Linux
> - Dedication: with this patch, only a complete dedicated CPU stack can
>   take benefit of the CPU Topology.
> 
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> support the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Although the title of the patch is not very correct, you are doing more
than just accepting STSI.

Maybe call it "guest PTF support", or "guest support for topology
function"?

> ---
>  Documentation/virt/kvm/api.rst   | 16 ++++++++++
>  arch/s390/include/asm/kvm_host.h | 14 ++++++---
>  arch/s390/kvm/kvm-s390.c         | 52 +++++++++++++++++++++++++++++++-
>  arch/s390/kvm/priv.c             |  7 ++++-
>  arch/s390/kvm/vsie.c             |  3 ++
>  include/uapi/linux/kvm.h         |  1 +
>  6 files changed, 87 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aeeb071c7688..e5c9da0782a6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7484,3 +7484,19 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.17 KVM_CAP_S390_CPU_TOPOLOGY
> +------------------------------
> +
> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
> +:Architectures: s390
> +:Type: vm
> +
> +This capability indicates that kvm will provide the S390 CPU Topology facility
> +which consist of the interpretation of the PTF instruction for the Function
> +Code 2 along with interception and forwarding of both the PTF instruction
> +with function Codes 0 or 1 and the STSI(15,1,x) instruction to the userland
> +hypervisor.
> +
> +The stfle facility 11, CPU Topology facility, should not be provided to the
> +guest without this capability.
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..cccc09a8fdab 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -95,15 +95,19 @@ struct bsca_block {
>  	union ipte_control ipte_control;
>  	__u64	reserved[5];
>  	__u64	mcn;
> -	__u64	reserved2;
> +#define ESCA_UTILITY_MTCR	0x8000
> +	__u16	utility;
> +	__u8	reserved2[6];
>  	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>  };
>  
>  struct esca_block {
>  	union ipte_control ipte_control;
> -	__u64   reserved1[7];
> +	__u64   reserved1[6];
> +	__u16	utility;
> +	__u8	reserved2[6];
>  	__u64   mcn[4];
> -	__u64   reserved2[20];
> +	__u64   reserved3[20];
>  	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>  };
>  
> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>  	__u8	icptcode;		/* 0x0050 */
>  	__u8	icptstatus;		/* 0x0051 */
>  	__u16	ihcpu;			/* 0x0052 */
> -	__u8	reserved54;		/* 0x0054 */
> +	__u8	mtcr;			/* 0x0054 */
>  #define IICTL_CODE_NONE		 0x00
>  #define IICTL_CODE_MCHK		 0x01
>  #define IICTL_CODE_EXT		 0x02
> @@ -247,6 +251,7 @@ struct kvm_s390_sie_block {
>  #define ECB_SPECI	0x08
>  #define ECB_SRSI	0x04
>  #define ECB_HOSTPROTINT	0x02
> +#define ECB_PTF		0x01
>  	__u8	ecb;			/* 0x0061 */
>  #define ECB2_CMMA	0x80
>  #define ECB2_IEP	0x20
> @@ -748,6 +753,7 @@ struct kvm_vcpu_arch {
>  	bool skey_enabled;
>  	struct kvm_s390_pv_vcpu pv;
>  	union diag318_info diag318_info;
> +	int prev_cpu;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 14a18ba5ff2c..b40d2a20bce0 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_PROTECTED:
>  		r = is_prot_virt_host();
>  		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		r = test_facility(11);
> +		break;
>  	default:
>  		r = 0;
>  	}
> @@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  		icpt_operexc_on_all_vcpus(kvm);
>  		r = 0;
>  		break;
> +	case KVM_CAP_S390_CPU_TOPOLOGY:
> +		r = -EINVAL;
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus) {
> +			r = -EBUSY;
> +		} else if (test_facility(11)) {
> +			set_kvm_facility(kvm->arch.model.fac_mask, 11);
> +			set_kvm_facility(kvm->arch.model.fac_list, 11);
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
> +			 r ? "(not available)" : "(success)");
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -3089,18 +3106,44 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>  	return value;
>  }
>  
> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +static void kvm_s390_set_mtcr(struct kvm_vcpu *vcpu)
>  {
> +	struct esca_block *esca = vcpu->kvm->arch.sca;
>  
> +	if (vcpu->arch.sie_block->ecb & ECB_PTF) {
> +		ipte_lock(vcpu);
> +		WRITE_ONCE(esca->utility, ESCA_UTILITY_MTCR);
> +		ipte_unlock(vcpu);
> +	}
> +}
> +
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
>  	gmap_enable(vcpu->arch.enabled_gmap);
>  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>  		__start_cpu_timer_accounting(vcpu);
>  	vcpu->cpu = cpu;
> +
> +	/*
> +	 * With PTF interpretation the guest will be aware of topology
> +	 * change when the Multiprocessor Topology-Change-Report is pending.
> +	 * We check for events modifying the result of STSI_15_2:
> +	 * - A new vCPU has been hotplugged (prev_cpu == -1)
> +	 * - The real CPU backing up the vCPU moved to another socket
> +	 */
> +	if (vcpu->arch.sie_block->ecb & ECB_PTF) {
> +		if (vcpu->arch.prev_cpu == -1 ||
> +		    (topology_physical_package_id(cpu) !=
> +		     topology_physical_package_id(vcpu->arch.prev_cpu)))
> +			kvm_s390_set_mtcr(vcpu);
> +	}
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +	/* Remember which CPU was backing the vCPU */
> +	vcpu->arch.prev_cpu = vcpu->cpu;
>  	vcpu->cpu = -1;
>  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>  		__stop_cpu_timer_accounting(vcpu);
> @@ -3220,6 +3263,13 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>  	if (test_kvm_facility(vcpu->kvm, 9))
>  		vcpu->arch.sie_block->ecb |= ECB_SRSI;
> +
> +	/* PTF needs guest facilities to enable interpretation */
> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		vcpu->arch.sie_block->ecb |= ECB_PTF;
> +	/* Set the prev_cpu value to an impossible value to detect a new vcpu */
> +	vcpu->arch.prev_cpu = -1;
> +
>  	if (test_kvm_facility(vcpu->kvm, 73))
>  		vcpu->arch.sie_block->ecb |= ECB_TE;
>  	if (!kvm_is_ucontrol(vcpu->kvm))
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 417154b314a6..26d165733496 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -861,7 +861,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>  
> -	if (fc > 3) {
> +	if ((fc > 3 && fc != 15) ||
> +	    (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
>  		kvm_s390_set_psw_cc(vcpu, 3);
>  		return 0;
>  	}
> @@ -898,6 +899,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  			goto out_no_data;
>  		handle_stsi_3_2_2(vcpu, (void *) mem);
>  		break;
> +	case 15:
> +		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
> +		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
> +		return -EREMOTE;
>  	}
>  	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>  		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index acda4b6fc851..da0397cf2cc7 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	/* Host-protection-interruption introduced with ESOP */
>  	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>  		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
> +	/* CPU Topology */
> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		scb_s->ecb |= scb_o->ecb & ECB_PTF;
>  	/* transactional execution */
>  	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>  		/* remap the prefix is tx is toggled on */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1daa45268de2..273c62dfbe9a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> +#define KVM_CAP_S390_CPU_TOPOLOGY 207
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

