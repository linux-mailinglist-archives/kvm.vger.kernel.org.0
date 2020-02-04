Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFB6152235
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 23:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgBDWCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 17:02:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgBDWCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 17:02:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014Ln1OY001911;
        Tue, 4 Feb 2020 22:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IgGcgFx4W8iUI2PM0KnTJ1kV8040cTbRidDGiGCct20=;
 b=dtRi21nm+zTqB4vWCjowrSuk4i5eYhjiJQiv79sdwh7Om6c9xl0hrHnoEXWIEiN/0JDl
 2p+l1o/wq2zAP/OJ5W4IgE9jgGuzkdkCqY+mKDGOTIfobSekq12k4LGxfAAwGHsHBs+u
 g8iHdVQmyARPlKTw4oRBHveWo/uqxuvSbS9fwjt2QxMLZYzXfVsQY3jADoPWyVeYUniu
 pTkreDQC9yioReGvNr56lKNFHuvOktx0tO+pR1UQGMoaVsrexyGzy4vdxrlNqdaUqY72
 W/0upwEnOFM8g+MF0PCQP9R56vqlpvDm0o+sNemNLe8vzCAiFB13H6eFBm1D7TX04/Ot PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xw0ru9rdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 22:01:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014Ln0WR164755;
        Tue, 4 Feb 2020 22:01:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xxvusr9vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 22:01:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 014M12rR005078;
        Tue, 4 Feb 2020 22:01:02 GMT
Received: from dhcp-10-132-97-93.usdhcp.oraclecorp.com (/10.132.97.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 14:01:01 -0800
Subject: Re: [PATCH] KVM: nVMX: Remove stale comment from
 nested_vmx_load_cr3()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204153259.16318-1-sean.j.christopherson@intel.com>
 <dcee13f5-f447-9ab4-4803-e3c4f42fb011@oracle.com>
 <20200204203607.GB5663@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <14d6b39b-b907-d1f3-8f15-9b1df0718082@oracle.com>
Date:   Tue, 4 Feb 2020 14:01:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20200204203607.GB5663@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/04/2020 12:36 PM, Sean Christopherson wrote:
> On Tue, Feb 04, 2020 at 11:57:39AM -0800, Krish Sadhukhan wrote:
>> On 2/4/20 7:32 AM, Sean Christopherson wrote:
>>> The blurb pertaining to the return value of nested_vmx_load_cr3() no
>>> longer matches reality, remove it entirely as the behavior it is
>>> attempting to document is quite obvious when reading the actual code.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   arch/x86/kvm/vmx/nested.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 7608924ee8c1..0c9b847f7a25 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -1076,8 +1076,6 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
>>>   /*
>>>    * Load guest's/host's cr3 at nested entry/exit. nested_ept is true if we are
>>>    * emulating VM entry into a guest with EPT enabled.
>>> - * Returns 0 on success, 1 on failure. Invalid state exit qualification code
>>> - * is assigned to entry_failure_code on failure.
>>>    */
>>>   static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
>>>   			       u32 *entry_failure_code)
>> I think it's worth keeping the last part which is " Exit qualification code
>> is assigned to entry_failure_code on failure." because "Entry Failure" and
>> "Exit Qualification" might sound bit confusing until you actually look at
>> the caller nested_vmx_enter_non_root_mode().
> Hmm, something like this?
>
> /*
>   * Load guest's/host's cr3 at nested entry/exit.  @nested_ept is true if we are
>   * emulating VM-Entry into a guest with EPT enabled.  On failure, the expected
>   * Exit Qualification (for a VM-Entry consistency check VM-Exit) is assigned to
>   * @entry_failure_code.
>   */
It  works.

With that,

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
