Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F8C7579F4
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjGRK6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjGRK6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:58:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8C0E77;
        Tue, 18 Jul 2023 03:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C711B61514;
        Tue, 18 Jul 2023 10:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626C4C433C8;
        Tue, 18 Jul 2023 10:58:09 +0000 (UTC)
Message-ID: <263b3c0f-53cf-14b6-b956-e0f5b03c95b5@xs4all.nl>
Date:   Tue, 18 Jul 2023 12:58:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 11/18] media: Remove flag FBINFO_FLAG_DEFAULT from
 fbdev drivers
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>, deller@gmx.de,
        javierm@redhat.com, geert@linux-m68k.org, dan.carpenter@linaro.org
Cc:     linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20230715185343.7193-1-tzimmermann@suse.de>
 <20230715185343.7193-12-tzimmermann@suse.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <20230715185343.7193-12-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 15/07/2023 20:51, Thomas Zimmermann wrote:
> The flag FBINFO_FLAG_DEFAULT is 0 and has no effect, as struct
> fbinfo.flags has been allocated to zero by kzalloc(). So do not
> set it.
> 
> Flags should signal differences from the default values. After cleaning
> up all occurrences of FBINFO_DEFAULT, the token will be removed.
> 
> v2:
> 	* fix commit message (Miguel)
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/pci/ivtv/ivtvfb.c              | 1 -
>  drivers/media/test-drivers/vivid/vivid-osd.c | 1 -
>  2 files changed, 2 deletions(-)

I can take this patches for 6.6, unless you prefer to have this whole series
merged in one go?

In that case you can use my:

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> 
> diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> index 0aeb9daaee4c..23c8c094e791 100644
> --- a/drivers/media/pci/ivtv/ivtvfb.c
> +++ b/drivers/media/pci/ivtv/ivtvfb.c
> @@ -1048,7 +1048,6 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
>  	/* Generate valid fb_info */
>  
>  	oi->ivtvfb_info.node = -1;
> -	oi->ivtvfb_info.flags = FBINFO_FLAG_DEFAULT;
>  	oi->ivtvfb_info.par = itv;
>  	oi->ivtvfb_info.var = oi->ivtvfb_defined;
>  	oi->ivtvfb_info.fix = oi->ivtvfb_fix;
> diff --git a/drivers/media/test-drivers/vivid/vivid-osd.c b/drivers/media/test-drivers/vivid/vivid-osd.c
> index ec25edc679b3..051f1805a16d 100644
> --- a/drivers/media/test-drivers/vivid/vivid-osd.c
> +++ b/drivers/media/test-drivers/vivid/vivid-osd.c
> @@ -310,7 +310,6 @@ static int vivid_fb_init_vidmode(struct vivid_dev *dev)
>  	/* Generate valid fb_info */
>  
>  	dev->fb_info.node = -1;
> -	dev->fb_info.flags = FBINFO_FLAG_DEFAULT;
>  	dev->fb_info.par = dev;
>  	dev->fb_info.var = dev->fb_defined;
>  	dev->fb_info.fix = dev->fb_fix;

