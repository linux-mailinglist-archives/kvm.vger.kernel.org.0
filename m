Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADC464D9F1
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiLOLAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLOK74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 05:59:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050012E9FA;
        Thu, 15 Dec 2022 02:58:59 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAgGMw017303;
        Thu, 15 Dec 2022 10:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=zBcCnQdL4Aa84x8reCSO+1pHTGxiQl6Arhke7gOXq5A=;
 b=mj/Gxe9GRYNTeY9A03Xo8w2Cx2Jgh2EFi87cwBNJNMPA4o9MMYI/BEjUFXQClJxvkCy/
 YCztk5EPj8cjDwHkrfiUFWdS7kWlYh5DnXC8Zqs/7H+1y5JxxaiAHoTWp74b3wX/09dG
 V3ZB/K+AsurVaUX/eBduzPlbUa02oASGCGYcQShYwqPjivWFWGxey9czcwAbkbC8Qbg4
 wlT2roK4IyqALsc2k3ib7OM5nNy9M6O2lYU1DQvwP2E92MIKqFns5SnouOPK5zW/g4ni
 CJBHd/XewRPZM9kzhmnGyudFizsY3g0rVUjY+tF0ExYxMSdIRbbSNVjkYlamD9GoZO5S zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg22egbv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:57 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFAiQrT025608;
        Thu, 15 Dec 2022 10:58:57 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg22egbun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:57 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFAOnM1005694;
        Thu, 15 Dec 2022 10:58:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3meyfdwc99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 10:58:56 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFAwsCb60031460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 10:58:54 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 028C658059;
        Thu, 15 Dec 2022 10:58:54 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C31458043;
        Thu, 15 Dec 2022 10:58:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 10:58:53 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 15 Dec 2022 11:58:53 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20221213154437.15480-8-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-8-akrowiak@linux.ibm.com>
Message-ID: <5e94ac7e0f7ec09885814df46eea0003@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oFXujXkphW6EObymnea5rEDQyo-PQoLj
X-Proofpoint-ORIG-GUID: jZf_4mSWLy3miL3ruoEz-xn0vEodFZhS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-13 16:44, Tony Krowiak wrote:
> Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an 
> error
> not handled by a case statement.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index e80c5a6b91be..2dd8db9ddb39 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1676,7 +1676,7 @@ static int vfio_ap_mdev_reset_queue(struct
> vfio_ap_queue *q)
>  		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>  		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>  		     status.response_code);
> -		return -EIO;
> +		break;
>  	}
> 
>  	vfio_ap_free_aqic_resources(q);

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
