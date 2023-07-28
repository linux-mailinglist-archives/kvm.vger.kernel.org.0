Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7739076758A
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjG1Sft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjG1Sfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:35:47 -0400
Received: from mailrelay1-1.pub.mailoutpod2-cph3.one.com (mailrelay1-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:400::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CAD4233
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=yhlqzaoSJHj1oBhyHOJO58FgrwVTmfOzCSyUIFeQhEY=;
        b=PEcPzlAsab2q5HAQN/yHKrzMYVZOsRy7MUZatuyZWA7uM3kwzi/V0IIXBTqrf8Z4FmZHFIt/HybiZ
         sbbJEqg+zqaWndIpRGziGwRAdnvYp2UskSeh4js0iHCY3oRw+McgFfjI0y7oLnQ5gzU+wULcIwUrBF
         R1R+aeb9KCgPKAuaXafOc0IO4JfNWyvnuuBhLD0J0hshqdj5Vvu+c4ldj/WYrartBW4EK2ktP2/lhf
         bp7IzcQFvT5d79Ly00On30yNXDukjQ+qvpzZLJdP2QU4xD5mCpGPPhj9JCV78AQSNl0UQedmdnBIp0
         WYJ6GjaRnQ7Fz9qCJEPWPwQ3KqH2t6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=yhlqzaoSJHj1oBhyHOJO58FgrwVTmfOzCSyUIFeQhEY=;
        b=y6kAh7BLK3FDXVvFJRPS8aaGvGwNkidIQo6yrUNTCXy1VTEvdvSmyPm1YcWkjEAF+PS7eF5bA8xDF
         FKUq6KgBA==
X-HalOne-ID: 8dec9b7e-2d75-11ee-9837-c5367ef0e45e
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay1 (Halon) with ESMTPSA
        id 8dec9b7e-2d75-11ee-9837-c5367ef0e45e;
        Fri, 28 Jul 2023 18:35:43 +0000 (UTC)
Date:   Fri, 28 Jul 2023 20:35:41 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/47] fbdev: Use I/O helpers
Message-ID: <20230728183541.GA1144760@ravnborg.org>
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
> 
> There are no functional changes. The helpers set the defaults that
> the drivers already use.

I have browsed all patches - they all looks good.
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

