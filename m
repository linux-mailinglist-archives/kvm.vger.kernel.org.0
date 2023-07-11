Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC79974F294
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjGKOr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjGKOrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:47:55 -0400
Received: from mailrelay6-1.pub.mailoutpod2-cph3.one.com (mailrelay6-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:405::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BFF10E7
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=IzJnH7tearuxnA6Z+6SlVNN7/HpdHXO6OvjidkyffDc=;
        b=t1UZoY+OgZB4qloOKAGoPzdxKiYC17C9++ltdd9VkKKSSJf/R5HyAsdaxr5chXo+LcqtCqMpEj2TA
         b8Z7yF6JHKQOlU7blN+narui79FThKq8hj2VwanKmhandBBtpyfKAhsU889SFEdFbXrVkiKx3hcR7H
         QKjso83LwxpCtsl1H23jeJIFNxLM2fJZpqpYaWgVJBzgpvhQLjm/hOp65N2Nj7rNyOZMvrxGPI6czh
         YS0MtrmIYLsQmwRyf7YF8HR5nxe+n7cXTvsKENehLpNtWPbi2L0wAhskoQ5ZCvD2WrQtbyYxsEJ/AP
         CUbin2WAzk67odxeRHKtnqDopCvMHJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=IzJnH7tearuxnA6Z+6SlVNN7/HpdHXO6OvjidkyffDc=;
        b=KzzqHm8tLnuEHjgNWidySCjTk6o2+jW4abV9LJjbJcqDWTbuxi74O9whyYkZn2CXMR1EK8Adpr0Tp
         1xeW/n7CQ==
X-HalOne-ID: e4c9d52a-1ff9-11ee-be66-6f01c1d0a443
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay6 (Halon) with ESMTPSA
        id e4c9d52a-1ff9-11ee-be66-6f01c1d0a443;
        Tue, 11 Jul 2023 14:47:46 +0000 (UTC)
Date:   Tue, 11 Jul 2023 16:47:44 +0200
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
Message-ID: <20230711144744.GA117276@ravnborg.org>
References: <20230710130113.14563-1-tzimmermann@suse.de>
 <20230710171903.GA14712@ravnborg.org>
 <ab92f8d9-36ab-06bc-b85b-d52b7a1bfe9a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab92f8d9-36ab-06bc-b85b-d52b7a1bfe9a@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Tue, Jul 11, 2023 at 08:24:40AM +0200, Thomas Zimmermann wrote:
> Hi Sam
> 
> Am 10.07.23 um 19:19 schrieb Sam Ravnborg:
> > Hi Thomas,
> > 
> > On Mon, Jul 10, 2023 at 02:50:04PM +0200, Thomas Zimmermann wrote:
> > > Remove the unused flags FBINFO_DEFAULT and FBINFO_FLAG_DEFAULT from
> > > fbdev and drivers, as briefly discussed at [1]. Both flags were maybe
> > > useful when fbdev had special handling for driver modules. With
> > > commit 376b3ff54c9a ("fbdev: Nuke FBINFO_MODULE"), they are both 0
> > > and have no further effect.
> > > 
> > > Patches 1 to 7 remove FBINFO_DEFAULT from drivers. Patches 2 to 5
> > > split this by the way the fb_info struct is being allocated. All flags
> > > are cleared to zero during the allocation.
> > > 
> > > Patches 8 to 16 do the same for FBINFO_FLAG_DEFAULT. Patch 8 fixes
> > > an actual bug in how arch/sh uses the tokne for struct fb_videomode,
> > > which is unrelated.
> > > 
> > > Patch 17 removes both flag constants from <linux/fb.h>
> > 
> > We have a few more flags that are unused - should they be nuked too?
> > FBINFO_HWACCEL_FILLRECT
> > FBINFO_HWACCEL_ROTATE
> > FBINFO_HWACCEL_XPAN
> 
> It seems those are there for completeness. Nothing sets _ROTATE, the others
> are simply never checked. According to the comments, some are required, some
> are optional. I don't know what that means.
> 
> IIRC there were complains about performance when Daniel tried to remove
> fbcon acceleration, so not all _HWACCEL_ flags are unneeded.
> 
> Leaving them in for reference/completeness might be an option; or not. I
> have no strong feelings about those flags.
> 
> > 
> > Unused as in no references from fbdev/core/*
> > 
> > I would rather see one series nuke all unused FBINFO flags in one go.
> > Assuming my quick grep are right and the above can be dropped.
> 
> I would not want to extend this series. I'm removing _DEFAULT as it's
> absolutely pointless and confusing.

OK, makes sense and thanks for the explanation.

The series is:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

