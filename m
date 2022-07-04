Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829A5650FC
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 11:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiGDJfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 05:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiGDJfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 05:35:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E94D136;
        Mon,  4 Jul 2022 02:35:38 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2649LZWY026442;
        Mon, 4 Jul 2022 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pwrFsA7OsADVL/T7Jvh2iQ2XxsGOzZsRWNFYAGjNqjs=;
 b=q3N56pRgYPCjYfjJHRZs1EfgE3HcepoK7qUnizq/XP+N1sDc9h5HMv2kXE0V3KBgDIhX
 HMGjqPNtKjgYKrJ6G4wfMTh4nuAYEu6kJzNJ25KEt6A2fxJfwoHirI2pvgc7BytcQ6R4
 2pkv63erIAGbTRHz+0oQjtlAT1y5PJ9W+YIMqQWwUogdjdYSsM8KD/xC/OClGa2tVDx+
 571riHncdoOky4LEAqgAMtDB9G4WI+l1kyBKVSSo5GIbUpMZvYcXpyQco04Av6xpr6O4
 DwW0EbMSnc3c2vWzjDBbkQ1GHy36+mrzvcQJHIn9GOmGLCyMB2fDjFmP93pe38GnRQEZ UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3wgj88nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:35:37 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2649OKXx032747;
        Mon, 4 Jul 2022 09:35:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3wgj88mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:35:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2649PULI013434;
        Mon, 4 Jul 2022 09:35:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3h2dn8tfm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 09:35:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2649ZdNB26870036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 09:35:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 556E942049;
        Mon,  4 Jul 2022 09:35:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD79B42041;
        Mon,  4 Jul 2022 09:35:30 +0000 (GMT)
Received: from [9.171.76.58] (unknown [9.171.76.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 09:35:30 +0000 (GMT)
Message-ID: <d90e2aaa-05ad-6f3a-83f8-428677256673@linux.ibm.com>
Date:   Mon, 4 Jul 2022 11:35:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v11 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
 <20220701162559.158313-4-pmorel@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220701162559.158313-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: txEPyHidLenGci6sCYbN2SmmXFeXm1he
X-Proofpoint-ORIG-GUID: S9QTTL7PeEhGCUiibfaJ0rA613ho6IHw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/22 18:25, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared.
> 
> Let's give userland the possibility to clear the MTCR in the case
> of a subsystem reset.
> 
> To migrate the MTCR, we give userland the possibility to
> query the MTCR state.
> 
> We indicate KVM support for the CPU topology facility with a new
> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst   | 25 +++++++++++++++
>  arch/s390/include/uapi/asm/kvm.h | 10 ++++++
>  arch/s390/kvm/kvm-s390.c         | 53 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  1 +
>  4 files changed, 89 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 11e00a46c610..5e086125d8ad 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7956,6 +7956,31 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>  type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>  
> +8.37 KVM_CAP_S390_CPU_TOPOLOGY
> +------------------------------
> +
> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
> +:Architectures: s390
> +:Type: vm
> +
> +This capability indicates that KVM will provide the S390 CPU Topology
> +facility which consist of the interpretation of the PTF instruction for
> +the function code 2 along with interception and forwarding of both the
> +PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
> +instruction to the userland hypervisor.
The latter only if the user STSI capability is also enabled.
> +
> +The stfle facility 11, CPU Topology facility, should not be indicated
> +to the guest without this capability.
> +
> +When this capability is present, KVM provides a new attribute group
> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
> +This new attribute allows to get, set or clear the Modified Change
> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
> +structure.
> +
> +When getting the Modified Change Topology Report value, the attr->addr
> +must point to a byte where the value will be stored.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 7a6b14874d65..df5e8279ffd0 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>  #define KVM_S390_VM_CRYPTO		2
>  #define KVM_S390_VM_CPU_MODEL		3
>  #define KVM_S390_VM_MIGRATION		4
> +#define KVM_S390_VM_CPU_TOPOLOGY	5
>  
>  /* kvm attributes for mem_ctrl */
>  #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> @@ -171,6 +172,15 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
>  
> +/* kvm attributes for cpu topology */
> +#define KVM_S390_VM_CPU_TOPO_MTCR_CLEAR	0
> +#define KVM_S390_VM_CPU_TOPO_MTCR_SET	1
> +
> +struct kvm_cpu_topology {
> +	__u16 mtcr : 1;
> +	__u16 reserved : 15;
> +};

This is no longer used, is it?
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ee59b03f2e45..5029fe40adbd 100644
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

I still would go for consistency here, "ENABLE: CAP_S390_CPU_TOPOLOGY %s".

> +			 r ? "(not available)" : "(success)");
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -1716,6 +1733,33 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>  	read_unlock(&kvm->arch.sca_lock);
>  }
>  
> +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	if (!test_kvm_facility(kvm, 11))
> +		return -ENXIO;
> +
> +	kvm_s390_update_topology_change_report(kvm, !!attr->attr);

Will this not be automatically clamped to 0,1 if the argument has type bool?
> +	return 0;
> +}
> +
> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	union sca_utility utility;
> +	struct bsca_block *sca = kvm->arch.sca;
> +	__u8 topo;
> +
> +	if (!test_kvm_facility(kvm, 11))
> +		return -ENXIO;
> +
        read_lock(&kvm->arch.sca_lock);
        utility.val = READ_ONCE(kvm->arch.sca->utility.val);
        read_unlock(&kvm->arch.sca_lock);

And then get rid of the sca declaration.
> +	topo = utility.mtcr;
> +
> +	if (copy_to_user((void __user *)attr->addr, &topo, sizeof(topo)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
[...]
