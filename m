Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18E1BB8AD
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD1IRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:17:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgD1IRg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 04:17:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S82lf7039844;
        Tue, 28 Apr 2020 04:17:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mfbsm2jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:17:34 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S82wkA041164;
        Tue, 28 Apr 2020 04:17:34 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30mfbsm2jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:17:34 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S8BO2X016805;
        Tue, 28 Apr 2020 08:17:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu50p2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 08:17:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S8HUrn62521766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 08:17:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FC1952054;
        Tue, 28 Apr 2020 08:17:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0F3655204F;
        Tue, 28 Apr 2020 08:17:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 06/10] s390x: css: stsch, enumeration
 test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
 <2f1e27a9-1cb2-79b2-b655-6f170431a14f@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9eb8ac80-057f-0fb1-0f95-4a6ab91136b5@linux.ibm.com>
Date:   Tue, 28 Apr 2020 10:17:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2f1e27a9-1cb2-79b2-b655-6f170431a14f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-27 15:06, Janosch Frank wrote:
> On 4/24/20 12:45 PM, Pierre Morel wrote:
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
>>
...snip...
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index bab0dd5..9417541 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -82,6 +82,7 @@ struct pmcw {
>>   	uint8_t  chpid[8];
>>   	uint32_t flags2;
>>   };
>> +#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
> 
> Why isn't this in the library patch?

OK


>> @@ -51,6 +52,7 @@ cflatobjs += lib/s390x/sclp-console.o
>>   cflatobjs += lib/s390x/interrupt.o
>>   cflatobjs += lib/s390x/mmu.o
>>   cflatobjs += lib/s390x/smp.o
>> +cflatobjs += lib/s390x/css_dump.o
> 
> Why isn't this in the library patch?

OK

> 
...snip...
>> +#define SID_ONE		0x00010000
> 
> Why isn't this in the library patch?

OK

> 
...snip...
>> +		if (!test_device_sid)
>> +			test_device_sid = scn|SID_ONE;
> 
> Give the pipe some space :)
> 
>> +		dev_found++;
> 
> Newlines would make this more readable.

OK and yes.

> 
>> +	}
>> +out:
> 
> We can report dev_found instead of 0/1 and a if/else
> 
> report(dev_found,
> 	"Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
>                      scn, scn_found, dev_found);	

Yes, :)


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
