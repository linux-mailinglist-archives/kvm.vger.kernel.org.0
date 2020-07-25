Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443E222D4F6
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 06:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgGYEcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jul 2020 00:32:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jul 2020 00:32:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P4VQm5000942;
        Sat, 25 Jul 2020 04:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O+7Lv6L1uyS+tIuaGTDpVS9j1mL2PuiwyimtMZWo48Y=;
 b=E8NZ1G8UclG60Wg318lI2/tFCylFMuk9aQYvTWk0ElGAiV/3hhMhs1OMRP0mUqxUZ/ZP
 FWIPrp/lNqyfhq1R1pjrGz7b8tijN1qB6243v3Fy3k6jw+5tuvBjwfx2FoVFBdRaIb6a
 fh0MC+rnRdTkJw1alwzt1L2wfggUTlFGqjQcX7ObDve88Y8O7r2MEuzVAmq38//32fuw
 S3g/hLyHMN43ydNI6nt+t9DMhuv1eENOFbELZFIsWYbpFxu7I5xzcBE5sC7ggTO3+2P2
 R6ZqczgCzyJRHJ+2pucjY67zO9KyEPq3nllLb6jLFKfPW3m86uVHCRtQf4s3ILY8FrH6 sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32gdcn0182-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 04:32:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P4Oau0144952;
        Sat, 25 Jul 2020 04:30:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32gasedj6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 04:30:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P4UAil007259;
        Sat, 25 Jul 2020 04:30:10 GMT
Received: from localhost.localdomain (/10.159.226.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 04:30:09 +0000
Subject: Re: [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and
 {vmx|svm}_nested_ops via macros
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
References: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
 <87zh7on6pb.fsf@vitty.brq.redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <411a1f85-6de8-8167-a861-12edb2bc0e35@oracle.com>
Date:   Fri, 24 Jul 2020 21:30:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87zh7on6pb.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250034
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/20 10:50 AM, Vitaly Kuznetsov wrote:
> Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:
>
>> There is no functional change. Just the names of the implemented functions in
>> KVM and SVM modules have been made conformant to the kvm_x86_ops and
>> kvm_x86_nested_ops structures, by using macros. This will help in better
>> readability and maintenance of the code.
>>
>>
>> [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and
>>
>> [root@nsvm-sadhukhan linux]# /root/Tools/git-format-patch.sh dcb7fd8
>>   arch/x86/include/asm/kvm_host.h |  12 +-
>>   arch/x86/kvm/svm/avic.c         |   4 +-
>>   arch/x86/kvm/svm/nested.c       |  16 +--
>>   arch/x86/kvm/svm/sev.c          |   4 +-
>>   arch/x86/kvm/svm/svm.c          | 218 +++++++++++++++++-----------------
>>   arch/x86/kvm/svm/svm.h          |   8 +-
>>   arch/x86/kvm/vmx/nested.c       |  26 +++--
>>   arch/x86/kvm/vmx/nested.h       |   2 +-
>>   arch/x86/kvm/vmx/vmx.c          | 238 +++++++++++++++++++-------------------
>>   arch/x86/kvm/vmx/vmx.h          |   2 +-
>>   arch/x86/kvm/x86.c              |  20 ++--
>>   11 files changed, 279 insertions(+), 271 deletions(-)
>>
>> Krish Sadhukhan (1):
>>        KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops
>>
> I like the patch!
>
> I would, however, want to suggest to split this:
>
> 1) Separate {vmx|svm}_x86_ops change from {vmx|svm}_nested_ops
> 2) Separate VMX/nVMX from SVM/nSVM
> 3) Separate other changes (like svm_tlb_flush() -> svm_flush_tlb()
> rename, set_irq() -> inject_irq() rename, ...) into induvidual patches.

It makes sense. However, I haven't separated #3 that you mentioned 
because the changes are not that many and hence I just squeezed them 
into the relevant patches. If you feel strongly about it, I will 
separate them.


>
> Or you'll have to provide a script to review it as a whole :-)
>
