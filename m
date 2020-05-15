Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC51D472C
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgEOHhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:37:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726714AbgEOHhf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:37:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F7Yc66034601;
        Fri, 15 May 2020 03:37:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ub0xt22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:37:34 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F7ZQhO040406;
        Fri, 15 May 2020 03:37:33 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310ub0xstb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 03:37:33 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F7ZIwm020039;
        Fri, 15 May 2020 07:37:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3100ub23ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 07:37:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F7bQk362652490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 07:37:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17028A405F;
        Fri, 15 May 2020 07:37:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8F75A4054;
        Fri, 15 May 2020 07:37:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 07:37:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 09/10] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-10-git-send-email-pmorel@linux.ibm.com>
 <20200514142411.6e369fe4.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7453c812-dd30-44bc-c64a-35c4a3c929ee@linux.ibm.com>
Date:   Fri, 15 May 2020 09:37:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514142411.6e369fe4.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 cotscore=-2147483648
 mlxlogscore=999 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-14 14:24, Cornelia Huck wrote:
> On Fri, 24 Apr 2020 12:45:51 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We add a new css_lib file to contain the I/O function we may
> 
> s/function/functions/

Yes, thanks.


>> +	report_prefix_push("tsch");
>> +	sid = lowcore->subsys_id_word;
>> +	ret = tsch(sid, &irb);
>> +	switch (ret) {
>> +	case 1:
>> +		dump_irb(&irb);
>> +		flags = dump_scsw_flags(irb.scsw.ctrl);
>> +		report(0,
>> +		       "I/O interrupt, but sch not status pending: %s", flags);
> 
> "...but tsch reporting sch as not status pending" ?

Yes, better, Thx

> 
> A buggy implementation might give the wrong cc for tsch, but still
> indicate status pending in the control block.

OK, I will write the status for other error cases too.
> 
>> +		break;
>> +	case 2:
>> +		report(0, "TSCH returns unexpected CC 2");

will also s/TSCH/tsch/ here

>> +		break;
>> +	case 3:
>> +		report(0, "Subchannel %08x not operational", sid);
> 
> "tsch reporting subchannel %08x as not operational" ?

Yes, better.
and I will standardize these three reports.

> 
>> +		break;
>> +	case 0:
>> +		/* Stay humble on success */
>> +		break;
>> +	}
>> +pop:
>> +	report_prefix_pop();
>> +	lowcore->io_old_psw.mask &= ~PSW_MASK_WAIT;
>> +}
> 
...snip...

>> +	lowcore->io_int_param = 0;
>> +
>> +	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid));
> 
> You're always send the full (extended) sense id block. What if the the
> machine you're running on doesn't support extended sense id? Would the
> SLI ccw flag help?

Yes, you are right, since I only use senseid for recognition of the PONG 
subchannel, I can accept non extended senseid

> 
>> +	if (!ret) {
>> +		report(0, "start_senseid failed");
> 
> "ssch failed for SENSE ID on sch <sch>" ?

Better. Thx

> 
>> +		goto unreg_cb;
>> +	}
>> +
>> +	wfi(PSW_MASK_IO);
>> +
>> +	if (lowcore->io_int_param != test_device_sid) {
>> +		report(0,
>> +		       "No interrupts. io_int_param: expect 0x%08x, got 0x%08x",
>> +		       test_device_sid, lowcore->io_int_param);
> 
> Doesn't irq_io() already moan here?

Yes, right, I kept this from last version with delays.
It has no sense here:
- We are the only user of the CSS
- If the interrupt did not fire we are stuck in wfi()

Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
