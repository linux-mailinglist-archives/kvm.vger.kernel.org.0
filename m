Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A376531CBD
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbiEWQfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiEWQfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:35:37 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C03D692B6
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:35:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y24so1390297wmq.5
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YgKjBDJ4v49u45br4vZm9IxNR6lfoSJ/HnI3ryjpgYs=;
        b=V9zrI3Y5hSu6Xj1Vnw9FAfyXRAaAqP8VY+bEP+/Ty6GlcAbotfgWhY/JLkLW/5RLV/
         SU52mcyXeec0zBRHCR9EQDcQps69z99wNixIreC8UKkvKd6jblRfu2CT66m/VPGJ37TH
         yVxNwuem0tGJizmlVi4UFAOrW3J1ajMyi4OhonWydXYfO47MG1z1pNQcAZoEe9beANeq
         LFK9Alu9DhH3ct58tpiTpEkqgvequFtXT4iaoxyRjV/Fm2sFZCOAQdB0+OTVVToeSdO9
         FdICfkUF75t87QhDad0gR8g8hD+NoxYSAx7kQ+FSM0/GXXxskOx0LJD7ltQtVGeDowCg
         wfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YgKjBDJ4v49u45br4vZm9IxNR6lfoSJ/HnI3ryjpgYs=;
        b=FBWCn2Jrbt4UZoIp/Q7iHulKlLXtEPL1FwhWBAMSqgk6PfMAnCg/SaEjzFl8dk6cRc
         WgSX5RAFP5Vhio2JGHwA82gitIAC5AMZphl/cgsE9b3XiW2gcw8VAyYKigGNs+DjdJaN
         fsnDA4y6PVtiImS3MkavsNxJh16EQKpVzC8HAtiIXMjry8OQNdseNwliDK3XDr7VZreT
         gB96nm7dsI+jlXLzKjriaOSSoKbVRdLTMB8I45zviZkPvEymHRsd0xJHNt1weHoHtz/L
         sUgwkVpYdTy+QmecLQE7wILr9rwdIWC+7sEtbQ8Tnl96d9na/EvWYPFj2SOVo75lAE8E
         IWow==
X-Gm-Message-State: AOAM532M3v7i/DNdtEJHcXI+daXyVpwWBcXomwdgA0WmUMFHYOzdZrTR
        ceD3ZbkQKU6Wdkn6LughNDwSZQ==
X-Google-Smtp-Source: ABdhPJyGSCJ1FvSiziQ/yGZLwj8I6BYDgLnpsvFJS+iZxrRqcZ7ryh0rMnRBxmgAA3Xz39GpuWE/eQ==
X-Received: by 2002:a05:600c:3509:b0:394:84bf:96c0 with SMTP id h9-20020a05600c350900b0039484bf96c0mr20941443wmq.11.1653323734743;
        Mon, 23 May 2022 09:35:34 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id c13-20020adfc04d000000b0020fee88d0f2sm120419wrf.0.2022.05.23.09.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:35:34 -0700 (PDT)
Date:   Mon, 23 May 2022 16:35:30 +0000
From:   Keir Fraser <keirf@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        catalin.marinas@arm.com, kernel-team@android.com
Subject: Re: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
Message-ID: <You30lZiaDIlTAsF@google.com>
References: <20220520143706.550169-1-keirf@google.com>
 <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
 <20220523154249.2fa6db09@donnerap.cambridge.arm.com>
 <Youi7+T1+YG/6ed9@google.com>
 <20220523161323.0e7df3d5@donnerap.cambridge.arm.com>
 <YoutGZHrgweh6pgm@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoutGZHrgweh6pgm@monolith.localdoman>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 04:49:45PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Mon, May 23, 2022 at 04:13:23PM +0100, Andre Przywara wrote:
> > On Mon, 23 May 2022 15:06:23 +0000
> > Keir Fraser <keirf@google.com> wrote:
> > 
> > > On Mon, May 23, 2022 at 03:42:49PM +0100, Andre Przywara wrote:
> > > > On Fri, 20 May 2022 21:51:07 +0100
> > > > Will Deacon <will@kernel.org> wrote:
> > > > 
> > > > Hi,
> > > >   
> > > > > On Fri, 20 May 2022 14:37:04 +0000, Keir Fraser wrote:  
> > > > > > While playing with kvmtool's virtio_balloon device I found a couple of
> > > > > > niggling issues with the printing of memory stats. Please consider
> > > > > > these fairly trivial fixes.  
> > > > 
> > > > Unfortunately patch 2/2 breaks compilation on userland with older kernel
> > > > headers, like Ubuntu 18.04:
> > > > ...
> > > >   CC       builtin-stat.o
> > > > builtin-stat.c: In function 'do_memstat':
> > > > builtin-stat.c:86:8: error: 'VIRTIO_BALLOON_S_HTLB_PGALLOC' undeclared (first use in this function); did you mean 'VIRTIO_BALLOON_S_AVAIL'?
> > > >    case VIRTIO_BALLOON_S_HTLB_PGALLOC:
> > > >         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >         VIRTIO_BALLOON_S_AVAIL
> > > > (repeated for VIRTIO_BALLOON_S_HTLB_PGFAIL and VIRTIO_BALLOON_S_CACHES).
> > > > 
> > > > I don't quite remember what we did here in the past in those cases,
> > > > conditionally redefine the symbols in a local header, or protect the
> > > > new code with an #ifdef?  
> > > 
> > > For what it's worth, my opinion is that the sensible options are to:
> > > 1. Build against the latest stable, or a specified version of, kernel
> > > headers; or 2. Protect with ifdef'ery until new definitions are
> > > considered "common enough".
> > > 
> > > Supporting older headers by grafting or even modifying required newer
> > > definitions on top seems a horrid middle ground, albeit I can
> > > appreciate the pragmatism of it.
> > 
> > Fair enough, although I don't think option 1) is really viable for users,
> > as upgrading the distro provided kernel headers is often not an option for
> > the casual user. And even more versed users would probably shy away from
> > staining their /usr/include directory just for kvmtool.
> > 
> > Which just leaves option 2? If no one hollers, I will send a patch to that
> > regard.
> 
> How about copying the required headers to kvmtool, under include/linux?
> That would remove any dependency on a specific kernel or distro version.

Maintaining just the required headers sounds a bit of a pain. Getting
it wrong ends up copying too many headers (and there's nearly 200kLOC
of them) or a confusing split between copied and system-installed
headers.

How about requiring headers at include/linux and if the required
version tag isn't found there, download the kernel tree and "make
headers_install" with customised INSTALL_HDR_PATH? The cost is a
big(ish) download: time, bandwidth, disk space.

 -- Keir

> Thanks,
> Alex
> 
> > 
> > Cheers,
> > Andre
> > 
> > 
> > > 
> > >  Regards,
> > >  Keir
> > > 
> > > 
> > > > I would lean towards the former (and hacking this in works), but then we
> > > > would need to redefine VIRTIO_BALLOON_S_NR, to encompass the new symbols,
> > > > which sounds fragile.
> > > > 
> > > > Happy to send a patch if we agree on an approach.
> > > > 
> > > > Cheers,
> > > > Andre
> > > >   
> > > > > > 
> > > > > > Keir Fraser (2):
> > > > > >   virtio/balloon: Fix a crash when collecting stats
> > > > > >   stat: Add descriptions for new virtio_balloon stat types
> > > > > > 
> > > > > > [...]    
> > > > > 
> > > > > Applied to kvmtool (master), thanks!
> > > > > 
> > > > > [1/2] virtio/balloon: Fix a crash when collecting stats
> > > > >       https://git.kernel.org/will/kvmtool/c/3a13530ae99a
> > > > > [2/2] stat: Add descriptions for new virtio_balloon stat types
> > > > >       https://git.kernel.org/will/kvmtool/c/bc77bf49df6e
> > > > > 
> > > > > Cheers,  
> > > >   
> > 
