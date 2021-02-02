Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE9C30C22A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 15:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhBBOm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 09:42:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234757AbhBBOjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 09:39:55 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112EWkB1153401;
        Tue, 2 Feb 2021 09:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TdKnFuUI5eAtLskAq9oHCadqvsPIc4ZPLJaUE/pSnKw=;
 b=lwS62jKMO0kLThzL+FMfSfruc+zKtUYDb/8swB/yEVgzOpFcHOrnGq/oii9+RwxPHWKV
 iTs2aoGJr+Fc5DF66rJekOmh/kDpKvwb5B9lPPC0O9+T8l/frosjxPSbPnzJx4nySVU3
 csnFYll4TRKx6KyVo9SY6gnzIcHr0AlzUzy65aY//m/xGtmpoTjWpN0iv7g4KBtLrzNe
 ga5+HdJsFBuFRYvK7XdrQ7Grl2a2TlYKPjVLjgsOimuf73ehks+y0sZ61xz2lvHDBMry
 ZrvUZuxRHQZrYOZEXH5We5QtwHIsLcEls8DMliBArwCWsI/sGoePl1lgDR235d0cqRZN YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36f8bh0t78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 09:39:12 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112EXDoR155895;
        Tue, 2 Feb 2021 09:39:11 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36f8bh0t68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 09:39:11 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112Ebt2s019717;
        Tue, 2 Feb 2021 14:39:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36er8y8rr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 14:39:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112EcvUp31588652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 14:38:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62550A4054;
        Tue,  2 Feb 2021 14:39:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F056A405B;
        Tue,  2 Feb 2021 14:39:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.19.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 14:39:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of the
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
 <20210202122311.3c1ead1c.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <98905e4a-5f9a-4614-4677-5acc511d3fdd@linux.ibm.com>
Date:   Tue, 2 Feb 2021 15:39:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202122311.3c1ead1c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_06:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 12:23 PM, Cornelia Huck wrote:
> On Fri, 29 Jan 2021 15:34:26 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
...snip...

>> +bool css_enabled(int schid)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: updating sch %08x failed with cc=%d",
>> +			    schid, cc);
>> +		return false;
>> +	}
>> +
>> +	if (!(pmcw->flags & PMCW_ENABLE)) {
>> +		report_info("stsch: sch %08x not enabled", schid);
>> +		return 0;
>> +	}
>> +	return true;
>> +}
>>   /*
>>    * css_enable: enable the subchannel with the specified ISC
>>    * @schid: Subchannel Identifier
>> @@ -167,18 +192,8 @@ retry:
>>   	/*
>>   	 * Read the SCHIB again to verify the enablement
>>   	 */
>> -	cc = stsch(schid, &schib);
>> -	if (cc) {
>> -		report_info("stsch: updating sch %08x failed with cc=%d",
>> -			    schid, cc);
>> -		return cc;
>> -	}
>> -
>> -	if ((pmcw->flags & flags) == flags) {
>> -		report_info("stsch: sch %08x successfully modified after %d retries",
>> -			    schid, retry_count);
>> +	if (css_enabled(schid))
> 
> This is a slightly different test now. Previously, you also checked
> whether the ISC matched the requested one. Not sure how valuable that
> test was.

Yes, I do not think it can be anything else when the CSS accept to 
enable the subchannel.

...
>>   
>> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
>> -	if (ret) {
>> -		report(0, "Could not enable the subchannel: %08x",
>> -		       test_device_sid);
>> -		return;
>> +	if (!css_enabled(test_device_sid)) {
>> +		report(0, "enabled subchannel: %08x", test_device_sid);
> 
> Isn't that a _not_ enabled subchannel?

:) yes, may be:

s/enabled/enabling/


...snip...

>>   
>>   static void css_init(void)
>> @@ -146,8 +142,17 @@ static void css_init(void)
>>   	int ret;
>>   
>>   	ret = get_chsc_scsc();
>> -	if (!ret)
>> -		report(1, " ");
>> +	if (ret)
>> +		return;
> 
> Shouldn't you report a failure here?

Clearly yes.


Thanks for the comments,
regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
