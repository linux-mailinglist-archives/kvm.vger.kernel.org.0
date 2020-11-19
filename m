Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17ED2B8EA7
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 10:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgKSJVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 04:21:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbgKSJVd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 04:21:33 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ93XDY059198;
        Thu, 19 Nov 2020 04:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=isX7XjeqSELMBhLt+p45nMMMWSh+E8Psrsc2HDVxEMs=;
 b=nLgviYH1wtrJEVOWqDNv7AK+Y9HxWt+B4usl3wse4vVR5b3SnPDT9xZviSHW7y++iYcd
 wJYc3wlF06Dxpw4zPRC7EPiOsDgx3YGFje1WKHCYgFwTrAHn+eXJEzeJwBPUiE/ofh5g
 ACVaMldF5HujcAGnVNFIqDYa8h54Q3Y7j4GO67hHY+QRHjmXAhEqrZ2SAsSTK1vO3mna
 N/1hCVU2NIHbEAaH2VISoDnvmKw1YQVDQAInLXXDHxq/DwzQVVDPJFJJbQ6jJyIBZMju
 wu/CirePHhcezpyHWxliYp2Kz3bQGlw9w0bdJVB6s6oguIZhrJNE//1qM7QnXXsrFYNl ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg6088ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:21:32 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJ9469i062174;
        Thu, 19 Nov 2020 04:21:32 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg6088dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:21:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ97ZHe013085;
        Thu, 19 Nov 2020 09:21:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 34w4yfgus5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:21:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ9LPTD7996028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 09:21:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69BA3AE053;
        Thu, 19 Nov 2020 09:21:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A20FAE051;
        Thu, 19 Nov 2020 09:21:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.72.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 09:21:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: SCLP feature checking
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-4-frankja@linux.ibm.com>
 <e9845ca1-96ac-23b8-5136-7a6916fb1b92@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <ef1aa882-64a2-6626-4ad8-a9b2e78f3cda@linux.ibm.com>
Date:   Thu, 19 Nov 2020 10:21:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <e9845ca1-96ac-23b8-5136-7a6916fb1b92@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/20 10:15 AM, Thomas Huth wrote:
> On 17/11/2020 16.42, Janosch Frank wrote:
>> Availability of SIE is announced via a feature bit in a SCLP info CPU
>> entry. Let's add a framework that allows us to easily check for such
>> facilities.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/io.c   |  1 +
>>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>>  lib/s390x/sclp.h | 15 +++++++++++++++
>>  3 files changed, 35 insertions(+)
> [...]
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index 6620531..bcc9f4b 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -101,6 +101,20 @@ typedef struct CPUEntry {
>>      uint8_t reserved1;
>>  } __attribute__((packed)) CPUEntry;
>>  
>> +extern struct sclp_facilities sclp_facilities;
>> +
>> +struct sclp_facilities {
>> +	u64 has_sief2 : 1;
>> +};
>> +
>> +/*
>> + * test_bit() uses unsigned long ptrs so we give it the ptr to the
>> + * address member and offset bits by 1> + */
>> +enum sclp_cpu_feature_bit {
>> +	SCLP_CPU_FEATURE_SIEF2_BIT = 16 + 4,
>> +};
> 
> That's kind of ugly ... why don't you simply replace the CPUEntry.features[]
> array with a bitfield, similar to what the kernel does with "struct
> sclp_core_entry" ?

That's an excellent idea, will do!

> 
>  Thomas
> 
> 

