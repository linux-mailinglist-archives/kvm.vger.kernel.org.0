Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A30371EA4
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhECRbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbhECRbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:31:09 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA0C06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 10:30:16 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id i81so6114338oif.6
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 10:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Ww87/u28SrRs0AQb4VrCAG+F/OsSAQIfgx2ufgEvzqY=;
        b=PaA3j1/67BuxpHs5cHtkSBua8jHfnIBQMQVjhlvU2kAmkpSmE5j4goJW2Seb5ggfC4
         d0a0P9ucBr1lQHazoec0gul5+AcXcg8XIzQFMrtVJdinRbmTvwhKcRGfExe2fDDzhPaW
         uFHaPoDhrvRXpXx8tjxa3LDcLZ86Du6oZWf1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Ww87/u28SrRs0AQb4VrCAG+F/OsSAQIfgx2ufgEvzqY=;
        b=FPWiS0xccf0WtW/xjvIZnnOrJKsumduzI2HTlJUpAQEt5ucBf/zpJYpkwA6fHeXbhh
         o4TJOGXLyMuB2iBajis25a1EBj8Dwg8OPn54IVjMGn3bEzXdqsSpBth7x8ahnTiE7HEj
         cFL1C/d6IkipgHJ1mEVy//VgoxMI9GA+HEUL3kMa80jxcLbkokcfSkIsk8z0Q0NS/Ls1
         PD1njJ13YNJNo7poVm7uG7/+md85hTZaagn9bn0Cw2BlAGOcKwb0vdUO6LC8ykY7Cz3J
         OZQsmFW6Amw0fhPW7k3BxJJifgMqSmMlg/9/r7YK52VHy+GN8oRuL/G2GsI0jFNgN/SB
         HrAg==
X-Gm-Message-State: AOAM532p39WBuDk3YeL0Q+SnPzdDcdgTIR0MDqmgT7lN9ectiMMFXhMW
        RU1h87EjRPcFcZ0ilIecaP/rX8YPEY3C6gOTYiLUvg==
X-Google-Smtp-Source: ABdhPJwNJ6NhUIpWVP8Ew1bTdKLBqrSK3V9oiD1uFsOIkcV4l4YiX9BNnR4CDl3qtDtLMexXC63mmJsQ0V1nxxAh1ik=
X-Received: by 2002:a54:4716:: with SMTP id k22mr14633067oik.55.1620063015513;
 Mon, 03 May 2021 10:30:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:a05:0:0:0:0:0 with HTTP; Mon, 3 May 2021 10:30:15 -0700 (PDT)
In-Reply-To: <20210502093319.61313-1-mgurtovoy@nvidia.com>
References: <20210502093319.61313-1-mgurtovoy@nvidia.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Mon, 3 May 2021 10:30:15 -0700
Message-ID: <CAA0tLEoT2P05cb8N+PXx7PLUgzvWqDtZ9eaMVhYtM5KXKF6E=A@mail.gmail.com>
Subject: Re: [PATCH 1/1] virtio-net: don't allocate control_buf if not supported
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/21, Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> Not all virtio_net devices support the ctrl queue feature. Thus, there
> is no need to allocate unused resources.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>

> ---
>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7fda2ae4c40f..9b6a4a875c55 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2870,9 +2870,13 @@ static int virtnet_alloc_queues(struct virtnet_info
> *vi)
>  {
>  	int i;
>
> -	vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> -	if (!vi->ctrl)
> -		goto err_ctrl;
> +	if (vi->has_cvq) {
> +		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> +		if (!vi->ctrl)
> +			goto err_ctrl;
> +	} else {
> +		vi->ctrl = NULL;
> +	}
>  	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
>  	if (!vi->sq)
>  		goto err_sq;
> --
> 2.18.1
>
>
