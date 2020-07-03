Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C454E213735
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGCJGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:06:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbgGCJGA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 05:06:00 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063941ra024764;
        Fri, 3 Jul 2020 05:06:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320ss4sn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 05:06:00 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06394AlX025425;
        Fri, 3 Jul 2020 05:05:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320ss4sn0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 05:05:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06391hxp001443;
        Fri, 3 Jul 2020 09:05:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3217b01fxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:05:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06395stM61407382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 09:05:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 863DC42049;
        Fri,  3 Jul 2020 09:05:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 197284204C;
        Fri,  3 Jul 2020 09:05:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.26])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 09:05:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
 <d8b2ed8c-3948-1cba-47af-ef2a8cdf27ed@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <0aaab65b-7856-9be9-c6dc-4da8e8d529d4@linux.ibm.com>
Date:   Fri, 3 Jul 2020 11:05:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d8b2ed8c-3948-1cba-47af-ef2a8cdf27ed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_03:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 cotscore=-2147483648 spamscore=0 clxscore=1015 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-03 10:41, Thomas Huth wrote:
> On 02/07/2020 18.31, Pierre Morel wrote:
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
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 0ddceb1..9c22644 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -11,6 +11,8 @@
>>   #ifndef CSS_H
>>   #define CSS_H
>>   
>> +#define lowcore_ptr ((struct lowcore *)0x0)
> 
> I'd prefer if you could either put this into the css_lib.c file or in
> lib/s390x/asm/arch_def.h.

I have a patch ready for this :)
But I did not want to add too much new things in this series that could 
start a new discussion.

I have 2 versions of the patch:
- The simple one with just the declaration in arch_def.h
- The complete one with update of all tests (but smp) using a pointer to 
lowcore.


> 
...snip...

>>   static inline int ssch(unsigned long schid, struct orb *addr)
>> @@ -251,6 +271,16 @@ void dump_orb(struct orb *op);
>>   
>>   int css_enumerate(void);
>>   #define MAX_ENABLE_RETRIES      5
>> -int css_enable(int schid);
>> +int css_enable(int schid, int isc);
>> +
>> +
> 
> In case you respin: Remove one empty line?

yes

> 
>> +/* Library functions */
>> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);

...snip...

>> +	lowcore_ptr->io_int_param = 0;
>> +
>> +	memset(&senseid, 0, sizeof(senseid));
>> +	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
>> +			       &senseid, sizeof(senseid), CCW_F_SLI);
>> +	if (ret) {
>> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
>> +		       test_device_sid, ret);
>> +		goto unreg_cb;
>> +	}
> 
> I'd maybe rather do something like:
> 
> 	report(ret == 0, "SENSE ID on sch %08x has good CC (%d)", ...)
> 	if (ret)
> 		goto unreg_cb;
> 
> and avoid report(0, ...) statements. Also for the other tests below. But
> maybe that's really just a matter of taste.

I prefer to use report(0,....) when an unexpected error occurs: This 
keep the test silent when what is expected occurs.

And use report(ret == xxx, ....) as the last report to report overall 
success or failure of the test.

Other opinions?

> 
>> +	wait_for_interrupt(PSW_MASK_IO);

...snip...

> 
> Apart from the nits, I'm fine with the patch.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
