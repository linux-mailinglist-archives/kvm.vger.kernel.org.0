Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCDD39A05
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 03:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbfFHBSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 21:18:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbfFHBSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 21:18:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x581FAPa121895;
        Sat, 8 Jun 2019 01:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pdsfGH4CVBqibdcRfZdsvFlLdL5r5V2B7eEBJOaO60A=;
 b=KDwqToqFCKu8RC7VNVG6gBSi1DWz47W2oSuRPCGUlrdJeFHZlN9ZADffQA/yUAmK4/3P
 s5AB1ZwjNJSXrXkMZsimBY7RwIcG9YtKVehsHfmNHB+MUsYRq0M+bC06hLilJKosC3U9
 PQg1vCzdHy/R2BWNj8SVQ7elQnPysU6Y2zkEVYh6MdTByT6O98eCbuTB3vWCnUU8fMSl
 mDKQBbwoHHaJPl/mFcr8DkZ7gnbDIAYiD+i6kJ2nUkM1c9dTCjvz48FwSjKlY+F8Mhte
 haPwCJZ+5+HwwMfJExM52pqSk5n8uvP5jq7v8o0CIRluo9jjrcGPTi2FLsEhD7fPS+Fe aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0r0y2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jun 2019 01:18:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x581I04A094738;
        Sat, 8 Jun 2019 01:18:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2swngka9rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jun 2019 01:18:00 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x581HxlG007086;
        Sat, 8 Jun 2019 01:17:59 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 18:17:59 -0700
Subject: Re: [PATCH 0/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit
 control on vmentry of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
 <b1dfa016-0441-22f2-667a-ae4109d41752@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <790112c9-1b3b-e03b-3afd-142fb6f3b8d5@oracle.com>
Date:   Fri, 7 Jun 2019 18:17:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <b1dfa016-0441-22f2-667a-ae4109d41752@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906080006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/06/2019 05:48 AM, Paolo Bonzini wrote:
> On 23/05/19 01:45, Krish Sadhukhan wrote:
>> Patch# 1 creates a wrapper for checking if the NX bit in MSR_EFER is enabled.
>> It is used in patch# 2.
>>
>> Patch# 2 adds tests for "Load IA32_EFER" VM-exit control.
> Queued with the change suggested by Sean, but this was also on top of
> some patches that you have not sent yet because patch 2 didn't apply
> cleanly.

Yes, this patchset was stacked on top of the following (pending v2) 
patchset in my git repo:

         [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of 
nested guests


But the two patchsets are not functionally dependent, so we are good.

Thanks.

> Paolo
>
>
>> [PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the CPU supports NX bit in
>> [PATCH 2/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of
>>
>>   lib/x86/processor.h |   8 ++++
>>   x86/vmexit.c        |   2 +-
>>   x86/vmx_tests.c     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 130 insertions(+), 1 deletion(-)
>>
>> Krish Sadhukhan (2):
>>        x86: Add a wrapper to check if the CPU supports NX bit in MSR_EFER
>>        nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of nested guests
>>

