Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CBD1EEB6F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgFDT6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFDT6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:58:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1946C08C5C1
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 12:58:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so2643181plo.6
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 12:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z2+bXPR2+Jym+qns9d2aby3e70oxsC4culu1OnVMUsc=;
        b=wD+ftdk8XUzqbiPr8Na112Cu51DQPZBAxXC0+Gq5Pou9jDzhylTGDlTJT2m9B+UqRm
         XLRCDyIXM/4fxkYCdCN74twd1cM5M9uFxoFAgHXY3oUEOotw0FMh6DKYw9IgT/peZqFP
         G4ZpCGuZRnp+h430Dhu78bwSAcaumKCCvXihiDn9Kl4OqRXqJn0W87khAgZ3DABas9+0
         Bp3g8Bnkj9/ViIGzHGJfh7ZG8tkYlmtrkTPD/tFXD290fxVbit26wQukNMtJkVEI3GTf
         SrEEZ3vmqC3DgOnZPJsR1XXABv+m6NTssruyPjZPU9oskYL5G00RgRiYshFxtFQeeJc0
         bTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z2+bXPR2+Jym+qns9d2aby3e70oxsC4culu1OnVMUsc=;
        b=LR2y8X6h5EPRmeTlq2R8xD8JRyprimzUnr3vG91NNMQG83P1YKVuZXcuI6TQPC28tD
         VxmxSyyiWgPzZwpzZ62lXg1ZhC0Zi04S/7D0ag0ku1XUbvdChFMhlLuomktuvUO7Kf4H
         tCrQKo16zYLlyMulquKAZXA/xj/k1/nJCvq4HNNswLIMMfNG09jhwS+cfNQ6jC2dyn2v
         Vwfzk4xym1uRT7Q0l+cUmiQrvtmMhsMhhnlDu5Sy9IAvMKGwKyjszHV6uuUqa7Wefik3
         K1wEUPdU8z1+S0z54gh2J1rDTMzA84ZxkCWCE7BbKZpabAJBbtNZM3zRxB3MXUHfx4G6
         fRlA==
X-Gm-Message-State: AOAM5328UmkLe4kRQtCQGtYts+JzS3QgJxy8dkVso4N/UVE4OHiwd7Gk
        oVNuZ0huagXKaUho6zieUG1O7Lg2pkQ=
X-Google-Smtp-Source: ABdhPJwoI6iZakaDayW86ZI5c9+SVK9lvsJys/UwZRIbOWOFopBEoOmESWc7kOBHjKXfZqSiTBFtTA==
X-Received: by 2002:a17:90a:2070:: with SMTP id n103mr7951376pjc.109.1591300722401;
        Thu, 04 Jun 2020 12:58:42 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id r1sm4695071pgb.37.2020.06.04.12.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 12:58:41 -0700 (PDT)
Date:   Thu, 4 Jun 2020 13:58:39 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [RFC 11/12] rpmsg: increase buffer size and reduce buffer number
Message-ID: <20200604195839.GA26734@xps15>
References: <20200529073722.8184-1-guennadi.liakhovetski@linux.intel.com>
 <20200529073722.8184-12-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529073722.8184-12-guennadi.liakhovetski@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Guennadi,

On Fri, May 29, 2020 at 09:37:21AM +0200, Guennadi Liakhovetski wrote:
> It is hard to imagine use-cases where 512 buffers would really be
> needed, whereas 512 bytes per buffer might be too little. Change this
> to use 16 16KiB buffers instead.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  include/linux/virtio_rpmsg.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/virtio_rpmsg.h b/include/linux/virtio_rpmsg.h
> index 679be8b..1add468 100644
> --- a/include/linux/virtio_rpmsg.h
> +++ b/include/linux/virtio_rpmsg.h
> @@ -72,8 +72,8 @@ enum rpmsg_ns_flags {
>   * can change this without changing anything in the firmware of the remote
>   * processor.
>   */
> -#define MAX_RPMSG_NUM_BUFS	512
> -#define MAX_RPMSG_BUF_SIZE	512
> +#define MAX_RPMSG_NUM_BUFS	(512 / 32)
> +#define MAX_RPMSG_BUF_SIZE	(512 * 32)

These have been a standard in the rpmsg protocol since the inception of the
subsystem 9 years ago and can't be changed without serious impact to existing
implementations.

I suggest to dynamically set the number and size of the buffers to use
based on the value of virtio_device_id::device.  To do that please spin
off a new function, something like rpmsg_get_buffer_size(), and in there use
the device ID to fetch the numbers based on vdev->id->device.  That way the
rpmsg driver can be used by multiple clients and the specifics of the buffers
adjusted without impact to other users.

Thanks,
Mathieu

>  
>  /* Address 53 is reserved for advertising remote services */
>  #define RPMSG_NS_ADDR		53
> -- 
> 1.9.3
> 
