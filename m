Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD4020F979
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388153AbgF3Qax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 12:30:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728931AbgF3Qaw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 12:30:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UG3NfF103097;
        Tue, 30 Jun 2020 12:30:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3205wsq2u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 12:30:51 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05UG3jlt105541;
        Tue, 30 Jun 2020 12:30:50 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3205wsq2t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 12:30:50 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05UGKbIA017562;
        Tue, 30 Jun 2020 16:30:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 31wwcgstkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 16:30:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05UGUkFn63111578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 16:30:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04AFF42049;
        Tue, 30 Jun 2020 16:30:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A484D42041;
        Tue, 30 Jun 2020 16:30:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.24.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Jun 2020 16:30:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 09/12] s390x: Library resources for CSS
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
 <9de11879-4429-bfe8-7f1e-1f5880764a6a@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b3a00973-6368-cc6b-a3a7-5d31f8d942d5@linux.ibm.com>
Date:   Tue, 30 Jun 2020 18:30:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9de11879-4429-bfe8-7f1e-1f5880764a6a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 cotscore=-2147483648
 impostorscore=0 clxscore=1015 phishscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-24 14:26, Thomas Huth wrote:
> On 15/06/2020 11.31, Pierre Morel wrote:
>> Provide some definitions and library routines that can be used by
>> tests targeting the channel subsystem.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 153 ++++++++++++++++++++++++++
>>   s390x/Makefile       |   1 +
>>   3 files changed, 410 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
> [...]
>> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
>> new file mode 100644
>> index 0000000..0c2b64e
>> --- /dev/null
>> +++ b/lib/s390x/css_dump.c
>> @@ -0,0 +1,153 @@
>> +/*
>> + * Channel subsystem structures dumping
>> + *
>> + * Copyright (c) 2020 IBM Corp.
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + *
>> + * Description:
>> + * Provides the dumping functions for various structures used by 
>> subchannels:
>> + * - ORB  : Operation request block, describes the I/O operation and 
>> points to
>> + *          a CCW chain
>> + * - CCW  : Channel Command Word, describes the command, data and 
>> flow control
>> + * - IRB  : Interuption response Block, describes the result of an 
>> operation;
>> + *          holds a SCSW and model-dependent data.
>> + * - SCHIB: SubCHannel Information Block composed of:
>> + *   - SCSW: SubChannel Status Word, status of the channel.
>> + *   - PMCW: Path Management Control Word
>> + * You need the QEMU ccw-pong device in QEMU to answer the I/O 
>> transfers.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <unistd.h>
> 
> Please don't use unistd.h in kvm-unit-tests - this header is not usable 
> in cross-compilation environments:
> 
>   https://travis-ci.com/github/huth/kvm-unit-tests/jobs/353089278#L536
> 
> Thanks,
>   Thomas
> 

Yes, no problem, it does not belong here anyway.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
