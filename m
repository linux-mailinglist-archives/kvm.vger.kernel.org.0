Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2482A1722DC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 17:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgB0QJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 11:09:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729134AbgB0QJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 11:09:49 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RG0q9I078424
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 11:09:48 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydxre55u1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 11:09:48 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 27 Feb 2020 16:09:46 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 16:09:42 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RG9fEx36175924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 16:09:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 602614204D;
        Thu, 27 Feb 2020 16:09:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DF2842047;
        Thu, 27 Feb 2020 16:09:41 +0000 (GMT)
Received: from [9.152.99.203] (unknown [9.152.99.203])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 16:09:41 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH] KVM: s390: introduce module parameter kvm.use_gisa
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        frankja@linux.vnet.ibm.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, linux-s390@vger.kernel.org
References: <20200227091031.102993-1-mimu@linux.ibm.com>
 <c16f65a7-5711-96e2-1527-fa13eab9f5ca@de.ibm.com>
 <48bbf704-11c7-0f67-a5ca-ae2841faccde@linux.ibm.com>
 <9195cc6d-a266-1c05-cba9-e434cd1bd0b7@de.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 27 Feb 2020 17:10:45 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9195cc6d-a266-1c05-cba9-e434cd1bd0b7@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022716-0012-0000-0000-0000038ADDDA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022716-0013-0000-0000-000021C787C4
Message-Id: <6d7b7e6b-23af-05c7-5b59-aa83f86ee2ad@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_05:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 adultscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.02.20 14:24, Christian Borntraeger wrote:
> 
> 
> On 27.02.20 13:43, Michael Mueller wrote:
>>
>>
>> On 27.02.20 13:27, Christian Borntraeger wrote:
>>>
>>>
>>> On 27.02.20 10:10, Michael Mueller wrote:
>>>> The boolean module parameter "kvm.use_gisa" controls if newly
>>>> created guests will use the GISA facility if provided by the
>>>> host system. The default is yes.
>>>>
>>>>     # cat /sys/module/kvm/parameters/use_gisa
>>>>     Y
>>>>
>>>> The parameter can be changed on the fly.
>>>>
>>>>     # echo N > /sys/module/kvm/parameters/use_gisa
>>>>
>>>> Already running guests are not affected by this change.
>>>>
>>>> The kvm s390 debug feature shows if a guest is running with GISA.
>>>>
>>>>     # grep gisa /sys/kernel/debug/s390dbf/kvm-$pid/sprintf
>>>>     00 01582725059:843303 3 - 08 00000000e119bc01  gisa 0x00000000c9ac2642 initialized
>>>>     00 01582725059:903840 3 - 11 000000004391ee22  00[0000000000000000-0000000000000000]: AIV gisa format-1 enabled for cpu 000
>>>>     ...
>>>>     00 01582725059:916847 3 - 08 0000000094fff572  gisa 0x00000000c9ac2642 cleared
>>>>
>>>> In general, that value should not be changed as the GISA facility
>>>> enhances interruption delivery performance.
>>>>
>>>> A reason to switch the GISA facility off might be a performance
>>>> comparison run or debugging.
>>>>
>>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>>>
>>> Looks good to me. Regarding the other comments, I think allowing for dynamic changes
>>> and keeping use_gisa vs disable_gisa makes sense. So I would think that the patch
>>> as is makes sense.
>>>
>>> The only question is: shall we set use_gisa to 0 when the machine does not support
>>> it (e.g. VSIE?) and then also forbid setting it to 1? Could be overkill.
>>
>> Then I would rename the parameter to "try_to_use_gisa" instead. (a joke ;) )
>>
>> In that case we exit gisa_init() because of the missing AIV facility.
>>
>> void kvm_s390_gisa_init(struct kvm *kvm)
>> {
>>          struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>>
>> -->    if (!css_general_characteristics.aiv)
>>                  return;
>>          gi->origin = &kvm->arch.sie_page2->gisa;
>>          gi->alert.mask = 0;
>>      ...
>> }
>>
> 
> I know. My point was more: "can we expose this". But this is probably overkill.

I agree with Connie here, that would make the whole thing
just more error-prone. That way the messages are at least
consistent.

> 

