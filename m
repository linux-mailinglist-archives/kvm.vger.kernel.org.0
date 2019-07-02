Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE65D10F
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGBN40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 09:56:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbfGBN4Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 09:56:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62Dq9kd093286
        for <kvm@vger.kernel.org>; Tue, 2 Jul 2019 09:56:24 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tg6j6nhf4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:56:23 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Tue, 2 Jul 2019 14:56:22 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 2 Jul 2019 14:56:20 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62DuJhY45613396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 13:56:19 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 565CAB2067;
        Tue,  2 Jul 2019 13:56:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47E98B2065;
        Tue,  2 Jul 2019 13:56:19 +0000 (GMT)
Received: from [9.56.58.42] (unknown [9.56.58.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 13:56:19 +0000 (GMT)
Subject: Re: [RFC v1 1/4] vfio-ccw: Set orb.cmd.c64 before calling
 ccwchain_handle_ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1561997809.git.alifm@linux.ibm.com>
 <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
 <20190702102606.2e9cfed3.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Tue, 2 Jul 2019 09:56:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190702102606.2e9cfed3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19070213-0072-0000-0000-0000044371ED
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011365; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01226390; UDB=6.00645639; IPR=6.01007610;
 MB=3.00027553; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-02 13:56:22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070213-0073-0000-0000-00004CB3AA25
Message-Id: <de9ae025-a96a-11ab-2ba9-8252d8b070e0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/02/2019 04:26 AM, Cornelia Huck wrote:
> On Mon,  1 Jul 2019 12:23:43 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> Because ccwchain_handle_ccw calls ccwchain_calc_length and
>> as per the comment we should set orb.cmd.c64 before calling
>> ccwchanin_calc_length.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index d6a8dff..5ac4c1e 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -640,16 +640,16 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>>   	memcpy(&cp->orb, orb, sizeof(*orb));
>>   	cp->mdev = mdev;
>>   
>> -	/* Build a ccwchain for the first CCW segment */
>> -	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>> -	if (ret)
>> -		cp_free(cp);
>> -
>>   	/* It is safe to force: if not set but idals used
>>   	 * ccwchain_calc_length returns an error.
>>   	 */
>>   	cp->orb.cmd.c64 = 1;
>>   
>> +	/* Build a ccwchain for the first CCW segment */
>> +	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>> +	if (ret)
>> +		cp_free(cp);
>> +
>>   	if (!ret)
>>   		cp->initialized = true;
>>   
> 
> Hm... has this ever been correct, or did this break only with the
> recent refactorings?
> 
> (IOW, what should Fixes: point to?)
> 
> 

I think it was correct before some of the new refactoring we did. But we 
do need to set before calling ccwchain_calc_length, because the function 
does have a check for orb.cmd.64. I will see which exact commit did it.

Thanks
Farhan

