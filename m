Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E59B1EDD86
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgFDGtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:49:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbgFDGtr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 02:49:47 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0546a39Y169410;
        Thu, 4 Jun 2020 02:49:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31etw21eyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 02:49:47 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0546cVu2184319;
        Thu, 4 Jun 2020 02:49:44 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31etw21ey8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 02:49:44 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0546jf2V019846;
        Thu, 4 Jun 2020 06:49:42 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 31bf483tw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 06:49:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0546nepe54788478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 06:49:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC0AB5204F;
        Thu,  4 Jun 2020 06:49:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.167.22])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8F5B452051;
        Thu,  4 Jun 2020 06:49:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 05/12] s390x: export the clock
 get_clock_ms() utility
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-6-git-send-email-pmorel@linux.ibm.com>
 <80ccd983-df12-a6ee-239e-b367ebc9dded@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <3edefd98-f9ef-8428-34f5-370ee61f860d@linux.ibm.com>
Date:   Thu, 4 Jun 2020 08:49:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <80ccd983-df12-a6ee-239e-b367ebc9dded@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_04:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006040043
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-26 20:10, Thomas Huth wrote:
> On 18/05/2020 18.07, Pierre Morel wrote:
>> To serve multiple times, the function get_clock_ms() is moved
>> from intercept.c test to the new file asm/time.h.

...snip...

>> index 0000000..25c7a3c
>> --- /dev/null
>> +++ b/lib/s390x/asm/time.h
>> @@ -0,0 +1,26 @@
>> +/*
>> + * Clock utilities for s390
>> + *
>> + * Authors:
>> + *  Thomas Huth <thuth@redhat.com>
>> + *
>> + * Copied from the s390/intercept test by:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +#ifndef _ASM_S390X_TIME_H_
>> +#define _ASM_S390X_TIME_H_
> 
> Please also remove the underscores at the beginning (and preferably also
> at the end) here.

OK,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
