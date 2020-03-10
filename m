Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DB17F93D
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 13:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgCJMy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 08:54:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729425AbgCJMy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 08:54:57 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ACnh3h130136
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 08:54:55 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ynra45eg0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 08:54:54 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 10 Mar 2020 12:54:52 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 12:54:49 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ACsmQD51904658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 12:54:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93CEDA405F;
        Tue, 10 Mar 2020 12:54:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5272BA405C;
        Tue, 10 Mar 2020 12:54:48 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.141])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 12:54:48 +0000 (GMT)
Subject: Re: [PATCH 3/4] KVM: selftests: Enable printf format warnings for
 TEST_ASSERT
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, peterx@redhat.com, thuth@redhat.com
References: <20200310091556.4701-1-drjones@redhat.com>
 <20200310091556.4701-4-drjones@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 10 Mar 2020 13:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310091556.4701-4-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031012-0020-0000-0000-000003B2506E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031012-0021-0000-0000-0000220A9C1D
Message-Id: <294eca4f-ef1e-9452-8c45-c0ed708abac0@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.03.20 10:15, Andrew Jones wrote:
> Use the format attribute to enable printf format warnings, and
> then fix them all.

(for x86).

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>  tools/testing/selftests/kvm/demand_paging_test.c          | 2 +-
>  tools/testing/selftests/kvm/include/test_util.h           | 3 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c                | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 4 ++--
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c         | 2 +-
>  .../testing/selftests/kvm/x86_64/set_memory_region_test.c | 3 +--
>  tools/testing/selftests/kvm/x86_64/state_test.c           | 4 ++--
>  tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c      | 3 +--
>  tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c   | 2 +-
>  .../selftests/kvm/x86_64/vmx_set_nested_state_test.c      | 2 +-
>  10 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index c1e326d3ed7f..47654071544c 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -388,7 +388,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>  	 */
>  	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
>  		    "Requested more guest memory than address space allows.\n"
> -		    "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",
> +		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
>  		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
>  		    vcpu_memory_bytes);
>  
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index c921ea719ae0..07823740227b 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -37,7 +37,8 @@ ssize_t test_read(int fd, void *buf, size_t count);
>  int test_seq_read(const char *path, char **bufp, size_t *sizep);
>  
>  void test_assert(bool exp, const char *exp_str,
> -		 const char *file, unsigned int line, const char *fmt, ...);
> +		 const char *file, unsigned int line, const char *fmt, ...)
> +		__attribute__((format(printf, 5, 6)));
>  
>  #define TEST_ASSERT(e, fmt, ...) \
>  	test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 69a28a9211b4..b29c5d338555 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -265,7 +265,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
>  		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
>  			    "  rc: %i errno: %i\n"
>  			    "  slot: %u flags: 0x%x\n"
> -			    "  guest_phys_addr: 0x%lx size: 0x%lx",
> +			    "  guest_phys_addr: 0x%llx size: 0x%llx",
>  			    ret, errno, region->region.slot,
>  			    region->region.flags,
>  			    region->region.guest_phys_addr,
> @@ -280,7 +280,7 @@ void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
>  
>  	ret = ioctl(vm->fd, KVM_GET_DIRTY_LOG, &args);
>  	TEST_ASSERT(ret == 0, "%s: KVM_GET_DIRTY_LOG failed: %s",
> -		    strerror(-ret));
> +		    __func__, strerror(-ret));
>  }
>  
>  void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
> @@ -293,7 +293,7 @@ void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
>  
>  	ret = ioctl(vm->fd, KVM_CLEAR_DIRTY_LOG, &args);
>  	TEST_ASSERT(ret == 0, "%s: KVM_CLEAR_DIRTY_LOG failed: %s",
> -		    strerror(-ret));
> +		    __func__, strerror(-ret));
>  }
>  
>  /*
> @@ -785,7 +785,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
>  	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
>  
>  	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
> -		    "ret: %i errno: %i slot: %u flags: 0x%x",
> +		    "ret: %i errno: %i slot: %u flags: 0x%lx",
>  		    ret, errno, slot, new_gpa);
>  }
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index 185226c39c03..464a55217085 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -109,7 +109,7 @@ int main(int argc, char *argv[])
>  
>  		switch (get_ucall(vm, VCPU_ID, &uc)) {
>  		case UCALL_ABORT:
> -			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
> +			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
>  				    __FILE__, uc.args[1]);
>  			/* NOT REACHED */
>  		case UCALL_SYNC:
> @@ -122,7 +122,7 @@ int main(int argc, char *argv[])
>  
>  		/* UCALL_SYNC is handled here.  */
>  		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
> -			    uc.args[1] == stage, "Unexpected register values vmexit #%lx, got %lx",
> +			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
>  			    stage, (ulong)uc.args[1]);
>  
>  		state = vcpu_save_state(vm, VCPU_ID);
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 443a2b54645b..3edf3b517f9f 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -66,7 +66,7 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
>  
>  		TEST_ASSERT((entry->function >= 0x40000000) &&
>  			    (entry->function <= 0x4000000A),
> -			    "function %lx is our of supported range",
> +			    "function %x is our of supported range",
>  			    entry->function);
>  
>  		TEST_ASSERT(entry->index == 0,
> diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> index 125aeab59ab6..f2efaa576794 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> @@ -61,8 +61,7 @@ static void *vcpu_worker(void *data)
>  		    "Unexpected exit reason = %d", run->exit_reason);
>  
>  	cmd = get_ucall(vm, VCPU_ID, &uc);
> -	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %llu",
> -		    uc.args[0]);
> +	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %lu", uc.args[0]);
>  	return NULL;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 164774206170..a4dc1ee59659 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -152,7 +152,7 @@ int main(int argc, char *argv[])
>  
>  		switch (get_ucall(vm, VCPU_ID, &uc)) {
>  		case UCALL_ABORT:
> -			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
> +			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
>  				    __FILE__, uc.args[1]);
>  			/* NOT REACHED */
>  		case UCALL_SYNC:
> @@ -165,7 +165,7 @@ int main(int argc, char *argv[])
>  
>  		/* UCALL_SYNC is handled here.  */
>  		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
> -			    uc.args[1] == stage, "Unexpected register values vmexit #%lx, got %lx",
> +			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
>  			    stage, (ulong)uc.args[1]);
>  
>  		state = vcpu_save_state(vm, VCPU_ID);
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> index e280f68f6365..8cd841ff6305 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> @@ -69,8 +69,7 @@ int main(int argc, char *argv[])
>  		case UCALL_DONE:
>  			goto done;
>  		default:
> -			TEST_ASSERT(false,
> -				    "Unknown ucall 0x%x.", uc.cmd);
> +			TEST_ASSERT(false, "Unknown ucall 0x%lx.", uc.cmd);
>  		}
>  	}
>  done:
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> index fe0734d9ef75..d9ca948d0b72 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
> @@ -126,7 +126,7 @@ int main(int argc, char *argv[])
>  
>  		switch (get_ucall(vm, VCPU_ID, &uc)) {
>  		case UCALL_ABORT:
> -			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
> +			TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
>  				    __FILE__, uc.args[1]);
>  			/* NOT REACHED */
>  		case UCALL_SYNC:
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> index 9ef7fab39d48..7962f2fe575d 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> @@ -212,7 +212,7 @@ void test_vmx_nested_state(struct kvm_vm *vm)
>  	test_nested_state(vm, state);
>  	vcpu_nested_state_get(vm, VCPU_ID, state);
>  	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
> -		    "Size must be between %d and %d.  The size returned was %d.",
> +		    "Size must be between %ld and %d.  The size returned was %d.",
>  		    sizeof(*state), state_sz, state->size);
>  	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
>  	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
> 

