Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8555353CA95
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244583AbiFCNVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244582AbiFCNVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:21:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FAF2DD67;
        Fri,  3 Jun 2022 06:21:30 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253CsXxN003385;
        Fri, 3 Jun 2022 13:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ffJL78TqU85YtBZD7cZhoO3vOXnSA6/kC7DBGlrFhXU=;
 b=sz1sQcZbi1tSlIRnncKb7Me8l+B4qr55K43WUxFFtWHCw6FrWmbSNeBMH6ABaUT7ZO/w
 7fe++dIWMj0CUKxi0Vbhq/LkeEoRjCWhzsn4Sh7gasXLO/f7vrK/D2ggfK6Y1vQD3CDG
 1WfHf7VrVNcLuaXOTPmyYw0uh3tupZSpCwuJbmlE6pqq/yB7NvAjADs3ClOz762xwbAv
 LIqhi80cErnLg002N/kin3rs2bLB9iC7/leOjibvQfLXNnt2l3OVhBEj8/1YDaFaBusN
 Kz8XLEyl1zwowE5NGhVCGQ66lkTXKm9pCJ0K4Me++mWt1lx2HY1U7ccFOOrxPvbC7Elx vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8atty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:21:27 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 253CtRwE011496;
        Fri, 3 Jun 2022 13:21:27 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfgg8attr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:21:27 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 253DK8kw017630;
        Fri, 3 Jun 2022 13:21:26 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3gcxt62u3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 13:21:26 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 253DLOcr35914146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 13:21:24 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83BC66A04D;
        Fri,  3 Jun 2022 13:21:24 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0F5E6A051;
        Fri,  3 Jun 2022 13:21:23 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 13:21:23 +0000 (GMT)
Message-ID: <65e84b02-6cd3-a230-f1e0-d22e2e70024d@linux.ibm.com>
Date:   Fri, 3 Jun 2022 09:21:23 -0400
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cl_vRQw0NzPBrOKgCcfaWirKm88oR8r9
X-Proofpoint-GUID: tNAiLk2QnnbWTeORiV78mtkqVZprCJnm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_04,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030057
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/22 1:19 PM, Eric Farman wrote:
> The FSM is in STANDBY state when arriving in vfio_ccw_mdev_probe(),
> and this routine converts it to IDLE as part of its processing.
> The error exit sets it to IDLE (again) but clears the private->mdev
> pointer.
> 
> The FSM should of course be managing the state itself, but the
> correct thing for vfio_ccw_mdev_probe() to do would be to put
> the state back the way it found it.
> 
> The corresponding check of private->mdev in vfio_ccw_sch_io_todo()
> can be removed, since the distinction is unnecessary at this point.
> 
> Fixes: 3bf1311f351ef ("vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>   drivers/s390/cio/vfio_ccw_ops.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 35055eb94115..b18b4582bc8b 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -108,7 +108,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>   	 * has finished. Do not overwrite a possible processing
>   	 * state if the final interrupt was for HSCH or CSCH.
>   	 */
> -	if (private->mdev && cp_is_finished)
> +	if (cp_is_finished)
>   		private->state = VFIO_CCW_STATE_IDLE;

Took me a bit to convince myself this was OK, mainly because AFAICT 
despite the change below the fsm jumptable would still allow you to 
reach this code when in STANDBY.  But, it should only be possible for an 
unsolicited interrupt (e.g. unsolicited implies !cp_is_finished) so we 
would still avoid a STANDBY->IDLE transition on accident.

Maybe work unsolicited interrupt into the comment block above along with 
HSCH/CSCH?

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

>   
>   	if (private->io_trigger)
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index bebae21228aa..a403d059a4e6 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -146,7 +146,7 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   	vfio_uninit_group_dev(&private->vdev);
>   	atomic_inc(&private->avail);
>   	private->mdev = NULL;
> -	private->state = VFIO_CCW_STATE_IDLE;
> +	private->state = VFIO_CCW_STATE_STANDBY;
