Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CD5634138
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiKVQPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiKVQPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11F670A22;
        Tue, 22 Nov 2022 08:13:03 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMG5GL0005997;
        Tue, 22 Nov 2022 16:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vSsdX93oXkXsRuSzmC8CObRmnO/5mVE6cVHLdONn8Zg=;
 b=VxaG+NzclL0S7K5TyjYE0WO16an/cd9pCcd8jkJ0UzHu7OAnXNPz8J0ICDedPiian+bi
 dDfhqbzhepwcUoESOybF8w2hnV+Rvmh8Bgdk/O+YDb9SKoglHWaiciXlDGrKWgqZRtNe
 xnwupWMvJFefccnICln0WyHhSun5WmMurGwtON/H8Ki8dDslzZE+7X3WzimFuKYBKNp+
 eN43gGkQa88La2auOTeUxzDZmpCv/G7zCAWE6OZC3fsEqSE0GbaKErhqAtPzmTMPq7fF
 dUIab2i/y7nsF338A8Lp7Ag9XrVR0+Udf/qLrFcL9jM+OC3xNvNxGEIqjqQ5p18ot0Nv Tg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0ytabpq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:13:02 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AMG56on024364;
        Tue, 22 Nov 2022 16:13:02 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3kxpsa53gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 16:13:02 +0000
Received: from smtpav06.wdc07v.mail.ibm.com ([9.208.128.115])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AMGD028131666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 16:13:01 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5D8058055;
        Tue, 22 Nov 2022 16:13:00 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166C658054;
        Tue, 22 Nov 2022 16:12:59 +0000 (GMT)
Received: from [9.160.109.153] (unknown [9.160.109.153])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 16:12:58 +0000 (GMT)
Message-ID: <81669522-5e4a-4b89-7bb1-c77db2fbff8e@linux.ibm.com>
Date:   Tue, 22 Nov 2022 11:12:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 01/16] vfio/ccw: cleanup some of the mdev commentary
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
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V5tcQZ3mN_eMs-Jbkj9LxmJXUH90Qr_R
X-Proofpoint-GUID: V5tcQZ3mN_eMs-Jbkj9LxmJXUH90Qr_R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_09,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> There is no longer an mdev struct accessible via a channel
> program struct, but there are some artifacts remaining that
> mention it. Clean them up.
> 
> Fixes: 0a58795647cd ("vfio/ccw: Remove mdev from struct channel_program")

Since it's only some changes in code comments, I don't think this needs to go to stable via a fixes tag.

Otherwise:
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 5 ++---
>  drivers/s390/cio/vfio_ccw_cp.h | 1 -
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index c0a09fa8991a..9e6df1f2fbee 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -121,7 +121,7 @@ static void page_array_unpin(struct page_array *pa,
>  /*
>   * page_array_pin() - Pin user pages in memory
>   * @pa: page_array on which to perform the operation
> - * @mdev: the mediated device to perform pin operations
> + * @vdev: the vfio device to perform pin operations
>   *
>   * Returns number of pages pinned upon success.
>   * If the pin request partially succeeds, or fails completely,
> @@ -229,7 +229,7 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
>  }
>  
>  /*
> - * Within the domain (@mdev), copy @n bytes from a guest physical
> + * Within the domain (@vdev), copy @n bytes from a guest physical
>   * address (@iova) to a host physical address (@to).
>   */
>  static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
> @@ -665,7 +665,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
>  /**
>   * cp_init() - allocate ccwchains for a channel program.
>   * @cp: channel_program on which to perform the operation
> - * @mdev: the mediated device to perform pin/unpin operations
>   * @orb: control block for the channel program from the guest
>   *
>   * This creates one or more ccwchain(s), and copies the raw data of
> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
> index 54d26e242533..16138a654fdd 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.h
> +++ b/drivers/s390/cio/vfio_ccw_cp.h
> @@ -27,7 +27,6 @@
>   * struct channel_program - manage information for channel program
>   * @ccwchain_list: list head of ccwchains
>   * @orb: orb for the currently processed ssch request
> - * @mdev: the mediated device to perform page pinning/unpinning
>   * @initialized: whether this instance is actually initialized
>   *
>   * @ccwchain_list is the head of a ccwchain list, that contents the

