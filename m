Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170594EDA1
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 19:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfFURNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 13:13:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfFURNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 13:13:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGxiV8069356;
        Fri, 21 Jun 2019 17:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=eyXJDCIHrjHQk5EczsZdfCWhosVccfS5kBF1Lk03GhU=;
 b=YilwLpQKkNc7CKnovN8XLd7SApjQyCfkiBm8VxcG4Eea6CskL21aI9lrc9lg3km1wYkS
 KTxsW6Jk9bP1UUYYZHl6mGWWKkLO6pVub6OHzTSeoJMfPDgojtTImd0c6bIS1yKEV3QN
 LqXUMy3f6V+nSZphz5LHaaeKNNa0I0ARKao5RrcVsk7S0OcNHdyKTHbc+PXB2MuSEsUK
 B0w0Y8Xl0OjXUjVOP5Ylg8FXJwa7DteK62uWYfjsvKBJ5LwIgsT++VwPMiZYFMmnvuh/
 PGwfJVMM6Y21tGOsuPDqgTqs3DjtGQRUvdX1BesoPdTFd1kR/KuRcpAm5r/mRrel+Wgy Vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809qk1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 17:13:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LHDG9i083476;
        Fri, 21 Jun 2019 17:13:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ypadw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 17:13:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LHDX1S021695;
        Fri, 21 Jun 2019 17:13:34 GMT
Received: from [10.159.155.215] (/10.159.155.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 10:13:33 -0700
Subject: Re: [PATCH] tests: kvm: Check for a kernel warning
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
References: <20190531141452.158909-1-aaronlewis@google.com>
 <CAAAPnDHLk=8SMKVy9-mPWWt2t+WX4xS+BKLQJox7vbnHwK50BA@mail.gmail.com>
 <4fdb4b8f-2c8e-c148-6f94-cb51d620a49b@oracle.com>
 <CAAAPnDERqGrYJoe4nUP9FefHGx4Wx=ioKiiSwBy0iimbvqwJLw@mail.gmail.com>
 <8774fa34-fccd-5828-026e-af91f3f0fa40@oracle.com>
 <CAAAPnDGcGrKnrrUowWgBz6aKEv0YrE02rHgBMLEKsd-=5L77iw@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <13260008-ac11-e96a-013b-dde2a8553a60@oracle.com>
Date:   Fri, 21 Jun 2019 10:13:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDGcGrKnrrUowWgBz6aKEv0YrE02rHgBMLEKsd-=5L77iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/20/19 12:47 PM, Aaron Lewis wrote:
> On Thu, Jun 20, 2019 at 11:17 AM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 6/20/19 7:12 AM, Aaron Lewis wrote:
>>> On Tue, Jun 18, 2019 at 12:38 PM Krish Sadhukhan
>>> <krish.sadhukhan@oracle.com> wrote:
>>>>
>>>> On 06/18/2019 07:13 AM, Aaron Lewis wrote:
>>>>> On Fri, May 31, 2019 at 7:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>>>>>> When running with /sys/module/kvm_intel/parameters/unrestricted_guest=N,
>>>>>> test that a kernel warning does not occur informing us that
>>>>>> vcpu->mmio_needed=1.  This can happen when KVM_RUN is called after a
>>>>>> triple fault.
>>>>>> This test was made to detect a bug that was reported by Syzkaller
>>>>>> (https://groups.google.com/forum/#!topic/syzkaller/lHfau8E3SOE) and
>>>>>> fixed with commit bbeac2830f4de ("KVM: X86: Fix residual mmio emulation
>>>>>> request to userspace").
>>>>>>
>>>>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>>>> Reviewed-by: Peter Shier <pshier@google.com>
>>>>>> ---
>>>>>>     tools/testing/selftests/kvm/.gitignore        |   1 +
>>>>>>     tools/testing/selftests/kvm/Makefile          |   1 +
>>>>>>     .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>>>>>>     .../selftests/kvm/include/x86_64/processor.h  |   2 +
>>>>>>     tools/testing/selftests/kvm/lib/kvm_util.c    |  36 +++++
>>>>>>     .../selftests/kvm/lib/x86_64/processor.c      |  16 +++
>>>>>>     .../selftests/kvm/x86_64/mmio_warning_test.c  | 126 ++++++++++++++++++
>>>>>>     7 files changed, 184 insertions(+)
>>>>>>     create mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
>>>>>> index df1bf9230a74..41266af0d3dc 100644
>>>>>> --- a/tools/testing/selftests/kvm/.gitignore
>>>>>> +++ b/tools/testing/selftests/kvm/.gitignore
>>>>>> @@ -2,6 +2,7 @@
>>>>>>     /x86_64/evmcs_test
>>>>>>     /x86_64/hyperv_cpuid
>>>>>>     /x86_64/kvm_create_max_vcpus
>>>>>> +/x86_64/mmio_warning_test
>>>>>>     /x86_64/platform_info_test
>>>>>>     /x86_64/set_sregs_test
>>>>>>     /x86_64/smm_test
>>>>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>>>>>> index 79c524395ebe..670b938f1049 100644
>>>>>> --- a/tools/testing/selftests/kvm/Makefile
>>>>>> +++ b/tools/testing/selftests/kvm/Makefile
>>>>>> @@ -22,6 +22,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>>>>>     TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>>>>>     TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
>>>>>>     TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>>>>>>     TEST_GEN_PROGS_x86_64 += dirty_log_test
>>>>>>     TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>>>>>> index 8c6b9619797d..c5c427c86598 100644
>>>>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>>>>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>>>>>> @@ -137,6 +137,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
>>>>>>                                     void *guest_code);
>>>>>>     void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
>>>>>>
>>>>>> +bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>>>>>> +
>>>>>>     struct kvm_userspace_memory_region *
>>>>>>     kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>>>>>>                                     uint64_t end);
>>>>>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>>>>>> index 6063d5b2f356..af4d26de32d1 100644
>>>>>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>>>>>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>>>>>> @@ -303,6 +303,8 @@ static inline unsigned long get_xmm(int n)
>>>>>>            return 0;
>>>>>>     }
>>>>>>
>>>>>> +bool is_intel_cpu(void);
>>>>>> +
>>>>>>     struct kvm_x86_state;
>>>>>>     struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
>>>>>>     void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
>>>>>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>>>>>> index e9113857f44e..b93b09ad9a11 100644
>>>>>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>>>>>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>>>>>> @@ -1584,3 +1584,39 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
>>>>>>     {
>>>>>>            return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
>>>>>>     }
>>>>>> +
>>>>>> +/*
>>>>>> + * Is Unrestricted Guest
>>>>>> + *
>>>>>> + * Input Args:
>>>>>> + *   vm - Virtual Machine
>>>>>> + *
>>>>>> + * Output Args: None
>>>>>> + *
>>>>>> + * Return: True if the unrestricted guest is set to 'Y', otherwise return false.
>>>>>> + *
>>>>>> + * Check if the unrestricted guest flag is enabled.
>>>>>> + */
>>>>>> +bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>>>>>> +{
>>>>>> +       char val = 'N';
>>>>>> +       size_t count;
>>>>>> +       FILE *f;
>>>>>> +
>>>>>> +       if (vm == NULL) {
>>>>>> +               /* Ensure that the KVM vendor-specific module is loaded. */
>>>>>> +               f = fopen(KVM_DEV_PATH, "r");
>>>>>> +               TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
>>>>>> +                           errno);
>>>>>> +               fclose(f);
>>>>>> +       }
>>>>>> +
>>>>>> +       f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
>>>>>> +       if (f) {
>>>>>> +               count = fread(&val, sizeof(char), 1, f);
>>>>>> +               TEST_ASSERT(count == 1, "Unable to read from param file.");
>>>>>> +               fclose(f);
>>>>>> +       }
>>>>>> +
>>>>>> +       return val == 'Y';
>>>>>> +}
>>>>>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>>>>>> index dc7fae9fa424..bcc0e70e1856 100644
>>>>>> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>>>>>> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>>>>>> @@ -1139,3 +1139,19 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
>>>>>>                            r);
>>>>>>            }
>>>>>>     }
>>>>>> +
>>>>>> +bool is_intel_cpu(void)
>>>>>> +{
>>>>>> +       int eax, ebx, ecx, edx;
>>>>>> +       const uint32_t *chunk;
>>>>>> +       const int leaf = 0;
>>>>>> +
>>>>>> +       __asm__ __volatile__(
>>>>>> +               "cpuid"
>>>>>> +               : /* output */ "=a"(eax), "=b"(ebx),
>>>>>> +                 "=c"(ecx), "=d"(edx)
>>>>>> +               : /* input */ "0"(leaf), "2"(0));
>>>>>> +
>>>>>> +       chunk = (const uint32_t *)("GenuineIntel");
>>>>>> +       return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
>>>>>> +}
>>>>>> diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
>>>>>> new file mode 100644
>>>>>> index 000000000000..00bb97d76000
>>>>>> --- /dev/null
>>>>>> +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
>>>>>> @@ -0,0 +1,126 @@
>>>>>> +/*
>>>>>> + * mmio_warning_test
>>>>>> + *
>>>>>> + * Copyright (C) 2019, Google LLC.
>>>>>> + *
>>>>>> + * This work is licensed under the terms of the GNU GPL, version 2.
>>>>>> + *
>>>>>> + * Test that we don't get a kernel warning when we call KVM_RUN after a
>>>>>> + * triple fault occurs.  To get the triple fault to occur we call KVM_RUN
>>>>>> + * on a VCPU that hasn't been properly setup.
>>>>>> + *
>>>>>> + */
>>>>>> +
>>>>>> +#define _GNU_SOURCE
>>>>>> +#include <fcntl.h>
>>>>>> +#include <kvm_util.h>
>>>>>> +#include <linux/kvm.h>
>>>>>> +#include <processor.h>
>>>>>> +#include <pthread.h>
>>>>>> +#include <stdio.h>
>>>>>> +#include <stdlib.h>
>>>>>> +#include <string.h>
>>>>>> +#include <sys/ioctl.h>
>>>>>> +#include <sys/mman.h>
>>>>>> +#include <sys/stat.h>
>>>>>> +#include <sys/types.h>
>>>>>> +#include <sys/wait.h>
>>>>>> +#include <test_util.h>
>>>>>> +#include <unistd.h>
>>>>>> +
>>>>>> +#define NTHREAD 4
>>>>>> +#define NPROCESS 5
>>>>>> +
>>>>>> +struct thread_context {
>>>>>> +       int kvmcpu;
>>>>>> +       struct kvm_run *run;
>>>>>> +};
>>>>>> +
>>>>>> +void *thr(void *arg)
>>>>>> +{
>>>>>> +       struct thread_context *tc = (struct thread_context *)arg;
>>>>>> +       int res;
>>>>>> +       int kvmcpu = tc->kvmcpu;
>>>>>> +       struct kvm_run *run = tc->run;
>>>>>> +
>>>>>> +       res = ioctl(kvmcpu, KVM_RUN, 0);
>>>>>> +       printf("ret1=%d exit_reason=%d suberror=%d\n",
>>>>>> +               res, run->exit_reason, run->internal.suberror);
>>>>>> +
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
>>>>>> +void test(void)
>>>>>> +{
>>>>>> +       int i, kvm, kvmvm, kvmcpu;
>>>>>> +       pthread_t th[NTHREAD];
>>>>>> +       struct kvm_run *run;
>>>>>> +       struct thread_context tc;
>>>>>> +
>>>>>> +       kvm = open("/dev/kvm", O_RDWR);
>>>>>> +       TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
>>>>>> +       kvmvm = ioctl(kvm, KVM_CREATE_VM, 0);
>>>>>> +       TEST_ASSERT(kvmvm != -1, "KVM_CREATE_VM failed");
>>>>>> +       kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
>>>>>> +       TEST_ASSERT(kvmcpu != -1, "KVM_CREATE_VCPU failed");
>>>>>> +       run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
>>>>>> +                                   kvmcpu, 0);
>>>>>> +       tc.kvmcpu = kvmcpu;
>>>>>> +       tc.run = run;
>>>>>> +       srand(getpid());
>>>>>> +       for (i = 0; i < NTHREAD; i++) {
>>>>>> +               pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
>>>>>> +               usleep(rand() % 10000);
>>>>>> +       }
>>>>>> +       for (i = 0; i < NTHREAD; i++)
>>>>>> +               pthread_join(th[i], NULL);
>>>>>> +}
>>>>>> +
>>>>>> +int get_warnings_count(void)
>>>>>> +{
>>>>>> +       int warnings;
>>>>>> +       FILE *f;
>>>>>> +
>>>>>> +       f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
>>>>>> +       fscanf(f, "%d", &warnings);
>>>>>> +       fclose(f);
>>>>>> +
>>>>>> +       return warnings;
>>>>>> +}
>>>>>> +
>>>>>> +int main(void)
>>>>>> +{
>>>>>> +       int warnings_before, warnings_after;
>>>>>> +
>>>>>> +       if (!is_intel_cpu()) {
>>>>>> +               printf("Must be run on an Intel CPU, skipping test\n");
>>>>>> +               exit(KSFT_SKIP);
>>>>>> +       }
>>>>>> +
>>>>>> +       if (vm_is_unrestricted_guest(NULL)) {
>>>>>> +               printf("Unrestricted guest must be disabled, skipping test\n");
>>>>>> +               exit(KSFT_SKIP);
>>>>>> +       }
>>>>>> +
>>>>>> +       warnings_before = get_warnings_count();
>>>>>> +
>>>>>> +       for (int i = 0; i < NPROCESS; ++i) {
>>>>>> +               int status;
>>>>>> +               int pid = fork();
>>>>>> +
>>>>>> +               if (pid < 0)
>>>>>> +                       exit(1);
>>>>>> +               if (pid == 0) {
>>>>>> +                       test();
>>>>>> +                       exit(0);
>>>>>> +               }
>>>>>> +               while (waitpid(pid, &status, __WALL) != pid)
>>>>>> +                       ;
>>>>>> +       }
>>>>>> +
>>>>>> +       warnings_after = get_warnings_count();
>>>> Since you are grep'ing for the word "WARNING",  is there a possibility
>>>> that the test can detect a false positive based on Warnings generated
>>>> due to some other cause while it ran ?
>>>>
>>> Yes, this is a possibility, however, it is still a warning and should
>>> still be dealt with.  We could special case the grep message to be
>>> more specific to the case we are dealing with here, but I'd prefer to
>>> keep it this way to alert on any warning.  That way other warnings,
>>> should they occur, are brought to our attention.
>>
>> OK.  In that case, does it make sense to provide some additional info in
>> the ASSERT message below ? dmesg can contain Warnings that may have
>> occurred either before or after the run of this test and so we can at
>> least link the false positives to this test.
>>
> I can go either way on this.  While there can be false positives in
> dmesg, if this asset fires there will be warnings worth looking at and
> addressing as it only fires if it detects warnings occurred during the
> test.  That's the reason I made the asset message general and only say
> to look at warnings.  We could add a more long winded message to the
> end of this informing the user that because the test doesn't clear
> dmesg there could be warnings not related to the test.  However, there
> will be warnings caused by running this test as well.


Yes, a little more info will certainly help in debugging.


>
>>>>>> +       TEST_ASSERT(warnings_before == warnings_after,
>>>>>> +                  "Warnings found in kernel.  Run 'dmesg' to inspect them.");
>>>>>> +
>>>>>> +       return 0;
>>>>>> +}
>>>>>> --
>>>>>> 2.22.0.rc1.311.g5d7573a151-goog
>>>>>>
>>>>> ping
