Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F262574DC94
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 19:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbjGJRfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 13:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjGJRfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 13:35:12 -0400
X-Greylist: delayed 964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jul 2023 10:35:11 PDT
Received: from mailrelay6-1.pub.mailoutpod2-cph3.one.com (mailrelay6-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:405::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE68CA
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 10:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=IgD20OUQ8wy5rFFsoBYb/VGqjIM7D6p+vuvVuio9hik=;
        b=CcwAZRGze1nz78tsTeGG31sH+B/tjdH+6ekcCAKy3lsh8Fx6Y+YXCD/TmIei/HlJU/+CjyCRKUyPh
         4CUMeeNCmxnxg5WnN8WYc+Y/3TRBu3GgBHOLLMWNEmjaKunSp3X6NAJPGuB+DxEkEZX+QnanSr3FYn
         2wlZ5UBU9Zu+O246GL/D/HneI1rQcFtBUkUV1dNMCwn+vM9M1hVrPjLsgJxFcU87WZ4nq2Vtx30nj9
         ArzioTOrLCz4P2HsQj4ZOuK/Fmh+TNaxaKUMNXnO1dvheypIb7/oOCjfcrCaYpZhivEpRMotLSbonb
         DLfigJoJ7elOqxhN67CrfrrG5kpNeWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=IgD20OUQ8wy5rFFsoBYb/VGqjIM7D6p+vuvVuio9hik=;
        b=vxQog57Oi39/DPw2NHC1MnZmnCknkQQw5bg9fTJIlcxSuaigVTP3V2Z7GSu+tbSUPTOKht6NYG4oF
         2pB/Sc4AQ==
X-HalOne-ID: de71c874-1f45-11ee-b17e-6f01c1d0a443
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay6 (Halon) with ESMTPSA
        id de71c874-1f45-11ee-b17e-6f01c1d0a443;
        Mon, 10 Jul 2023 17:19:05 +0000 (UTC)
Date:   Mon, 10 Jul 2023 19:19:03 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-fbdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-geode@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-nvidia@lists.surfsouth.com,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 00/17] fbdev: Remove FBINFO_DEFAULT and
 FBINFO_FLAG_DEFAULT flags
Message-ID: <20230710171903.GA14712@ravnborg.org>
References: <20230710130113.14563-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710130113.14563-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Mon, Jul 10, 2023 at 02:50:04PM +0200, Thomas Zimmermann wrote:
> Remove the unused flags FBINFO_DEFAULT and FBINFO_FLAG_DEFAULT from
> fbdev and drivers, as briefly discussed at [1]. Both flags were maybe
> useful when fbdev had special handling for driver modules. With
> commit 376b3ff54c9a ("fbdev: Nuke FBINFO_MODULE"), they are both 0
> and have no further effect.
> 
> Patches 1 to 7 remove FBINFO_DEFAULT from drivers. Patches 2 to 5
> split this by the way the fb_info struct is being allocated. All flags
> are cleared to zero during the allocation.
> 
> Patches 8 to 16 do the same for FBINFO_FLAG_DEFAULT. Patch 8 fixes
> an actual bug in how arch/sh uses the tokne for struct fb_videomode,
> which is unrelated.
> 
> Patch 17 removes both flag constants from <linux/fb.h>

We have a few more flags that are unused - should they be nuked too?
FBINFO_HWACCEL_FILLRECT
FBINFO_HWACCEL_ROTATE
FBINFO_HWACCEL_XPAN

Unused as in no references from fbdev/core/*

I would rather see one series nuke all unused FBINFO flags in one go.
Assuming my quick grep are right and the above can be dropped.

	Sam
