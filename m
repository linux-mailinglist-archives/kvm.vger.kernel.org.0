Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88151559E95
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiFXQbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiFXQbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:31:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9972350B2F;
        Fri, 24 Jun 2022 09:31:42 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OGSMra016294;
        Fri, 24 Jun 2022 16:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N7kkXBKAKxWujWpwIUjPyI+viTC2gKWpM5K480E82jU=;
 b=rIsO6cCHs6O5P09ZNkOw02jxloELx+7IhCh3H8wTeKuodSkJFTBU2/34wKO1eh79/Z51
 R9mv6Bi+fA0S2D7adpvhwgbOlXF03FyDQDBjZlejDExBvfD4wyLbBFzz1qHWFFvgx2rE
 iBnwVzXqL+s1hmB8d5mYVS89oVWFideE9jhdAO3+bYRedg8nK1ZcLOfY25XYYlVd6oR2
 5WGraxsMURHhRuIWvAKh9TtyE7BtCJ/xK1YYzyQKcV5SyXckeVHf7ztucSnWnpdrWuRZ
 zfqZdkrnFaLsbm4MZiPWVlPyjP+ibovBbEsTsyO0LDuaNfFJRa5XCdehzseGpBDUjVEj CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwgts01hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OGVf7t028955;
        Fri, 24 Jun 2022 16:31:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwgts01h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OGKFHc020989;
        Fri, 24 Jun 2022 16:31:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gvtjp9bjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OGVZdM18874720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:31:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA91D4C044;
        Fri, 24 Jun 2022 16:31:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F6164C040;
        Fri, 24 Jun 2022 16:31:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 16:31:35 +0000 (GMT)
Date:   Fri, 24 Jun 2022 11:32:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Message-ID: <20220624113225.019a9294@p-imbrenda>
In-Reply-To: <20220620125437.37122-3-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
        <20220620125437.37122-3-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7DUD0QhrpGZOJI0FiexF3DYHuljzFs7Y
X-Proofpoint-GUID: HqEWnPW8oud8PUj-mVoKu8KGFYQHEcHq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_08,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240064
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jun 2022 14:54:36 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We report a topology change to the guest for any CPU hotplug.
> 
> The reporting to the guest is done using the Multiprocessor
> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
> SCA which will be cleared during the interpretation of PTF.
> 
> On every vCPU creation we set the MCTR bit to let the guest know the
> next time he uses the PTF with command 2 instruction that the
> topology changed and that he should use the STSI(15.1.x) instruction
> to get the topology details.
> 
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> support the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>  arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>  arch/s390/kvm/priv.c             | 15 +++++++++++----
>  arch/s390/kvm/vsie.c             |  3 +++
>  4 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 766028d54a3e..bb54196d4ed6 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -97,15 +97,19 @@ struct bsca_block {
>  	union ipte_control ipte_control;
>  	__u64	reserved[5];
>  	__u64	mcn;
> -	__u64	reserved2;
> +#define SCA_UTILITY_MTCR	0x8000
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
> @@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
>  #define ECB_SPECI	0x08
>  #define ECB_SRSI	0x04
>  #define ECB_HOSTPROTINT	0x02
> +#define ECB_PTF		0x01
>  	__u8	ecb;			/* 0x0061 */
>  #define ECB2_CMMA	0x80
>  #define ECB2_IEP	0x20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8fcb56141689..95b96019ca8e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>  	return ret;
>  }
>  
> +/**
> + * kvm_s390_sca_set_mtcr

the format for kdoc is:

	function_name - very short description

please add a very short description. something like:

	kvm_s390_sca_set_mtcr - update mtcr to signal topology change

> + * @kvm: guest KVM description
> + *
> + * Is only relevant if the topology facility is present,
> + * the caller should check KVM facility 11
> + *
> + * Updates the Multiprocessor Topology-Change-Report to signal
> + * the guest with a topology change.
> + */
> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +
> +	ipte_lock(kvm);
> +	sca->utility |= SCA_UTILITY_MTCR;
> +	ipte_unlock(kvm);
> +}
> +
>  static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>  {
>  	int ret;
> @@ -3143,7 +3162,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> -
>  	gmap_enable(vcpu->arch.enabled_gmap);
>  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
> @@ -3272,6 +3290,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>  	if (test_kvm_facility(vcpu->kvm, 9))
>  		vcpu->arch.sie_block->ecb |= ECB_SRSI;
> +
> +	/* PTF needs guest facilities to enable interpretation */
> +	if (test_kvm_facility(vcpu->kvm, 11))
> +		vcpu->arch.sie_block->ecb |= ECB_PTF;
> +
>  	if (test_kvm_facility(vcpu->kvm, 73))
>  		vcpu->arch.sie_block->ecb |= ECB_TE;
>  	if (!kvm_is_ucontrol(vcpu->kvm))
> @@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	rc = kvm_s390_vcpu_setup(vcpu);
>  	if (rc)
>  		goto out_ucontrol_uninit;
> +
> +	kvm_s390_sca_set_mtcr(vcpu->kvm);
>  	return 0;
>  
>  out_ucontrol_uninit:
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 12c464c7cddf..77a692238585 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>  
> -	if (fc > 3) {
> -		kvm_s390_set_psw_cc(vcpu, 3);
> -		return 0;
> -	}
> +	/* Bailout forbidden function codes */
> +	if (fc > 3 && fc != 15)
> +		goto out_no_data;
> +
> +	/* fc 15 is provided with PTF/CPU topology support */
> +	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
> +		goto out_no_data;
>  
>  	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
>  	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
> @@ -910,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
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
> index dada78b92691..4f4fee697550 100644
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

