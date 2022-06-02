Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9E53BEAB
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbiFBTWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbiFBTWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:22:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEF0202;
        Thu,  2 Jun 2022 12:22:19 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252J2AdV001975;
        Thu, 2 Jun 2022 19:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=izIICxj8OXeTWFZnEOd6qi4zlXKQis3DccOZAUlcG/4=;
 b=oSEyiIDZopQm3O+JAfoPrs7w4OX7IGPBNu6I8nrPOehoTjI1Pow/tRqfaHgzafVUlw0h
 YeefBiaUQe1lUdFjCdVWXAhNVpR49radVuA75Oc6Py2AJOzYfaIM1/hHuzTXQRtFISYm
 egEP5VgAgoP1E5HhsHn0uylY+hO4KkF4m2k4Y4eHdCAcX51rmuuhtbTNnbHig+9BRA1W
 wvLaRmerxoLI2gjLWn+GieT3d5y5+yh3AWIH3NdBVuX5Pgx3ak3n7fqTRzvJzDA8j7yI
 dYs1DBlYgGvBcz/hqskvEsiNDIqNBDY2pjrdqkPe5wRhq4Ojke0zdegh74gJn+taoCxl +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gf30v8anv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:22:15 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252J2RhQ002488;
        Thu, 2 Jun 2022 19:22:15 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gf30v8anm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:22:15 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252JL2pS001239;
        Thu, 2 Jun 2022 19:22:14 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1adbgku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:22:14 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252JMCCZ18153966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 19:22:12 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D70CB6A054;
        Thu,  2 Jun 2022 19:22:12 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 086BD6A047;
        Thu,  2 Jun 2022 19:22:12 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 19:22:11 +0000 (GMT)
Message-ID: <2f6c508b-78ef-f908-6263-e0ec2664ba0c@linux.ibm.com>
Date:   Thu, 2 Jun 2022 15:22:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 06/18] vfio/ccw: Pass enum to FSM event jumptable
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-7-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-7-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h7oLi19R6HW_NloAEhd2g04ggCtQn8TQ
X-Proofpoint-ORIG-GUID: EvcHhHBjUriBVs5VxuuhI3kt-1yQKDFx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020081
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/22 1:19 PM, Eric Farman wrote:
> The FSM has an enumerated list of events defined.
> Use that as the argument passed to the jump table,
> instead of a regular int.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")

Not sure if this change really merits a fixes tag

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_private.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index 12b5537d478f..5c128eec596b 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -156,7 +156,7 @@ typedef void (fsm_func_t)(struct vfio_ccw_private *, enum vfio_ccw_event);
>   extern fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
>   
>   static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
> -				     int event)
> +				      enum vfio_ccw_event event)
>   {
>   	trace_vfio_ccw_fsm_event(private->sch->schid, private->state, event);
>   	vfio_ccw_jumptable[private->state][event](private, event);

