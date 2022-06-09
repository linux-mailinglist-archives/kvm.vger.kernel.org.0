Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7959F5452E0
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiFIRYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 13:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245457AbiFIRYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 13:24:38 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 10:24:37 PDT
Received: from mailrelay1-1.pub.mailoutpod1-cph3.one.com (mailrelay1-1.pub.mailoutpod1-cph3.one.com [46.30.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7927B25
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 10:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=wNOUiBw/rJTSYauDyEhMfXMRlRrqLZQh50hYSmQWq+w=;
        b=h03dH+2IzhirOaSl9zx/tKAOAkC/lbsNkbuqFgMq3C5lLkr/gxxqZwLR44Erz+gNZy4kbJLuDmGew
         W+cPbunM+Y5Sfl0oXhDpHQJBjdkt0Qp6fUpCR5CX7kaCESRdub5RSh48rU2dQ4F6LMxzln4q+jl3Fn
         /LsLQ372w6ohuZ65PCsAZF7Uvk3rDEVE/7poQn+NNkm46FhZ9WGm8J1KlnEBep58BVc9sEX/j7xgcI
         INDaYdJeY9Qs+PGcAXmA5rq5W3ZAkBVaZ/F94UmjlaVId1Nd0bXyysacJFGOKGy/n6cKjtxRjxs2G1
         DsBVtN9IGIldkT3Y1RmvdQITFTKLZfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=wNOUiBw/rJTSYauDyEhMfXMRlRrqLZQh50hYSmQWq+w=;
        b=fo2mWotsx0uFkMRqN2XFQ1cnTjbBQHaQfHLt/uBrj6cCvJ1Wj8s/PWRcuZVP+MsTfNIKBoPkPAtpv
         PpRwURcAA==
X-HalOne-Cookie: 3ddab91af89094ee70c34864cd093f29a661beea
X-HalOne-ID: e1a5637b-e818-11ec-a6bf-d0431ea8a283
Received: from mailproxy1.cst.dirpod4-cph3.one.com (80-162-45-141-cable.dk.customer.tdc.net [80.162.45.141])
        by mailrelay1.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id e1a5637b-e818-11ec-a6bf-d0431ea8a283;
        Thu, 09 Jun 2022 17:23:31 +0000 (UTC)
Date:   Thu, 9 Jun 2022 19:23:28 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Jerry Lin <wahahab11@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Laszlo Ersek <lersek@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        kernel test robot <lkp@intel.com>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        linux-staging@lists.linux.dev,
        Daniel Vetter <daniel.vetter@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        Matthew Wilcox <willy@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        linux-fbdev@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Mark olpc_dcon BROKEN [Was: [PATCH v6 5/5] fbdev: Make
 registered_fb[] private to fbmem.c]
Message-ID: <YqIskEjUvJo4y4cb@ravnborg.org>
References: <20220607182338.344270-1-javierm@redhat.com>
 <20220607182338.344270-6-javierm@redhat.com>
 <3ebac271-1276-8132-6175-ca95a26cfcbb@suse.de>
 <69d8ad0e-efc6-f37d-9aa7-d06f8de16a6a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d8ad0e-efc6-f37d-9aa7-d06f8de16a6a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Javier.

On Thu, Jun 09, 2022 at 03:09:21PM +0200, Javier Martinez Canillas wrote:
> Hello Thomas,
> 
> On 6/9/22 13:49, Thomas Zimmermann wrote:
> > Hi Javier
> > 
> > Am 07.06.22 um 20:23 schrieb Javier Martinez Canillas:
> >> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>
> >> Well except when the olpc dcon fbdev driver is enabled, that thing
> >> digs around in there in rather unfixable ways.
> > 
> > There is fb_client_register() to set up a 'client' on top of an fbdev. 
> > The client would then get messages about modesetting, blanks, removals, 
> > etc. But you'd probably need an OLPC to convert dcon, and the mechanism 
> > itself is somewhat unloved these days.
> > 
> > Your patch complicates the fbdev code AFAICT. So I'd either drop it or, 
> > even better, build a nicer interface for dcon.
> > 
> > The dcon driver appears to look only at the first entry. Maybe add 
> > fb_info_get_by_index() and fb_info_put() and export those. They would be 
> > trivial wrappers somewhere in fbmem.c:
> > 
> > #if IS_ENABLED(CONFIG_FB_OLPC_DCON)
> > struct fb_info *fb_info_get_by_index(unsigned int index)
> > {
> > 	return get_fb_info(index);
> > }
> > EXPORT_SYMBOL()
> > void fb_info_put(struct fb_info *fb_info)
> > {
> > 	put_fb_info(fb_info);
> > }
> > EXPORT_SYMBOL()
> > #endif
> > 
> > In dcon itself, using the new interfaces will actually acquire a 
> > reference to keep the display alive. The code at [1] could be replaced. 
> > And a call to fb_info_put() needs to go into dcon_remove(). [2]
> > 
> 
> Thanks for your suggestions, that makes sense to me. I'll drop this
> patch from the set and post as a follow-up a different approach as
> you suggested.

To repeat myself from irc.
olpc_dcon is a staging driver and we should avoid inventing anything in
core code for to make staging drivers works.
Geert suggested EXPORT_SYMPBOL_NS_GPL() that could work and narrow it
down to olpc_dcon.
The better approach is to mark said driver BROKEN and then someone can
fix it it there is anyone who cares.
Last commit to olpc_dcon was in 2019: e40219d5e4b2177bfd4d885e7b64e3b236af40ac
and maybe Jerry Lin cares enough to fix it.

Added Jerry and Greg to the mail.

	Sam
