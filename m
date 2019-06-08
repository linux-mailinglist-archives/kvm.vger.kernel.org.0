Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B334399FB
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 03:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbfFHBHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 21:07:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbfFHBHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 21:07:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x580xWo1111733;
        Sat, 8 Jun 2019 01:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Vp7vKN+uZRTgmaqNUCB1V+HRD9fr7LLOJoGf3ypuppw=;
 b=ckHv74ZT2CiZ3haw2JlibcPNyOHyKh5ETyfZMfrDtbIOybTaSxHkzouD57VUtFD7HKvh
 1u593bBosmQIWO5TPmCHW34rqvkZtbo+00vAEIi4wzc6Ct/PEXfhat+RYhgVU9iy/9nH
 3CAbWvIpwIu+BxQmoUMevNN9cOms4XLrZqCD4FvwODpbc2Vj2N1c0gdw2DQsEA1dUEVw
 qRYadPAF1CHUciB4gejaL9qUkFlw4rDhHNi3nr0Ok3BA2z4gtDdVOmI6yL0dBxMay8Rb
 uevPTVughxpsj3n23TBG+MfzAz6pK16Fcl8yU8D2enYmq+zbbt0bOUGEt1rzkyShWIjW eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0r0xn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jun 2019 01:07:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x58157Vt069101;
        Sat, 8 Jun 2019 01:07:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t024t0hd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jun 2019 01:07:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x58170AV006353;
        Sat, 8 Jun 2019 01:07:00 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 18:06:59 -0700
Subject: Re: [PATCH 0/4][kvm-unit-test nVMX]: Test "load
 IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
 <6363dc39-b44b-0cca-de2f-603703df41b9@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <70e2e133-4b6c-8131-72a8-237256e81cb0@oracle.com>
Date:   Fri, 7 Jun 2019 18:06:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <6363dc39-b44b-0cca-de2f-603703df41b9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906080005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906080005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/06/2019 05:39 AM, Paolo Bonzini wrote:
> On 09/05/19 23:20, Krish Sadhukhan wrote:
>> This set contains the unit test, and related changes, for the "load
>> IA32_PERF_GLOBAL_CONTROL" VM-entry control that was enabled in my previous
>> patchset titled:
>>
>> 	[KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested guests
>>
>>
>> [PATCH 1/4][kvm-unit-test nVMX]: Rename guest_pat_main to guest_state_test_main
>> [PATCH 2/4][kvm-unit-test nVMX]: Rename report_guest_pat_test to
>> [PATCH 3/4][kvm-unit-test nVMX]: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
>> [PATCH 4/4][kvm-unit-test nVMX]: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry
>>
>>   x86/vmx.h       |   1 +
>>   x86/vmx_tests.c | 108 +++++++++++++++++++++++++++++++++++++++++++-----------
>>   2 files changed, 87 insertions(+), 22 deletions(-)
>>
>> Krish Sadhukhan (4):
>>        nVMX: Rename guest_pat_main to guest_state_test_main
>>        nVMX: Rename report_guest_pat_test to report_guest_state_test
>>        nVMX: Add #define for "load IA32_PERF_GLOBAL_CONTROL" bit
>>        nVMX: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
>>
> Queued 1-3, but patch 4 does not apply.  It seems like you have another
> patch that this sits on top of?

Yes, the following patchset:

             [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry 
of nested guests

I need to send out v2 of that set and patch# 4 of this set builds on top 
of that.

You don't need to pull 1-3 out because they are independent of the 
pending patchset. I will attach patch# 4 of this set to the v2 of the 
pending set.

>
> Paolo

