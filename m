Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC99E4EA87
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFUO03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:26:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfFUO03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jun 2019 10:26:29 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LEKlb6120425
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 10:26:28 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8y885746-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 10:26:27 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Fri, 21 Jun 2019 15:26:23 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 21 Jun 2019 15:26:21 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LEQKfO43712960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 14:26:20 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 615482805E;
        Fri, 21 Jun 2019 14:26:20 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 541B128058;
        Fri, 21 Jun 2019 14:26:20 +0000 (GMT)
Received: from [9.56.58.42] (unknown [9.56.58.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 14:26:20 +0000 (GMT)
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     cohuck@redhat.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1561055076.git.alifm@linux.ibm.com>
 <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
 <20190621160032.1bd0c15f.pasic@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Fri, 21 Jun 2019 10:26:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190621160032.1bd0c15f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062114-2213-0000-0000-000003A27694
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011302; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01221212; UDB=6.00642481; IPR=6.01002350;
 MB=3.00027407; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-21 14:26:22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062114-2214-0000-0000-00005EF0C5A4
Message-Id: <18812cc9-5c18-f075-d806-b55cc0cfbd3b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Halil,

On 06/21/2019 10:00 AM, Halil Pasic wrote:
> On Thu, 20 Jun 2019 17:07:09 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> There is a small window where it's possible that an interrupt can
>> arrive and can call cp_free, while we are still processing a channel
>> program (i.e allocating memory, pinnging pages, translating
>> addresses etc). This can lead to allocating and freeing at the same
>> time and can cause memory corruption.
>>
>> Let's not call cp_free if we are currently processing a channel program.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>
>> I have been running my test overnight with this patch and I haven't
>> seen the stack traces that I mentioned about earlier. I would like
>> to get some reviews on this and also if this is the right thing to
>> do?
>>
>> Thanks
>> Farhan
>>
>>   drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 66a66ac..61ece3f 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>   		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>   	if (scsw_is_solicited(&irb->scsw)) {
>>   		cp_update_scsw(&private->cp, &irb->scsw);
>> -		if (is_final)
>> +		if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)
> 
> How is access to private->state correctly synchronized? And don't we
> expect private->state == VFIO_CCW_STATE_CP_PENDING in case the cp was
> submitted successfully with a ssch() and is done now (one way or the
> other)?

I think the interrupt that we are processing could be for a csch/hsch 
and not an ssch. So we could have one thread handling an ssch and 
another thread handling a csch/hsch interrupt.

> 
> Does this have something to do with 71189f2 "vfio-ccw: make it safe to
> access channel programs" (Cornelia Huck, 2019-01-21)?

It's related. Though that patch handles freeing cp when we have 
successfully issued a ssch and then issue a csch/hsch. But it leaves a 
tiny window where if the reverse happens where we get an csch/hsch 
first, and then ssch there could be a scenario where we can end up 
calling cp_free in 2 different threads.

I have responded to Eric's email explaining further, so if you could 
kindly refer to that and continue the discussion there because I think 
he had similar questions and concern as you :)

Thanks
Farhan

>
> Regards,
> Halil
> 
>>   			cp_free(&private->cp);
>>   	}
>>   	mutex_lock(&private->io_mutex);
> 
> 

