Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC28221713
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGOVeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 17:34:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOVea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 17:34:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FLXDmC060311;
        Wed, 15 Jul 2020 21:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vxI8F/g/2D34ELORrpBC/MphKpr9cByMWNlNHJvbgd0=;
 b=bKbqElcNh0ckxwabWqXq+RiP4K1HlwH6WMQPfKDaBUSHLGQUm1oePl80V7+KDbquPf6I
 rQfWY9A0a6m4YIFvMJui9YsfHHA288cTHwUXWOorM1gGEfUMebGqkox3+ChsrDDOJD0t
 K+BS/mMsDwQygjqO7zki4MgtpSO2L1P4PjnI2EyB2J4trscTXqZ+IdCOu0wa8OO4cLxt
 v3R/TjEfyrfAczz2bvcDb2liddmBw7b/LXgmOl7QJYV6xSWwAia7yGUhdB84RmOYsNo1
 s8TBNlC0sWYYrKPzi5zX0xrPI5dZBHZNYP0pIAnRLRKTg9Bj/8n1RVCuK8qkNXrjuFVy jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cmdwbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 21:34:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FLXuxO134972;
        Wed, 15 Jul 2020 21:34:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32a4crd010-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 21:34:25 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FLYOfW018438;
        Wed, 15 Jul 2020 21:34:24 GMT
Received: from localhost.localdomain (/10.159.239.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 14:34:24 -0700
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Restore active host RIP/CR4
 after test_host_addr_size()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
 <20200714002355.538-2-sean.j.christopherson@intel.com>
 <378edd35-38eb-1d62-8471-f111c17afee7@oracle.com>
 <20200715184810.GC12349@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c00836d0-45bb-3d50-5082-6670c1c5e2a9@oracle.com>
Date:   Wed, 15 Jul 2020 14:34:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200715184810.GC12349@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/15/20 11:48 AM, Sean Christopherson wrote:
> On Wed, Jul 15, 2020 at 11:34:46AM -0700, Krish Sadhukhan wrote:
>> On 7/13/20 5:23 PM, Sean Christopherson wrote:
>>> Perform one last VMX transition to actually load the host's RIP and CR4
>>> at the end of test_host_addr_size().  Simply writing the VMCS doesn't
>>> restore the values in hardware, e.g. as is, CR4.PCIDE can be left set,
>>> which causes spectacularly confusing explosions when other misguided
>>> tests assume setting bit 63 in CR3 will cause a non-canonical #GP.
>>>
>>> Fixes: 0786c0316ac05 ("kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested guests")
>>> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>> Cc: Karl Heubaum <karl.heubaum@oracle.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   x86/vmx_tests.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index 29f3d0e..cb42a2d 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -7673,6 +7673,11 @@ static void test_host_addr_size(void)
>>>   		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
>>>   		vmcs_write(HOST_RIP, rip_saved);
>>>   		vmcs_write(HOST_CR4, cr4_saved);
>>> +
>>> +		/* Restore host's active RIP and CR4 values. */
>>> +		report_prefix_pushf("restore host state");
>>> +		test_vmx_vmlaunch(0);
>>> +		report_prefix_pop();
>>>   	}
>>>   }
>> Just for my understanding.  When you say, "other misguided tests", which
>> tests are you referring to ?  In the current sequence of tests in
>> vmx_host_state_area_test(), test_load_host_perf_global_ctrl() is the  one
>> that follows and it runs fine.
> See test_mtf_guest() in patch 2/2.  https://patchwork.kernel.org/patch/11661189/

I ran the two tests as follows but couldn't reproduce it:

     ./x86/run x86/vmx.flat  -smp 1 -cpu host,+vmx -append 
"vmx_host_state_area_test vmx_mtf_test"


How did you run the them ?

