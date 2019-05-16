Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA8021072
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 00:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfEPWIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 18:08:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfEPWIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 18:08:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GLwkdk131288;
        Thu, 16 May 2019 22:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=N+RrLuQi/yWZ/T4pDK9Q7Cqmdio1ysKCh9wepuuqeQg=;
 b=w5V/D8ovPxpyZYTc61eBr08UCDm1DZ/rbMgfpzq5XTULo/mkNmFTdz8bwaYeU0jMETsG
 obzLPMZ2k/QDQCDh2KFZsqF54/5RPeqJGx2KYsa10jzsTrNNNtZuiRNcYPSyn7eIkHRs
 kLcsNN/brI9Sl3xkiDkchu7my9Ih/2/GDDR8DCoIc82mIWVM8U6sUPlNgVKjs8IWK863
 nJO+VH3oafqD8SjDLSK+S/1InSH966vVYhCyMMC0Nl6rMO7xO/n6kWswC3zXYRc7APLY
 5qz92EnsVt0ZA6DfhN53B7SViD6PqBz6lrbmuznOIrzcjl9wfsZ/Or3FHPhaeGBaIqqg MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sdq1qx8jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 22:07:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GM7gps129809;
        Thu, 16 May 2019 22:07:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2sgkx4bfcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 22:07:50 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4GM7nvI003861;
        Thu, 16 May 2019 22:07:49 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 15:07:49 -0700
Subject: Re: [PATCH 4/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" VM-exit
 control on vmentry of nested guests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-5-krish.sadhukhan@oracle.com>
 <20190513190016.GI28561@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <2c08cd38-fd7d-da68-7c8d-2c7c93c3a9c8@oracle.com>
Date:   Thu, 16 May 2019 15:07:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190513190016.GI28561@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905160134
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905160133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/13/2019 12:00 PM, Sean Christopherson wrote:
> On Wed, Apr 24, 2019 at 07:17:20PM -0400, Krish Sadhukhan wrote:
>> According to section "Checks on Host Control Registers and MSRs" in Intel
>> SDM vol 3C, the following check is performed on vmentry of nested guests:
>>
>>      "If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, bits reserved
>>      in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
>>      register."
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 83cd887638cb..d2067370e288 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2595,6 +2595,11 @@ static int nested_check_host_control_regs(struct kvm_vcpu *vcpu,
>>   	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
>>   	    !nested_cr3_valid(vcpu, vmcs12->host_cr3))
>>   		return -EINVAL;
>> +
>> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
>> +	   !kvm_valid_perf_global_ctrl(vmcs12->host_ia32_perf_global_ctrl))
> If vmcs12->host_ia32_perf_global_ctrl were ever actually consumed, this
> needs to ensure L1 isn't able to take control of counters that are owned
> by the host.

Sorry, I didn't understand your concern. Could you please explain how L1 
can control L0's counters ?

>
>> +		return -EINVAL;
>> +
>>   	/*
>>   	 * If the load IA32_EFER VM-exit control is 1, bits reserved in the
>>   	 * IA32_EFER MSR must be 0 in the field for that register. In addition,
>> -- 
>> 2.17.2
>>

