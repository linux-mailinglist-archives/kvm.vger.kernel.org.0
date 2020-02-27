Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85CE1717E0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 13:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgB0Mzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 07:55:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728977AbgB0Mzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 07:55:39 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RCos6k160698
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 07:55:37 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ye711qgx5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 07:55:37 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 27 Feb 2020 12:55:35 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 12:55:32 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RCtVOQ46662088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 12:55:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E1CE4204C;
        Thu, 27 Feb 2020 12:55:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E88E24203F;
        Thu, 27 Feb 2020 12:55:30 +0000 (GMT)
Received: from [9.152.99.203] (unknown [9.152.99.203])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 12:55:30 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH] KVM: s390: introduce module parameter kvm.use_gisa
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     frankja@linux.vnet.ibm.com, kvm@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, linux-s390@vger.kernel.org
References: <20200227091031.102993-1-mimu@linux.ibm.com>
 <c16f65a7-5711-96e2-1527-fa13eab9f5ca@de.ibm.com>
 <20200227134810.268fc3b5.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 27 Feb 2020 13:56:35 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227134810.268fc3b5.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022712-0020-0000-0000-000003AE1D15
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022712-0021-0000-0000-000022063C24
Message-Id: <0ecc5167-2a33-0f99-a8c3-6e74cf3689a5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_03:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.02.20 13:48, Cornelia Huck wrote:
> On Thu, 27 Feb 2020 13:27:10 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 27.02.20 10:10, Michael Mueller wrote:
>>> The boolean module parameter "kvm.use_gisa" controls if newly
>>> created guests will use the GISA facility if provided by the
>>> host system. The default is yes.
>>>
>>>    # cat /sys/module/kvm/parameters/use_gisa
>>>    Y
>>>
>>> The parameter can be changed on the fly.
>>>
>>>    # echo N > /sys/module/kvm/parameters/use_gisa
>>>
>>> Already running guests are not affected by this change.
>>>
>>> The kvm s390 debug feature shows if a guest is running with GISA.
>>>
>>>    # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
>>>    00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
>>>    00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
>>>    ...
>>>    00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared
>>>
>>> In general, that value should not be changed as the GISA facility
>>> enhances interruption delivery performance.
>>>
>>> A reason to switch the GISA facility off might be a performance
>>> comparison run or debugging.
>>>
>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>>
>> Looks good to me. Regarding the other comments, I think allowing for dynamic changes
>> and keeping use_gisa vs disable_gisa makes sense. So I would think that the patch
>> as is makes sense.
> 
> use_gisa vs disable_gisa is more a personal preference; I don't mind
> keeping it as use_gisa.
> 
>>
>> The only question is: shall we set use_gisa to 0 when the machine does not support
>> it (e.g. VSIE?) and then also forbid setting it to 1? Could be overkill.
> 
> I don't think you should try to overload a debug knob like that; it's
> now simple enough, adding more code also adds to the potential for
> errors.
> 
>>
>>
>>> ---
>>>   arch/s390/kvm/kvm-s390.c | 8 +++++++-
>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index d7ff30e45589..5c2081488024 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -184,6 +184,11 @@ static u8 halt_poll_max_steal = 10;
>>>   module_param(halt_poll_max_steal, byte, 0644);
>>>   MODULE_PARM_DESC(halt_poll_max_steal, "Maximum percentage of steal time to allow polling");
>>>   
>>> +/* if set to true, the GISA will be initialized and used if available */
>>> +static bool use_gisa  = true;
>>> +module_param(use_gisa, bool, 0644);
>>> +MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
> 
> Especially as the description explicitly says "if the host supports it"
> -- that's good enough for a new knob.
> 
>>> +
>>>   /*
>>>    * For now we handle at most 16 double words as this is what the s390 base
>>>    * kernel handles and stores in the prefix page. If we ever need to go beyond
>>> @@ -2504,7 +2509,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>   	kvm->arch.use_skf = sclp.has_skey;
>>>   	spin_lock_init(&kvm->arch.start_stop_lock);
>>>   	kvm_s390_vsie_init(kvm);
>>> -	kvm_s390_gisa_init(kvm);
>>> +	if (use_gisa)
>>> +		kvm_s390_gisa_init(kvm);
>>>   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
>>>   
>>>   	return 0;
>>>    
>>
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks!

