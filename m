Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CD054E625
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377788AbiFPPf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiFPPf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:35:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CED52E6AC;
        Thu, 16 Jun 2022 08:35:25 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GDoPYe028574;
        Thu, 16 Jun 2022 15:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0LZYdhoIfMIv/VJem5DGSShrwbJuy7lzk+r+2OFd89E=;
 b=UTOd3s1uI8j5JIv2uCF7RDbez6z0qRjsrx8Wht+GdUyQKDOmRX8RY+TVuOPuCb1d+dOs
 KJ7D62maIn6gAkWw0mBqU0MC5mHVYiNmtDj+0ouV0a8cXfaSgImDnxOR78ZK2gCT7enU
 NFz9h82ZXt5U+x5/JRA/6yXU8UqHOfdgLTw69nuxS/YVRkAvd3+s7UvEGXaRniq2Qomi
 oDQkJx+hKosOkDrCCCucO9wgIluzH2zs85JT0xn4JHjGF1etJPGfehD7oS8KSG9GLQXt
 zOEO1pNMtoU2h32SpCPoFaCL6fpgodiZUZaDzwUXKmYtfhdI9NKgSVbKDLhceuayMhVT 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqxe2f2wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:35:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GFRjDj004473;
        Thu, 16 Jun 2022 15:35:22 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqxe2f2w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:35:22 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GFThEM026348;
        Thu, 16 Jun 2022 15:35:21 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3gmjpakaf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 15:35:21 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GFZJ2F23593470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 15:35:20 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBCD5136051;
        Thu, 16 Jun 2022 15:35:19 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09E4D136053;
        Thu, 16 Jun 2022 15:35:19 +0000 (GMT)
Received: from [9.211.56.136] (unknown [9.211.56.136])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 15:35:18 +0000 (GMT)
Message-ID: <6d6451d0-68cb-4dcf-c6c7-7480e6ae8e78@linux.ibm.com>
Date:   Thu, 16 Jun 2022 11:35:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 03/10] vfio/ccw: Do not change FSM state in subchannel
 event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-4-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220615203318.3830778-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: abj_eNAyQwQugUHqoD9JCTJtJMLeTDFH
X-Proofpoint-ORIG-GUID: RjVQ7gMg6mKwn3IrNMEBTxboBA06mQRw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_11,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 mlxlogscore=658 malwarescore=0
 adultscore=0 mlxscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160060
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 4:33 PM, Eric Farman wrote:
> The routine vfio_ccw_sch_event() is tasked with handling subchannel events,
> specifically machine checks, on behalf of vfio-ccw. It correctly calls
> cio_update_schib(), and if that fails (meaning the subchannel is gone)
> it makes an FSM event call to mark the subchannel Not Operational.
> 
> If that worked, however, then it decides that if the FSM state was already
> Not Operational (implying the subchannel just came back), then it should
> simply change the FSM to partially- or fully-open.
> 
> Remove this trickery, since a subchannel returning will require more
> probing than simply "oh all is well again" to ensure it works correctly.
> 
> Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

So, I agree that this code does not belong here and should be removed 
-- if the subchannel just came back, we can't assume it's even the same 
device.  We'd better just leave it NOT_OPER for this weird window for 
now.  So...

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

But I also wonder if more work could be done from vfio_ccw_sch_event 
based upon whats in the schib, like what io_subchannel_sch_event does 
(e.g. detecting if a reprobe of the device is necessary).  We should 
probably take a closer look here for potential follow-ups.

> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 179eb614fa5b..279ad2161f17 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -301,19 +301,11 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>   	if (work_pending(&sch->todo_work))
>   		goto out_unlock;
>   
> -	if (cio_update_schib(sch)) {
> -		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
> -		rc = 0;
> -		goto out_unlock;
> -	}
> -
> -	private = dev_get_drvdata(&sch->dev);
> -	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
> -		private->state = private->mdev ? VFIO_CCW_STATE_IDLE :
> -				 VFIO_CCW_STATE_STANDBY;
> -	}
>   	rc = 0;
>   
> +	if (cio_update_schib(sch))
> +		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
> +
>   out_unlock:
>   	spin_unlock_irqrestore(sch->lock, flags);
>   

