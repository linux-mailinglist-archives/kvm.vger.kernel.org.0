Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0794363E06
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfGIWvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 18:51:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIWvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 18:51:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69MmwX6146466;
        Tue, 9 Jul 2019 22:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oFZ2IG8z09zgeg7eMExHdQDEIfUU+HsEvfq542ng2h4=;
 b=I5nJC+KmBWcq9vLjOI3iDvsi02hrKhW4e8dSIWoQo4DQH7c0n/Q+wXcay/5IfIwoqCq+
 6e1CAyB51C9X3hNR9t4cNB2TpaEsmTg+dEVDAv50wXOR9Rg7L12Pkz48lgA2i1vKCMbv
 BoZSjX34QzRBeto3O6dTc+2IiHmYt/qVoXRSe6E/JLv9Fgobmxo+5BtdG7D/KS+0hNiS
 tlrGhAX1UOx8GtWl+Bck6Odqsyxj28y//MpQOCu+AhMGiuLJmds5Dp3y7xCmQ9O2JRNw
 6x+wuxPjOZBbzBUW/TV8BqTlwpOb7WCuZkQc9MBTjfI7wduZM16Gfu5jPn8sRM3wWzVt 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tjk2tpy0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 22:50:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69MmFBT038116;
        Tue, 9 Jul 2019 22:50:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tn1j0hv31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 22:50:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x69Mo312003881;
        Tue, 9 Jul 2019 22:50:03 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 15:50:03 -0700
Subject: Re: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary
 only if VMCS12 is dirty
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190708181759.GB20791@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a1180bd0-1382-b515-fc28-41ac0200b03a@oracle.com>
Date:   Tue, 9 Jul 2019 15:50:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190708181759.GB20791@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090272
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090272
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/08/2019 11:17 AM, Sean Christopherson wrote:
> On Sun, Jul 07, 2019 at 03:11:42AM -0400, Krish Sadhukhan wrote:
>> The following functions,
>>
>> 	nested_vmx_check_controls
>> 	nested_vmx_check_host_state
>> 	nested_vmx_check_guest_state
>>
>> do a number of vmentry checks for VMCS12. However, not all of these checks need
>> to be executed on every vmentry. This patchset makes some of these vmentry
>> checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
>> then the checks will be executed. This will reduce performance impact on
>> vmentry of nested guests.
> All of these patches break vmx_set_nested_state(), which sets dirty_vmcs12
> only after the aforementioned consistency checks pass.

Perhaps vmx_set_nested_state() can set dirty_vmcs12 right before the 
consistency checks are done ? I see no difference in correctness. Also, 
it calls set_current_vmptr() which anyway sets dirty_vmcs12 for valid VMCSs.

>
> The new nomenclature for the dirty paths is "rare", not "full".
OK.
>
> In general, I dislike directly associating the consistency checks with
> dirty_vmcs12.
>
>    - It's difficult to assess the correctness of the resulting code, e.g.
>      changing CPU_BASED_VM_EXEC_CONTROL doesn't set dirty_vmcs12, which
>      calls into question any and all SECONDARY_VM_EXEC_CONTROL checks since
>      an L1 could toggle CPU_BASED_ACTIVATE_SECONDARY_CONTROLS.
>
>    - We lose the existing organization of the consistency checks, e.g.
>      similar checks get arbitrarily split into separate flows based on
>      the rarity of the field changing.

Initially, I was thinking of inserting the check for dirty_vmcs12 right 
in place of each of the checks without having to move them to separate 
functions. That approach saves the separation of the checks but results 
in poor readability. Hence I adopted the current approach.

>
>    - The performance gains are likely minimal since the majority of checks
>      can't be skipped due to the coarseness of dirty_vmcs12.
>
> Rather than a quick and dirty (pun intended) change to use dirty_vmcs12,
> I think we should have some amount of dedicated infrastructure for
> optimizing consistency checks from the get go, e.g. perhaps something
> similar to how eVMCS categorizes fields.
Are you referring to the categorization done in 
copy_vmcs12_to_enlightened() ? If so, what is the basis for 
categorization in there ?
We can re-order the checks in 
nested_vmx_check_{controls,host_state,guest_state} based on dirty_vmcs  
to create an initial framework for controlling the consistency checks. 
The only disadvantage will be that such an ordering will be completely 
off from how the SDM describes the checks.

>   The initial usage could be very
> coarse grained, e.g. based purely on dirty_vmcs12, but having the
> infrastructure would make it easier to reason about the correctness of
> the code.  Future patches could then refine the triggerring of checks to
> achieve better optimization, e.g. skipping the vast majority of checks
> when L1 is simply toggling CPU_BASED_VIRTUAL_INTR_PENDING.
It seems you are suggesting a finer granularity up to each VMCS field 
instead of groups of VMCS fields ? Then we need a per-field flag to 
track its modification and that seems an overkill.
