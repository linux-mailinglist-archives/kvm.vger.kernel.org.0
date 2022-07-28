Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721C55846A8
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 21:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiG1Tud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 15:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiG1Tua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 15:50:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A38615717;
        Thu, 28 Jul 2022 12:50:29 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SJXxnh000367;
        Thu, 28 Jul 2022 19:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=q8thYccoVYuCRt11+05QecRiY5Sj9Lix29KIZtl9Hxg=;
 b=PStHSSZvIDPis6wS5AqfzfVU4sf8ur/RcMX6Zgaq1yiHsqMTNj0FYOSGr89V0lFqtSnK
 MvWwKdikP2UzRX7gKH8nMvyak8jIVK7HvogMmvuLSaJ/UWTasfntdWopNFsLzrEt3BHs
 Zqrw+U2EurFzg+PiTZmntQc3OgM1AFf3jeiHXitBcLfk+TNhLbW/o/NKPCV82D49SXcf
 8QaD5crid7MZrXsS+hr6UwgIb10gss6ukiJRWvQFBdblMGW2QlDwMNUsIv6LYBvfeO4G
 KzKL5bxfOIWZGWhk6J3uIRirgeSMMdYSRgOoFeRZk0+ulVM3rkOENmQy0UNOMqfAF+c3 hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm0qr0hav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 19:50:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SJaWBv014697;
        Thu, 28 Jul 2022 19:50:26 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm0qr0ham-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 19:50:26 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SJo4Fo017053;
        Thu, 28 Jul 2022 19:50:25 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 3hg97usfux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 19:50:25 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SJoOpW66847172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 19:50:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEBFA2805E;
        Thu, 28 Jul 2022 19:50:24 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37EC328058;
        Thu, 28 Jul 2022 19:50:22 +0000 (GMT)
Received: from [9.211.95.8] (unknown [9.211.95.8])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jul 2022 19:50:22 +0000 (GMT)
Message-ID: <88d6c9f2-15f7-9c3d-ce56-f448c27d2322@linux.ibm.com>
Date:   Thu, 28 Jul 2022 15:50:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/3] vfio/ccw: Add length to DMA_UNMAP checks
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220728160550.2119289-1-farman@linux.ibm.com>
 <20220728160550.2119289-2-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220728160550.2119289-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u44QGc7ycgNAzjfmep0bUB0sewhPFH__
X-Proofpoint-ORIG-GUID: 7ypIwDePnpZIMYGeylrB-rmc3zmcNUj2
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 12:05 PM, Eric Farman wrote:
> As pointed out with the simplification of the
> VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
> parameter was never used to check against the pinned
> pages.
> 
> Let's correct that, and see if a page is within the
> affected range instead of simply the first page of
> the range.
> 
> [1] https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

With one nit comment, feel free to change or not...

> ---
>   drivers/s390/cio/vfio_ccw_cp.c  | 14 ++++++++++----
>   drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>   drivers/s390/cio/vfio_ccw_ops.c |  2 +-
>   3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 8963f452f963..6202f1e3e792 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -170,12 +170,17 @@ static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vde
>   	kfree(pa->pa_iova);
>   }
>   
> -static bool page_array_iova_pinned(struct page_array *pa, unsigned long iova)
> +static bool page_array_iova_pinned(struct page_array *pa, unsigned long iova,
> +				   unsigned long length)
>   {
> +	unsigned long iova_pfn_start = iova >> PAGE_SHIFT;
> +	unsigned long iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
> +	unsigned long pfn;


^ why do we switch to unsigned longs here when the callers use u64 for 
length (and iova)?  Maybe just stick with u64s?

I thought maybe it was something introduced by Nicolin's series but it 
looks like the old pfn_array_iova_pinned did the same thing.

>   	int i;
>   
>   	for (i = 0; i < pa->pa_nr; i++)
> -		if (pa->pa_iova[i] == iova)
> +		pfn = pa->pa_iova[i] >> PAGE_SHIFT;
> +		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end)
>   			return true;
>   
>   	return false;
> @@ -899,11 +904,12 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>    * cp_iova_pinned() - check if an iova is pinned for a ccw chain.
>    * @cp: channel_program on which to perform the operation
>    * @iova: the iova to check
> + * @length: the length to check from @iova
>    *
>    * If the @iova is currently pinned for the ccw chain, return true;
>    * else return false.
>    */
> -bool cp_iova_pinned(struct channel_program *cp, u64 iova)
> +bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length)
>   {
>   	struct ccwchain *chain;
>   	int i;
> @@ -913,7 +919,7 @@ bool cp_iova_pinned(struct channel_program *cp, u64 iova)
>   
>   	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>   		for (i = 0; i < chain->ch_len; i++)
> -			if (page_array_iova_pinned(chain->ch_pa + i, iova))
> +			if (page_array_iova_pinned(chain->ch_pa + i, iova, length))
>   				return true;
>   	}
>   
> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
> index 3194d887e08e..54d26e242533 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.h
> +++ b/drivers/s390/cio/vfio_ccw_cp.h
> @@ -46,6 +46,6 @@ void cp_free(struct channel_program *cp);
>   int cp_prefetch(struct channel_program *cp);
>   union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
>   void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
> -bool cp_iova_pinned(struct channel_program *cp, u64 iova);
> +bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length);
>   
>   #endif
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 0047fd88f938..3f67fa103c7f 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -39,7 +39,7 @@ static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
>   		container_of(vdev, struct vfio_ccw_private, vdev);
>   
>   	/* Drivers MUST unpin pages in response to an invalidation. */
> -	if (!cp_iova_pinned(&private->cp, iova))
> +	if (!cp_iova_pinned(&private->cp, iova, length))
>   		return;
>   
>   	vfio_ccw_mdev_reset(private);

