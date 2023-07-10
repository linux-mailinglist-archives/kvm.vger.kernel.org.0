Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E4474D896
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 16:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjGJOIx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 10 Jul 2023 10:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjGJOIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 10:08:49 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7248110D;
        Mon, 10 Jul 2023 07:08:25 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1qIrYc-0018bo-NE; Mon, 10 Jul 2023 16:08:06 +0200
Received: from p57bd95f7.dip0.t-ipconnect.de ([87.189.149.247] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1qIrYc-001ne7-Et; Mon, 10 Jul 2023 16:08:06 +0200
Message-ID: <268cf09b42a5ad6f1edb30b6d237f31174b85abb.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 08/17] arch/sh: Do not assign FBINFO_FLAG_DEFAULT to
 fb_videomode.flag
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Thomas Zimmermann <tzimmermann@suse.de>, deller@gmx.de,
        javierm@redhat.com
Cc:     linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Date:   Mon, 10 Jul 2023 16:08:05 +0200
In-Reply-To: <b9fe2f32-f4f6-6158-267a-da83b731b794@suse.de>
References: <20230710130113.14563-1-tzimmermann@suse.de>
         <20230710130113.14563-9-tzimmermann@suse.de>
         <0a47ed93fe90a77180533f8c2e42e402827e8f1c.camel@physik.fu-berlin.de>
         <54e3e070-52fb-9ccb-bc47-0f41690f6bfa@suse.de>
         <536cc8c679cc68829c8662176ff02a9052249a46.camel@physik.fu-berlin.de>
         <b9fe2f32-f4f6-6158-267a-da83b731b794@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.149.247
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

On Mon, 2023-07-10 at 16:04 +0200, Thomas Zimmermann wrote:
> > > I won't argue with that, but the flag itself is wrong.
> > > FBINFO_FLAG_DEFAULT is/was for struct fb_info.flags. You have struct
> > > fb_videomode.flag. The valid flags for this field are at [1]. If
> > > anything, the field could be initialized to FB_MODE_IS_UNKNOWN, which
> > > has the same value.
> > > 
> > > [1] https://elixir.bootlin.com/linux/latest/source/include/linux/fb.h#L681
> > 
> > FB_MODE_IS_UNKNOWN sounds very reasonable to me. Would you agree using that instead?
> 
> Sure, I'll update the patch accordingly.

Thanks! I'll ack the updated patch.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
