Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C4333108F
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCHOOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:14:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229704AbhCHOOA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:14:00 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128E3h2X009855
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:14:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IZKLxgVYWT7F981jpViXifG71/lkpXIW5B+iJItoUtc=;
 b=IR4MZI3+76ifq1VIBpXIe4ROvoUbnyf4h52FPHgo9mvvJCwMyAarwyel86qVQ7GTY2sF
 N/4JEJSVucFbwE7RyvhBkPsTUAhnPYuVESZJIwgaM3MEQ96xU2YiRywixT9ETCfy+vS8
 t8smMZd2G/g/aBpKRKAf1ulWUYACAMB0gML1AzpQPEX2cL+YQC9wKQYoK7hIV5LzAndK
 uYQfOfGj6YGnDngucFwLd9GOjKHig+269Ma4ilV3EsddFXyGsLUEUnCWUj5/P149F/lW
 7x8B8oGWuFMUdYazZb5xx6bspNDjmH7+6qTFV4DT/KrTPT5lnmxOvhKVKKPstJuNtdJB lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375n5wrrn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:13:59 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128E4ciu013540
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:13:59 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375n5wrrmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:13:59 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128E8WMX024287;
        Mon, 8 Mar 2021 14:13:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 37410h9048-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:13:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EDtHj43909492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:13:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4771AE04D;
        Mon,  8 Mar 2021 14:13:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7358AE045;
        Mon,  8 Mar 2021 14:13:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:13:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:13:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/21 4:00 PM, Janosch Frank wrote:
> On 3/1/21 12:47 PM, Pierre Morel wrote:
>> In order to ease the writing of tests based on:

...snip...

>> -static void test_sense(void)
>> +static bool do_test_sense(void)
>>   {
>>   	struct ccw1 *ccw;
>> +	bool success = false;
> 
> That is a very counter-intuitive name, something like "retval" might be
> better.
> You're free to use the normal int returns but unfortunately you can't
> use the E* error constants like ENOMEM.

hum, I had retval and changed it to success on a proposition of Thomas...
I find it more intuitive as a bool since this function succeed or fail, 
no half way and is used for the reporting.

other opinion?


> 
>>   	int ret;
>>   	int len;
>>   
>>   	if (!test_device_sid) {
>>   		report_skip("No device");
>> -		return;
>> +		return success;
>>   	}
>>   
>> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
>> -	if (ret) {
>> -		report(0, "Could not enable the subchannel: %08x",
>> -		       test_device_sid);
>> -		return;
>> +	if (!css_enabled(test_device_sid)) {
>> +		report(0, "enabling subchannel %08x", test_device_sid);
>> +		return success;
>>   	}
>>   
>> -	ret = register_io_int_func(css_irq_io);
>> -	if (ret) {
>> -		report(0, "Could not register IRQ handler");
>> -		return;
>> -	}
>> -
>> -	lowcore_ptr->io_int_param = 0;
>> -
>>   	senseid = alloc_io_mem(sizeof(*senseid), 0);
>>   	if (!senseid) {
>>   		report(0, "Allocation of senseid");
>> -		goto error_senseid;
>> +		return success;
>>   	}
>>   
>>   	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
>> @@ -129,21 +120,34 @@ static void test_sense(void)
>>   	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>>   		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>>   		    senseid->dev_type, senseid->dev_model);
>> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
>> +		    senseid->cu_type);
>>   
>> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
>> -	       (uint16_t)cu_type, senseid->cu_type);
>> +	success = senseid->cu_type == cu_type;
>>   
>>   error:
>>   	free_io_mem(ccw, sizeof(*ccw));
>>   error_ccw:
>>   	free_io_mem(senseid, sizeof(*senseid));
>> -error_senseid:
>> -	unregister_io_int_func(css_irq_io);
>> +	return success;
>> +}
>> +
>> +static void test_sense(void)
>> +{
>> +	report(do_test_sense(), "Got CU type expected");
>>   }
>>   
>>   static void css_init(void)
>>   {
>>   	report(!!get_chsc_scsc(), "Store Channel Characteristics");
>> +
>> +	if (register_io_int_func(css_irq_io)) {
>> +		report(0, "Could not register IRQ handler");
>> +		return;
> 
> assert() please

Yes.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
