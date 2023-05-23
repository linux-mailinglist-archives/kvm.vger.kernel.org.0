Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F970E436
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbjEWRxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 13:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbjEWRxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 13:53:00 -0400
X-Greylist: delayed 451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 23 May 2023 10:52:58 PDT
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2682BF
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:52:58 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id 1W4UqPsLO8SAU1W4UqtSil; Tue, 23 May 2023 19:45:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1684863919;
        bh=6+vEzETCBUbqlh1LZrUq3iscDKbAGRNMMe5Z1TEFaUA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=GMAwEpWkBjSvQeerMp4Irxwjp9ZtaXEwb196Z+fF3X/ErHcEzDX0EkZsPkf2/vxc6
         KNAIrx+1kiuqC5dchulERoi3z98pTebsRrwp0U67RaOxsvmR10mjWq1A8bg3T5E9DK
         +u18Swc6+IPUooc7vJqy8jxQmQQUOS4EBrxf2qNsTsSsNnBivgvXb6bJGzQrsKxB6z
         +/O7zGLLEnZyWnbjBO/8nnG+a8lFgSQ1FkCQrs/51UJrHKZP9Q0Qv/To78heWX4y9U
         O1q0u092cyEb7dB7nwhCEpctSrl11ORSvzN7MOLoh0+Swy75PZA8cFAm/Xlhtkx1ol
         IX4lgafGL16Yg==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 23 May 2023 19:45:19 +0200
X-ME-IP: 86.243.2.178
Message-ID: <c3a473c2-1d4a-1b8a-648f-7f75b800ecd7@wanadoo.fr>
Date:   Tue, 23 May 2023 19:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Content-Language: fr, en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1684805398.git.gustavoars@kernel.org>
 <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 23/05/2023 à 03:35, Gustavo A. R. Silva a écrit :
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct vfio_ccw_parent and refactor the the rest of the code
> accordingly.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/297
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c     | 3 ++-
>   drivers/s390/cio/vfio_ccw_private.h | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index ff538a086fc7..57906a9c6324 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -171,7 +171,8 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   		return -ENODEV;
>   	}
>   
> -	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> +	parent = kzalloc(sizeof(*parent) + sizeof(struct mdev_type *),

Hi, wouldn't:

    parent = kzalloc(struct_size(parent, mdev_types, 1)),

be more informative and in the spirit of flexible array use?

Just my 2c,

CJ

> +			 GFP_KERNEL);
>   	if (!parent)
>   		return -ENOMEM;
>   
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index b441ae6700fd..b62bbc5c6376 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -79,7 +79,7 @@ struct vfio_ccw_parent {
>   
>   	struct mdev_parent	parent;
>   	struct mdev_type	mdev_type;
> -	struct mdev_type	*mdev_types[1];
> +	struct mdev_type	*mdev_types[];
>   };
>   
>   /**

