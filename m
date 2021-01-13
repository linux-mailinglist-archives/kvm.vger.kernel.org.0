Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2862F49B6
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbhAMLIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:08:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727715AbhAMLIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 06:08:21 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DB20Ut137335;
        Wed, 13 Jan 2021 06:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3hvqLMyBtOQ05LiXzZ8DQWBzCjIaLMA4SCJ5eymFNpE=;
 b=FEhkh7GFKZuawc0qN3U4LJe2CVEaVXEi9JDO+mKf9n6smu2ylZZXdkDWGjP6SnkTvf7l
 oerijLfetbNUQfvZWH1APTyUxE2WDQn5UoqYYuwJIcaQH1yL+oCDr7UDnSR2KONZQRb8
 MT8NiVyf4PM3dgO2E8+sPD3qNez2ypeVEBWePhPq/KT/oqUUdESgHDm6d3JoMpWvr1cQ
 FgM32ZDf40/Vze4SwbMB8ZPixDPobQR78CytSCejuBct1JOHw+LhVBjTa4CTkia+LA7r
 +Kok4jGfzwUMOBDakL79Rv5AdMkINanuO+A4ChWeLm0JmkCGeTiTj3IpkGu3nit8WQXa Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361ybagu99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 06:07:39 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DB2DBx138269;
        Wed, 13 Jan 2021 06:07:08 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361ybagt20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 06:07:08 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DAwLso011747;
        Wed, 13 Jan 2021 11:06:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448cxr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 11:06:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DB6XxX46858692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 11:06:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E339DA4064;
        Wed, 13 Jan 2021 11:06:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77AFCA405C;
        Wed, 13 Jan 2021 11:06:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.171.171])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 11:06:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-10-frankja@linux.ibm.com>
 <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <a9b36c6f-f84e-a0b3-d0ef-5f707adbac94@linux.ibm.com>
Date:   Wed, 13 Jan 2021 12:06:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_05:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 11:25 AM, David Hildenbrand wrote:
> On 12.01.21 14:20, Janosch Frank wrote:
>> Let's make it clear that there is something at the end of the
>> struct. The exact offset is reported by the cpu_offset member.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/sclp.h | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index dccbaa8..395895f 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -134,7 +134,10 @@ typedef struct ReadInfo {
>>  	uint8_t reserved7[134 - 128];
>>  	uint8_t byte_134_diag318 : 1;
>>  	uint8_t : 7;
>> -	struct CPUEntry entries[0];
>> +	/*
>> +	 * The cpu entries follow, they start at the offset specified
>> +	 * in offset_cpu.
>> +	 */
> 
> I mean, that's just best practice. At least when I spot "[0];" and the
> end of a struct, I know what's happening.
> 
> No strong opinion about the comment, I wouldn't need it to understand it.

The comment was a wish by Thomas.
Anyway, it doesn't hurt :)

> 
>>  } __attribute__((packed)) ReadInfo;
>>  
>>  typedef struct ReadCpuInfo {
>>
> 
> 

