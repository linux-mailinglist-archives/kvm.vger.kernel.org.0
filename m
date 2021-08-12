Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0153EA713
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbhHLPFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:05:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234850AbhHLPFy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:05:54 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CF3OoD022047;
        Thu, 12 Aug 2021 11:05:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cloP8LUTkFeJJKsbDnZZmtEp4+zbjzUIP+ycy2RWO/I=;
 b=inv0gA4uVu4ctUOvYSU24PSAkx698PxgpcbAHSKUzGqMBlwD55hW8/sNwUSB33jiCAFZ
 nzUxCeX38qY4TW+XkRS9qg/4PgaS9SJVFO28n3y/jGA9sN34hNUHHn4WFmQFABgmNtkh
 WGmZYuELtxE3s3KCUY1siRoc6uQOf8IEqL/pLgZ7pNgqeQZmKS5mc7fNcsv6JRxzViAY
 sDRMD8F0SiRu7g5Ui/UMGPoRoUJ0ENmeCFAGvVq9taQOwLQfjyMzpwjuuy74z87S3ndl
 4878ElcA2KWTxUqlr0zGPrFI0kyzfhD9lGPpm4eA4nSwRAt/wv9r9Ryu2QbF3rGWK53p Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy935p5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:05:29 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17CF3oxK024272;
        Thu, 12 Aug 2021 11:05:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy935p4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:05:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CF2pOu010741;
        Thu, 12 Aug 2021 15:05:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ad4kqg468-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 15:05:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CF25jB57934094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 15:02:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DA514C052;
        Thu, 12 Aug 2021 15:05:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECDF34C044;
        Thu, 12 Aug 2021 15:05:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 15:05:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy nested
 level
To:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
 <87czqivn1q.fsf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <08c479b7-491a-3f21-c869-d7a76a3af4e5@linux.ibm.com>
Date:   Thu, 12 Aug 2021 17:05:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87czqivn1q.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CztrsUe08thYhJ_QhSBPOgIfywfaplOG
X-Proofpoint-ORIG-GUID: Xaud-JDbmhxj-dCqfbBtzEKa3vCUFrzf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_05:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/12/21 2:56 PM, Cornelia Huck wrote:
> On Tue, Aug 10 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> The maximum CPU Topology nested level is available with the SCLP
>> READ_INFO command inside the byte at offset 15 of the ReadInfo
>> structure.
>>
>> Let's return this information to check the number of topology nested
>> information available with the STSI 15.1.x instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.c | 6 ++++++
>>   lib/s390x/sclp.h | 4 +++-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 9502d161..ee379ddf 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
>>   	return read_info->entries_cpu;
>>   }
>>   
>> +int sclp_get_stsi_parm(void)
>> +{
>> +	assert(read_info);
>> +	return read_info->stsi_parm;
> 
> Is this a generic "stsi parm", or always the concrete topology nested
> level? IOW, is that name good, or too generic?

It is the name used in the documentation, but for now only the 3 bits 
5-7 are used for the maximum value of the selector 2 of the STSI 
instruction allowed by the machine.


> 
>> +}
>> +
>>   CPUEntry *sclp_get_cpu_entries(void)
>>   {
>>   	assert(read_info);
> 

-- 
Pierre Morel
IBM Lab Boeblingen
