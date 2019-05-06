Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F21547C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 21:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEFThq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 15:37:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbfEFThp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 15:37:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46Jb4iP007096
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 15:37:44 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2satqqsabc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 15:37:44 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 6 May 2019 20:37:44 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 20:37:40 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46JbcWa34930920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 19:37:38 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 546E9AC05B;
        Mon,  6 May 2019 19:37:38 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09562AC059;
        Mon,  6 May 2019 19:37:38 +0000 (GMT)
Received: from [9.60.75.251] (unknown [9.60.75.251])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 19:37:37 +0000 (GMT)
Subject: Re: [PATCH v2 1/7] s390: vfio-ap: wait for queue empty on queue reset
To:     pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-2-git-send-email-akrowiak@linux.ibm.com>
 <0bdb1655-4c4e-1982-a842-9dfc7c02a576@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 6 May 2019 15:37:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <0bdb1655-4c4e-1982-a842-9dfc7c02a576@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050619-2213-0000-0000-00000389BF5B
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011061; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199536; UDB=6.00629317; IPR=6.00980412;
 MB=3.00026760; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 19:37:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050619-2214-0000-0000-00005E548F93
Message-Id: <ecc5d1d5-a1ea-64ed-2af0-b2a6ca00d748@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/19 2:41 AM, Pierre Morel wrote:
> On 03/05/2019 23:14, Tony Krowiak wrote:
>> Refactors the AP queue reset function to wait until the queue is empty
>> after the PQAP(ZAPQ) instruction is executed to zero out the queue as
>> required by the AP architecture.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 35 
>> ++++++++++++++++++++++++++++++++---
>>   1 file changed, 32 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 900b9cf20ca5..b88a2a2ba075 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -271,6 +271,32 @@ static int vfio_ap_mdev_verify_no_sharing(struct 
>> ap_matrix_mdev *matrix_mdev)
>>       return 0;
>>   }
>> +static void vfio_ap_mdev_wait_for_qempty(unsigned long apid, unsigned 
>> long apqi)
>> +{
>> +    struct ap_queue_status status;
>> +    ap_qid_t qid = AP_MKQID(apid, apqi);
>> +    int retry = 5;
>> +
>> +    do {
>> +        status = ap_tapq(qid, NULL);
>> +        switch (status.response_code) {
>> +        case AP_RESPONSE_NORMAL:
>> +            if (status.queue_empty)
>> +                return;
>> +            msleep(20);
> 
> NIT:     Fall through ?

Yes

> 
>> +            break;
>> +        case AP_RESPONSE_RESET_IN_PROGRESS:
>> +        case AP_RESPONSE_BUSY:
>> +            msleep(20);
>> +            break;
>> +        default:
>> +            pr_warn("%s: tapq err %02x: %04lx.%02lx may not be empty\n",
>> +                __func__, status.response_code, apid, apqi);
> 
> I do not thing the warning sentence is appropriate:
> The only possible errors here are if the AP is not available due to AP 
> checkstop, deconfigured AP or invalid APQN.

Right you are! I'll work on a new message.

> 
> 
>> +            return;
>> +        }
>> +    } while (--retry);
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
>> @@ -790,15 +816,18 @@ static int vfio_ap_mdev_group_notifier(struct 
>> notifier_block *nb,
>>       return NOTIFY_OK;
>>   }
>> -static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int 
>> apqi,
>> -                    unsigned int retry)
>> +int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi)
>>   {
>>       struct ap_queue_status status;
>> +    int retry = 5;
>>       do {
>>           status = ap_zapq(AP_MKQID(apid, apqi));
>>           switch (status.response_code) {
>>           case AP_RESPONSE_NORMAL:
>> +            vfio_ap_mdev_wait_for_qempty(apid, apqi);
>> +            return 0;
>> +        case AP_RESPONSE_DECONFIGURED:
> 
> Since you modify the switch, you can return for all the following cases:
> AP_RESPONSE_DECONFIGURE
> ..._CHECKSTOP
> ..._INVALID_APQN
> 
> 
> And you should wait for qempty on AP_RESET_IN_PROGRESS along with 
> AP_RESPONSE_NORMAL

If a queue reset is in progress, we retry the zapq. Are you saying we
should wait for qempty then reissue the zapq?

> 
>>               return 0;
>>           case AP_RESPONSE_RESET_IN_PROGRESS:
>>           case AP_RESPONSE_BUSY:
> 
> While at modifying this function, the AP_RESPONSE_BUSY is not a valid 
> code for ZAPQ, you can remove this.

Okay

> 
>> @@ -824,7 +853,7 @@ static int vfio_ap_mdev_reset_queues(struct 
>> mdev_device *mdev)
>>                    matrix_mdev->matrix.apm_max + 1) {
>>           for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>>                        matrix_mdev->matrix.aqm_max + 1) {
>> -            ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> +            ret = vfio_ap_mdev_reset_queue(apid, apqi);
> 
> IMHO, since you are at changing this call, passing the apqn as parameter 
> would be a good simplification.

Okay.

> 
> 
> 
>>               /*
>>                * Regardless whether a queue turns out to be busy, or
>>                * is not operational, we need to continue resetting
> 
> Depends on why the reset failed, but this is out of scope.

I'm not sure what you mean by out of scope here, but you do make a valid
point. If the response code for the zapq is AP_RESPONSE_DECONFIGURED,
there is probably no sense in continuing to reset queues for that
particular adapter. I'll consider a change here.

> 
>>
> 
> 

