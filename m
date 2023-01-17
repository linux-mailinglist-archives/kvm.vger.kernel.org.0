Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC5566E539
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 18:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjAQRse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 12:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAQRqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 12:46:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F1B1554B
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:36:36 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGE3Ra026756;
        Tue, 17 Jan 2023 17:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jGGuIWsX4s7fbyAnVnRWk7AsoIWXaHuDdBJQCGslBg0=;
 b=dhMjIWuGz/ZyCc2jZrtaZBSRrqy9jowxMZzMfmhbGPZddQEtv5zPY5maCBGhBdSyEUAp
 6bhNhTT+XF9Kdn3g6bzG6kYmLr5fvY3RYkaU4hBSPCvMbHwB0CKzFt3lQI0ql+zCHNdN
 fDW2GUfoAaTNhux4USOS1GkOduJqAb0R+nhhmDVbJX3qb5/N1wM/mYhregDP0g+jjE5t
 VsJue2BtLXe9SsErE4Ru93v1oqNCIkfJ9dUersgRJvvlDC73l/o4WsA1DZT7Uolsp1sK
 8pxn1VJS4dF4HvzXfVSMdCPJSuDi1+l/GOs9YdjWFdtHnk0sfO3kOY2SjUBeYb38RUYb tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3uutyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:36:19 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HGmB5S027942;
        Tue, 17 Jan 2023 17:36:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3uutxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:36:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H8vxP9017966;
        Tue, 17 Jan 2023 17:36:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16k2fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:36:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HHaCK221037636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 17:36:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E1BB2004F;
        Tue, 17 Jan 2023 17:36:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4214620043;
        Tue, 17 Jan 2023 17:36:11 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 17:36:11 +0000 (GMT)
Message-ID: <22aff83d-4379-e4f0-9826-33f986ddeec7@linux.ibm.com>
Date:   Tue, 17 Jan 2023 18:36:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-5-pmorel@linux.ibm.com>
 <e65bce5b-977c-ed19-9562-3af8ee8e9fba@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e65bce5b-977c-ed19-9562-3af8ee8e9fba@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yONBSYJHrdhU_9QsFgt01Fj9TDh-ZQzA
X-Proofpoint-ORIG-GUID: daRYZMZnXRWt9QXjO_QaSOZnnZGA2Ija
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_08,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/23 09:57, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> The maximum nested topology entries is used by the guest to know
>> how many nested topology are available on the machine.
>>
>> Currently, SCLP READ SCP INFO reports MNEST = 0, which is the
>> equivalent of reporting the default value of 2.
>> Let's use the default SCLP value of 2 and increase this value in the
>> future patches implementing higher levels.
> 
> I'm confused ... so does a SCLP value of 2 mean a MNEST level of 4 ?

Sorry, I forgot to change this.
MNEST = 0 means no MNEST support and only socket is supported so it is 
like MNEST = 2.
MNEST != 0 set the maximum nested level and correct values may be 2,3 or 4.
But this setting to 4 should already have been done in previous patch 
where we introduced the books and drawers.

I change the commit message with:
---
s390x/sclp: reporting the maximum nested topology entries

The maximum nested topology entries is used by the guest to know
how many nested topology are available on the machine.

Let's return this information to the guest.
---

> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/sclp.h | 5 +++--
>>   hw/s390x/sclp.c         | 4 ++++
>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
>> index 712fd68123..4ce852473c 100644
>> --- a/include/hw/s390x/sclp.h
>> +++ b/include/hw/s390x/sclp.h
>> @@ -112,12 +112,13 @@ typedef struct CPUEntry {
>>   } QEMU_PACKED CPUEntry;
>>   #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
>> -#define SCLP_READ_SCP_INFO_MNEST                2
>> +#define SCLP_READ_SCP_INFO_MNEST                4
> 
> ... since you update it to 4 here.

Yes, in fact this should be set in the previous patch already to 4.
So I will do that.

> 
>>   typedef struct ReadInfo {
>>       SCCBHeader h;
>>       uint16_t rnmax;
>>       uint8_t rnsize;
>> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
>> +    uint8_t  _reserved1[15 - 11];       /* 11-14 */
>> +    uint8_t  stsi_parm;                 /* 15-16 */
>>       uint16_t entries_cpu;               /* 16-17 */
>>       uint16_t offset_cpu;                /* 18-19 */
>>       uint8_t  _reserved2[24 - 20];       /* 20-23 */
>> diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
>> index eff74479f4..07e3cb4cac 100644
>> --- a/hw/s390x/sclp.c
>> +++ b/hw/s390x/sclp.c
>> @@ -20,6 +20,7 @@
>>   #include "hw/s390x/event-facility.h"
>>   #include "hw/s390x/s390-pci-bus.h"
>>   #include "hw/s390x/ipl.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   static inline SCLPDevice *get_sclp_device(void)
>>   {
>> @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB 
>> *sccb)
>>       /* CPU information */
>>       prepare_cpu_entries(machine, entries_start, &cpu_count);
>> +    if (s390_has_topology()) {
>> +        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
> 
> This seems to be in contradiction to what you've said in the commit 
> description - you set it to 4 and not to 2.

Yes, I change the commit message.

Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
