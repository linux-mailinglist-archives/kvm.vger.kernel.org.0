Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC31EDDF1
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 09:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgFDHVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 03:21:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726664AbgFDHVV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 03:21:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0547Jjfj073498;
        Thu, 4 Jun 2020 03:21:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31d2u3gdxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 03:21:20 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0547LJMC080429;
        Thu, 4 Jun 2020 03:21:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31d2u3gdx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 03:21:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0547KNXi030582;
        Thu, 4 Jun 2020 07:21:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf481ghe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:21:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0547LFuR49742068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 07:21:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A98E5204E;
        Thu,  4 Jun 2020 07:21:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.167.22])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2E07052065;
        Thu,  4 Jun 2020 07:21:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 06/12] s390x: use get_clock_ms() to
 calculate a delay in ms
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-7-git-send-email-pmorel@linux.ibm.com>
 <a490dc16-b323-5a52-2d29-f4707d89a1d6@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <abb9f3e4-f8d1-3394-0c3d-8f2a2ef30f32@linux.ibm.com>
Date:   Thu, 4 Jun 2020 09:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a490dc16-b323-5a52-2d29-f4707d89a1d6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_04:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040043
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 20:16, Thomas Huth wrote:
> On 18/05/2020 18.07, Pierre Morel wrote:
>> use get_clock_ms() to calculate a delay in ms
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/time.h | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
>> index 25c7a3c..931a119 100644
>> --- a/lib/s390x/asm/time.h
>> +++ b/lib/s390x/asm/time.h
>> @@ -23,4 +23,14 @@ static inline uint64_t get_clock_ms(void)
>>   	return (clk >> (63 - 51)) / 1000;
>>   }
>>   
>> +static inline void mdelay(unsigned long ms)
>> +{
>> +	unsigned long startclk;
>> +
>> +	startclk = get_clock_ms();
>> +	for (;;)
>> +		if (get_clock_ms() - startclk > ms)
>> +			break;
> 
> Maybe rather:
> 
>      for (;get_clock_ms() - startclk <= ms;)
> 	;
> 
> ?
> Or:
> 
>      while (get_clock_ms() - startclk <= ms)
>          ;
> ?
> 
>   Thomas
> 

Hi,

your comment made me realize I did not take care on the wrapping.
I will rework this.

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
