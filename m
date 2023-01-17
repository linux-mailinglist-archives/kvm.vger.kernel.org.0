Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6371D66E56B
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjAQR4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 12:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjAQRyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 12:54:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6789E4F85B
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:45:07 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HH0Lmr026843;
        Tue, 17 Jan 2023 17:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Bhb7ILYOt2EJK3Cl+DmN7jh0JDCUTSMxZBov3CzC6uc=;
 b=GYUOui0kMXHNMojkdFn+fN9PsrHY57SdKJAIRAGYtgrqteM/IwpcU9Hai2aOp4Y3CsDj
 GdpwL/LDrqw+OKOS4MpIGCR+qPTpTCm5TzUX1YjmtKT2l53t0kAAZU6So9fDBCsJs8vw
 SG/vHpWKh3d74XhKPxQ9qaMQdJanGthoUbhtqbYS5i//dvjLpC1Fs9JOKaYZO/4fda0g
 41YhDuiBgVS3WhXLpQBIqgTlI/Ha0xuudWtpr/Veod1LqzV1HfBH4fim98LiLzK5MhMR
 cYOX+0Sl/mW5eMNU1N+jOeGOjGNJbiuBuH3lZspEFe+ahRBr/eYzhkvD0qH0yr3t29eo iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3uv1k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:44:53 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HHiZPZ003871;
        Tue, 17 Jan 2023 17:44:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5x3uv1jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:44:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HFXfGC024441;
        Tue, 17 Jan 2023 17:44:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n3m16k2m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 17:44:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HHiksM41877960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 17:44:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9260620043;
        Tue, 17 Jan 2023 17:44:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13EDF20049;
        Tue, 17 Jan 2023 17:44:45 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 17:44:44 +0000 (GMT)
Message-ID: <eb92e864-fe57-121b-06d6-8f78e8405540@linux.ibm.com>
Date:   Tue, 17 Jan 2023 18:44:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 04/11] s390x/sclp: reporting the maximum nested
 topology entries
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-5-pmorel@linux.ibm.com>
 <47b72645aaa2456476fe0d73f45d3f37ebb4eb3d.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <47b72645aaa2456476fe0d73f45d3f37ebb4eb3d.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ifbwDp7GYdcfJ1aWARL2enU1QsZB_5O
X-Proofpoint-ORIG-GUID: iOxoJZz2iz02OVAnBVfSG-BndOsr1e2S
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



On 1/11/23 18:52, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>> The maximum nested topology entries is used by the guest to know
>> how many nested topology are available on the machine.
>>
>> Currently, SCLP READ SCP INFO reports MNEST = 0, which is the
>> equivalent of reporting the default value of 2.
>> Let's use the default SCLP value of 2 and increase this value in the
>> future patches implementing higher levels.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> if you address the issues Thomas found with the commit description
> and the nits below.

Thanks.

> 
>> ---
>>   include/hw/s390x/sclp.h | 5 +++--
>>   hw/s390x/sclp.c         | 4 ++++
>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/hw/s390x/sclp.h b/include/hw/s390x/sclp.h
>> index 712fd68123..4ce852473c 100644
>> --- a/include/hw/s390x/sclp.h
>> +++ b/include/hw/s390x/sclp.h
>> @@ -112,12 +112,13 @@ typedef struct CPUEntry {
>>   } QEMU_PACKED CPUEntry;
>>   
>>   #define SCLP_READ_SCP_INFO_FIXED_CPU_OFFSET     128
>> -#define SCLP_READ_SCP_INFO_MNEST                2
>> +#define SCLP_READ_SCP_INFO_MNEST                4
>>   typedef struct ReadInfo {
>>       SCCBHeader h;
>>       uint16_t rnmax;
>>       uint8_t rnsize;
>> -    uint8_t  _reserved1[16 - 11];       /* 11-15 */
>> +    uint8_t  _reserved1[15 - 11];       /* 11-14 */
>> +    uint8_t  stsi_parm;                 /* 15-16 */
> 
> The numbering here is the same as the one in the arch doc, instead
> of the maybe more usual one where the right number is exclusive.
> So 15-16 looks like a two byte field, so just do 15 or just drop it.

Yes right, thanks.

> 
>>       uint16_t entries_cpu;               /* 16-17 */
>>       uint16_t offset_cpu;                /* 18-19 */
>>       uint8_t  _reserved2[24 - 20];       /* 20-23 */
>> diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
>> index eff74479f4..07e3cb4cac 100644
>> --- a/hw/s390x/sclp.c
>> +++ b/hw/s390x/sclp.c
>> @@ -20,6 +20,7 @@
>>   #include "hw/s390x/event-facility.h"
>>   #include "hw/s390x/s390-pci-bus.h"
>>   #include "hw/s390x/ipl.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   
>>   static inline SCLPDevice *get_sclp_device(void)
>>   {
>> @@ -125,6 +126,9 @@ static void read_SCP_info(SCLPDevice *sclp, SCCB *sccb)
>>   
>>       /* CPU information */
>>       prepare_cpu_entries(machine, entries_start, &cpu_count);
>> +    if (s390_has_topology()) {
>> +        read_info->stsi_parm = SCLP_READ_SCP_INFO_MNEST;
>> +    }
> 
> Maybe move that up a bit, not sure if it belongs under the CPU information section.
> I'd leave prepare_cpu_entries and read_info->entries_cpu = adjacent in any case.
> 

Yes, I do that.

Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
