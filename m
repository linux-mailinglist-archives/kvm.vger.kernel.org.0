Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6167557DF8
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiFWOhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiFWOg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:36:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFA3434AA
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:36:57 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NEaCqt028964;
        Thu, 23 Jun 2022 14:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yi5rsBUmm4XxTOle/HCeIAGdS+RgJtlEMNmbObZnWO4=;
 b=rIsN/dR+TUPfeY5geqtho2m6mB4fFTgG8w6CLDfGKj1+0wHy1Q4VDIfOuSqTBg8zEc3H
 hK3dWGIbI+eepyCCcAgvNnUci2KoedOsDhbrKTjh0HhN22c1LejDkflPPh9+jUAxuEjq
 CjzrA+CiYvbpTGn+4ftcOKWvAcYEDtpcbd5eSWTqiY2ImtS0B1FzQNmANGzhnPw2sYb1
 NVk2iI754oQA1FmY8bAjIiGOj7CRFxtD/p5XsLtycswMi0c8V+k4vPIU2RgJnhpS9q2E
 l8kPt89yucSgRZRQgUTG8saEP+DuupadV3YIKhJTWz+Dr4khiwLMVs9bytnl9BUsg+wA DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvsdeh5mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 14:36:38 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25NEaRnC031100;
        Thu, 23 Jun 2022 14:36:36 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvsdeh3nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 14:36:34 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25NEM2xY021650;
        Thu, 23 Jun 2022 14:26:23 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 3gvrxqgb5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 14:26:23 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25NEQMfA34930972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 14:26:22 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 099817805C;
        Thu, 23 Jun 2022 14:26:22 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9D6B7805F;
        Thu, 23 Jun 2022 14:26:20 +0000 (GMT)
Received: from [9.211.143.38] (unknown [9.211.143.38])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jun 2022 14:26:20 +0000 (GMT)
Message-ID: <ae85d880-97c3-20da-8ef1-c06e04ce7b9b@linux.ibm.com>
Date:   Thu, 23 Jun 2022 10:26:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v7 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine
 property
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
 <20220606203614.110928-9-mjrosato@linux.ibm.com>
 <a39b5023-8db2-fb13-8afd-67c18fbe7d53@linux.ibm.com>
 <3ac2e525-87b4-b906-9830-5d89f5d006df@linux.ibm.com>
 <5c6bd37d-45b3-026a-aa2c-e9d6c3349cf9@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <5c6bd37d-45b3-026a-aa2c-e9d6c3349cf9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YMV_IIwy7pRBTDcJY7Ycf97mg3WW-kau
X-Proofpoint-GUID: 5DOZIL6MW2gYG79O3DbyaaQLEFSwYy-j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_06,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206230059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 9:50 AM, Pierre Morel wrote:
> 
> 
> On 6/22/22 17:20, Matthew Rosato wrote:
>> On 6/22/22 4:50 AM, Pierre Morel wrote:
>>>
>>>
>>> On 6/6/22 22:36, Matthew Rosato wrote:
>>>> The zpcii-disable machine property can be used to force-disable the use
>>>> of zPCI interpretation facilities for a VM.  By default, this setting
>>>> will be off for machine 7.1 and newer.
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>   hw/s390x/s390-pci-kvm.c            |  4 +++-
>>>>   hw/s390x/s390-virtio-ccw.c         | 24 ++++++++++++++++++++++++
>>>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>>>   qemu-options.hx                    |  8 +++++++-
>>>>   util/qemu-config.c                 |  4 ++++
>>>>   5 files changed, 39 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
>>>> index 9134fe185f..5eb7fd12e2 100644
>>>> --- a/hw/s390x/s390-pci-kvm.c
>>>> +++ b/hw/s390x/s390-pci-kvm.c
>>>> @@ -22,7 +22,9 @@
>>>>   bool s390_pci_kvm_interp_allowed(void)
>>>>   {
>>>> -    return kvm_s390_get_zpci_op() && !s390_is_pv();
>>>> +    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
>>>> +            !object_property_get_bool(OBJECT(qdev_get_machine()),
>>>> +                                      "zpcii-disable", NULL));
>>>>   }
>>>
>>> Isn't it a duplication of machine_get_zpcii_disable?
>>>
>>
>> No, this will actually trigger machine_get_zpcii_disable -- it was 
>> setup as the 'getter' routine in s390_machine_initfn() -- see below:
> 
> OK, I did not explain myself correctly:
> I was curious why we do not use directly ms->zpci_disabled and use the 
> getter.
> 

To do so, we'd have to either call machine_get_zpcii_disable directly 
from here or duplicate the work machine_get_zpcii_disable does by 
casting the machine to S390CcwMachineState so we could look at 
ms->zpcii_disabled.  We can't call machine_get_zpcii_disable directly 
as-is, it's a static routine in s390-virtio-ccw.c -- making a 'getter' 
routine public seems wrong, so we are left with recreating the cast and 
looking at ms->zpcii_disabled here; but as far as I can figure the point 
is to have a unified interface for querying a machine property value via 
object_property_get_*().  Why wouldn't we use that interface?

FWIW, I modeled this after the way we today handle aes-key-wrap in 
target/s390x/kvm/kvm.c and loadparm in hw/s390x/ipl.c (albeit we use 
object_property_get_str for the latter since it's a different property 
type).


> Does not mean it is false. Far from.
>  >>
>>> Wouldn't it better go to hw/s390x/kvm/ ?
>>>
>>> There get the MachineState *ms = MACHINE(qdev_get_machine()) and 
>>> return the ms->zpcii_disable
>>>
>>> ?
>>>
>>>>   int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, 
>>>> bool assist)
>>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>>> index cc3097bfee..70229b102b 100644
>>>> --- a/hw/s390x/s390-virtio-ccw.c
>>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>>> @@ -645,6 +645,21 @@ static inline void 
>>>> machine_set_dea_key_wrap(Object *obj, bool value,
>>>>       ms->dea_key_wrap = value;
>>>>   }
>>>> +static inline bool machine_get_zpcii_disable(Object *obj, Error 
>>>> **errp)
>>>> +{
>>>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>>>> +
>>>> +    return ms->zpcii_disable;
>>>> +}
>>>> +
>>>> +static inline void machine_set_zpcii_disable(Object *obj, bool value,
>>>> +                                             Error **errp)
>>>> +{
>>>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>>>> +
>>>> +    ms->zpcii_disable = value;
>>>> +}
>>>> +
>>>>   static S390CcwMachineClass *current_mc;
>>>>   /*
>>>> @@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object 
>>>> *obj)
>>>>               "Up to 8 chars in set of [A-Za-z0-9. ] (lower case 
>>>> chars converted"
>>>>               " to upper case) to pass to machine loader, boot 
>>>> manager,"
>>>>               " and guest kernel");
>>>> +
>>>> +    object_property_add_bool(obj, "zpcii-disable",
>>>> +                             machine_get_zpcii_disable,
>>
>> ^^ Here.
> 

