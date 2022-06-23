Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038B1557D40
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiFWNq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 09:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiFWNq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 09:46:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE2030548
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:46:27 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NDWtK5022466;
        Thu, 23 Jun 2022 13:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PZZDf+63CUXTDJ70UmWwLm2+Ijvm1sO72iJLvf9EOGw=;
 b=LwtlSfX8ZT1X2cLdyZOhwvvqQKNTZM5z6WNUYZ3UexayPd6Gb1BZktuCUnqhRcT+wzFu
 1UVo//cYgLL7kR8Or3tCjWybS57BgvCgOL037afnAlY/bQq7LiGU9pfns2U39s4AI4hd
 FvqxOdlRdrIo0wd3EcU4/oxD5XdMCR0sxO4iPZmpyx+t45qqmXRf5/j0+sp0BTXwBDBc
 yDTevQRvbAY8MwRl9K8QUQwg1BTKN7nBtCfElKLuVz/CFj++6kMTqNRqCLBuHo9aqQ7t
 ruACE1AMrTnf1W905hO22s2hlOywx8i0jsBej49uTTS0Fk9/Ku4wxuUgHTHPpNQCz6gz CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvs5grakt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 13:46:21 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25NDYis7027192;
        Thu, 23 Jun 2022 13:46:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvs5grakc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 13:46:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25NDaZDI023385;
        Thu, 23 Jun 2022 13:46:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gv9r717nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 13:46:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25NDkFl220185358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 13:46:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E90FA4053;
        Thu, 23 Jun 2022 13:46:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE52FA404D;
        Thu, 23 Jun 2022 13:46:14 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jun 2022 13:46:14 +0000 (GMT)
Message-ID: <5c6bd37d-45b3-026a-aa2c-e9d6c3349cf9@linux.ibm.com>
Date:   Thu, 23 Jun 2022 15:50:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine
 property
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
 <20220606203614.110928-9-mjrosato@linux.ibm.com>
 <a39b5023-8db2-fb13-8afd-67c18fbe7d53@linux.ibm.com>
 <3ac2e525-87b4-b906-9830-5d89f5d006df@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3ac2e525-87b4-b906-9830-5d89f5d006df@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bH9k_uy0NUR7qiAZ5hnqaauvUCBKECPl
X-Proofpoint-ORIG-GUID: ovSq5EkzSU9g1FyCKHtzquKiOFDYTlbO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_05,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/22/22 17:20, Matthew Rosato wrote:
> On 6/22/22 4:50 AM, Pierre Morel wrote:
>>
>>
>> On 6/6/22 22:36, Matthew Rosato wrote:
>>> The zpcii-disable machine property can be used to force-disable the use
>>> of zPCI interpretation facilities for a VM.  By default, this setting
>>> will be off for machine 7.1 and newer.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   hw/s390x/s390-pci-kvm.c            |  4 +++-
>>>   hw/s390x/s390-virtio-ccw.c         | 24 ++++++++++++++++++++++++
>>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>>   qemu-options.hx                    |  8 +++++++-
>>>   util/qemu-config.c                 |  4 ++++
>>>   5 files changed, 39 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
>>> index 9134fe185f..5eb7fd12e2 100644
>>> --- a/hw/s390x/s390-pci-kvm.c
>>> +++ b/hw/s390x/s390-pci-kvm.c
>>> @@ -22,7 +22,9 @@
>>>   bool s390_pci_kvm_interp_allowed(void)
>>>   {
>>> -    return kvm_s390_get_zpci_op() && !s390_is_pv();
>>> +    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
>>> +            !object_property_get_bool(OBJECT(qdev_get_machine()),
>>> +                                      "zpcii-disable", NULL));
>>>   }
>>
>> Isn't it a duplication of machine_get_zpcii_disable?
>>
> 
> No, this will actually trigger machine_get_zpcii_disable -- it was setup 
> as the 'getter' routine in s390_machine_initfn() -- see below:

OK, I did not explain myself correctly:
I was curious why we do not use directly ms->zpci_disabled and use the 
getter.

Does not mean it is false. Far from.

> 
>> Wouldn't it better go to hw/s390x/kvm/ ?
>>
>> There get the MachineState *ms = MACHINE(qdev_get_machine()) and 
>> return the ms->zpcii_disable
>>
>> ?
>>
>>>   int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, 
>>> bool assist)
>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>> index cc3097bfee..70229b102b 100644
>>> --- a/hw/s390x/s390-virtio-ccw.c
>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>> @@ -645,6 +645,21 @@ static inline void 
>>> machine_set_dea_key_wrap(Object *obj, bool value,
>>>       ms->dea_key_wrap = value;
>>>   }
>>> +static inline bool machine_get_zpcii_disable(Object *obj, Error **errp)
>>> +{
>>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>>> +
>>> +    return ms->zpcii_disable;
>>> +}
>>> +
>>> +static inline void machine_set_zpcii_disable(Object *obj, bool value,
>>> +                                             Error **errp)
>>> +{
>>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>>> +
>>> +    ms->zpcii_disable = value;
>>> +}
>>> +
>>>   static S390CcwMachineClass *current_mc;
>>>   /*
>>> @@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object *obj)
>>>               "Up to 8 chars in set of [A-Za-z0-9. ] (lower case 
>>> chars converted"
>>>               " to upper case) to pass to machine loader, boot manager,"
>>>               " and guest kernel");
>>> +
>>> +    object_property_add_bool(obj, "zpcii-disable",
>>> +                             machine_get_zpcii_disable,
> 
> ^^ Here.

-- 
Pierre Morel
IBM Lab Boeblingen
