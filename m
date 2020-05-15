Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908ED1D46AE
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgEOHHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:07:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgEOHHZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:07:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F74l21134201;
        Fri, 15 May 2020 03:07:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310v8sn5qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:07:24 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F77Nfn140834;
        Fri, 15 May 2020 03:07:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310v8sn2yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:07:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F71334030806;
        Fri, 15 May 2020 07:02:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3100ub536m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 07:02:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F71Qt264028956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 07:01:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A75FA405F;
        Fri, 15 May 2020 07:02:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEDDEA4054;
        Fri, 15 May 2020 07:02:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 07:02:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 05/10] s390x: Library resources for CSS
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-6-git-send-email-pmorel@linux.ibm.com>
 <20200514140315.6077046b.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <42beb241-8cc1-51a1-b374-3fb89968df36@linux.ibm.com>
Date:   Fri, 15 May 2020 09:02:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514140315.6077046b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 cotscore=-2147483648
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150061
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-14 14:03, Cornelia Huck wrote:
> On Fri, 24 Apr 2020 12:45:47 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> These are the include and library utilities for the css tests patch
>> series.
> 
> "Provide some definitions and library routines that can be used by
> tests targeting the channel subsystem."
> 
> ?

Definitively better. Thanks, I will update.

> 
>>
>> Debug function can be activated by defining DEBUG_CSS before the
>> inclusion of the css.h header file.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>>   2 files changed, 413 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
> 
> (...)
> 
>> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
>> new file mode 100644
>> index 0000000..2f33fab
>> --- /dev/null
>> +++ b/lib/s390x/css_dump.c
>> @@ -0,0 +1,157 @@
>> +/*
>> + * Channel subsystem structures dumping
>> + *
>> + * Copyright (c) 2020 IBM Corp.
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + *
>> + * Description:
>> + * Provides the dumping functions for various structures used by subchannels:
>> + * - ORB  : Operation request block, describes the I/O operation and points to
>> + *          a CCW chain
>> + * - CCW  : Channel Command Word, describes the data and flow control
> 
> "describes the command, data, and flow control" ?

OK, thanks

> 
>> + * - IRB  : Interuption response Block, describes the result of an operation
> 
> s/operation/operation;/

? I do not understand, do you want a ";" at the end of "operation"
Isn't it a typo error?

> 
>> + *          holds a SCSW and model-dependent data.
>> + * - SCHIB: SubCHannel Information Block composed of:
> 
>> + *   - SCSW: SubChannel Status Word, status of the channel.
>> + *   - PMCW: Path Management Control Word
>> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
>> + */
> 
> (...)
> 
> Otherwise, looks good.
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
