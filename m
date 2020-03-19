Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98A18C090
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 20:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSTlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 15:41:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbgCSTlS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 15:41:18 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02JJYwRL086332
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 15:41:17 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yvcw9umnq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 15:41:16 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <linuxram@us.ibm.com>;
        Thu, 19 Mar 2020 19:41:15 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 19 Mar 2020 19:41:13 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02JJeBMm43385136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 19:40:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7604642047;
        Thu, 19 Mar 2020 19:41:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46BA242041;
        Thu, 19 Mar 2020 19:41:11 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.165.102])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Mar 2020 19:41:11 +0000 (GMT)
Date:   Thu, 19 Mar 2020 12:41:08 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200319043301.GA13052@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319043301.GA13052@blackberry>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20031919-4275-0000-0000-000003AF455E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031919-4276-0000-0000-000038C474F2
Message-Id: <20200319194108.GB5563@oc0525413822.ibm.com>
Subject: Re:  [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling secure
 guests
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_07:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 03:33:01PM +1100, Paul Mackerras wrote:
> At present, on Power systems with Protected Execution Facility
> hardware and an ultravisor, a KVM guest can transition to being a
> secure guest at will.  Userspace (QEMU) has no way of knowing
> whether a host system is capable of running secure guests.  This
> will present a problem in future when the ultravisor is capable of
> migrating secure guests from one host to another, because
> virtualization management software will have no way to ensure that
> secure guests only run in domains where all of the hosts can
> support secure guests.
> 
> This adds a VM capability which has two functions: (a) userspace
> can query it to find out whether the host can support secure guests,
> and (b) userspace can enable it for a guest, which allows that
> guest to become a secure guest.  If userspace does not enable it,
> KVM will return an error when the ultravisor does the hypercall
> that indicates that the guest is starting to transition to a
> secure guest.  The ultravisor will then abort the transition and
> the guest will terminate.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
> Note, only compile-tested.  Ram, please test.
> 
>  Documentation/virt/kvm/api.rst      | 17 +++++++++++++++++
>  arch/powerpc/include/asm/kvm_host.h |  1 +
>  arch/powerpc/include/asm/kvm_ppc.h  |  1 +
>  arch/powerpc/kvm/book3s_hv.c        | 13 +++++++++++++
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  4 ++++
>  arch/powerpc/kvm/powerpc.c          | 13 +++++++++++++
>  include/uapi/linux/kvm.h            |  1 +
>  7 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 158d118..a925500 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5779,6 +5779,23 @@ it hard or impossible to use it correctly.  The availability of
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
>  Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
> 
> +7.19 KVM_CAP_PPC_SECURE_GUEST
> +------------------------------
> +
> +:Architectures: ppc
> +
> +This capability indicates that KVM is running on a host that has
> +ultravisor firmware and thus can support a secure guest.  On such a
> +system, a guest can ask the ultravisor to make it a secure guest,
> +one whose memory is inaccessible to the host except for pages which
> +are explicitly requested to be shared with the host.  The ultravisor
> +notifies KVM when a guest requests to become a secure guest, and KVM
> +has the opportunity to veto the transition.
> +
> +If present, this capability can be enabled for a VM, meaning that KVM
> +will allow the transition to secure guest mode.  Otherwise KVM will
> +veto the transition.
> +
>  8. Other capabilities.
>  ======================
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 6e8b8ff..f99b433 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -303,6 +303,7 @@ struct kvm_arch {
>  	u8 radix;
>  	u8 fwnmi_enabled;
>  	u8 secure_guest;
> +	u8 svm_enabled;
>  	bool threads_indep;
>  	bool nested_enable;
>  	pgd_t *pgtable;
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 406ec46..0733618 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -316,6 +316,7 @@ struct kvmppc_ops {
>  			       int size);
>  	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  			      int size);
> +	int (*enable_svm)(struct kvm *kvm);
>  	int (*svm_off)(struct kvm *kvm);
>  };
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index fbc55a1..36da720 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5423,6 +5423,18 @@ static void unpin_vpa_reset(struct kvm *kvm, struct kvmppc_vpa *vpa)
>  }
> 
>  /*
> + * Enable a guest to become a secure VM.
> + * Called when the KVM_CAP_PPC_SECURE_GUEST capability is enabled.
> + */
> +static int kvmhv_enable_svm(struct kvm *kvm)
> +{
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		return -EINVAL;
> +	kvm->arch.svm_enabled = 1;
> +	return 0;
> +}
> +
> +/*
>   *  IOCTL handler to turn off secure mode of guest
>   *
>   * - Release all device pages
> @@ -5543,6 +5555,7 @@ static struct kvmppc_ops kvm_ops_hv = {
>  	.enable_nested = kvmhv_enable_nested,
>  	.load_from_eaddr = kvmhv_load_from_eaddr,
>  	.store_to_eaddr = kvmhv_store_to_eaddr,
> +	.enable_svm = kvmhv_enable_svm,
>  	.svm_off = kvmhv_svm_off,
>  };
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 79b1202..2ad999f 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -216,6 +216,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
>  	if (!kvm_is_radix(kvm))
>  		return H_UNSUPPORTED;
> 
> +	/* NAK the transition to secure if not enabled */
> +	if (!kvm->arch.svm_enabled)
> +		return H_AUTHORITY;
> +
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
>  	slots = kvm_memslots(kvm);
>  	kvm_for_each_memslot(memslot, slots) {
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 62ee66d..c32e6cc2 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);

We also need to check if the kvmppc_uvmem_init() has been successfully
called and initialized.

	r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR)
		&& kvmppc_uvmem_bitmap;

RP

