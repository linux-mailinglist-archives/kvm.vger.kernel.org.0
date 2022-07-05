Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4F65677D6
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiGET3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 15:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiGET3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 15:29:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBDE18E10;
        Tue,  5 Jul 2022 12:29:34 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265JGorj021667;
        Tue, 5 Jul 2022 19:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F6DYHDuA2LH62hZ+fJXgp6qM7Pg7lPCcOp1N/uNZjb4=;
 b=W7utLlbYEuIOOd2trMoRO4laUX1/Qem02SWn7ROg9A+PxcFPiJ6krcFzol6zuY9BZ5AP
 8ExGMjeJub7I19AfabcT0Hy1RZalswbnLx1ZcGvbQwA5zmHNYukD8Io+0+Hf3PICLbdB
 E0AWGsqvyZGXfmv3UQxsILQc4AXjprevRorAr+D18FhLhtUl0Pa3YJDnSwjRFf1tpzBE
 XwCWqz8pfMfuLxW2SN1ohl8VD4MFXegEAKYgLlCxpE9uuHJeif7Xtf+PSC29barSTYNF
 servg3BqYr4ivVwtKTNQp14zs/mf4AVpbxvufbWNd094WUhnQ+V7Sq/HERDCzIb2avHJ 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4u080v53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265JFjup018387;
        Tue, 5 Jul 2022 19:29:32 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4u080v49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:32 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265JLo6i020347;
        Tue, 5 Jul 2022 19:29:31 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3h4ud1g13f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:30 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265JTTJY9830936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 19:29:29 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8801BE04F;
        Tue,  5 Jul 2022 19:29:29 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED1EBBE059;
        Tue,  5 Jul 2022 19:29:28 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 19:29:28 +0000 (GMT)
Message-ID: <40613523-0719-a9fd-f895-79fec1c292bf@linux.ibm.com>
Date:   Tue, 5 Jul 2022 15:29:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 10/11] vfio/ccw: Refactor vfio_ccw_mdev_reset
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630203647.2529815-11-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220630203647.2529815-11-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QXm2laFi6VqdyjXxEEFmNkvvSaXlM7Js
X-Proofpoint-ORIG-GUID: _vihIewbwI8ztqzheMLSEf2DEXVwVim-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 mlxlogscore=942 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 4:36 PM, Eric Farman wrote:
> Use both the FSM Close and Open events when resetting an mdev,
> rather than making a separate call to cio_enable_subchannel().
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_ops.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index fc5b83187bd9..4673b7ddfe20 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -21,25 +21,21 @@ static const struct vfio_device_ops vfio_ccw_dev_ops;
>   
>   static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
>   {
> -	struct subchannel *sch;
> -	int ret;
> -
> -	sch = private->sch;
>   	/*
> -	 * TODO:
> -	 * In the cureent stage, some things like "no I/O running" and "no
> -	 * interrupt pending" are clear, but we are not sure what other state
> -	 * we need to care about.
> -	 * There are still a lot more instructions need to be handled. We
> -	 * should come back here later.
> +	 * If the FSM state is seen as Not Operational after closing
> +	 * and re-opening the mdev, return an error.
> +	 *
> +	 * Otherwise, change the FSM from STANDBY to IDLE which is
> +	 * normally done by vfio_ccw_mdev_probe() in current lifecycle.
>   	 */
>   	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
> +	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
> +	if (private->state == VFIO_CCW_STATE_NOT_OPER)
> +		return -EINVAL;
>   
> -	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
> -	if (!ret)
> -		private->state = VFIO_CCW_STATE_IDLE;
> +	private->state = VFIO_CCW_STATE_IDLE;
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static int vfio_ccw_mdev_notifier(struct notifier_block *nb,

