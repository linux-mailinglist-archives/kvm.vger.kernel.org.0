Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812011BB90C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgD1Io6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:44:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbgD1Io5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 04:44:57 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S8X9hR173462;
        Tue, 28 Apr 2020 04:44:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mguvrusa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:44:56 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S8XP3j174065;
        Tue, 28 Apr 2020 04:44:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mguvrum2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 04:44:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S8Z1Z4002392;
        Tue, 28 Apr 2020 08:44:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6wqt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 08:44:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S8hYnS65077626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 08:43:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E547E52063;
        Tue, 28 Apr 2020 08:44:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 968FF52050;
        Tue, 28 Apr 2020 08:44:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 08/10] s390x: define wfi: wait for
 interrupt
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-9-git-send-email-pmorel@linux.ibm.com>
 <4cc33b1c-7fa2-0775-f176-08bb31b7e68e@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <60b951c7-2fa2-2284-db04-33e422974626@linux.ibm.com>
Date:   Tue, 28 Apr 2020 10:44:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4cc33b1c-7fa2-0775-f176-08bb31b7e68e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=806 mlxscore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-27 14:59, Janosch Frank wrote:
> On 4/24/20 12:45 PM, Pierre Morel wrote:
>> wfi(irq_mask) allows the programm to wait for an interrupt.
> 
> s/programm/program/

Thx,

> 
>> The interrupt handler is in charge to remove the WAIT bit
>> when it finished handling interrupt.
> 
> ...finished handling the interrupt.

OK, thx

> 

>>   }
>>   
>> +static inline void wfi(uint64_t irq_mask)
> 
> enabled_wait()


I do not like enabled_wait(), we do not know what is enabled and we do 
not know what we are waiting for.

What about wait_for_interrupt()

> 
>> +{
>> +	uint64_t psw_mask;
> 
> You can directly initialize this variable.
> 
>> +
>> +	psw_mask = extract_psw_mask();
>> +	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
> 
> Maybe add a comment here:
> 
> /*
>   * After being woken and having processed the interrupt, let's restore
> the PSW mask.
> */
> 
>> +	load_psw_mask(psw_mask);
>> +}
>> +

I can do this, but wasn't it obvious?


Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
