Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7CC5677D4
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiGET3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 15:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiGET3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 15:29:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861413CD3;
        Tue,  5 Jul 2022 12:29:10 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265JKsb7021946;
        Tue, 5 Jul 2022 19:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q9k6VJHv7I/5dsTOLHFDh1UOO/8w55FSsit0mxSKOuA=;
 b=KFuFnst7YRWYWt8pJ3rp8EMvnTqS8T4UKwH2Pleti5KsHcGPEl2TFshB07sjIAfhB94H
 GQHGAiDf+Vy17T9Olb+e2Odshm0x4jAnzIjDitVvV1/I8hQzGlANEZTGmVc/zVF5SDZW
 bRTF2KyD4ko9gQAmW8sFJKANqC029o2piT3sWEXRXCGKzvG3i0eF4zHg8bESa7467biR
 txJj0xdp2HNupHea6/XQGpShDnXqrq9P5uaynvy+ySOyBGP2cc/g6mk6Z44Ml5wX9uuY
 dNM8pEigaa/s8+h9BEY4ICee0tc/e5th7w19xcGsnxBOVuEksf699+9Wbrqn0hBTwiZO jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4ucmg65v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:07 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265JOnD4012540;
        Tue, 5 Jul 2022 19:29:07 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4ucmg65k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:07 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265JMGNl029963;
        Tue, 5 Jul 2022 19:29:06 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3h4ud781ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 19:29:06 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265JT4B234341294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 19:29:05 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6C42BE051;
        Tue,  5 Jul 2022 19:29:04 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 105D5BE04F;
        Tue,  5 Jul 2022 19:29:04 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 19:29:03 +0000 (GMT)
Message-ID: <3d54c408-9906-0921-b6ba-33f7185689b0@linux.ibm.com>
Date:   Tue, 5 Jul 2022 15:29:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 07/11] vfio/ccw: Update trace data for not operational
 event
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630203647.2529815-8-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220630203647.2529815-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dE372R3sOfJpgwI7qJz6q0iOz70ZEHJh
X-Proofpoint-GUID: zoBQIH3wU6kdBOttord_3TH1dQDexIvF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> We currently cut a very basic trace whenever the FSM directs
> control to the not operational routine.
> 
> Convert this to a message, so it's alongside the other configuration
> related traces (create, remove, etc.), and record both the event
> that brought us here and the current state of the device.
> This will provide some better footprints if things go bad.
> 
> Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_fsm.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index bbcc5b486749..88e529a2e184 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -160,8 +160,12 @@ static void fsm_notoper(struct vfio_ccw_private *private,
>   {
>   	struct subchannel *sch = private->sch;
>   
> -	VFIO_CCW_TRACE_EVENT(2, "notoper");
> -	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
> +	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: notoper event %x state %x\n",
> +			   sch->schid.cssid,
> +			   sch->schid.ssid,
> +			   sch->schid.sch_no,
> +			   event,
> +			   private->state);
>   
>   	/*
>   	 * TODO:

