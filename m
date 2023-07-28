Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931EB7675E0
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbjG1Szf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbjG1Szd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:55:33 -0400
X-Greylist: delayed 983 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Jul 2023 11:55:33 PDT
Received: from mailrelay4-1.pub.mailoutpod2-cph3.one.com (mailrelay4-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:403::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1328C136
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=VUh0aFlPbE0R5Fq1OrHOqUL95X24rHdCYRyu0H18kZs=;
        b=nCioZWrNeey8vxCpdX1PS6JYetosi8C9O01ss/HH2HJyQXZSYif+EEXq9NgAX5lnt9PA5zaB1X84Z
         k3xM6obOVGislRz2M/Gu2JcHM+1Q0C2O3AV5w9puCJmFcVLRrxADec0YlHAi45Q8VpsSY7CdLKY+cN
         OaB+/IUMss5pZ3YeVozbedZ0vdXKwm+VudzaZhSSeBAwuxaCvEgACUFad4qD7EoFj/Cyfjm951Xcj/
         cOnDJ+TbfS8IrJiw/cYE+i+eagFKsWC0gPGKxp/Eiedcsg7qzVn4IoYMAFosU21ToLsp5YWa6YQfcd
         VSyuvwb7cX/TTAjNGmbaT5AveVet4hQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=VUh0aFlPbE0R5Fq1OrHOqUL95X24rHdCYRyu0H18kZs=;
        b=kxR6wyzaXh0paaidtMnBto7pO+DGTJZUEWWvVTg8x1oYY2WafA14eiAr3Hh13dnzpbSCA4Lkqj0Oh
         e0DOECCAw==
X-HalOne-ID: 082225de-2d76-11ee-8c15-592bb1efe9dc
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay4 (Halon) with ESMTPSA
        id 082225de-2d76-11ee-8c15-592bb1efe9dc;
        Fri, 28 Jul 2023 18:39:08 +0000 (UTC)
Date:   Fri, 28 Jul 2023 20:39:06 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/47] fbdev: Use I/O helpers
Message-ID: <20230728183906.GB1144760@ravnborg.org>
References: <20230728182234.10680-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728182234.10680-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Fri, Jul 28, 2023 at 06:39:43PM +0200, Thomas Zimmermann wrote:
> Most fbdev drivers operate on I/O memory. And most of those use the
> default implementations for file I/O and console drawing. Convert all
> these low-hanging fruits to the fb_ops initializer macro and Kconfig
> token for fbdev I/O helpers.
> 
> The fbdev I/O helpers are easily grep-able. In a later patch, they can
> be left to empty values if the rsp. funtionality, such as file I/O or
> console, has been disabled.

Did you miss sm750 or was it left out on purpose?
As it hide in staging it is easy to miss.

	Sam
