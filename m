Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580F9216303
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 02:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGGAeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 20:34:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGGAeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 20:34:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0670WY21046067;
        Tue, 7 Jul 2020 00:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RTv/6XDovWSvRfYSHR1dcRBY8X/+09W2o7nvuDMFGNI=;
 b=s+rvaUjbyW3PySo4VM9banLFyeUEJihLZkSuN+AvTCGLXSWrudNSxdQWDyY39FyMte7C
 DYYJpiF75xOLWDCzvVoVgchqFQYtEB/idQ57vm9ZuU9ItuBLLPPOfC0qixXgRqK9V38b
 46aopXtzVxSvgYkqHF4yCGcCPrDmCFjX95RhnIfiZJW++XwUFktQUec2sCS7U65XVyAm
 FdS1qFWLCNjVuvBy4V+4MQgi4DRFY7sWXsYTiAS3zuAsrT33dOEuw4rKcZ4FOesx88NV
 v07bcW/9NvYl4zX15BbbPvpax2RfX3Rlw5Zf0OGyJHbOzBLxpa/50WQR1QbhL6YgfPxz Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 322kv699eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 07 Jul 2020 00:34:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0670YAL9074850;
        Tue, 7 Jul 2020 00:34:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233pw6yjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jul 2020 00:34:15 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0670YEwU025451;
        Tue, 7 Jul 2020 00:34:14 GMT
Received: from localhost.localdomain (/10.159.144.242)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jul 2020 17:34:14 -0700
Subject: Re: [PATCH 0/3 v3] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun
 of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200515053609.3347-1-krish.sadhukhan@oracle.com>
 <fff40d79-1731-2f24-227a-bf57e8e33b97@oracle.com>
 <b2276167-0bda-0b31-85c0-63a3a0b789bd@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4b0fd4e7-465a-428f-c906-ddf0ad367cbb@oracle.com>
Date:   Mon, 6 Jul 2020 17:34:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b2276167-0bda-0b31-85c0-63a3a0b789bd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007070001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/3/20 10:11 AM, Paolo Bonzini wrote:
> On 03/07/20 00:33, Krish Sadhukhan wrote:
>> Ping.
>>
>> On 5/14/20 10:36 PM, Krish Sadhukhan wrote:
>>> v2 -> v3:
>>>      In patch# 1, the mask for guest CR4 reserved bits is now cached in
>>>      'struct kvm_vcpu_arch', instead of in a global variable.
>>>
>>>
>>> [PATCH 1/3 v3] KVM: x86: Create mask for guest CR4 reserved bits in
>>> [PATCH 2/3 v3] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not
>>> set on
>>> [PATCH 3/3 v3] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not
>>> set on vmrun
>>>
>>>    arch/x86/include/asm/kvm_host.h |  2 ++
>>>    arch/x86/kvm/cpuid.c            |  2 ++
>>>    arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
>>>    arch/x86/kvm/svm/svm.h          |  5 ++++-
>>>    arch/x86/kvm/x86.c              | 27 ++++-----------------------
>>>    arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
>>>    6 files changed, 53 insertions(+), 26 deletions(-)
>>>
>>> Krish Sadhukhan (2):
>>>         KVM: x86: Create mask for guest CR4 reserved bits in
>>> kvm_update_cpuid()
>>>         nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun
>>> of nested gu
>>>
>>>    x86/svm.h       |   6 ++++
>>>    x86/svm_tests.c | 105
>>> +++++++++++++++++++++++++++++++++++++++++++++++++-------
>>>    2 files changed, 99 insertions(+), 12 deletions(-)
>>>
>>> Krish Sadhukhan (1):
>>>         nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of
>>> nested g
>>>
> Sorry, this one was not queued because there were comments (also I think
> it doesn't apply anymore).

Sorry, Paolo, I got bit lost here :-). IIRC, you had two comments on 
this set:

     1. kvm_valid_cr4() should be used for checking the reserved bits in 
guest CR4

     2. LMA shouldn't be checked via guest state

v3 has addressd your first suggestion by caching CR4 reserved bits in 
kvm_update_cpuid() and then using kvm_valid_cr4() in nested_vmcb_checks().

As for your second suggestion, v3 uses is_long_mode() which uses 
vcpu->arch.efer for checking long mode.

I will send out a rebased version.

Is there anything I missed ?


Thanks.

>
> Paolo
>
