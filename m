Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3482F116E69
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 15:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfLIOBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 09:01:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:35912 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfLIOBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 09:01:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 06:01:35 -0800
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="206899935"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 06:01:32 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 11/12] samples: vfio-mdev: constify fb ops
In-Reply-To: <ddb10df1316ef585930cda7718643a580f4fe37b.1575390741.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1575390740.git.jani.nikula@intel.com> <ddb10df1316ef585930cda7718643a580f4fe37b.1575390741.git.jani.nikula@intel.com>
Date:   Mon, 09 Dec 2019 16:01:29 +0200
Message-ID: <87tv694myu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 03 Dec 2019, Jani Nikula <jani.nikula@intel.com> wrote:
> Now that the fbops member of struct fb_info is const, we can start
> making the ops const as well.
>
> v2: fix	typo (Christophe de Dinechin)
>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Kirti, may I have your ack to merge this through drm-misc please?

BR,
Jani.

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

-- 
Jani Nikula, Intel Open Source Graphics Center
