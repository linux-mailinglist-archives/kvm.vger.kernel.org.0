Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F08842AFFD
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhJLXMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 19:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLXMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 19:12:18 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9D9C061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 16:10:15 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s64so1919244yba.11
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TrP4EPdUdqneFbp2i8NjxRKk6eN5o3i+doXozi/qnn4=;
        b=IUA75Ft46grOBVc5XwFROQyNhJvWiEYizm7+hxHBSNYZZjZkZDaoeMPQYbVM8vgOpF
         5IUcqXGbakByWNarV2GXZEqwXYuLV5lhqmVAiTuMY8qsrZZDzz/MAe3oOlHi/z9LNt2N
         sOt7xtjnv2QC76coXQV3mqaOt2UCgRZy+xUsE4G5+t9jcmWaoaOXHUBbl6qXu8Cb3Tam
         g+Wincoo2Ejl8hQ39k6nypj8D7ddK9Pq/knBwQrSYh250/YN6q2A4KcrLRPWtU4p92ON
         eiJJqxh8r7kbW9STmriVRFPpgnpHKH39xohXZIyQmBxWVczwLOydODcoPpBBG9lgVncp
         71Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TrP4EPdUdqneFbp2i8NjxRKk6eN5o3i+doXozi/qnn4=;
        b=l7p2vTQ5T8Fm+mC9D9k5NwWyCP7GKtEsOhJo+sh1MOwdvbrOlz8FI50lE0J8NgJVFI
         k6jspJNbYbxUCZrxBDLaBrEYAbz40Iox9xdIjNKBSNOvPjJVw5jkd39wUXsqrg5fjvCC
         IudmskX/l4XDHQkRWbvOrSTvPv6hNXicb3O5AaFepEaj9WEIdZf47NjULDDhACyWdlw4
         EuGJsuf5R1I635afcBWt/CIuDd7g6r/VOJrmLffUP44nqM5su/Ejfr7YH1p/3Tyw6slF
         TSFqLp16a/E6uInFCAO92P5NFWpLQhk/7hJ1snWUGhX+3g10xB8rnL/BVW/euoFkrr8U
         i/ag==
X-Gm-Message-State: AOAM533Y6KqwQ+3Q6kUuPS410osstUZhwWRiISNxb4QQ+HIK/uljsgbC
        RjTInETpA00oEqUqvxD3RBqXq8rE6yQyd39sdrLKVr9Jzt5dB7WKZljCkly1
X-Google-Smtp-Source: ABdhPJzhcFCyTJPdfqL8Vp3eJFUHQKR44ZnZkqMpYxMXMUekvyNCzOnrStdvcahpyewNwY5/YevbvNZG3aWCw8EmxuI=
X-Received: by 2002:a25:6115:: with SMTP id v21mr31717201ybb.462.1634080215262;
 Tue, 12 Oct 2021 16:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211011154459.21f9b477.alex.williamson@redhat.com>
 <20211012124855.52463-1-colin.xu@gmail.com> <20211012111248.2314ad0b.alex.williamson@redhat.com>
In-Reply-To: <20211012111248.2314ad0b.alex.williamson@redhat.com>
From:   Colin Xu <colin.xu@gmail.com>
Date:   Wed, 13 Oct 2021 07:10:04 +0800
Message-ID: <CAB4daBQzbR5x5QYk93Ba_u5sf5LQyd1S0awheHww1OSchFz4dw@mail.gmail.com>
Subject: Re: [PATCH v8] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, colin.xu@intel.com, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com, Colin Xu <colin.xu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 1:12 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 12 Oct 2021 20:48:55 +0800
> Colin Xu <colin.xu@gmail.com> wrote:
>
> > From: Colin Xu <colin.xu@intel.com>
> >
> > Due to historical reason, some legacy shipped system doesn't follow
> > OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
> > VBT is not contiguous after OpRegion in physical address, but any
> > location pointed by RVDA via absolute address. Also although current
> > OpRegion 2.1+ systems appears that the extended VBT follows OpRegion,
> > RVDA is the relative address to OpRegion head, the extended VBT location
> > may change to non-contiguous to OpRegion. In both cases, it's impossible
> > to map a contiguous range to hold both OpRegion and the extended VBT and
> > expose via one vfio region.
> >
> > The only difference between OpRegion 2.0 and 2.1 is where extended
> > VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
> > while for 2.1, RVDA is the relative address of extended VBT to OpRegion
> > baes, and there is no other difference between OpRegion 2.0 and 2.1.
> > To support the non-contiguous region case as described, the updated read
> > op will patch OpRegion version and RVDA on-the-fly accordingly. So that
> > from vfio igd OpRegion view, only 2.1+ with contiguous extended VBT
> > after OpRegion is exposed, regardless the underneath host OpRegion is
> > 2.0 or 2.1+. The mechanism makes it possible to support legacy OpRegion
> > 2.0 extended VBT systems with on the market, and support OpRegion 2.1+
> > where the extended VBT isn't contiguous after OpRegion.
> >
> > V2:
> > Validate RVDA for 2.1+ before increasing total size. (Alex)
> >
> > V3: (Alex)
> > Split read and write ops.
> > On-the-fly modify OpRegion version and RVDA.
> > Fix sparse error on assign value to casted pointer.
> >
> > V4: (Alex)
> > No need support write op.
> > Direct copy to user buffer with several shift instead of shadow.
> > Copy helper to copy to user buffer and shift offset.
> >
> > V5: (Alex)
> > Simplify copy help to only cover common shift case.
> > Don't cache patched version and rvda. Patch on copy if necessary.
> >
> > V6:
> > Fix comment typo and max line width.
> >
> > V7:
> > Keep bytes to copy/remain as size_t.
> > Proper shift byte address on copy source.
> > Rebase to linux-next.
> >
> > V8:
> > Replace min() with min_t() to avoid type cast.
> > Wrap long lines.
> >
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Cc: Hang Yuan <hang.yuan@linux.intel.com>
> > Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
> > Cc: Fred Gao <fred.gao@intel.com>
> > Signed-off-by: Colin Xu <colin.xu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_igd.c | 234 ++++++++++++++++++++++++--------
> >  1 file changed, 175 insertions(+), 59 deletions(-)
>
> Looks good, applied to vfio next branch for v5.16.  Thanks,
>
> Alex
>
Thanks Alex for the help plugging the hole due to the special OpRegion 2.0 case.

Colin
