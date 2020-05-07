Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF51E1C7FF8
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 04:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgEGCTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 22:19:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgEGCTX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 22:19:23 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04722XsG012543;
        Wed, 6 May 2020 22:19:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8t7js3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 22:19:22 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04722ond014599;
        Wed, 6 May 2020 22:19:22 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8t7js2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 22:19:22 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0472GDLZ029397;
        Thu, 7 May 2020 02:19:21 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 30s0g765tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 02:19:21 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0472JJT650397670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 May 2020 02:19:19 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9CF8BE05A;
        Thu,  7 May 2020 02:19:19 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D2DBBE04F;
        Thu,  7 May 2020 02:19:18 +0000 (GMT)
Received: from [9.160.6.78] (unknown [9.160.6.78])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  7 May 2020 02:19:18 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
To:     Jared Rossi <jrossi@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200506212440.31323-1-jrossi@linux.ibm.com>
 <20200506212440.31323-2-jrossi@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <b223f68e-c8bb-7c3a-605e-296869ba07a6@linux.ibm.com>
Date:   Wed, 6 May 2020 22:19:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506212440.31323-2-jrossi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 phishscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/20 5:24 PM, Jared Rossi wrote:
> Remove the explicit prefetch check when using vfio-ccw devices.
> This check does not trigger in practice as all Linux channel programs
> are intended to use prefetch.
> 
> It is expected that all ORBs issued by Linux will request prefetch.
> Although non-prefetching ORBs are not rejected, they will prefetch
> nonetheless. A warning is issued up to once per 5 seconds when a
> forced prefetch occurs.
> 
> A non-prefetch ORB does not necessarily result in an error, however
> frequent encounters with non-prefetch ORBs indicate that channel
> programs are being executed in a way that is inconsistent with what
> the guest is requesting. While there is currently no known case of an
> error caused by forced prefetch, it is possible in theory that forced
> prefetch could result in an error if applied to a channel program that
> is dependent on non-prefetch.
> 
> Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  Documentation/s390/vfio-ccw.rst |  6 ++++++
>  drivers/s390/cio/vfio_ccw_cp.c  | 19 ++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index fca9c4f5bd9c..23e7d136f8b4 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -335,6 +335,12 @@ device.
>  The current code allows the guest to start channel programs via
>  START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
>  
> +Currently all channel programs are prefetched, regardless of the
> +p-bit setting in the ORB.  As a result, self modifying channel
> +programs are not supported.  For this reason, IPL has to be handled as
> +a special case by a userspace/guest program; this has been implemented
> +in QEMU's s390-ccw bios as of QEMU 4.1.
> +
>  vfio-ccw supports classic (command mode) channel I/O only. Transport
>  mode (HPF) is not supported.
>  
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 3645d1720c4b..f237480c3d43 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -8,6 +8,7 @@
>   *            Xiao Feng Ren <renxiaof@linux.vnet.ibm.com>
>   */
>  
> +#include <linux/ratelimit.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/iommu.h>
> @@ -625,23 +626,27 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
>   * the target channel program from @orb->cmd.iova to the new ccwchain(s).
>   *
>   * Limitations:
> - * 1. Supports only prefetch enabled mode.
> - * 2. Supports idal(c64) ccw chaining.
> - * 3. Supports 4k idaw.
> + * 1. Supports idal(c64) ccw chaining.
> + * 2. Supports 4k idaw.
>   *
>   * Returns:
>   *   %0 on success and a negative error value on failure.
>   */
>  int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  {
> +	/* custom ratelimit used to avoid flood during guest IPL */
> +	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
>  	int ret;
>  
>  	/*
> -	 * XXX:
> -	 * Only support prefetch enable mode now.
> +	 * We only support prefetching the channel program. We assume all channel
> +	 * programs executed by supported guests likewise support prefetching.
> +	 * Executing a channel program that does not specify prefetching will
> +	 * typically not cause an error, but a warning is issued to help identify
> +	 * the problem if something does break.
>  	 */
> -	if (!orb->cmd.pfch)
> -		return -EOPNOTSUPP;
> +	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
> +		dev_warn(mdev, "Prefetching channel program even though prefetch not specified in ORB");
>  
>  	INIT_LIST_HEAD(&cp->ccwchain_list);
>  	memcpy(&cp->orb, orb, sizeof(*orb));
> 
