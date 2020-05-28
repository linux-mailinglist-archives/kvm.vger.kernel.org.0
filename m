Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0F1E6AD7
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 21:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406352AbgE1T01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 15:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406258AbgE1T00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 15:26:26 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E82BC08C5C7
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 12:26:26 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c20so39311ilk.6
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 12:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZijaWGRwFYPgwZsXuw5DjnfYktdp3O/hEKFM6I48YM=;
        b=nK+TRML4DL+pCrN2GvYIvhh52ADr4WP6GzV7WCGn741Q/l0gqjhIWvp9UGIbvh/RM4
         gRePKb4MK6+ufROPVyHTzALz9ljEna3lsWZVgPvSBHLAukKxo+kwle/gw977RWClKzcU
         P0qn5UrYGtEoOOH8In++FHZlG6ftt8imq+jdYqDjjK6cTULG2ov2mh7OKCTRv/8kgGFa
         gaBFGQ13ldYY64QPd7N+2BRNhefZa7hDxgrn/q+v/ObP9ZRrKsWdz/ZVG0SsgFCO7C9H
         5DWliReVZUTYT1nCLzBGbScrT5Qnbd6SQPiAL6kdZlo1qUA6NEqR+/kSIN1fUyI4r4NF
         0fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZijaWGRwFYPgwZsXuw5DjnfYktdp3O/hEKFM6I48YM=;
        b=WZRxduhIlzKyIxjLSQO7/n2vfZXeBByCF5PyfOHMXrd/84IOlIYlBikFqLICjydqMR
         wX/xTI6Ex9A/MVwrKsndsU4rZyICmV1+jNzX2dupNAOi5MNY6XJCN8QsujaadNf4Vacb
         6AHR4tgXnP6M+bbZUlLw6YNBeSElHyAnyVucrk2K2eNxTWu6Bal8LUq7q0PGEao7/tM7
         VF9cLJ9lk+k0Epg20y2/WzV8WO1us2hBGW8MQBMBvTQsJcf0dtGxYMHFE0vk6D1aHO3e
         nZMF1tHT+3krK/XlO12A1WGkZ9mwBrioG7ceSmNd4o3jHuzo5SB0jXYvIJ6Bh/7scppD
         g/cA==
X-Gm-Message-State: AOAM532YorMPAuxxKX5dofBNxgUZhBQyLbkKPEcsHel19GzjZF4v4Mly
        5ksu/KCows6+eVRp1nbhyU6jrdKH9U9pIf/wFK9wm6CW
X-Google-Smtp-Source: ABdhPJztYWYQUmPTUmXiwY86vNCEzII8ShazbcVR75X4IuSa/Jau0J6oZX7FJaGoAiRrCKDikKNk361RF38Rp2RZpCA=
X-Received: by 2002:a92:89cf:: with SMTP id w76mr4134728ilk.57.1590693985637;
 Thu, 28 May 2020 12:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com> <20200527180541.5570-5-guennadi.liakhovetski@linux.intel.com>
In-Reply-To: <20200527180541.5570-5-guennadi.liakhovetski@linux.intel.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Thu, 28 May 2020 13:26:14 -0600
Message-ID: <CANLsYkxMiEABD+fhcCB7-r5bs4RSzY_qE09BVpaQ0C94BCWnfg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] rpmsg: update documentation
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 May 2020 at 12:05, Guennadi Liakhovetski
<guennadi.liakhovetski@linux.intel.com> wrote:
>
> rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
> argument, not a u32 value. The first two arguments are also updated.
>
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  Documentation/rpmsg.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
> index 24b7a9e..1ce353c 100644
> --- a/Documentation/rpmsg.txt
> +++ b/Documentation/rpmsg.txt
> @@ -192,9 +192,9 @@ Returns 0 on success and an appropriate error value on failure.
>
>  ::
>
> -  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
> -               void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
> -               void *priv, u32 addr);
> +  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev,
> +                                         rpmsg_rx_cb_t cb, void *priv,
> +                                         struct rpmsg_channel_info chinfo);
>

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

>  every rpmsg address in the system is bound to an rx callback (so when
>  inbound messages arrive, they are dispatched by the rpmsg bus using the
> --
> 1.9.3
>
