Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CDA26658A
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIKRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:06:28 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18158 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKRGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:06:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5badf10001>; Fri, 11 Sep 2020 10:03:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:06:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 10:06:02 -0700
Received: from [10.40.102.132] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:05:58 +0000
Subject: Re: [PATCH] vfio: Fix typo of the device_state
To:     Zenghui Yu <yuzenghui@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>
References: <20200910122508.705-1-yuzenghui@huawei.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b9767f0f-9e4e-fef7-5d1c-7410f1046d03@nvidia.com>
Date:   Fri, 11 Sep 2020 22:35:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910122508.705-1-yuzenghui@huawei.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599843825; bh=oAdnjCgE6+iYbbPbrmUM/+4Dh3xpWufH9eNFtbxYdtk=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=iWwTYCoa6SupNAGECYzBpnTpMiOnQuJZIJhj90bZdB0EIWwy47+WUZc2XBsWWgUm6
         mkSWRtC78bnVfWGkSwqPUfNeQqc+OSd7Ce6bLUgshO686Qmrk8faSifJxd5BE5ebzH
         VOK8a8RjFvx0WsfH/J4fcJQ720OzZ90lgqmF0B7i9K+etHMiiyox75/uv1ZdcAlBWV
         IYSh12exnFQeUqiBUBOuxFishSY2t6uAqUUHjcXjnsHBdxhfEfYOoCjEXOEdgaDsjj
         XQ3D7k5AK6NjqXLcX2c+kwIh520Y9kBYVYhVid+n/h5wcn5P4k4l2Qfp3GhtcFxPII
         27dVWdBiGZieg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ops. Thanks for fixing it.

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

On 9/10/2020 5:55 PM, Zenghui Yu wrote:
> A typo fix ("_RUNNNG" => "_RUNNING") in comment block of the uapi header.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>   include/uapi/linux/vfio.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 920470502329..d4bd39e124bf 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -462,7 +462,7 @@ struct vfio_region_gfx_edid {
>    * 5. Resumed
>    *                  |--------->|
>    *
> - * 0. Default state of VFIO device is _RUNNNG when the user application starts.
> + * 0. Default state of VFIO device is _RUNNING when the user application starts.
>    * 1. During normal shutdown of the user application, the user application may
>    *    optionally change the VFIO device state from _RUNNING to _STOP. This
>    *    transition is optional. The vendor driver must support this transition but
> 
