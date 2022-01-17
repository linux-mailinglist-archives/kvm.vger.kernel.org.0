Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCCC490CA8
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiAQQvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 11:51:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235348AbiAQQvg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:51:36 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HERJca029155;
        Mon, 17 Jan 2022 16:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ELIJgYo+OZUIhdo/NUiebs+y+VUSEoZj1EtWH3+1wZM=;
 b=WU24718l8rtJ4DA7v+LjXYqjRRZTNY4LHuQcEprUOl9627R+HMZz7wfFTqj2r9+8xioy
 H1BOcaDXdU/7On5wnM+FFp/p1m6SaSro+HA1XdyVqOLmBQRp6CvuxiOimr2L+8DKk3l3
 c4n9UPEgH1tYs+pwAozbc9iJ3h917GAPenB3q2knK+9zICfxoUoTXc3wTUdQhnfJJKPX
 rGdZH3Qa2cvHHl+AFMTMAmaEDzwkyba4ln2Vubx2+Y010Cx7nZ0NmHZZPp5ZEQN3gBnV
 xK4G9csTIDXgVjHPdvWi6isdpKfupvcrrFeuHsFmKqUl+D/WOGX6pERVKwSOYvBczjMM Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dna813r95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:51:23 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGj4tM009440;
        Mon, 17 Jan 2022 16:51:22 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dna813r8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:51:22 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGmmNK000712;
        Mon, 17 Jan 2022 16:51:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3dknw8w5p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:51:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGpIld37945740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:51:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2376411C05C;
        Mon, 17 Jan 2022 16:51:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E6CA11C052;
        Mon, 17 Jan 2022 16:51:14 +0000 (GMT)
Received: from [9.171.34.22] (unknown [9.171.34.22])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:51:14 +0000 (GMT)
Message-ID: <d47dc156-405f-77c5-787a-99073053a06b@linux.ibm.com>
Date:   Mon, 17 Jan 2022 17:51:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 19/21] kvm: selftests: Add support for KVM_CAP_XSAVE2
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-20-pbonzini@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220107185512.25321-20-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h_GrhG0RD4aQdEPLZtYeWLl4ClQ71j35
X-Proofpoint-ORIG-GUID: 77OMc0kDnJFya5YmZvXemjyQ5ZWeq1pl
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1011 impostorscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 19:55, Paolo Bonzini wrote:
> From: Wei Wang <wei.w.wang@intel.com>
> 
> When KVM_CAP_XSAVE2 is supported, userspace is expected to allocate
> buffer for KVM_GET_XSAVE2 and KVM_SET_XSAVE using the size returned
> by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: Guang Zeng <guang.zeng@intel.com>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> Message-Id: <20220105123532.12586-20-yang.zhong@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/arch/x86/include/uapi/asm/kvm.h         | 16 ++++-
>  tools/include/uapi/linux/kvm.h                |  3 +
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  .../selftests/kvm/include/x86_64/processor.h  | 10 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++
>  .../selftests/kvm/lib/x86_64/processor.c      | 67 ++++++++++++++++++-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
>  .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
>  .../kvm/x86_64/vmx_preemption_timer_test.c    |  2 +-
>  10 files changed, 130 insertions(+), 8 deletions(-)
> 

[...]

> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 1e5ab6a92848..66775de26952 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -103,6 +103,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
>  int open_path_or_exit(const char *path, int flags);
>  int open_kvm_dev_path_or_exit(void);
>  int kvm_check_cap(long cap);
> +int vm_check_cap(struct kvm_vm *vm, long cap);
>  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
>  		    struct kvm_enable_cap *cap);
> @@ -344,6 +345,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>   *   guest_code - The vCPU's entry point
>   */
>  void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
> +void vm_xsave_req_perm(void);
> 
>  bool vm_is_unrestricted_guest(struct kvm_vm *vm);
> 

[...]

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ecc53d108ad8..4a645dc77f34 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -85,6 +85,33 @@ int kvm_check_cap(long cap)
>  	return ret;
>  }
> 
> +/* VM Check Capability
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   cap - Capability
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   On success, the Value corresponding to the capability (KVM_CAP_*)
> + *   specified by the value of cap.  On failure a TEST_ASSERT failure
> + *   is produced.
> + *
> + * Looks up and returns the value corresponding to the capability
> + * (KVM_CAP_*) given by cap.
> + */
> +int vm_check_cap(struct kvm_vm *vm, long cap)
> +{
> +	int ret;
> +
> +	ret = ioctl(vm->fd, KVM_CHECK_EXTENSION, cap);
> +	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION VM IOCTL failed,\n"
> +		"  rc: %i errno: %i", ret, errno);
> +
> +	return ret;
> +}
> +
>  /* VM Enable Capability
>   *
>   * Input Args:
> @@ -366,6 +393,11 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  	struct kvm_vm *vm;
>  	int i;
> 
> +	/*
> +	 * Permission needs to be requested before KVM_SET_CPUID2.
> +	 */
> +	vm_xsave_req_perm();
> +

Since

79e06c4c4950 (Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm)

on s390x I'm getting:

/usr/bin/ld: tools/testing/selftests/kvm/libkvm.a(kvm_util.o): in function `vm_create_with_vcpus':
tools/testing/selftests/kvm/lib/kvm_util.c:399: undefined reference to `vm_xsave_req_perm'
collect2: error: ld returned 1 exit status
make: *** [../lib.mk:146: tools/testing/selftests/kvm/s390x/memop] Error 1

Looks like it only exists for x86.
v2 had a comment about unconditional enablement:
https://lore.kernel.org/kvm/e20f590b-b9d9-237d-3b9c-77dd82a24b40@redhat.com/

Thanks for having a look.

>  	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
>  	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
>  		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index eef7b34756d5..f19d6d201977 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -650,6 +650,45 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid)
>  	vcpu_sregs_set(vm, vcpuid, &sregs);
>  }
> 
> +#define CPUID_XFD_BIT (1 << 4)
> +static bool is_xfd_supported(void)
> +{
> +	int eax, ebx, ecx, edx;
> +	const int leaf = 0xd, subleaf = 0x1;
> +
> +	__asm__ __volatile__(
> +		"cpuid"
> +		: /* output */ "=a"(eax), "=b"(ebx),
> +		  "=c"(ecx), "=d"(edx)
> +		: /* input */ "0"(leaf), "2"(subleaf));
> +
> +	return !!(eax & CPUID_XFD_BIT);
> +}
> +
> +void vm_xsave_req_perm(void)
> +{
> +	unsigned long bitmask;
> +	long rc;
> +
> +	if (!is_xfd_supported())
> +		return;
> +
> +	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM,
> +		     XSTATE_XTILE_DATA_BIT);
> +	/*
> +	 * The older kernel version(<5.15) can't support
> +	 * ARCH_REQ_XCOMP_GUEST_PERM and directly return.
> +	 */
> +	if (rc)
> +		return;
> +
> +	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
> +	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
> +	TEST_ASSERT(bitmask & XFEATURE_XTILE_MASK,
> +		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
> +		    bitmask);
> +}
> +

[...]
