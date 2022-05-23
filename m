Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBF553129D
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbiEWPGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 11:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiEWPGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 11:06:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A2C36B46
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:06:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h14so21814039wrc.6
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jT91v2sdujiUrOeVFYLyjGU8hHIqKFVeJ1Zs0tfCEQo=;
        b=U6BtzPGS4NtI0gXMXPikHkjVn0kaZYHXXvdRpOqIjC7VGMXRwwX3mCiDwGqU7iH4Yx
         X1xaf1upK84Ri6Kio7rm+XrzhQ9pZEuPCOy8Qz4F0ne4+iMpBhW7o6f1M0ipanF1uczH
         /ty/Ci2Bgr5HbId4F7Cc08CrPoHKXEFDHC1Ry36Bx0naLOFh4tvXhVxPG01KQsi2boa/
         rcT4aTr4O1wKWHXDm+msmPGLXN1FXJ32+hRC3Gf6oqRl7maOE5DLGOThYCeyz4Mgb+85
         RwxhnYFhvLew6AeisTtErC6EenH5eIaJMIxV1jt1ZZhBh1WwaTxvBoJkTdXfjPhCNmb7
         YqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jT91v2sdujiUrOeVFYLyjGU8hHIqKFVeJ1Zs0tfCEQo=;
        b=U1GeUkIaia2SN6hQIstLY0BGR2fIB8Xm2ChSlA6q9yA5ijhxZa/2uKINv+vTHvt+cN
         ilL7GgNUzxCPrMJ268+YXuxUR7fAXxliYDOVPspN/CZduqp3y2Pmg6G3JxuxrfWa+GFT
         N7Xrbq1rONbCgSEqVRr7DUvnYWF6D5/kMzDvfq4BJPkmYG/eD7h23L4kEyrMfSDZKCyC
         EGBuZTPJDGSGa6ya/JsEDya8C0vA7lEUznxWQ4QfOtk5XO6IqielG0K0W7xAcKuFQioX
         L2equkxx3QTkNdOS3yrSB9S1nWqqyAu9PvWn3YDmRv2wTAHwhSqUVZnbNy2nN06OAMU4
         2sKg==
X-Gm-Message-State: AOAM5300LhpNnG0cFWGwTAptBf6T+DejfvYWBPdja2FR/FLChC+2682B
        hKiX+Cl6oWkDoEUQ/YdJNRC0BA==
X-Google-Smtp-Source: ABdhPJzFDlMtZlK9rm+u1HxkOgBSA7iN+UF6dTpLRLVW4VdMw0nnYn9icyGDn7eoEhuYl3bi0JTpNA==
X-Received: by 2002:a5d:6da3:0:b0:20e:67a2:6779 with SMTP id u3-20020a5d6da3000000b0020e67a26779mr18524548wrs.418.1653318388082;
        Mon, 23 May 2022 08:06:28 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s1-20020adf8901000000b0020c5253d91asm10456623wrs.102.2022.05.23.08.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 08:06:27 -0700 (PDT)
Date:   Mon, 23 May 2022 15:06:23 +0000
From:   Keir Fraser <keirf@google.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        catalin.marinas@arm.com, kernel-team@android.com,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
Message-ID: <Youi7+T1+YG/6ed9@google.com>
References: <20220520143706.550169-1-keirf@google.com>
 <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
 <20220523154249.2fa6db09@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523154249.2fa6db09@donnerap.cambridge.arm.com>
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

On Mon, May 23, 2022 at 03:42:49PM +0100, Andre Przywara wrote:
> On Fri, 20 May 2022 21:51:07 +0100
> Will Deacon <will@kernel.org> wrote:
> 
> Hi,
> 
> > On Fri, 20 May 2022 14:37:04 +0000, Keir Fraser wrote:
> > > While playing with kvmtool's virtio_balloon device I found a couple of
> > > niggling issues with the printing of memory stats. Please consider
> > > these fairly trivial fixes.
> 
> Unfortunately patch 2/2 breaks compilation on userland with older kernel
> headers, like Ubuntu 18.04:
> ...
>   CC       builtin-stat.o
> builtin-stat.c: In function 'do_memstat':
> builtin-stat.c:86:8: error: 'VIRTIO_BALLOON_S_HTLB_PGALLOC' undeclared (first use in this function); did you mean 'VIRTIO_BALLOON_S_AVAIL'?
>    case VIRTIO_BALLOON_S_HTLB_PGALLOC:
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         VIRTIO_BALLOON_S_AVAIL
> (repeated for VIRTIO_BALLOON_S_HTLB_PGFAIL and VIRTIO_BALLOON_S_CACHES).
> 
> I don't quite remember what we did here in the past in those cases,
> conditionally redefine the symbols in a local header, or protect the
> new code with an #ifdef?

For what it's worth, my opinion is that the sensible options are to:
1. Build against the latest stable, or a specified version of, kernel
headers; or 2. Protect with ifdef'ery until new definitions are
considered "common enough".

Supporting older headers by grafting or even modifying required newer
definitions on top seems a horrid middle ground, albeit I can
appreciate the pragmatism of it.

 Regards,
 Keir


> I would lean towards the former (and hacking this in works), but then we
> would need to redefine VIRTIO_BALLOON_S_NR, to encompass the new symbols,
> which sounds fragile.
> 
> Happy to send a patch if we agree on an approach.
> 
> Cheers,
> Andre
> 
> > > 
> > > Keir Fraser (2):
> > >   virtio/balloon: Fix a crash when collecting stats
> > >   stat: Add descriptions for new virtio_balloon stat types
> > > 
> > > [...]  
> > 
> > Applied to kvmtool (master), thanks!
> > 
> > [1/2] virtio/balloon: Fix a crash when collecting stats
> >       https://git.kernel.org/will/kvmtool/c/3a13530ae99a
> > [2/2] stat: Add descriptions for new virtio_balloon stat types
> >       https://git.kernel.org/will/kvmtool/c/bc77bf49df6e
> > 
> > Cheers,
> 
