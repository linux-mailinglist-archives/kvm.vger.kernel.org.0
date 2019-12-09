Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE61111720C
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLIQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:43:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726522AbfLIQn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 11:43:26 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9GMKbw078299
        for <kvm@vger.kernel.org>; Mon, 9 Dec 2019 11:43:25 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wrtksbmmy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 11:43:24 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 9 Dec 2019 16:43:23 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Dec 2019 16:43:19 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB9GhIfr29163712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Dec 2019 16:43:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8F81AE04D;
        Mon,  9 Dec 2019 16:43:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 830A6AE045;
        Mon,  9 Dec 2019 16:43:18 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Dec 2019 16:43:18 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 5/9] s390x: Library resources for CSS
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-6-git-send-email-pmorel@linux.ibm.com>
 <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 9 Dec 2019 17:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <66233a15-7cc4-45b5-d930-abbedbd0729d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120916-0028-0000-0000-000003C6EF50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120916-0029-0000-0000-0000248A1BC3
Message-Id: <bd5b7fd3-aa52-cb57-d0f3-5052a83dedcf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090141
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
> in the header here - it could trigger unexpected behavior with other
> files that also use a DEBUG macro.
> 
> Could you please declare the prototypes here and move the "#else" part
> to the .c file instead? Thanks!
> 
>   Thomas
> 

Yes, I can do this.
Thanks
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

