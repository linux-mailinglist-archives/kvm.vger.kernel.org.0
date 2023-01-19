Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F59D673995
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 14:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjASNKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 08:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjASNIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 08:08:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF66798C1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 05:08:41 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JCKlTU029976;
        Thu, 19 Jan 2023 13:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u84ZFt5oKG52HGOkFH+/VGTn1J4zI1utC8K/a+fTEY8=;
 b=PJSzdlm4N4u1KU+tUkdVIiW5DLzArbURs17DW3L/xyMJlLl97z9O+S+ywZUOObaWliFE
 wEmKemkXJNL2a2Z6ZUIwDTuZuQchtqWbYuWityaV/owlgpZlDwC205P48Is018NMZLlz
 +0czEO+WaySRlSq71pYV+YtsA1pkYWRAsNJrtLtwIxEBEOWYB3vOK/E/HdKBxnE7Brwx
 125MINNTAG7U7mgrlfnXp5+VzidbG2J+RMLgSuGUZIweZCYaR2TcDT/VBrnTl10nTU6e
 RJEMNuqPB2GPgXxkcJ/ALTcAuYYzFKwHigd6Wt2Cv7rYAM7+np32LSlaf3RcGOAGcytF mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc045xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:08:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JCgUul017400;
        Thu, 19 Jan 2023 13:08:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc045w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:08:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J6b5FM023694;
        Thu, 19 Jan 2023 13:08:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16pqaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:08:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JD8NFr32571720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 13:08:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8350820043;
        Thu, 19 Jan 2023 13:08:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E36520040;
        Thu, 19 Jan 2023 13:08:20 +0000 (GMT)
Received: from [9.152.224.248] (unknown [9.152.224.248])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 13:08:19 +0000 (GMT)
Message-ID: <e4527b0e-fd4e-7caa-f4ce-9b254b1e2801@linux.ibm.com>
Date:   Thu, 19 Jan 2023 14:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-5-pmorel@linux.ibm.com>
 <e65bce5b-977c-ed19-9562-3af8ee8e9fba@redhat.com>
 <22aff83d-4379-e4f0-9826-33f986ddeec7@linux.ibm.com>
 <0103e627a835013e00a9c55d46348e76b94366e9.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <0103e627a835013e00a9c55d46348e76b94366e9.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 38VMioND3IB-uP8koP-4oCxMGVgQlw7Y
X-Proofpoint-GUID: 3OfC6ysQ0iQ-lKSOZiTrwN1FlIXQ3aUi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190103
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/17/23 20:58, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-01-17 at 18:36 +0100, Pierre Morel wrote:
>>
>> On 1/11/23 09:57, Thomas Huth wrote:
>>> On 05/01/2023 15.53, Pierre Morel wrote:
>>>> The maximum nested topology entries is used by the guest to know
>>>> how many nested topology are available on the machine.
>>>>
>>>> Currently, SCLP READ SCP INFO reports MNEST = 0, which is the
>>>> equivalent of reporting the default value of 2.
>>>> Let's use the default SCLP value of 2 and increase this value in the
>>>> future patches implementing higher levels.
>>>
>>> I'm confused ... so does a SCLP value of 2 mean a MNEST level of 4 ?
>>
>> Sorry, I forgot to change this.
>> MNEST = 0 means no MNEST support and only socket is supported so it is
>> like MNEST = 2.
>> MNEST != 0 set the maximum nested level and correct values may be 2,3 or 4.
>> But this setting to 4 should already have been done in previous patch
>> where we introduced the books and drawers.
> 
> I think setting it to 4 here is fine/preferable, since 2 is the default unless
> you tell the guest that more are available, which you do in this patch.
> It's only the commit description that is confusing.

Yes.
Only the commit message is confusing, it is to be set on 4 in this patch.

I change the commit message to:

---
s390x/sclp: reporting the maximum nested topology entries

The maximum nested topology entries is used by the guest to
know how many nested topology are available on the machine.

Let change the MNEST value from 2 to 4 in the SCLP READ INFO
structure now that we support books and drawers.
---

is it OK ?

Regards,
Pierre

> 
>>
>> I change the commit message with:
>> ---
>> s390x/sclp: reporting the maximum nested topology entries
>>
>> The maximum nested topology entries is used by the guest to know
>> how many nested topology are available on the machine.
>>
>> Let's return this information to the guest.
>> ---
>>
>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    include/hw/s390x/sclp.h | 5 +++--
>>>>    hw/s390x/sclp.c         | 4 ++++
>>>>    2 files changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
>>>> index 712fd68123..4ce852473c 100644
>>>> --- a/include/hw/s390x/sclp.h
>>>> +++ b/include/hw/s390x/sclp.h
>>>> @@ -112,12 +112,13 @@ typedef struct CPUEntry {
>>>>    } QEMU_PACKED CPUEntry;
>>>>    #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
>>>> -#define SCLP_READ_SCP_INFO_MNEST                2
>>>> +#define SCLP_READ_SCP_INFO_MNEST                4
>>>
>>> ... since you update it to 4 here.
>>
>> Yes, in fact this should be set in the previous patch already to 4.
>> So I will do that.
>>
>>>
>>>>    typedef struct ReadInfo {
>>>>        SCCBHeader h;
>>>>        uint16_t rnmax;
>>>>        uint8_t rnsize;
>>>> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
>>>> +    uint8_t  _reserved1[15 - 11];       /* 11-14 */
>>>> +    uint8_t  stsi_parm;                 /* 15-16 */
>>>>        uint16_t entries_cpu;               /* 16-17 */
>>>>        uint16_t offset_cpu;                /* 18-19 */
>>>>        uint8_t  _reserved2[24 - 20];       /* 20-23 */
>>>> diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
>>>> index eff74479f4..07e3cb4cac 100644
>>>> --- a/hw/s390x/sclp.c
>>>> +++ b/hw/s390x/sclp.c
>>>> @@ -20,6 +20,7 @@
>>>>    #include "hw/s390x/event-facility.h"
>>>>    #include "hw/s390x/s390-pci-bus.h"
>>>>    #include "hw/s390x/ipl.h"
>>>> +#include "hw/s390x/cpu-topology.h"
>>>>    static inline SCLPDevice *get_sclp_device(void)
>>>>    {
>>>> @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB
>>>> *sccb)
>>>>        /* CPU information */
>>>>        prepare_cpu_entries(machine, entries_start, &cpu_count);
>>>> +    if (s390_has_topology()) {
>>>> +        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
>>>
>>> This seems to be in contradiction to what you've said in the commit
>>> description - you set it to 4 and not to 2.
>>
>> Yes, I change the commit message.
>>
>> Thanks.
>>
>> Regards,
>> Pierre
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
