Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6F8341807
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhCSJMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:12:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31958 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhCSJLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:11:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J938EX135741
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZVSdp4oHiXM1j8i3Vzx/h6hJifCj4eBctW/03X8v2pw=;
 b=FwRnQCkJ+m/lIisdrqWXGG548mea9Na1PdaNAXrcLtuBTPqDxr7nJYRTp77Rs8PVsWoD
 R727s8RO47HJIsAnihH5M+5eQnFWxWO2YmmhnPFggx5XZwh3V2miRc8m1Jpq1L1PYGDO
 xc4h9kFnQoXck4J+a3D1WAB1EUIFX/m8scSSnRG/0vnW8lhnLMbzxoZlSqfSKWnhk/O2
 ukLnOyAquFnvPPTrdgA6GdcivgdE4hQ4n2kk43GvweHhyTgsx3d5iYrbzQ4jqXHNN1XZ
 pfEWXSqK37V4Tj2xoTPI9wpJeXdldUmHrtqwyavNpzF6XoBtVCOb2nH0452bXKQe4wDI ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vq5199-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:11:37 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12J946vR144180
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:11:36 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vq518g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 05:11:36 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12J97Sa3023598;
        Fri, 19 Mar 2021 09:11:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 37b6xjh6p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 09:11:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12J9BVPG34537816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 09:11:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6A92A405B;
        Fri, 19 Mar 2021 09:11:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E478A4054;
        Fri, 19 Mar 2021 09:11:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.79])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 09:11:31 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/6] s390x: lib: css: disabling a
 subchannel
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-2-git-send-email-pmorel@linux.ibm.com>
 <e279c463-55e0-3051-c150-f37c16f37157@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c483a656-d730-37e0-731a-eb182e649626@linux.ibm.com>
Date:   Fri, 19 Mar 2021 10:11:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <e279c463-55e0-3051-c150-f37c16f37157@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 10:02 AM, Janosch Frank wrote:
> On 3/18/21 2:26 PM, Pierre Morel wrote:
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Looks ok, minor nits below.
> 
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 70 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 7e3d261..b0de3a3 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -284,6 +284,7 @@ int css_enumerate(void);
>>   #define IO_SCH_ISC      3
>>   int css_enable(int schid, int isc);
>>   bool css_enabled(int schid);
>> +int css_disable(int schid);
>>   
>>   /* Library functions */
>>   int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index efc7057..f8db205 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -186,6 +186,75 @@ bool css_enabled(int schid)
>>   	}
>>   	return true;
>>   }
>> +
>> +/*
>> + * css_disable: disable the subchannel
>> + * @schid: Subchannel Identifier
>> + * Return value:
>> + *   On success: 0
>> + *   On error the CC of the faulty instruction
>> + *      or -1 if the retry count is exceeded.
>> + */
>> +int css_disable(int schid)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int retry_count = 0;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>> +		return cc;
>> +	}
>> +
>> +	if (!(pmcw->flags & PMCW_ENABLE)) {
>> +		report_info("stsch: sch %08x already disabled", schid);
>> +		return 0;
>> +	}
>> +
>> +retry:
>> +	/* Update the SCHIB to disable the subchannel */
>> +	pmcw->flags &= ~PMCW_ENABLE;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(schid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
>> +		 */
> 
> Weird indentation, the lines should be longer, no?
> 
>> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
>> +		return cc;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the enablement
>> +	 */
> 
> Can be one line
> 
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: updating sch %08x failed with cc=%d",
>> +			    schid, cc);
>> +		return cc;
>> +	}
>> +
>> +	if (!(pmcw->flags & PMCW_ENABLE)) {
>> +		if (retry_count)
>> +			report_info("stsch: sch %08x successfully disabled after %d retries",
>> +				    schid, retry_count);
>> +		return 0;
>> +	}
>> +
>> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
>> +		mdelay(10); /* the hardware was not ready, give it some time */
> 
> Personally I dislike comments at the end of lines except for
> constant/variable comments. Just put it before the delay.
> 
>> +		goto retry;
>> +	}
>> +
>> +	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
>> +		    schid, retry_count, pmcw->flags);
>> +	return -1;
>> +}
>>   /*
>>    * css_enable: enable the subchannel with the specified ISC
>>    * @schid: Subchannel Identifier
>>
> 

Thanks, will do the changes
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
