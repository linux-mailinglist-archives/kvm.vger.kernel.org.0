Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B72322DBC
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhBWPoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:44:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233251AbhBWPoO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:44:14 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NFXcTl125428
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wadBHFKyb0oLe0p5oAHZPDcrpnKpv97ZWj3hzdFRfnk=;
 b=s28I5OSzpNqiTw1TZV0TzIdpjgGNNE+fPSgS9ApyIJoYTn6Tt9FzLjySLICbHsqrEwkp
 Bz9Q3MpUcPfJVqssTZY2x5h0djPgUx9WUSBdiWMT/fBxyjZ2sQoNLqBA+26CuZvAHD+G
 bXxB5XGUgurltT/Injhsk9vT1M2vStJe8VR335u5xGRdNBVz8RJ4TP/6uvtKM6i8ZdsP
 HG52ARGlVNQ57L/P0hD4Ux4gvUKMDt0sKqHpIWcmbasfkblRQY/ockDLV4wT/+aGbbZX
 z7IG+3d9ODbYijzig/yzo93ebxLsfhcSNDxjplEmXhaJFi1hzAa0vbR6XL74x1S5Pudk Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfku3xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:43:30 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NFXo87126331
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:43:30 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfku3wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:43:30 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NFgZsu027666;
        Tue, 23 Feb 2021 15:43:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 36tsph9emj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:43:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFhONh41157082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:43:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F6905205A;
        Tue, 23 Feb 2021 15:43:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DFC1A52050;
        Tue, 23 Feb 2021 15:43:23 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 3/5] s390x: css: implementing Set
 CHannel Monitor
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-4-git-send-email-pmorel@linux.ibm.com>
 <20210223142219.0f42a303.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6896535f-fde4-89bb-669a-2d7f0249b31b@linux.ibm.com>
Date:   Tue, 23 Feb 2021 16:43:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223142219.0f42a303.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/21 2:22 PM, Cornelia Huck wrote:
> On Thu, 18 Feb 2021 18:26:42 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement the call of the Set CHannel Monitor instruction,
>> starting the monitoring of the all Channel Sub System, and
>> initializing channel subsystem monitoring.
>>
>> Initial tests report the presence of the extended measurement block
>> feature, and verify the error reporting of the hypervisor for SCHM.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  21 +++++++++-
>>   lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/css.c         |  35 ++++++++++++++++
>>   3 files changed, 155 insertions(+), 1 deletion(-)
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 65b58ff..4c8a6ae 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -265,6 +265,106 @@ retry:
>>   	return -1;
>>   }
>>   
>> +/*
>> + * schib_update_mb: update the subchannel Mesurement Block
> 
> s/Mesurement/Measurement/
> 
> I guess that one is hard to get out of one's fingers :)

grrr yes, thanks

> 
>> + * @schid: Subchannel Identifier
>> + * @mb   : 64bit address of the measurement block
>> + * @mbi : the measurement block offset
>> + * @flags : PMCW_MBUE to enable measurement block update
>> + *	    PMCW_DCTME to enable device connect time
>> + *	    0 to disable measurement
>> + * @format1: set if format 1 is to be used
>> + */
>> +static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
>> +			    uint16_t flags, bool format1)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>> +		return false;
>> +	}
>> +
>> +	/* Update the SCHIB to enable the measurement block */
>> +	if (flags) {
>> +		pmcw->flags |= flags;
>> +
>> +		if (format1)
>> +			pmcw->flags2 |= PMCW_MBF1;
>> +		else
>> +			pmcw->flags2 &= ~PMCW_MBF1;
>> +
>> +		pmcw->mbi = mbi;
>> +		schib.mbo = mb;
>> +	} else {
>> +		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
>> +	}
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(schid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
>> +		 */
>> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
>> +		return false;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again
>> +	 */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: updating sch %08x failed with cc=%d",
>> +			    schid, cc);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * css_enable_mb: enable the subchannel Mesurement Block
> 
> s/Mesurement/Measurement/
> 
>> + * @schid: Subchannel Identifier
>> + * @mb   : 64bit address of the measurement block
>> + * @format1: set if format 1 is to be used
>> + * @mbi : the measurement block offset
>> + * @flags : PMCW_MBUE to enable measurement block update
>> + *	    PMCW_DCTME to enable device connect time
>> + */
>> +bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
>> +		   bool format1)
>> +{
>> +	int retry_count = MAX_ENABLE_RETRIES;
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +
>> +	while (retry_count-- &&
>> +	       !schib_update_mb(schid, mb, mbi, flags, format1))
>> +		mdelay(10); /* the hardware was not ready, give it some time */
>> +
>> +	return schib.mbo == mb && pmcw->mbi == mbi;
>> +}
>> +
>> +/*
>> + * css_disable_mb: enable the subchannel Mesurement Block
> 
> s/enable/disable/

hum yes,

> s/Mesurement/Measurement/

... /o\

> 
>> + * @schid: Subchannel Identifier
>> + */
>> +bool css_disable_mb(int schid)
>> +{
>> +	int retry_count = MAX_ENABLE_RETRIES;
>> +
>> +	while (retry_count-- &&
>> +	       !schib_update_mb(schid, 0, 0, 0, 0))
>> +		mdelay(10); /* the hardware was not ready, give it some time */
>> +
>> +	return retry_count > 0;
>> +}
>> +
>>   static struct irb irb;
>>   
>>   void css_irq_io(void)
> 
> (...)
> 
> I'd still have split out the subchannel-modifying functions into a
> separate patch, but no strong opinion.

Will do it since I need a respin due to all the Me"a"surement errors!

> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
