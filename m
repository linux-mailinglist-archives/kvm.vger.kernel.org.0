Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49D30A764
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBAMQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:16:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhBAMQJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:16:09 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111C2oBr056120;
        Mon, 1 Feb 2021 07:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zm0KeU1qFF9bO02K3yV7dNdHhStA/yUOIPbX3LpcuUc=;
 b=EryV1Yk+oBV17Wy+fRIs70HKgaWMf24S6HJ5ktUNbRctp0LC39mARJeAEdHiTwiUAmvX
 yC4Yws1rBU/DsGGQym5MbNDEBk3IFKg7XeB8IKrOfuv1aQQxjKM9pV6/ni6YDnn00tHp
 Dietn88+otKe6uTrrrh7T1gSVCSupxgvtIr4yKezENXLs0bLVTcv4ix8zqtOq8DothW0
 J1LMn1jP7d+JIsvmLcJ6TLBx8iQKTeX/l31nmAZP0yvsjiXdWDmQjftjua3umeJ3ht+D
 m7OI+1gggIPOJAMCZSHHjIKe9M5e+Sr1SRrrFyy/1HI3iTAYPh4owYL57kYsXLdW+JWe dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36egn2sv5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 07:15:27 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111C3LUZ061210;
        Mon, 1 Feb 2021 07:15:27 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36egn2sv44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 07:15:27 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111CCWqQ015683;
        Mon, 1 Feb 2021 12:15:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36cy38hu1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:15:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111CFDJY37224706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 12:15:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34977A405C;
        Mon,  1 Feb 2021 12:15:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3280A4054;
        Mon,  1 Feb 2021 12:15:21 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 12:15:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of the
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
 <4f5ca0b9-378e-431c-33ec-79946bdf21b2@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <10f3108b-c1fe-7da9-7153-803690d311d4@linux.ibm.com>
Date:   Mon, 1 Feb 2021 13:15:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4f5ca0b9-378e-431c-33ec-79946bdf21b2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_04:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/1/21 11:11 AM, Janosch Frank wrote:
> On 1/29/21 3:34 PM, Pierre Morel wrote:

...snip...

>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index fe05021..f300969 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -118,6 +118,31 @@ out:
>>   	return schid;
>>   }
>>   
>> +/*
>> + * css_enable: enable the subchannel with the specified ISC
> 
> enabled or enable?

Forgot to change the cut and paste :(

/*
  * css_enabled: report if the sub channel is enabled

> 
> I.e. do you test if it is enabled or do you want to enable it.
> 
>> + * @schid: Subchannel Identifier
>> + * Return value:
>> + *   true if the subchannel is enabled
>> + *   false otherwise
>> + */
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
> 
> Please stay with true/false or change the return type to int and use ints.

yes

> 
>> +	}
>> +	return true;
>> +}

...snip...

>> @@ -129,16 +120,21 @@ static void test_sense(void)
>>   	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>>   		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>>   		    senseid->dev_type, senseid->dev_model);
>> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
>> +		    senseid->cu_type);
>>   
>> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
>> -	       (uint16_t)cu_type, senseid->cu_type);
>> +	retval = senseid->cu_type == cu_type;
>>   
>>   error:
>>   	free_io_mem(ccw, sizeof(*ccw));
>>   error_ccw:
>>   	free_io_mem(senseid, sizeof(*senseid));
>> -error_senseid:
>> -	unregister_io_int_func(css_irq_io);
>> +	return retval;
> 
> Could you return senseid->cu_type == cu_type here?

It would work for the current code and DEFAULT_CU_TYPE.
But I do not think it is a good idea due to the goto we have in error 
case before I find that it makes the code less understandable.

Other opinion?

Thanks for the comments,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
