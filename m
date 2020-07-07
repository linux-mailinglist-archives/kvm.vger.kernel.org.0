Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15193216AD8
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGGK5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:57:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11532 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgGGK5L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 06:57:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 067AXBsr188416;
        Tue, 7 Jul 2020 06:57:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324bp90g5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:57:09 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 067AXJO5188754;
        Tue, 7 Jul 2020 06:57:09 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 324bp90g42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 06:57:08 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 067Av6Us019224;
        Tue, 7 Jul 2020 10:57:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 322hd81ph8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 10:57:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 067Av4Uk61210626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 10:57:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 043CFA405B;
        Tue,  7 Jul 2020 10:57:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BACBA4054;
        Tue,  7 Jul 2020 10:57:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 10:57:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
 <20200706114655.5088b6b7.cohuck@redhat.com>
 <02eb7a70-7a74-6f09-334f-004e69aaa198@linux.ibm.com>
 <20200706162413.1a24fe40.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b4bad260-1ae5-7cd8-2339-63c73e3218bd@linux.ibm.com>
Date:   Tue, 7 Jul 2020 12:57:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200706162413.1a24fe40.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_06:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxscore=0
 cotscore=-2147483648 malwarescore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007070081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-06 16:24, Cornelia Huck wrote:
> On Mon, 6 Jul 2020 15:01:50 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-07-06 11:46, Cornelia Huck wrote:
>>> On Thu,  2 Jul 2020 18:31:20 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> After a channel is enabled we start a SENSE_ID command using
>>>> the SSCH instruction to recognize the control unit and device.
>>>>
>>>> This tests the success of SSCH, the I/O interruption and the TSCH
>>>> instructions.
>>>>
>>>> The SENSE_ID command response is tested to report 0xff inside
>>>> its reserved field and to report the same control unit type
>>>> as the cu_type kernel argument.
>>>>
>>>> Without the cu_type kernel argument, the test expects a device
>>>> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    lib/s390x/asm/arch_def.h |   1 +
>>>>    lib/s390x/css.h          |  32 ++++++++-
>>>>    lib/s390x/css_lib.c      | 148 ++++++++++++++++++++++++++++++++++++++-
>>>>    s390x/css.c              |  94 ++++++++++++++++++++++++-
>>>>    4 files changed, 272 insertions(+), 3 deletions(-)
> 
> (...)
> 
>>>> @@ -114,6 +128,7 @@ retry:
>>>>    		return cc;
>>>>    	}
>>>>    
>>>> +	report_info("stsch: flags: %04x", pmcw->flags);
>>>
>>> It feels like all of this already should have been included in the
>>> previous patch?
>>
>> Yes, I did not want to modify it since it was reviewed-by.
> 
> It's not such a major change (the isc change and this here), though...
> what do the others think?
changed my mind:
What about keeping css_enable() to only do enable, in case we only want 
to do this, and add a function to modify the ISC.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
