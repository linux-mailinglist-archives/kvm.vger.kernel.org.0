Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8DF10C66E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 11:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfK1KLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 05:11:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55353 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfK1KLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 05:11:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id a131so5999154wme.5
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sISXPTjlwJ7V4ITzTlJun09VzrXW1uLl32xxBS1VK28=;
        b=klzHbCkoQlkg81BbUL+EwHZ6p0WS/SQgfNh6KC2POoVTgHs2znnPxgYJm0K5b2ECIX
         hMpCOOixeQHlahZM1wGlahTd7uwQOxI15aS7DpKxKriCVt6j6Krp4fR5eNJ+6CJ1hqZj
         3miAgkLmwqgjTWpsx+3/GKiitbN+RJhcpIJJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sISXPTjlwJ7V4ITzTlJun09VzrXW1uLl32xxBS1VK28=;
        b=qzaCJPTGmAU1ARhYGf9QMAjSaowKLfMRwXhxeI4mwZcDSL0KLn55zNGYEY4WflILD2
         dhyTtc6VKlTs1YChH3gt1KtbLsttZNO45VV1EWhplHI6EGUlbOyiYU5UAXhzQLizOfVi
         W5AWe20CTlACvjRiriIWgDfnaUK56ZV9dGf2ST4fO7Y9PjQUTihWMgnMuXH1BBaX2SFM
         INyHxW3GvgVZhmOT2AXu4xb13V/ZtA/oV4Z//kMHntqx1xfhagOtRG2GHkkMCQUREqoI
         mKioz7NDnkRdGn2QBxRuqHt5O5SCI+NsNzbA+JNN0/i5YzEFBR7iXRrBdb/t/6G5OGs6
         CwCw==
X-Gm-Message-State: APjAAAXeebv9Zw+fc0KlHR52Ot+xbJmPSM5d9PmswJFjo3+tsYxkDfV7
        YAZiRHo0va1e7ezzE8hg0l7axw==
X-Google-Smtp-Source: APXvYqwnNrI49aZ2W2YOZm0w5C0k/FdmQqHJgDY8+tOWqD4ok/grJ1NwsYJD988O1lFJnK/fDsmZBg==
X-Received: by 2002:a7b:cb02:: with SMTP id u2mr9058232wmj.142.1574935879478;
        Thu, 28 Nov 2019 02:11:19 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id s8sm22418162wrt.57.2019.11.28.02.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 02:11:18 -0800 (PST)
Date:   Thu, 28 Nov 2019 11:11:16 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/13] samples: vfio-mdev: constify fb ops
Message-ID: <20191128101116.GQ406127@phenom.ffwll.local>
References: <cover.1574871797.git.jani.nikula@intel.com>
 <fc8342eef9fcd2f55c86fcd78f7df52f7c76fa87.1574871797.git.jani.nikula@intel.com>
 <20191127182940.GM406127@phenom.ffwll.local>
 <87d0dcnynk.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0dcnynk.fsf@intel.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 11:22:23AM +0200, Jani Nikula wrote:
> On Wed, 27 Nov 2019, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Wed, Nov 27, 2019 at 06:32:09PM +0200, Jani Nikula wrote:
> >> Now that the fbops member of struct fb_info is const, we can star making
> >> the ops const as well.
> >> 
> >> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> >> Cc: kvm@vger.kernel.org
> >> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> >
> > You've missed at least drivers/staging/fbtft in your search. I guess you
> > need to do a full make allyesconfig on x86/arm and arm64 (the latter
> > because some stupid drivers only compile there, not on arm, don't ask).
> > Still misses a pile of mips/ppc only stuff and maybe the sparcs and
> > alphas, but should be good enough.
> 
> fbtft dynamically allocates the fbops, for whatever reason. There were
> others like that too. Some of the drivers modify the fbops runtime to
> choose different hooks for different configurations. Can't change them
> all anyway.
> 
> Facilitating making the fbops const is one thing (patches 1-8), but I'm
> not really sure I want to sign up for exhaustively moving fbops to
> rodata on anything beyond drivers/gpu/drm. It's not like I leave stuff
> broken. Besides I am trying to cover all the low hanging fruit where I
> can simply add the "const" and be done with it.

Uh indeed, I didn't check the output of my grep with sufficient finesses.
r-b as-is on that pile.

Since fbdev is officially in drm-misc you can just merge it all once the
prep is done - feels silly not to when you've done the work already.
-Daniel

> 
> BR,
> Jani.
> 
> >
> > With that done, on the remaining patches:
> >
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >
> >> ---
> >>  samples/vfio-mdev/mdpy-fb.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> >> index 2719bb259653..21dbf63d6e41 100644
> >> --- a/samples/vfio-mdev/mdpy-fb.c
> >> +++ b/samples/vfio-mdev/mdpy-fb.c
> >> @@ -86,7 +86,7 @@ static void mdpy_fb_destroy(struct fb_info *info)
> >>  		iounmap(info->screen_base);
> >>  }
> >>  
> >> -static struct fb_ops mdpy_fb_ops = {
> >> +static const struct fb_ops mdpy_fb_ops = {
> >>  	.owner		= THIS_MODULE,
> >>  	.fb_destroy	= mdpy_fb_destroy,
> >>  	.fb_setcolreg	= mdpy_fb_setcolreg,
> >> -- 
> >> 2.20.1
> >> 
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
