Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9E10B5BE
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfK0S3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:29:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfK0S3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:29:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so27819642wrn.11
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2019 10:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q8PU0rul7Ps0UsPr1EhmDg+IsYeeYEG3+1dENJKBMlg=;
        b=HHEosXhsFZU4tqkKFMksMLlRSe317ArG/tQxZhX1RqfwX/e+KF1TMl5jI61vAQkDl/
         8offhU56rjNkhhxp9/ycfqju9SbNu4oaSH9vR/HOha+3oY+pHIdESc1HJmsI3ZsGJ7d2
         /aFmv6TQXTAHuEVAF1AWRDtAOks/esHYEA7Vo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q8PU0rul7Ps0UsPr1EhmDg+IsYeeYEG3+1dENJKBMlg=;
        b=DackPt71kO9IeEKd8OOpQ7tjV3e6e1Nde2cU24XK9LwtuT3GXOXs7x1Dgxwxkja5oB
         1SiC1PIk6yyjVuECjF7Qt54EtYIAwtSuJLIHfAO3P0TrTrRSpWB5L/KXxjMA8X9171Uw
         zG6jhfq6++6IdHCn8pZUqcpN20oVLqZB5yrek0qwPFBSXbMCja1IBKrI63UDw9NhYj8L
         i+CG1SXN9UVqBpD+5NGPv0pdk5vdufCMF5icbg+CAEjNrdt8LezFyPAgwoJgKVx7ABWO
         WOMSwHiIdBShCevNTcuijy0FjNMbtFf4tIt71qOd2jv+Bhn6DxzfeJI4IU+2LfmF5+4L
         sudQ==
X-Gm-Message-State: APjAAAVbKaOoGg0igar1Rgj6f9Bt6b95jGWj8v8q1WIojE8XX9WyYSzu
        DyEGYTZGTJKu561hq/VaeNFTNA==
X-Google-Smtp-Source: APXvYqzGxb027T6AjbrSIyxgbGT10Rlua3bWwnVmub45qfU7fTieDKg9Vuu7OFHe0iUJBy2r/1eQDw==
X-Received: by 2002:adf:f108:: with SMTP id r8mr13256774wro.390.1574879387660;
        Wed, 27 Nov 2019 10:29:47 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id h15sm20789799wrb.44.2019.11.27.10.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 10:29:43 -0800 (PST)
Date:   Wed, 27 Nov 2019 19:29:40 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/13] samples: vfio-mdev: constify fb ops
Message-ID: <20191127182940.GM406127@phenom.ffwll.local>
References: <cover.1574871797.git.jani.nikula@intel.com>
 <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 06:32:09PM +0200, Jani Nikula wrote:
> Now that the fbops member of struct fb_info is const, we can star making
> the ops const as well.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

You've missed at least drivers/staging/fbtft in your search. I guess you
need to do a full make allyesconfig on x86/arm and arm64 (the latter
because some stupid drivers only compile there, not on arm, don't ask).
Still misses a pile of mips/ppc only stuff and maybe the sparcs and
alphas, but should be good enough.

With that done, on the remaining patches:

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  samples/vfio-mdev/mdpy-fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> index 2719bb259653..21dbf63d6e41 100644
> --- a/samples/vfio-mdev/mdpy-fb.c
> +++ b/samples/vfio-mdev/mdpy-fb.c
> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
>  		iounmap(info->screen_base);
>  }
>  
> -static struct fb_ops mdpy_fb_ops = {
> +static const struct fb_ops mdpy_fb_ops = {
>  	.owner		= THIS_MODULE,
>  	.fb_destroy	= mdpy_fb_destroy,
>  	.fb_setcolreg	= mdpy_fb_setcolreg,
> -- 
> 2.20.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
