Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5073217F76D
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 13:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJM3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 08:29:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726273AbgCJM33 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 08:29:29 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ACKSQ2041764
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 08:29:28 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8g4gy4x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 08:29:27 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 10 Mar 2020 12:29:26 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 12:29:24 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ACTN0g60948632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 12:29:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18C195204F;
        Tue, 10 Mar 2020 12:29:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 961A252050;
        Tue, 10 Mar 2020 12:29:22 +0000 (GMT)
Subject: Re: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
References: <20200310091556.4701-1-drjones@redhat.com>
 <1b6d5b6a-f323-14d5-f423-d59547637819@de.ibm.com>
 <20200310115814.fxgbfrxn62zge2jp@kamzik.brq.redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 10 Mar 2020 13:29:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310115814.fxgbfrxn62zge2jp@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031012-4275-0000-0000-000003AA33BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031012-4276-0000-0000-000038BF4CDC
Message-Id: <a801a41c-5b7e-9c01-fc24-02d7f57079ca@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=837 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I get the following with your patches.


In file included from s390x/sync_regs_test.c:21:
s390x/sync_regs_test.c: In function ‘compare_sregs’:
s390x/sync_regs_test.c:41:7: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 6 has type ‘__u32’ {aka ‘unsigned int’} [-Wformat=]
   41 |       "Register " #reg \
      |       ^~~~~~~~~~~
   42 |       " values did not match: 0x%llx, 0x%llx\n", \
   43 |       left->reg, right->reg)
      |       ~~~~~~~~~~~~~~~~~~~~~~
   44 | 
      |        
   45 | static void compare_regs(struct kvm_regs *left, struct kvm_sync_regs *right)
      | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   46 | {
      | ~      
   47 |  int i;
      |  ~~~~~~
   48 | 
      |        
   49 |  for (i = 0; i < 16; i++)
      |  ~~~~~~~~~~~~~~~~~~~~~~~~
   50 |   REG_COMPARE(gprs[i]);
      |   ~~~~~~~~~~~~~~~~~~~~~
   51 | }
      | ~      
   52 | 
      |        
   53 | static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
      | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   54 | {
      | ~      
   55 |  int i;
      |  ~~~~~~
   56 | 
      |        
   57 |  for (i = 0; i < 16; i++)
      |  ~~~~~~~~~~~~~~~~~~~~~~~~
   58 |   REG_COMPARE(acrs[i]);
      |   ~~~~~~~~~~~~~~~~~~~
      |                   |
      |                   __u32 {aka unsigned int}
include/test_util.h:46:43: note: in definition of macro ‘TEST_ASSERT’
   46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
      |                                           ^~~
s390x/sync_regs_test.c:58:3: note: in expansion of macro ‘REG_COMPARE’
   58 |   REG_COMPARE(acrs[i]);
      |   ^~~~~~~~~~~
s390x/sync_regs_test.c:41:7: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 7 has type ‘__u32’ {aka ‘unsigned int’} [-Wformat=]
   41 |       "Register " #reg \
      |       ^~~~~~~~~~~
   42 |       " values did not match: 0x%llx, 0x%llx\n", \
   43 |       left->reg, right->reg)
      |                  ~~~~~~~~~~~
   44 | 
      |        
   45 | static void compare_regs(struct kvm_regs *left, struct kvm_sync_regs *right)
      | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   46 | {
      | ~      
   47 |  int i;
      |  ~~~~~~
   48 | 
      |        
   49 |  for (i = 0; i < 16; i++)
      |  ~~~~~~~~~~~~~~~~~~~~~~~~
   50 |   REG_COMPARE(gprs[i]);
      |   ~~~~~~~~~~~~~~~~~~~~~
   51 | }
      | ~      
   52 | 
      |        
   53 | static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
      | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   54 | {
      | ~      
   55 |  int i;
      |  ~~~~~~
   56 | 
      |        
   57 |  for (i = 0; i < 16; i++)
      |  ~~~~~~~~~~~~~~~~~~~~~~~~
   58 |   REG_COMPARE(acrs[i]);
      |   ~~~~~~~~~~~~~~~~~~~
      |                   |
      |                   __u32 {aka unsigned int}
include/test_util.h:46:43: note: in definition of macro ‘TEST_ASSERT’
   46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
      |                                           ^~~
s390x/sync_regs_test.c:58:3: note: in expansion of macro ‘REG_COMPARE’
   58 |   REG_COMPARE(acrs[i]);
      |   ^~~~~~~~~~~
s390x/sync_regs_test.c: In function ‘main’:
s390x/sync_regs_test.c:158:7: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 6 has type ‘__u32’ {aka ‘unsigned int’} [-Wformat=]
  158 |       "acr0 sync regs value incorrect 0x%llx.",
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  159 |       run->s.regs.acrs[0]);
      |       ~~~~~~~~~~~~~~~~~~~
      |                       |
      |                       __u32 {aka unsigned int}
include/test_util.h:46:43: note: in definition of macro ‘TEST_ASSERT’
   46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
      |                                           ^~~
s390x/sync_regs_test.c:158:44: note: format string is defined here
  158 |       "acr0 sync regs value incorrect 0x%llx.",
      |                                         ~~~^
      |                                            |
      |                                            long long unsigned int
      |      



On 10.03.20 12:58, Andrew Jones wrote:
> On Tue, Mar 10, 2020 at 10:45:43AM +0100, Christian Borntraeger wrote:
>> On 10.03.20 10:15, Andrew Jones wrote:
>>>
>>> Andrew Jones (4):
>>>   fixup! selftests: KVM: SVM: Add vmcall test
>>>   KVM: selftests: Share common API documentation
>>>   KVM: selftests: Enable printf format warnings for TEST_ASSERT
>>>   KVM: selftests: Use consistent message for test skipping
>>
>> This looks like a nice cleanup but this does not seem to apply
>> cleanly on kvm/master or linus/master. Which tree is this based on?
> 
> This is based on kvm/queue. Sorry, I should have mentioned that in
> the cover letter.
> 
> Thanks,
> drew
> 
>>
>>>
>>>  tools/testing/selftests/kvm/.gitignore        |   5 +-
>>>  .../selftests/kvm/demand_paging_test.c        |   6 +-
>>>  tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
>>>  .../testing/selftests/kvm/include/kvm_util.h  | 100 ++++++++-
>>>  .../testing/selftests/kvm/include/test_util.h |   5 +-
>>>  .../selftests/kvm/lib/aarch64/processor.c     |  17 --
>>>  tools/testing/selftests/kvm/lib/assert.c      |   6 +-
>>>  tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +-
>>>  .../selftests/kvm/lib/kvm_util_internal.h     |  48 +++++
>>>  .../selftests/kvm/lib/s390x/processor.c       |  74 -------
>>>  tools/testing/selftests/kvm/lib/test_util.c   |  12 ++
>>>  .../selftests/kvm/lib/x86_64/processor.c      | 196 ++++--------------
>>>  tools/testing/selftests/kvm/lib/x86_64/svm.c  |   2 +-
>>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
>>>  tools/testing/selftests/kvm/s390x/memop.c     |   2 +-
>>>  .../selftests/kvm/s390x/sync_regs_test.c      |   2 +-
>>>  .../kvm/x86_64/cr4_cpuid_sync_test.c          |   2 +-
>>>  .../testing/selftests/kvm/x86_64/evmcs_test.c |   6 +-
>>>  .../selftests/kvm/x86_64/hyperv_cpuid.c       |   8 +-
>>>  .../selftests/kvm/x86_64/mmio_warning_test.c  |   4 +-
>>>  .../selftests/kvm/x86_64/platform_info_test.c |   3 +-
>>>  .../kvm/x86_64/set_memory_region_test.c       |   3 +-
>>>  .../testing/selftests/kvm/x86_64/state_test.c |   4 +-
>>>  .../selftests/kvm/x86_64/svm_vmcall_test.c    |   3 +-
>>>  .../selftests/kvm/x86_64/sync_regs_test.c     |   4 +-
>>>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   2 +-
>>>  .../kvm/x86_64/vmx_set_nested_state_test.c    |   4 +-
>>>  .../selftests/kvm/x86_64/xss_msr_test.c       |   2 +-
>>>  28 files changed, 243 insertions(+), 292 deletions(-)
>>>
>>
> 

