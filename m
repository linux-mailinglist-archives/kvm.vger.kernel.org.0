Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF536863E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 19:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhDVR5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 13:57:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVR5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 13:57:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHt1Zh128869;
        Thu, 22 Apr 2021 17:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+eYHU4INq3bzBGpE+DXyPkvQC1OQIgdVUrexPZD3DTQ=;
 b=y4eEFzZbux04DC/jXOdKr9LeADSpp+gx7J32BMsVxlfZZQ6/zGh1bXlExe+hLtAdzPB0
 Kgnav5F8ikSTMkG6nAnibrgVohjR4dw7JDhw/9D7H/w1oTju3EKm+bU6Hl+o+rD334RV
 EzTVdqw8v0fEakWBqiMVgoQaVczcjO5OM4tyNRxHt7etNZEhXz1uPbL12lXfF5nBCFDI
 ayTkKqc0YTKNRyNa6/XhK3/MFAomEolDxrd0TwRobrhh0igOrZuJwAxs5Mr8VdRVIPXS
 WZyv+0lVIR3m3/eduT3sH7VgUByzqakpJlDylsFSqiw1dxPa6ruORgDn7NveB7CcRFVk eA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37yqmnp8j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:56:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHtrV4144817;
        Thu, 22 Apr 2021 17:56:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 383ccemb8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:56:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13MHuamr002664;
        Thu, 22 Apr 2021 17:56:36 GMT
Received: from localhost.localdomain (/10.159.130.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Apr 2021 10:56:36 -0700
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
Message-ID: <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
Date:   Thu, 22 Apr 2021 10:56:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220135
X-Proofpoint-ORIG-GUID: TV4PulFLmH0Ku9xNSOMbcEF1HJ_5reTx
X-Proofpoint-GUID: TV4PulFLmH0Ku9xNSOMbcEF1HJ_5reTx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/22/21 10:50 AM, Krish Sadhukhan wrote:
>
> On 4/20/21 1:00 PM, Sean Christopherson wrote:
>> On Mon, Apr 12, 2021, Krish Sadhukhan wrote:
>>> According to APM vol 2, hardware ignores the low 12 bits in MSRPM 
>>> and IOPM
>>> bitmaps. Therefore setting/unssetting these bits has no effect as 
>>> far as
>>> VMRUN is concerned. Also, setting/unsetting these bits prevents 
>>> tests from
>>> verifying hardware behavior.
>>>
>>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>> ---
>>>   arch/x86/kvm/svm/nested.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>>> index ae53ae46ebca..fd42c8b7f99a 100644
>>> --- a/arch/x86/kvm/svm/nested.c
>>> +++ b/arch/x86/kvm/svm/nested.c
>>> @@ -287,8 +287,6 @@ static void 
>>> nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>>>         /* Copy it here because nested_svm_check_controls will check 
>>> it.  */
>>>       svm->nested.ctl.asid           = control->asid;
>>> -    svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
>>> -    svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>> This will break nested_svm_vmrun_msrpm() if L1 passes an unaligned 
>> address.
>> The shortlog is also wrong, KVM isn't setting bits, it's clearing bits.
>>
>> I also don't think svm->nested.ctl.msrpm_base_pa makes its way to 
>> hardware; IIUC,
>> it's a copy of vmcs12->control.msrpm_base_pa.  The bitmap that gets 
>> loaded into
>> the "real" VMCB is vmcb02->control.msrpm_base_pa.
>
>
> Not sure if there's a problem with my patch as such, but upon 
> inspecting the code, I see something missing:
>
>     In nested_load_control_from_vmcb12(), we are not really loading 
> msrpm_base_pa from vmcb12 even     though the name of the function 
> suggests so.
>
>     Then nested_vmcb_check_controls() checks msrpm_base_pa from 
> 'nested.ctl' which doesn't have         the copy from vmcb12.
>
>     Then nested_vmcb02_prepare_control() prepares the vmcb02 copy of 
> msrpm_base_pa from vmcb01.ptr->control.msrpm_base_pa.
>
>     Then nested_svm_vmrun_msrpm() uses msrpm_base_pa from 'nested.ctl'.
>
>
> Aren't we actually using msrpm_base_pa from vmcb01 instead of vmcb02 ?


Sorry, I meant to say,  "from vmcb01 instead of vmcb12"

>
>>>   }
>>>     /*
>>> -- 
>>> 2.27.0
>>>
