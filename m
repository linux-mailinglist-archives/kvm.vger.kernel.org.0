Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC171F3591
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgFIHx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:53:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbgFIHx4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 03:53:56 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0597ZeeW094223;
        Tue, 9 Jun 2020 03:53:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41en62s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:53:55 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0597jHns118756;
        Tue, 9 Jun 2020 03:53:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41en623-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:53:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0597ivPB016892;
        Tue, 9 Jun 2020 07:53:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 31g2s7wfxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 07:53:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0597roEG11272420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 07:53:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD224C04E;
        Tue,  9 Jun 2020 07:53:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7876A4C044;
        Tue,  9 Jun 2020 07:53:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 07:53:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-9-git-send-email-pmorel@linux.ibm.com>
 <b013343d-d08d-43c6-1fac-f29d3070b535@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1f7ae06a-b754-a75c-8658-8c46274fdc32@linux.ibm.com>
Date:   Tue, 9 Jun 2020 09:53:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b013343d-d08d-43c6-1fac-f29d3070b535@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_02:2020-06-08,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 suspectscore=0 cotscore=-2147483648 priorityscore=1501
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 07:21, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> We often need to retrieve hexadecimal kernel parameters.
>> Let's implement a shared utility to do it.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/kernel-args.h | 18 +++++++++++++
>>   s390x/Makefile          |  1 +
>>   3 files changed, 79 insertions(+)
>>   create mode 100644 lib/s390x/kernel-args.c
>>   create mode 100644 lib/s390x/kernel-args.h
> [...]
>> +int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val)
>> +{
>> +	int i, ret;
>> +	char *p;
>> +
>> +	for (i = 0; i < argc; i++) {
>> +		ret = strncmp(argv[i], str, strlen(str));
>> +		if (ret)
>> +			continue;
>> +		p = strchr(argv[i], '=');
>> +		if (!p)
>> +			return -1;
>> +		p = strchr(p, 'x');
>> +		if (!p)
>> +			*val = atol(p + 1);
> 
> If p is NULL, then you call atol(NULL + 1) ... I think you need another
> temporary variable here instead to hold the new pointer / NULL value?


grrrr, clearly!

> 
>   Thomas
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
