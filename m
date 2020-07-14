Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849A121EFBF
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGNLvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:51:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726041AbgGNLvw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 07:51:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EBWegJ140840;
        Tue, 14 Jul 2020 07:51:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3279kxed6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:51:50 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06EBjLgw189891;
        Tue, 14 Jul 2020 07:51:50 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3279kxed2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 07:51:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EBoY00006457;
        Tue, 14 Jul 2020 11:51:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 327527u9vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:51:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EBpcgf52297772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 11:51:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8104C046;
        Tue, 14 Jul 2020 11:51:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B55D4C04E;
        Tue, 14 Jul 2020 11:51:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.162.148])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 11:51:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v12 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com
References: <1594725348-10034-1-git-send-email-pmorel@linux.ibm.com>
 <1594725348-10034-10-git-send-email-pmorel@linux.ibm.com>
 <865cb20f-ac2d-f54a-6613-5d580675eb97@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b197e520-7fb4-bb14-2641-aa4de472fe12@linux.ibm.com>
Date:   Tue, 14 Jul 2020 13:51:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <865cb20f-ac2d-f54a-6613-5d580675eb97@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_02:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-14 13:38, Thomas Huth wrote:
> On 14/07/2020 13.15, Pierre Morel wrote:
>> After a channel is enabled we start a SENSE_ID command using
>> the SSCH instruction to recognize the control unit and device.
>>
>> This tests the success of SSCH, the I/O interruption and the TSCH
>> instructions.
>>
>> The SENSE_ID command response is tested to report 0xff inside
>> its reserved field and to report the same control unit type
>> as the cu_type kernel argument.
>>
>> Without the cu_type kernel argument, the test expects a device
>> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> [...]
>> @@ -102,6 +113,19 @@ struct irb {
>>   	uint32_t emw[8];
>>   } __attribute__ ((aligned(4)));
>>   
>> +#define CCW_CMD_SENSE_ID	0xe4
>> +#define CSS_SENSEID_COMMON_LEN	8
>> +struct senseid {
>> +	/* common part */
>> +	uint8_t reserved;        /* always 0x'FF' */
>> +	uint16_t cu_type;        /* control unit type */
>> +	uint8_t cu_model;        /* control unit model */
>> +	uint16_t dev_type;       /* device type */
>> +	uint8_t dev_model;       /* device model */
>> +	uint8_t unused;          /* padding byte */
>> +	uint8_t padding[256 - 10]; /* Extra padding for CCW */
>> +} __attribute__ ((aligned(4))) __attribute__ ((packed));
> 
> Is that padding[256 - 10] right? If I count right, there are only 8
> bytes before the padding field, so "10" sounds wrong here?
> 

No it is not, should be 248 or 256 - 8.


> [...]
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index e47a945..274c293 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
> [...]
>> +/*
>> + * css_residual_count
>> + * Return the residual count, if it is valid.
>> + *
>> + * Return value:
>> + * Success: the residual count
>> + * Not meaningful: -1 (-1 can not be a valid count)
>> + */
>> +int css_residual_count(unsigned int schid)
>> +{
>> +
>> +	if (!(irb.scsw.ctrl & (SCSW_SC_PENDING | SCSW_SC_PRIMARY)))
>> +		goto invalid;
>> +
>> +	if (irb.scsw.dev_stat)
>> +		if (irb.scsw.sch_stat & ~(SCSW_SCHS_PCI | SCSW_SCHS_IL))
>> +			goto invalid;
>> +
>> +	return irb.scsw.count;
>> +
>> +invalid:
>> +	return -1;
>> +}
> 
> Cosmetical nit: Unless you want to add something between "invalid:" and
> "return -1" later, I'd rather replace "goto invalid" with "return -1"
> and get rid of the "invalid" label here.
> 
>   Thomas
> 

OK, since I need to respin for the padding above.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
