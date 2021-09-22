Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107B9415148
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 22:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhIVUTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 16:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbhIVUTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 16:19:35 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99249C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 13:18:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i25so17018538lfg.6
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 13:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IMc/6p6J74iyC6if8CkioVA61V3h/mOokcaAl6SGsRY=;
        b=oi6q/T4WA9rs7KMxHAAj+nVC5S4DAmA4KMJLYiZpzoqfDAVP56XkXzsn9/f8XpVZty
         iNuIqbLou1Mq2/KxudcAcbeSRFy3YqBwVXzhpInxCKq2iZMyXw3RXPfpPrs0eAQyJPvh
         CgWMYduQVCG6H85h4hjCXL8ntnyIJCUF+xnzCluVC/v7f1WxwOQXxDZ3yIXIPjtpEv94
         mJJQUv0SRQ05Uc9HckfWzafzMrjA51e5qvA7NHd5ACtKQJeW52irIPqLamzuxaaudDF0
         XhvCDh1NdJXQAjnK0XmKboDvMFM67hZUPZ1IqXP/0tCYYQk1Hp2c9vuEv8bh9Ayv4f6z
         OyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMc/6p6J74iyC6if8CkioVA61V3h/mOokcaAl6SGsRY=;
        b=fy8uhjaaNPRnrWrPMt89I1Ft4sMQi8b0fRDwJQf5CAfCdnAyZMLfLKZExYM/JBY6wU
         4HqLqhpekUaN4ld/RH5nPEBWylB2pPLSKtNZJ1NgnsBFn+eWuEeu7oJaaVs+m8zRPeoi
         j/JAuYqYbyb8RgeD5LJkwgCtaoxmG2NrwhkGyZ0Fei7UsxeLAKBbIYw6pv8mTQQ0z8Z0
         W+0bzldraBFmRGWC1wOcQfOM99PcmmZyD8bioX6MuKJdLEgayrTi2FRytidpRzAAMPLF
         CgmFPSpVNWBEoyjOqzYsiNoTHhxU6wgxzv5tdqCgH383yShoWgsk5mdIXAZGj5hU1yyr
         1usw==
X-Gm-Message-State: AOAM5305RK59dz2YmBaU3jrSWTRJixy/dRZQX2imrotHGoUfTO/9EAow
        G81ZVmYHOgVmUVA0gnj+B9I4WdBT/cEaaeNaGHw=
X-Google-Smtp-Source: ABdhPJx4JiQJf220SPmZoajzUi9x3IwBoTp/Lui8LdLBk84q8m4hoJdSgxE/jL8CRXnjGm0TlSCQin3Z26MRAf5bFEI=
X-Received: by 2002:a05:6512:3196:: with SMTP id i22mr768536lfe.416.1632341883025;
 Wed, 22 Sep 2021 13:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-3-zixuanwang@google.com> <20210921164334.zo6bbi77hbh2vdjz@gator.home>
In-Reply-To: <20210921164334.zo6bbi77hbh2vdjz@gator.home>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Wed, 22 Sep 2021 13:17:28 -0700
Message-ID: <CAEDJ5ZQZeXdP2KQB86kQ9JrDHkp5+auvwfByXpOb3p+SL48PjQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 02/17] x86 UEFI: Implement UEFI function calls
To:     Andrew Jones <drjones@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 9:44 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:07AM +0000, Zixuan Wang wrote:
> > From: Varad Gautam <varad.gautam@suse.com>
> >
> > This commit implements helper functions that call UEFI services and
> > assist the boot up process.
> >
> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> > ---
> >  lib/efi.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> >  create mode 100644 lib/efi.c
> >
> > diff --git a/lib/efi.c b/lib/efi.c
> > new file mode 100644
> > index 0000000..9711354
> > --- /dev/null
> > +++ b/lib/efi.c
> > @@ -0,0 +1,58 @@
> > +#include <linux/uefi.h>
>
> Please add at least an SPDX header.

Got it, I will add one in the next version.

> > +     status = efi_bs_call(get_memory_map, &map_size,
> > +                          NULL, &key, &desc_size, NULL);
> > +     if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
> > +             goto out;
> > +
> > +     /* Pad map_size with additional descriptors so we don't need to
> > +      * retry. */
>
> nit: please use Linux comment style

Got it! I will update the comment style in the next version

> > +     return 0;
> > +}
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> Otherwise
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thank you!

Best regards,
Zixuan
