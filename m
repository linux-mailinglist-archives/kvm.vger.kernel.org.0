Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF6263A77
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 04:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgIJCaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 22:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730484AbgIJC1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 22:27:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488DEC061756
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 15:45:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so3435267pfn.8
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 15:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c5p8WBq1qtYrMuvvxqfHaHn+LepsJk3lGDjCppOmf40=;
        b=KkNfWb46nCHMbeFpHEoN0CbeSeqN6bPdBtG/eCBoKkF5xrln8OHsk8sdUVWe6AVc+O
         AhU2Crlxq9yZYcOelSde58riCYNYgoy/ey+O4+zsy5V2FekMCi7xlgOLeh6A7i/3kr2l
         xqUYhCHu525mHAIUpJViw0XumMcql9dqFwXxWo4MADUdyyDsbOWvwOsackh9DPWljen3
         hxO3NZriyaJav3J0+5HfkY3UYYEZv8WYs74R2ovvsgHgMVb2HuT5TKHLuZ6rQE8unlyn
         ykQBizXIhC3iyqFaW+4RMpfD3u+SlgObF1nUTce/d7F7SFe60IWFX3YHaXRbM/KhPSbf
         RKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c5p8WBq1qtYrMuvvxqfHaHn+LepsJk3lGDjCppOmf40=;
        b=iJPkELGeo6q/B0d8wfYt94BMYBYVcqa0pG7UO/zKk7ozN/uOrbAjw3GlCAI0AQe1RR
         5HSL3JfaKyelBE11Ny5aAJ/mSp8I99xN27S1pUkxrTb5SlNsnYMQH/ADpALmFgPe5ZNT
         x9NqHQXpS7mUUcYqfNZpSqzvAMAA85T3ChplxCMOmF/yE7Ga99WnOgZnW1OF2OOJdz80
         xICAdF7SRfMHpC9NgNLYr+rdUbLssMdbMNRHf8SVrlH2W+xkvNSJCEeazEDyfEU06/IN
         ks7PtB7q2KGdqHthGAXqPq6hVYRt+0Wu1bWbbyJNrkMw/O1I3lSyTdUqS+2lxVy5yYyM
         As9w==
X-Gm-Message-State: AOAM530w1Wp+wN/2HxgFU8syvufqMrcJLBstWKku79G7rbHCHeZT7UPw
        UNLtv31e2Sqpcch6jNiq17Wxpw==
X-Google-Smtp-Source: ABdhPJyLFnTKMqZCaScZAKIRwTEhSbQsApyF37uNABYJwF5hSOk5cB5ERfNlpt7X7bbBFCi4l+e1yA==
X-Received: by 2002:a17:902:b686:: with SMTP id c6mr2834249pls.74.1599691523776;
        Wed, 09 Sep 2020 15:45:23 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id s66sm3668057pfc.159.2020.09.09.15.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 15:45:23 -0700 (PDT)
Date:   Wed, 9 Sep 2020 16:45:21 -0600
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
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 3/4] rpmsg: update documentation
Message-ID: <20200909224521.GC562265@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-4-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826174636.23873-4-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 07:46:35PM +0200, Guennadi Liakhovetski wrote:
> rpmsg_create_ept() takes struct rpmsg_channel_info chinfo as its last
> argument, not a u32 value. The first two arguments are also updated.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  Documentation/rpmsg.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
> index 24b7a9e1a5f9..1ce353cb232a 100644
> --- a/Documentation/rpmsg.txt
> +++ b/Documentation/rpmsg.txt
> @@ -192,9 +192,9 @@ Returns 0 on success and an appropriate error value on failure.
>  
>  ::
>  
> -  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
> -		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
> -		void *priv, u32 addr);
> +  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev,
> +					  rpmsg_rx_cb_t cb, void *priv,
> +					  struct rpmsg_channel_info chinfo);

Again I don't see this being used in this set...  It should have been sent on
its own to the remoteproc and documentation mailing list.  Note that
Documentation/rpmsg.txt is now Documentation/staging/rpmsg.rst

>  
>  every rpmsg address in the system is bound to an rx callback (so when
>  inbound messages arrive, they are dispatched by the rpmsg bus using the
> -- 
> 2.28.0
> 
