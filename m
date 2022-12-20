Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451C6652587
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLTRZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiLTRY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:24:57 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D931C91B;
        Tue, 20 Dec 2022 09:24:56 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHEM9Q003354;
        Tue, 20 Dec 2022 17:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GZhDvTuq3qLE5y8U8Ix7im0PsUQrLPc5BuJpvNfAjLk=;
 b=IYTVZ6gqO/HhfGmETQIl0dcMEOOoRek2iXdkoYz9saJA02JfDfT5V5NF/wL5iwuPrp4A
 qUoViGBafACHSKPqCSrq4X+WS8RPa5iOt1ZQnhizH60CkskRNOtu/lqJyK5walxLO38b
 TC1E1WZpTiMw65fJzWGDV19qFhpND4VnQ6m/EowZEAGG6196B9h12kuU4pn90HscHOUa
 yFhEt4w/5f2qIjo0LZ4IKpIjE1w4EhtXclkOgeJ90fNF5RBiGVlyjMxmtQGHd+hTZcd+
 vpPPK1JfqVwc5hM57fxgsupnnzfjtvIYP4DJlnkWSkOOB2BVk+12km4vyHFMJZcBcQ9s xQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkh92g8wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:24:55 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKFQMBT032666;
        Tue, 20 Dec 2022 17:24:55 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3mh6yyu3cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:24:54 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHOquc4063818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:24:53 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B60F058043;
        Tue, 20 Dec 2022 17:24:52 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB1E05805D;
        Tue, 20 Dec 2022 17:24:51 +0000 (GMT)
Received: from [9.160.107.82] (unknown [9.160.107.82])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 17:24:51 +0000 (GMT)
Message-ID: <d3f130b3-5196-6a02-9b6b-162c3082396b@linux.ibm.com>
Date:   Tue, 20 Dec 2022 12:24:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 11/16] vfio/ccw: read only one Format-1 IDAW
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221220171008.1362680-1-farman@linux.ibm.com>
 <20221220171008.1362680-12-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221220171008.1362680-12-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v3fU35OFsO4drwm9z1YrWgmIqct-Mrea
X-Proofpoint-ORIG-GUID: v3fU35OFsO4drwm9z1YrWgmIqct-Mrea
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/22 12:10 PM, Eric Farman wrote:
> The intention is to read the first IDAW to determine the starting
> location of an I/O operation, knowing that the second and any/all
> subsequent IDAWs will be aligned per architecture. But, this read
> receives 64-bits of data, which is the size of a Format-2 IDAW.
> 
> In the event that Format-1 IDAWs are presented, adjust the size
> of the read to 32-bits. The data will end up occupying the upper
> word of the target iova variable, so shift it down to the lower
> word for use as an adddress. (By definition, this IDAW format
> uses a 31-bit address, so the "sign" bit will always be off and
> there is no concern about sign extension.)
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 9d74e0b74da7..29d1e418b2e2 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -509,6 +509,7 @@ static int ccw_count_idaws(struct ccw1 *ccw,
>  	struct vfio_device *vdev =
>  		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
>  	u64 iova;
> +	int size = cp->orb.cmd.c64 ? sizeof(u64) : sizeof(u32);
>  	int ret;
>  	int bytes = 1;
>  
> @@ -516,11 +517,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
>  		bytes = ccw->count;
>  
>  	if (ccw_is_idal(ccw)) {
> -		/* Read first IDAW to see if it's 4K-aligned or not. */
> -		/* All subsequent IDAws will be 4K-aligned. */
> -		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova), false);
> +		/* Read first IDAW to check its starting address. */
> +		/* All subsequent IDAWs will be 2K- or 4K-aligned. */
> +		ret = vfio_dma_rw(vdev, ccw->cda, &iova, size, false);
>  		if (ret)
>  			return ret;
> +
> +		/* Format-1 IDAWs only occupy the first int */

nit: s/int/32 bits/

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> +		if (!cp->orb.cmd.c64)
> +			iova = iova >> 32;
>  	} else {
>  		iova = ccw->cda;
>  	}

