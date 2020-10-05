Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74017283F5B
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 21:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgJETM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 15:12:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgJETM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 15:12:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095J9t3c109421;
        Mon, 5 Oct 2020 19:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J2CNHLbQUaQBrncpPwC9uFIbCgspT//xg1VJuXRr1uo=;
 b=tvMMfn8G50xRV1hMPIUfkJHKuR/OHxuJIjkPL5/0+YKgMfiJvXlUfqNgVxs9u/MSp0D8
 nPhMJbg042rZwEopEI27tCz2v3z36AiQlRGYqxdZ8d93ZZTvwsZ2NxxRATHs4RGdfjk0
 Bme9z+21Vp2Z2g5HMxyCq9uQEP0jyqTtVqR/NQlaWZM0vCU8gii86agc/FUC9x8EDQeM
 hxweXeAgCkVQz/UDI8vgZmr61foZKTgatadyTDCpZwnRXtf3tcgYlGLW/8MpeV641b0K
 86wV4fPGSfl3xhDk4iOn0UcNORyGCxQV3v4W+tU0B0G39JGUd0GlAtrKPV+2s+46WG+U HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34ccte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 19:12:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IpE41182653;
        Mon, 5 Oct 2020 19:10:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33y2vkw6qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 19:10:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095JAJ7q011426;
        Mon, 5 Oct 2020 19:10:19 GMT
Received: from localhost.localdomain (/10.159.233.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 12:10:19 -0700
Subject: Re: [PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in
 long mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
 <20200928072043.9359-4-krish.sadhukhan@oracle.com>
 <20200929031154.GC31514@linux.intel.com>
 <5f236941-5086-167a-6518-6191d8ef04cf@oracle.com>
 <20201001005041.GE2988@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <7669d79b-1d3b-f37c-ef90-b78a50d7491f@oracle.com>
Date:   Mon, 5 Oct 2020 12:10:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201001005041.GE2988@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/30/20 5:50 PM, Sean Christopherson wrote:
> On Wed, Sep 30, 2020 at 05:29:24PM -0700, Krish Sadhukhan wrote:
>> On 9/28/20 8:11 PM, Sean Christopherson wrote:
>>> On Mon, Sep 28, 2020 at 07:20:42AM +0000, Krish Sadhukhan wrote:
>>>> According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
>>>> need to be set by software as follows:
>>>>
>>>> 	"Reserved Bits. Reserved fields should be cleared to 0 by software
>>>> 	when writing CR3."
>>> Nothing in the shortlog or changelog actually states what this patch does.
>>> "Test non-MBZ reserved bits in CR3 in long mode" is rather ambiguous, and
>>> IIUC, the changelog is straight up misleading.
>>>
>>> Based on the discussion from v1, I _think_ this test verifies that KVM does
>>> _not_ fail nested VMRUN if non-MBZ bits are set, correct?
>> Not KVM, hardware rather.  Hardware doesn't consider it as an invalid guest
>> state if non-MBZ reserved bits are set.
>>> If so, then something like:
>>>
>>>    KVM: nSVM: Verify non-MBZ CR3 reserved bits can be set in long mode
>>>
>>> with further explanation in the changelog would be very helpful.
>> Even though the non-MBZ reserved bits are ignored by the consistency checks
>> in hardware, eventually page-table walks fail. So, I am wondering whether it
> Page table walks fail how?  Are you referring to forcing the #NPF, or does
> the CPU puke on the non-MBZ reserved bits at some point?


I notice the following in my experiments when I don't clear the P bit in 
NPT PML4[0] to induce an
#NPF:

     1. In long mode and in legacy-PAE mode, guest VMMCALL is 
successfully executed and kvm_x86_ops.handle_exit() receives VMEXIT_VMMCALL.

     2. In legacy-non-PAE mode, kvm_x86_ops.handle_exit(), receives 
VMEXIT_NPF.

>
>> is appropriate to say,
>>
>>              "Verify non-MBZ CR3 reserved bits can be set in long mode"
>>
>> because the test is inducing an artificial failure even before any guest
>> instruction is executed. We are not entering the guest with these bits set.
> Yes we are, unless I'm misunderstanding how SVM handles VMRUN.  "entering" the
> guest does not mean successfully executing guest code, it means loading guest
> state and completing the world switch.  I don't think I'm misunderstanding,
> because the test explicitly clears the NPT PML4[0]'s present bit to induce a
> #NPF.  That means the CPU is fetching instructions, and again unless there's
> details about NPT that I'm missing, the fact that the test sees a #NPF means
> that the CPU successfully completed the GVA->GPA translation using the "bad"
> CR3.


You are right. According to APM, the hardware loads the guest state 
first and then does the consistency checking. So, yes, world switch 
happens before consistency checking begins.

>
>> I prefer to keep the commit header as is and rather expand the commit
>> message to explain what I have described here. How about that ?
> That's fine, so long as it documents both what the test is actually verifying
> and what is/isn't legal.
