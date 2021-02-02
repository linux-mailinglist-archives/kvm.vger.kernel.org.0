Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A2F30C1A7
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhBBOaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 09:30:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234310AbhBBOUV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 09:20:21 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112E85Tr166792;
        Tue, 2 Feb 2021 09:19:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uSnGI5pFuou2Iuji89JfuDYlmug+VJJQxBlfxIzsF9Y=;
 b=fLVtrUCxramJNQ925RgbLcZG3Qhb6hB3VithqZoW7SwwCIpdBP2y+OgTzjHazqfTTGOV
 ZxuFjydkv00U3TfTIOJrMRcL66+6fs9ppekc1kZKLGTNTgheQyyWxMjtfmj//vNWQBW/
 KFct6LIFNHUfsGNjlXi+WBRG2a+B3PtgGAi2vE6JJ8bxDnbiugw+P/Cci/skeN3+jD27
 TudM+hjx2GtlFpPWi2Gov50nM9XE5miHA6bBbYY5i8BhmprTIgT+5udgr27r9KE6aPs3
 lyANsGyF/4OyNVPei9bsWGokPO7guksLkmHPju8AtuKhYzP+PPlWPH6yAAvCAwN49K8U 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36f681chp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 09:19:36 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112E8k5e169478;
        Tue, 2 Feb 2021 09:19:36 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36f681chnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 09:19:36 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112ECcr3012366;
        Tue, 2 Feb 2021 14:19:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 36evvf0jxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 14:19:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112EJVmr50135476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 14:19:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F47FA405C;
        Tue,  2 Feb 2021 14:19:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AE3DA4054;
        Tue,  2 Feb 2021 14:19:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.19.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 14:19:31 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: css: Store CSS
 Characteristics
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
 <20210202121123.2397d844.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e19e0d76-2909-ea01-45fc-6e1127fabcb2@linux.ibm.com>
Date:   Tue, 2 Feb 2021 15:19:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202121123.2397d844.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_06:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 12:11 PM, Cornelia Huck wrote:
> On Fri, 29 Jan 2021 15:34:25 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> CSS characteristics exposes the features of the Channel SubSystem.
>> Let's use Store Channel Subsystem Characteristics to retrieve
>> the features of the CSS.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 57 +++++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_lib.c | 50 ++++++++++++++++++++++++++++++++++++++-
>>   s390x/css.c         | 12 ++++++++++
>>   3 files changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 3e57445..bc0530d 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -288,4 +288,61 @@ int css_residual_count(unsigned int schid);
>>   void enable_io_isc(uint8_t isc);
>>   int wait_and_check_io_completion(int schid);
>>   
>> +/*
>> + * CHSC definitions
>> + */
>> +struct chsc_header {
>> +	u16 len;
>> +	u16 code;
>> +};
>> +
>> +/* Store Channel Subsystem Characteristics */
>> +struct chsc_scsc {
>> +	struct chsc_header req;
>> +	u32 reserved1;
>> +	u32 reserved2;
>> +	u32 reserved3;
>> +	struct chsc_header res;
>> +	u32 format;
>> +	u64 general_char[255];
>> +	u64 chsc_char[254];
> 
> Both the kernel and QEMU use arrays of 32 bit values to model that. Not
> a problem, just a stumbling block when comparing code :)

This spares a devilish cast when using test_bit_inv, so I prefer to keep 
it like this since you seem OK with it.

> 
>> +};
>> +extern struct chsc_scsc *chsc_scsc;
>> +
>> +#define CSS_GENERAL_FEAT_BITLEN	(255 * 64)
>> +#define CSS_CHSC_FEAT_BITLEN	(254 * 64)
>> +
>> +int get_chsc_scsc(void);
>> +
>> +static inline int _chsc(void *p)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	.insn   rre,0xb25f0000,%2,0\n"
>> +		"	ipm     %0\n"
>> +		"	srl     %0,28\n"
>> +		: "=d" (cc), "=m" (p)
>> +		: "d" (p), "m" (p)
>> +		: "cc");
>> +
>> +	return cc;
>> +}
>> +
>> +#define CHSC_SCSC	0x0010
>> +#define CHSC_SCSC_LEN	0x0010
>> +
>> +static inline int chsc(void *p, uint16_t code, uint16_t len)
>> +{
>> +	struct chsc_header *h = p;
>> +
>> +	h->code = code;
>> +	h->len = len;
>> +	return _chsc(p);
>> +}
> 
> I'm wondering how useful this function is. For store channel subsystem
> characteristics, you indeed only need to fill in code and len, but
> other commands may need more fields filled out in the header, and
> filling in code and len is not really extra work. I guess it depends
> whether you plan to add more commands in the future.

It is different levels, CHSC instruction is the support for the 
different commands.
That is why I prefer to separate CHSC from the command's handling.

After your comment on the check of the response code, I will expand this 
function with response code check and report.


> 
> Also maybe move the definitions to the actual invocation of scsc?

Yes.

> 
>> +
>> +#include <bitops.h>
>> +#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
>> +
>>   #endif
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 3c24480..fe05021 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -15,11 +15,59 @@
>>   #include <asm/arch_def.h>
>>   #include <asm/time.h>
>>   #include <asm/arch_def.h>
>> -
>> +#include <alloc_page.h>
>>   #include <malloc_io.h>
>>   #include <css.h>
>>   
>>   static struct schib schib;
>> +struct chsc_scsc *chsc_scsc;
>> +
>> +int get_chsc_scsc(void)
>> +{
>> +	int i, n;
>> +	int ret = 0;
>> +	char buffer[510];
>> +	char *p;
>> +
>> +	report_prefix_push("Channel Subsystem Call");
>> +
>> +	if (chsc_scsc) {
>> +		report_info("chsc_scsc already initialized");
>> +		goto end;
>> +	}
>> +
>> +	chsc_scsc = alloc_pages(0);
>> +	report_info("scsc_scsc at: %016lx", (u64)chsc_scsc);
>> +	if (!chsc_scsc) {
>> +		ret = -1;
>> +		report(0, "could not allocate chsc_scsc page!");
>> +		goto end;
>> +	}
>> +
>> +	ret = chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN);
>> +	if (ret) {
>> +		report(0, "chsc: CC %d", ret);
>> +		goto end;
>> +	}
> 
> Shouldn't you check the response code in the chsc area as well?

yes, I should... I will.

I will rework the chsc() function to add the response code check.

-- 
Pierre Morel
IBM Lab Boeblingen
