Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7D953F148
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiFFU7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiFFU7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:59:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CDB7A80C;
        Mon,  6 Jun 2022 13:48:34 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KXOjq001677;
        Mon, 6 Jun 2022 20:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vUxnzz5Wk9sXLWQo1vyY8fSzT6u8ZSyDiLt3Up+Y1p8=;
 b=K8JO/+22sfCbnEj/GB5BEz2QORPUeKGvj/msOEGaE2k16hXxsvjQ0Z1M/p9opdhFEqQr
 M66IrH4A+67pXABk9IngYQV0ctT4LQnSjPLyQtbB+JcHG/EPF6MZ494J7gqfcsHCzlgc
 02h0cO7vHHZ05PMp1Yo0GT6rQaRWDgOpwgLQ0ZqKh1/0hdATUSb8B5LikhZoxCndJHxs
 tnh5JCyeVX5EIa6YtWrs3XS8Bx1lFutIOQkK/auRRuPs6uSV6V0uYsQfqjPeSRw4Zc0D
 dKswFMBI7Weu1uqmrYvTIn/RaVwKJFJrrBohYb7GbKuFqRM3g6CJ2bQorPTwBBsrwGOM NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1hcjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:44:30 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KiO44009385;
        Mon, 6 Jun 2022 20:44:29 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqj1hcjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:44:29 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KLLsq007299;
        Mon, 6 Jun 2022 20:44:28 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3gfy1abstm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:44:28 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KiRY135389800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:44:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F7EB6A047;
        Mon,  6 Jun 2022 20:44:27 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B86976A04D;
        Mon,  6 Jun 2022 20:44:26 +0000 (GMT)
Received: from [9.163.20.188] (unknown [9.163.20.188])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:44:26 +0000 (GMT)
Message-ID: <fdcbab94-5399-d471-a433-7f90f2e9c7db@linux.ibm.com>
Date:   Mon, 6 Jun 2022 16:44:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 02/18] vfio/ccw: Fix FSM state if mdev probe fails
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-3-farman@linux.ibm.com>
 <65e84b02-6cd3-a230-f1e0-d22e2e70024d@linux.ibm.com>
 <f60647cde44658a4f09b399bd2406bcd6ef31c3e.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <f60647cde44658a4f09b399bd2406bcd6ef31c3e.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OcVPbp1v_q8nmAPhK4jsnxuGi37JM59b
X-Proofpoint-GUID: Z_YMmg4mBtznbG2lPIXUzSGkpVjg7U8Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060081
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 3:12 PM, Eric Farman wrote:
> On Fri, 2022-06-03 at 09:21 -0400, Matthew Rosato wrote:
>> On 6/2/22 1:19 PM, Eric Farman wrote:
>>> The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
>>> and this routine converts it to IDLE as part of its processing.
>>> The error exit sets it to IDLE (again) but clears the private->mdev
>>> pointer.
>>>
>>> The FSM should of course be managing the state itself, but the
>>> correct thing for vfio_ccw_mdev_probe() to do would be to put
>>> the state back the way it found it.
>>>
>>> The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
>>> can be removed, since the distinction is unnecessary at this point.
>>>
>>> Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use
>>> vfio_register_emulated_iommu_dev()")
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>>    drivers/s390/cio/vfio_ccw_ops.c | 2 +-
>>>    2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
>>> b/drivers/s390/cio/vfio_ccw_drv.c
>>> index 35055eb94115..b18b4582bc8b 100644
>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>> @@ -108,7 +108,7 @@ static void vfio_ccw_sch_io_todo(struct
>>> work_struct *work)
>>>    	 * has finished. Do not overwrite a possible processing
>>>    	 * state if the final interrupt was for HSCH or CSCH.
>>>    	 */
>>> -	if (private->mdev && cp_is_finished)
>>> +	if (cp_is_finished)
>>>    		private->state = VFIO_CCW_STATE_IDLE;
>>
>> Took me a bit to convince myself this was OK
> 
> Me too. :)
> 
>> , mainly because AFAICT
>> despite the change below the fsm jumptable would still allow you to
>> reach this code when in STANDBY.  But, it should only be possible for
>> an
>> unsolicited interrupt (e.g. unsolicited implies !cp_is_finished) so
>> we
>> would still avoid a STANDBY->IDLE transition on accident.
>>
>> Maybe work unsolicited interrupt into the comment block above along
>> with
>> HSCH/CSCH?
> 
> Good idea. How about:
> 
>          /*
>           * Reset to IDLE only if
> processing of a channel program
>           * has finished. Do not
> overwrite a possible processing
>           * state if the interrupt was
> unsolicited, or if the final
>           * interrupt was for HSCH or CSCH.
>   
>          */
> 

Sounds good to me
