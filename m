Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8C4AB2E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 21:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfFRTr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 15:47:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRTr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 15:47:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJcU6U166816;
        Tue, 18 Jun 2019 19:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sOgZwQp0gntXxyIlNbF6GqUizbh4O0zPdT0MNsHNs1s=;
 b=RfZy1hvplqGS882m8LtyldsOz1BIZVqO4Uw6zUbccQyzOE4m4TS1Ix8BzXiSo101oRgc
 e9yxAQw8hyrGvUSsb3SKw3BeFuWYSUywRiHIWtLXkcoYBdjbd1ZhBWlCKs4enZhKc6Oa
 eqCIfLRMW+lReJuJt2wXAhwYIN1zRckF6XW3o5VAlROFkuOQsX2WJtVPX+8Llkjj08+8
 maPQFXouqFItSXHr1lcBYNx/OHNjqQSI/sPo5/ieGY6+2SBcSKjj3xP37JzaVnDJ8MSW
 MWOWyWPnh0RdoatJLCMXH7Am6fYI5W+HbNNELqGzGrSmXDO1UNFDgxbwU7Zri+Gjij+r Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t4r3tpj95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:47:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IJlRF4085833;
        Tue, 18 Jun 2019 19:47:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t5mgc5n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 19:47:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IJlr1i017477;
        Tue, 18 Jun 2019 19:47:54 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 12:47:53 -0700
Subject: Re: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
To:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>, Marc Orr <marcorr@google.com>,
        kvm@vger.kernel.org
References: <20190521171358.158429-1-aaronlewis@google.com>
 <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
 <CAAAPnDHg6Qmwwuh3wGNdTXQ3C4hpSJo9D5bvZG4yX9s48DeSLQ@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <63c62aa7-2dd1-f133-d8bc-c7a3528b7598@oracle.com>
Date:   Tue, 18 Jun 2019 12:47:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDHg6Qmwwuh3wGNdTXQ3C4hpSJo9D5bvZG4yX9s48DeSLQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/18/2019 07:14 AM, Aaron Lewis wrote:
> On Fri, May 31, 2019 at 9:37 AM Aaron Lewis <aaronlewis@google.com> wrote:
>> On Tue, May 21, 2019 at 10:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>> Reviewed-by: Peter Shier <pshier@google.com>
>>> ---
>>>   tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
>>>   1 file changed, 10 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>>> index 79c524395ebe..234f679fa5ad 100644
>>> --- a/tools/testing/selftests/kvm/Makefile
>>> +++ b/tools/testing/selftests/kvm/Makefile
>>> @@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
>>>   LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
>>>   LIBKVM_aarch64 = lib/aarch64/processor.c
>>>
>>> -TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/state_test
>>> +TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>>>   TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>>>   TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>> -TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>>   TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
>>> +TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/state_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>> -TEST_GEN_PROGS_x86_64 += dirty_log_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>>>   TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>> +TEST_GEN_PROGS_x86_64 += dirty_log_test

May be, place the last two at the beginning if you are arranging them 
alphabetically ?

>>>
>>> -TEST_GEN_PROGS_aarch64 += dirty_log_test
>>>   TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
>>> +TEST_GEN_PROGS_aarch64 += dirty_log_test

May be, put the aarch64 ones above the x86_64 ones to arrange them 
alphabetically ?

>>>
>>>   TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>>>   LIBKVM += $(LIBKVM_$(UNAME_M))
>>> --
>>> 2.21.0.1020.gf2820cf01a-goog
>>>
>> Does this look okay?  It's just a simple reordering of the list.  It
>> helps when adding new tests.
> ping

