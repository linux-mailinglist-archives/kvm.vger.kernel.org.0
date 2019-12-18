Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3DB1245EF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 12:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfLRLjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 06:39:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfLRLjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 06:39:54 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIBbPW0100753
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 06:39:54 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wyjf7ab7e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 06:39:53 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 18 Dec 2019 11:39:51 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 11:39:45 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIBd1Qd45482342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 11:39:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0BFE4C046;
        Wed, 18 Dec 2019 11:39:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 182E94C044;
        Wed, 18 Dec 2019 11:39:44 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.119])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 11:39:44 +0000 (GMT)
Subject: Re: [PATCH v4 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-20-sean.j.christopherson@intel.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 xsFNBE6cPPgBEAC2VpALY0UJjGmgAmavkL/iAdqul2/F9ONz42K6NrwmT+SI9CylKHIX+fdf
 J34pLNJDmDVEdeb+brtpwC9JEZOLVE0nb+SR83CsAINJYKG3V1b3Kfs0hydseYKsBYqJTN2j
 CmUXDYq9J7uOyQQ7TNVoQejmpp5ifR4EzwIFfmYDekxRVZDJygD0wL/EzUr8Je3/j548NLyL
 4Uhv6CIPf3TY3/aLVKXdxz/ntbLgMcfZsDoHgDk3lY3r1iwbWwEM2+eYRdSZaR4VD+JRD7p8
 0FBadNwWnBce1fmQp3EklodGi5y7TNZ/CKdJ+jRPAAnw7SINhSd7PhJMruDAJaUlbYaIm23A
 +82g+IGe4z9tRGQ9TAflezVMhT5J3ccu6cpIjjvwDlbxucSmtVi5VtPAMTLmfjYp7VY2Tgr+
 T92v7+V96jAfE3Zy2nq52e8RDdUo/F6faxcumdl+aLhhKLXgrozpoe2nL0Nyc2uqFjkjwXXI
 OBQiaqGeWtxeKJP+O8MIpjyGuHUGzvjNx5S/592TQO3phpT5IFWfMgbu4OreZ9yekDhf7Cvn
 /fkYsiLDz9W6Clihd/xlpm79+jlhm4E3xBPiQOPCZowmHjx57mXVAypOP2Eu+i2nyQrkapaY
 IdisDQfWPdNeHNOiPnPS3+GhVlPcqSJAIWnuO7Ofw1ZVOyg/jwARAQABzUNDaHJpc3RpYW4g
 Qm9ybnRyYWVnZXIgKDJuZCBJQk0gYWRkcmVzcykgPGJvcm50cmFlZ2VyQGxpbnV4LmlibS5j
 b20+wsF5BBMBAgAjBQJdP/hMAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQEXu8
 gLWmHHy/pA/+JHjpEnd01A0CCyfVnb5fmcOlQ0LdmoKWLWPvU840q65HycCBFTt6V62cDljB
 kXFFxMNA4y/2wqU0H5/CiL963y3gWIiJsZa4ent+KrHl5GK1nIgbbesfJyA7JqlB0w/E/SuY
 NRQwIWOo/uEvOgXnk/7+rtvBzNaPGoGiiV1LZzeaxBVWrqLtmdi1iulW/0X/AlQPuF9dD1Px
 hx+0mPjZ8ClLpdSp5d0yfpwgHtM1B7KMuQPQZGFKMXXTUd3ceBUGGczsgIMipZWJukqMJiJj
 QIMH0IN7XYErEnhf0GCxJ3xAn/J7iFpPFv8sFZTvukntJXSUssONnwiKuld6ttUaFhSuSoQg
 OFYR5v7pOfinM0FcScPKTkrRsB5iUvpdthLq5qgwdQjmyINt3cb+5aSvBX2nNN135oGOtlb5
 tf4dh00kUR8XFHRrFxXx4Dbaw4PKgV3QLIHKEENlqnthH5t0tahDygQPnSucuXbVQEcDZaL9
 WgJqlRAAj0pG8M6JNU5+2ftTFXoTcoIUbb0KTOibaO9zHVeGegwAvPLLNlKHiHXcgLX1tkjC
 DrvE2Z0e2/4q7wgZgn1kbvz7ZHQZB76OM2mjkFu7QNHlRJ2VXJA8tMXyTgBX6kq1cYMmd/Hl
 OhFrAU3QO1SjCsXA2CDk9MM1471mYB3CTXQuKzXckJnxHkHOwU0ETpw8+AEQAJjyNXvMQdJN
 t07BIPDtbAQk15FfB0hKuyZVs+0lsjPKBZCamAAexNRk11eVGXK/YrqwjChkk60rt3q5i42u
 PpNMO9aS8cLPOfVft89Y654Qd3Rs1WRFIQq9xLjdLfHh0i0jMq5Ty+aiddSXpZ7oU6E+ud+X
 Czs3k5RAnOdW6eV3+v10sUjEGiFNZwzN9Udd6PfKET0J70qjnpY3NuWn5Sp1ZEn6lkq2Zm+G
 9G3FlBRVClT30OWeiRHCYB6e6j1x1u/rSU4JiNYjPwSJA8EPKnt1s/Eeq37qXXvk+9DYiHdT
 PcOa3aNCSbIygD3jyjkg6EV9ZLHibE2R/PMMid9FrqhKh/cwcYn9FrT0FE48/2IBW5mfDpAd
 YvpawQlRz3XJr2rYZJwMUm1y+49+1ZmDclaF3s9dcz2JvuywNq78z/VsUfGz4Sbxy4ShpNpG
 REojRcz/xOK+FqNuBk+HoWKw6OxgRzfNleDvScVmbY6cQQZfGx/T7xlgZjl5Mu/2z+ofeoxb
 vWWM1YCJAT91GFvj29Wvm8OAPN/+SJj8LQazd9uGzVMTz6lFjVtH7YkeW/NZrP6znAwv5P1a
 DdQfiB5F63AX++NlTiyA+GD/ggfRl68LheSskOcxDwgI5TqmaKtX1/8RkrLpnzO3evzkfJb1
 D5qh3wM1t7PZ+JWTluSX8W25ABEBAAHCwV8EGAECAAkFAk6cPPgCGwwACgkQEXu8gLWmHHz8
 2w//VjRlX+tKF3szc0lQi4X0t+pf88uIsvR/a1GRZpppQbn1jgE44hgF559K6/yYemcvTR7r
 6Xt7cjWGS4wfaR0+pkWV+2dbw8Xi4DI07/fN00NoVEpYUUnOnupBgychtVpxkGqsplJZQpng
 v6fauZtyEcUK3dLJH3TdVQDLbUcL4qZpzHbsuUnTWsmNmG4Vi0NsEt1xyd/Wuw+0kM/oFEH1
 4BN6X9xZcG8GYUbVUd8+bmio8ao8m0tzo4pseDZFo4ncDmlFWU6hHnAVfkAs4tqA6/fl7RLN
 JuWBiOL/mP5B6HDQT9JsnaRdzqF73FnU2+WrZPjinHPLeE74istVgjbowvsgUqtzjPIG5pOj
 cAsKoR0M1womzJVRfYauWhYiW/KeECklci4TPBDNx7YhahSUlexfoftltJA8swRshNA/M90/
 i9zDo9ySSZHwsGxG06ZOH5/MzG6HpLja7g8NTgA0TD5YaFm/oOnsQVsf2DeAGPS2xNirmknD
 jaqYefx7yQ7FJXXETd2uVURiDeNEFhVZWb5CiBJM5c6qQMhmkS4VyT7/+raaEGgkEKEgHOWf
 ZDP8BHfXtszHqI3Fo1F4IKFo/AP8GOFFxMRgbvlAs8z/+rEEaQYjxYJqj08raw6P4LFBqozr
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 18 Dec 2019 12:39:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191217204041.10815-20-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121811-0012-0000-0000-000003762703
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121811-0013-0000-0000-000021B2154B
Message-Id: <f962fafb-3956-746f-d077-3dbcefaae7c8@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_03:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.12.19 21:40, Sean Christopherson wrote:
> Add a KVM selftest to test moving the base gfn of a userspace memory
> region.  The test is primarily targeted at x86 to verify its memslot
> metadata is correctly updated, but also provides basic functionality
> coverage on other architectures.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  30 ++++
>  .../selftests/kvm/set_memory_region_test.c    | 142 ++++++++++++++++++
>  5 files changed, 177 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/set_memory_region_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 30072c3f52fb..6f60ceb81440 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -17,3 +17,4 @@
>  /clear_dirty_log_test
>  /dirty_log_test
>  /kvm_create_max_vcpus
> +/set_memory_region_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 3138a916574a..01c79e02c5b7 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -29,15 +29,18 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
> +TEST_GEN_PROGS_x86_64 += set_memory_region_test
> 
>  TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
>  TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
> +TEST_GEN_PROGS_aarch64 += set_memory_region_test
> 
>  TEST_GEN_PROGS_s390x = s390x/memop
>  TEST_GEN_PROGS_s390x += s390x/sync_regs_test
>  TEST_GEN_PROGS_s390x += dirty_log_test
>  TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
> +TEST_GEN_PROGS_s390x += set_memory_region_test
> 
>  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>  LIBKVM += $(LIBKVM_$(UNAME_M))
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 29cccaf96baf..15d3b8690ffb 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -100,6 +100,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
>  		void *arg);
>  void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> +void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  			  uint32_t data_memslot, uint32_t pgd_memslot);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 41cf45416060..464a75ce9843 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -756,6 +756,36 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
>  		ret, errno, slot, flags);
>  }
> 
> +/*
> + * VM Memory Region Move
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   slot - Slot of the memory region to move
> + *   flags - Starting guest physical address
> + *
> + * Output Args: None
> + *
> + * Return: None
> + *
> + * Change the gpa of a memory region.
> + */
> +void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
> +{
> +	struct userspace_mem_region *region;
> +	int ret;
> +
> +	region = memslot2region(vm, slot);
> +
> +	region->region.guest_phys_addr = new_gpa;
> +
> +	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
> +
> +	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
> +		    "ret: %i errno: %i slot: %u flags: 0x%x",
> +		    ret, errno, slot, new_gpa);
> +}
> +
>  /*
>   * VCPU mmap Size
>   *
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> new file mode 100644
> index 000000000000..c9603b95ccf7
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -0,0 +1,142 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <sched.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include <linux/compiler.h>
> +
> +#include <test_util.h>
> +#include <kvm_util.h>
> +#include <processor.h>
> +
> +#define VCPU_ID 0
> +
> +/*
> + * Somewhat arbitrary location and slot, intended to not overlap anything.  The
> + * location and size are specifically 2mb sized/aligned so that the initial
> + * region corresponds to exactly one large page (on x86 and arm64).
> + */
> +#define MEM_REGION_GPA		0xc0000000
> +#define MEM_REGION_SIZE		0x200000
> +#define MEM_REGION_SLOT		10
> +
> +static void guest_code(void)
> +{
> +	uint64_t val;
> +
> +	do {
> +		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
> +	} while (!val);
> +
> +	if (val != 1)
> +		ucall(UCALL_ABORT, 1, val);
> +
> +	GUEST_DONE();
> +}
> +
> +static void *vcpu_worker(void *data)
> +{
> +	struct kvm_vm *vm = data;
> +	struct kvm_run *run;
> +	struct ucall uc;
> +	uint64_t cmd;
> +
> +	/*
> +	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
> +	 * which will occur if the guest attempts to access a memslot while it
> +	 * is being moved.
> +	 */
> +	run = vcpu_state(vm, VCPU_ID);
> +	do {
> +		vcpu_run(vm, VCPU_ID);
> +	} while (run->exit_reason == KVM_EXIT_MMIO);
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +		    "Unexpected exit reason = %d", run->exit_reason);


This will also not work for s390. Maybe just make this test x86 specific for now?

