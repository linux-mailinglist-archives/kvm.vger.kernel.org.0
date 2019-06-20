Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008E04D4B2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfFTRUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 13:20:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTRUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 13:20:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KH419W089797;
        Thu, 20 Jun 2019 17:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BLmxau0BD5uWLQUzeZJVaulHwG3wkxEeqxhcYJmZOdA=;
 b=JVvuDZeJ7BEQczkq7cSm7f1WuU0W8HAVGtsDLVjdtCawKWOMVxxFKWjPhGIRpxUaLnWX
 FOg5MDqGSktDBbHVEBU7MhvNAVRZFTk6tyA5vDjNWZzQDARo3yeFnBfQtjFzHrGT6UUF
 ecN6QrWkcNwaJ5RvX8FGtpkQsN8CNF2HwaigFccOhSpCL1AJkGuzDHuxQv6lxqh5Eat8
 BfZNV/5ou6359DNfIIVYeG4RHqZkS7yDJ3oABZNldhasAJcbhuryRtUMtTHeDp/rhrhh
 dq/bdoWXCZFaBDKcvT0KkM02T5VbIlFW9PhU6gEnJkuWVfkE0uH9XWGSuXIZQE7S0EbP zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t7809jcr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 17:20:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KHJDAn196284;
        Thu, 20 Jun 2019 17:20:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ynr60n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 17:20:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KHK0BO004984;
        Thu, 20 Jun 2019 17:20:00 GMT
Received: from [10.159.145.23] (/10.159.145.23)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 10:20:00 -0700
Subject: Re: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
References: <20190521171358.158429-1-aaronlewis@google.com>
 <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
 <CAAAPnDHg6Qmwwuh3wGNdTXQ3C4hpSJo9D5bvZG4yX9s48DeSLQ@mail.gmail.com>
 <63c62aa7-2dd1-f133-d8bc-c7a3528b7598@oracle.com>
 <CAAAPnDFSRbYMwNrbTe-n7efwwD5KZJd2GebYwjWKKhh9QhtmXQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a35e3e3d-166e-6244-716f-b8df7491e6d9@oracle.com>
Date:   Thu, 20 Jun 2019 10:19:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFSRbYMwNrbTe-n7efwwD5KZJd2GebYwjWKKhh9QhtmXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/20/19 8:03 AM, Aaron Lewis wrote:
> On Tue, Jun 18, 2019 at 12:47 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 06/18/2019 07:14 AM, Aaron Lewis wrote:
>>> On Fri, May 31, 2019 at 9:37 AM Aaron Lewis <aaronlewis@google.com> wrote:
>>>> On Tue, May 21, 2019 at 10:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>>>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>>>> Reviewed-by: Peter Shier <pshier@google.com>
>>>>> ---
>>>>>    tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
>>>>>    1 file changed, 10 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>>>>> index 79c524395ebe..234f679fa5ad 100644
>>>>> --- a/tools/testing/selftests/kvm/Makefile
>>>>> +++ b/tools/testing/selftests/kvm/Makefile
>>>>> @@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
>>>>>    LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
>>>>>    LIBKVM_aarch64 = lib/aarch64/processor.c
>>>>>
>>>>> -TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/state_test
>>>>> +TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>>>>>    TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>>>>>    TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>>>> -TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>>>>    TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/state_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>>>>    TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>>>> -TEST_GEN_PROGS_x86_64 += dirty_log_test
>>>>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>>>>    TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>>>> +TEST_GEN_PROGS_x86_64 += dirty_log_test
>> May be, place the last two at the beginning if you are arranging them
>> alphabetically ?
> The original scheme had everything in x86_64 first then everything in
> the root folder second.  I wanted to maintain this scheme, so that's
> why it is sorted this way.
>
>>>>> -TEST_GEN_PROGS_aarch64 += dirty_log_test
>>>>>    TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
>>>>> +TEST_GEN_PROGS_aarch64 += dirty_log_test
>> May be, put the aarch64 ones above the x86_64 ones to arrange them
>> alphabetically ?
> I want to make a minimal change, so sorting the tags isn't a priority,
> just the files.  The goal is to have a more predictable place to add
> new tests, and I think this helps.


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>


>>>>>    TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>>>>>    LIBKVM += $(LIBKVM_$(UNAME_M))
>>>>> --
>>>>> 2.21.0.1020.gf2820cf01a-goog
>>>>>
>>>> Does this look okay?  It's just a simple reordering of the list.  It
>>>> helps when adding new tests.
>>> ping
