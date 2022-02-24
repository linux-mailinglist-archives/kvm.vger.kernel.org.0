Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261014C3630
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiBXTwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiBXTwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:52:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD0190B5F;
        Thu, 24 Feb 2022 11:51:48 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x5so4372140edd.11;
        Thu, 24 Feb 2022 11:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9qg7if8ql+3plBSwkT6TgAtzWlmuEyfLLgzRTJi8YQ=;
        b=f2lf04BHLZAj80uYzAAwXonUGiiGREIqyP4yynLUoM3sXW+i37nMqEIqrBoPHuE691
         ZzpzZhf0LjTHo3+rLKFbwhKyDZn7W1jiXSm6PtkPQvzTCg3b2HrYJDAd35saHIhjNGjV
         LsATq3qaKwkD6KhpjxHNaEFsLHJx7ON7c4LiNZQy5tQ/Yio1lD9Jgy4dcCjAufE8jLuo
         O6Vzl2HZ/5zKI6YEG3UqQc9xBN4Mvm5i//zTkz4ao5uKBWTXyKPXCjGECRjSzpGoe5oB
         n9fgwYMZ4MrB6v+3gQ9q4Lxox2EtzHfZODAkXLW/3wuR3nreLSk4Tfkb1aUTplGP+MwJ
         UG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9qg7if8ql+3plBSwkT6TgAtzWlmuEyfLLgzRTJi8YQ=;
        b=2etRFR7umilLLYidzNaGTVe1n5SHb3xGn942y8C8Ufv762N+evRmsGhli0GUWyvDvE
         ROunreCKrp0/POETna8geivHmbGfvvHf6oXqlJpeb88z79qLHRsXZKSQ0hv1/ltWGrqr
         bcYWX9W//x2uRrx0GuIRQ45/nrcYOfEhiJ/LjSrD3/9sww4ws4lJd/wtGsDVv7ai9b6k
         yn3DsiAhD6dsZwe5Lo9MyFCWr6Ps6TkorqZGIDzpBuDAmFWiB3AzxBAD8c2Dkcl6Qe2w
         y7gKWc3MjAHHh3XWCbQYeKZXeGj5YJ9EHi17Xo7yXQAJEMhYD75AZHnYcGC92Nao6B/v
         tDEg==
X-Gm-Message-State: AOAM532QWSVRDypSlLKJ4lZjA1crssjp8ndH230M5AFrM02S2IpKS1qv
        MN3ooWJjsH64IdXZ16jvvbTtKjrMvqkbd29jkOQ=
X-Google-Smtp-Source: ABdhPJx/0TMTSf0DpZHNqLvOOmdnCzSskcMYgchY9e+IODSTxH06C1j4b+dTuM9o0XmXqfojjvjq3gr8/5LBTBiaq8E=
X-Received: by 2002:a05:6402:198:b0:410:83e3:21d7 with SMTP id
 r24-20020a056402019800b0041083e321d7mr3945297edv.159.1645732306568; Thu, 24
 Feb 2022 11:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com> <20220224123620.57fd6c8b@p-imbrenda>
In-Reply-To: <20220224123620.57fd6c8b@p-imbrenda>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 24 Feb 2022 21:51:10 +0200
Message-ID: <CAHp75Vfm-zmzoO0AZTv-3eBjXf0FzHh7tbHRn3DoO7EjukFVig@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 2:51 PM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>
> On Wed, 23 Feb 2022 18:44:20 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>
> > While in this particular case it would not be a (critical) issue,
> > the pattern itself is bad and error prone in case somebody blindly
> > copies to their code.
> >
> > Don't cast parameter to unsigned long pointer in the bit operations.
> > Instead copy to a local variable on stack of a proper type and use.

...

> > +             struct { /* as a 256-bit bitmap */
> > +                     DECLARE_BITMAP(b, 256);
> > +             } bitmap;
> > +             struct { /* as a set of 64-bit words */
> >                       u64 word[4];
> >               } u64;

> > -     set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
> > +     set_bit_inv(IPM_BIT_OFFSET + gisc, gisa->bitmap.b);
>
> wouldn't it be enough to pass gisa->u64.word here?
> then no cast would be necessary

No, it will have the same hidden bugs. As I stated in the commit
message, the pattern is quite bad even if in particular code it would
work.

Thanks, Michael, for pointing out other places. They all need to be fixed.

-- 
With Best Regards,
Andy Shevchenko
