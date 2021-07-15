Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1053C9D3A
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbhGOKvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 06:51:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232055AbhGOKvP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 06:51:15 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FAXwl0090894;
        Thu, 15 Jul 2021 06:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ajXHLHDEBxtcysRI+JtyCQLk+dpnXZmt4tX8qjYsO6E=;
 b=Ov8h1iIYScH6ysIFJulNnX5jTffQCUIIMeJwl6PZa/Z/FMEKCyMjoYV54/QkXw2uDL7e
 tqBElkxjC3hKo3bLpFui8I98VBgembnW9DWUA5lKNom6JIibNX6eMOAPLRpl9K53TCGv
 OKXm/3vys0X+YU+S9pKj5vbPJCa4S5uZiwep0vQrMFrtfPXaVE526sYkCoDYcT17IpSX
 PX8q70PLTQQX3iGtsuAw6KNCx1PYitlHI231tqYugqiX5NqEMmyOs6bhTVvIJGdbvic6
 C0gnMj30a1edsdvTqqX5HC/EwzjWNs+91UD5YrU4fbEYwIRTwn4a7F0KGrtmqoCB0gk9 oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc8m2cu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 06:48:22 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16FAZIr7095574;
        Thu, 15 Jul 2021 06:48:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sc8m2ctc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 06:48:22 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16FAlahE014044;
        Thu, 15 Jul 2021 10:48:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 39q36895wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 10:48:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16FAmGLP28246340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 10:48:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 177D6AE059;
        Thu, 15 Jul 2021 10:48:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98819AE070;
        Thu, 15 Jul 2021 10:48:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.77.125])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 10:48:15 +0000 (GMT)
Subject: Re: [PATCH v1 2/2] KVM: s390: Topology expose TOPOLOGY facility
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
 <1626276343-22805-3-git-send-email-pmorel@linux.ibm.com>
 <3a7836ad-f748-296e-cd1a-a10cbc570474@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d0f4ac74-af7b-87ef-f451-bfa3ad90ad01@linux.ibm.com>
Date:   Thu, 15 Jul 2021 12:48:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3a7836ad-f748-296e-cd1a-a10cbc570474@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rIfUhqHvEZ2PmSvGgBLtE7jtLTSYW3HG
X-Proofpoint-ORIG-GUID: 3H3nkTlfYU4CSM610bGfVQkbWNPFflsM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_07:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/21 10:52 AM, David Hildenbrand wrote:
> On 14.07.21 17:25, Pierre Morel wrote:
>> We add the KVM extension KVM_CAP_S390_CPU_TOPOLOGY, this will
>> allow the userland hypervisor to handle the interception of the
>> PTF (Perform topology Function) instruction.
> 
> Ehm, no you don't add any new capability. Or my eyes are too tired to 
> spot it :)

hum, yes, sorry, seems I kept my old commit message as I let fall the 
capability after internal reviews.


> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/tools/gen_facilities.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/s390/tools/gen_facilities.c 
>> b/arch/s390/tools/gen_facilities.c
>> index 606324e56e4e..2c260eb22bae 100644
>> --- a/arch/s390/tools/gen_facilities.c
>> +++ b/arch/s390/tools/gen_facilities.c
>> @@ -112,6 +112,7 @@ static struct facility_def facility_defs[] = {
>>           .name = "FACILITIES_KVM_CPUMODEL",
>>           .bits = (int[]){
>> +            11, /* configuration topology facility */
>>               12, /* AP Query Configuration Information */
>>               15, /* AP Facilities Test */
>>               156, /* etoken facility */
>>
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
