Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B972118459
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 11:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfLJKHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 05:07:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbfLJKHT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 05:07:19 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAA75MV021012
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 05:07:18 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wsu3p3x6v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 05:07:17 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 10 Dec 2019 10:07:15 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Dec 2019 10:07:13 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBAA7CBb43778244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 10:07:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B67A4053;
        Tue, 10 Dec 2019 10:07:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE00A4040;
        Tue, 10 Dec 2019 10:07:12 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Dec 2019 10:07:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 5/9] s390x: Library resources for CSS
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-6-git-send-email-pmorel@linux.ibm.com>
 <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 10 Dec 2019 11:07:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121010-0020-0000-0000-00000396235F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121010-0021-0000-0000-000021ED6333
Message-Id: <c37b0a10-358d-08be-7a59-20048b7af620@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_01:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-09 12:49, Thomas Huth wrote:
> On 06/12/2019 17.26, Pierre Morel wrote:
>> These are the include and library utilities for the css tests patch
>> series.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 156 ++++++++++++++++++++++++++
>>   2 files changed, 415 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> new file mode 100644
>> index 0000000..6f19bb5
>> --- /dev/null
>> +++ b/lib/s390x/css.h
> [...]
>> +/* Debug functions */
>> +char *dump_pmcw_flags(uint16_t f);
>> +char *dump_scsw_flags(uint32_t f);
>> +#undef DEBUG
>> +#ifdef DEBUG
>> +void dump_scsw(struct scsw *);
>> +void dump_irb(struct irb *irbp);
>> +void dump_schib(struct schib *sch);
>> +struct ccw *dump_ccw(struct ccw *cp);
>> +#else
>> +static inline void dump_scsw(struct scsw *scsw) {}
>> +static inline void dump_irb(struct irb *irbp) {}
>> +static inline void dump_pmcw(struct pmcw *p) {}
>> +static inline void dump_schib(struct schib *sch) {}
>> +static inline void dump_orb(struct orb *op) {}
>> +static inline struct ccw *dump_ccw(struct ccw *cp)
>> +{
>> +	return NULL;
>> +}
>> +#endif
> 
> I'd prefer to not have a "#undef DEBUG" (or "#define DEBUG") statement

Anyway hawfull!

> in the header here - it could trigger unexpected behavior with other
> files that also use a DEBUG macro.
> 
> Could you please declare the prototypes here and move the "#else" part
> to the .c file instead? Thanks!

What if I use a CSS_DEBUG here instead of a simple DEBUG definition?

It can be enabled or not by defining CSS_ENABLED ahead of the include...?



-- 
Pierre Morel
IBM Lab Boeblingen

