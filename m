Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFC36863D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhDVRx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 13:53:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbhDVRx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 13:53:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHo2wS090224;
        Thu, 22 Apr 2021 17:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LhDwt90eaZvon5rUc+tJE/t3SSwW/QKL6JAHVKq1Znc=;
 b=kJCfSPk9sanDNC5bcVWDcxwLV7eDXWswOuYnz3E83RBWo1Ie1bDOl2LBHI+CIxcFppAS
 gzeCLnnM81I5rrwocGmC/OF4k7U0XDCjUATe7b/ypn0l8M+WJtKAJpUuMhwzigukDcTa
 Gfr0SuLm37ZTAJtGRyZAoZWfaZ3Bf9GpOQwSQkLJ1A2K7Gq1CNTyZyFtSTdWpLndRUnG
 wt7Bp6seVWdcBiccWhoQDgWltDlEMPIwQ6o3JRFYVlnXPedDd7JrTscShLnaXGsiAo/y
 hh61mcWwNIgy2tc3TPBd/tQiElgTHThVAZnS02m/t2RRemNeJZ+lJ1tj+Higz+1VZYno ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38022y5kvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:52:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHoAc9087561;
        Thu, 22 Apr 2021 17:52:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 383cdrvdnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:52:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13MHqkM7009095;
        Thu, 22 Apr 2021 17:52:46 GMT
Received: from localhost.localdomain (/10.159.130.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Apr 2021 17:52:46 +0000
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
Message-ID: <ea03a5b5-adc2-c574-3d69-18df72cce6e6@oracle.com>
Date:   Thu, 22 Apr 2021 10:52:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220134
X-Proofpoint-ORIG-GUID: h1mtssgvxUHxLe5pfHqF6JMFe02nbOIY
X-Proofpoint-GUID: h1mtssgvxUHxLe5pfHqF6JMFe02nbOIY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220134
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

Sorry, I meant to say:  Aren't we actually using msrpm_base_pa from 
vmcb01 instead of vmcb12 ?
>
>>>   }
>>>     /*
>>> -- 
>>> 2.27.0
>>>
