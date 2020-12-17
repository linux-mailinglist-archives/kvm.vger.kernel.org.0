Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A062DD308
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgLQOcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:32:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQOcU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:32:20 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEDlCX024617;
        Thu, 17 Dec 2020 09:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GLVvRQTAYdSlaAC6I1xghJU5/TEzfSzY+zfggkGMCfE=;
 b=kYZitWi/fWkbrCNUmefX2h5AFVRgICmDIJbKTerPnN5qf06hriVt+XqgfQRHM+RKOC63
 2FwFJ7L44AJ86bEHFjeFyRC7WDv/Md5xcVGGV4R0VpI0vW9wu2Q/ek1a53JOt5SbCqOg
 hnmtF3lD0MTPv11vJGtOpzQ7akC4z2kOE+o75qzURX6xWg2d4Ko57hUWDWpMIyblDZy4
 ozslMpkiETTBO3eKkD8242loF67HFzZVuuIewkJTtZJIHwNKYMNEw7kAQs/sFu8v+qDc
 SStH2cJsgOuoTnxfEtRmzDeJlZzPX6ltNKXp//4Kby6ZdtURXFnh9BakAk/OcAR/h/qI Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8qrgx97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:31:39 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEVdrE109187;
        Thu, 17 Dec 2020 09:31:39 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8qrgx7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:31:38 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHESB4U009683;
        Thu, 17 Dec 2020 14:31:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 35d310aj4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 14:31:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEVX8x24314346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:31:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 640D4A405F;
        Thu, 17 Dec 2020 14:31:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3B79A4054;
        Thu, 17 Dec 2020 14:31:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:31:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-8-frankja@linux.ibm.com>
 <4f689585-ae2e-4632-9055-f2332d9f7751@redhat.com>
 <44d6ac32-f7ac-6b33-ea9e-e037f936a181@de.ibm.com>
 <24e9883c-22d5-de4f-0001-d271855d7ea3@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <23af5bca-dd2c-43bd-b2b4-6c7e2031517f@linux.ibm.com>
Date:   Thu, 17 Dec 2020 15:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <24e9883c-22d5-de4f-0001-d271855d7ea3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 phishscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 11:34 AM, Thomas Huth wrote:
> On 17/12/2020 10.59, Christian Borntraeger wrote:
>>
>>
>> On 17.12.20 10:53, Thomas Huth wrote:
>>> On 11/12/2020 11.00, Janosch Frank wrote:
>>>> Not much to test except for the privilege and specification
>>>> exceptions.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>  lib/s390x/sclp.c  |  2 ++
>>>>  lib/s390x/sclp.h  |  6 +++++-
>>>>  s390x/intercept.c | 19 +++++++++++++++++++
>>>>  3 files changed, 26 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>>> index cf6ea7c..0001993 100644
>>>> --- a/lib/s390x/sclp.c
>>>> +++ b/lib/s390x/sclp.c
>>>> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>>>>  
>>>>  	assert(read_info);
>>>>  
>>>> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
>>>> +
>>>>  	cpu = (void *)read_info + read_info->offset_cpu;
>>>>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>>>>  		if (cpu->address == cpu0_addr) {
>>>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>>>> index 6c86037..58f8e54 100644
>>>> --- a/lib/s390x/sclp.h
>>>> +++ b/lib/s390x/sclp.h
>>>> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>>>>  
>>>>  struct sclp_facilities {
>>>>  	uint64_t has_sief2 : 1;
>>>> -	uint64_t : 63;
>>>> +	uint64_t has_diag318 : 1;
>>>> +	uint64_t : 62;
>>>>  };
>>>>  
>>>>  typedef struct ReadInfo {
>>>> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>>>>      uint16_t highest_cpu;
>>>>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>>>>      uint32_t hmfai;
>>>> +    uint8_t reserved7[134 - 128];
>>>> +    uint8_t byte_134_diag318 : 1;
>>>> +    uint8_t : 7;
>>>>      struct CPUEntry entries[0];
>>>
>>> ... the entries[] array can be moved around here without any further ado?
>>> Looks confusing to me. Should there be a CPUEntry array here at all, or only
>>> in ReadCpuInfo?
>>
>> there is offset_cpu for the cpu entries at the beginning of the structure.
> 
> Ah, thanks, right, this was used earlier in the patch series, now I
> remember. But I think the "struct CPUEntry entries[0]" here is rather
> confusing, since there is no guarantee that the entries are really at this
> location ... I think this line should rather be replaced by a comment saying
> that offset_cpu should be used instead.

Sure, as long as it's clear that there's something at the end, I'm fine
with it.

> 
>  Thomas
> 

