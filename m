Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D0F636782
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiKWRpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 12:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiKWRp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 12:45:28 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8488CF24
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:45:26 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id a7so1408252ljq.12
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 09:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KErMMccYd6jPvKTmqg8bFwxAfMLrEXW806w61xqDHSc=;
        b=RWVJZZ85CRLUhESqyZwTpfBmJZMDopBado1fjzLl0cwMUHYXjhR3Z6Zey0jfp77vWd
         LQdVrUQ8D16dVrt5BzLeMAPDc48yN/QGNlmqwLmySS855V7a/dZuggV0LJZXrnoq5jSE
         6xyxGoED7SmW9S9mdD+afNQt0OVcsSLjb+kVL3RsZb3m/bLcQPwVYnUYEzk0xBF/m0zO
         stciwlBa/fVG+2VrAHpfDmTPHMtWDSzxM6jUvE1D/jZaJWSXskX5iU+41TpctNlJQ9Pe
         cUwj1dZ8UZ9HBcEQY7Rkg1yMUFfplzAn7URTDQhNo0xIOjLAD91IEeymXDbgJ9Z+Ttrr
         LY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KErMMccYd6jPvKTmqg8bFwxAfMLrEXW806w61xqDHSc=;
        b=SoKoqehOGIKz0dsqq0wJ1c3RFuJLhQ6+5Jh27suNFLkmBEWQUK3EUfXirOPwTjxlVo
         ToVuxhbYUHweks2QOjD5JGslaQTRvsbupmHl9b2CC5EKXobfp8A8vBlWkTWtwm7l0Dgc
         Zq4IRrkoMigrWgzmWAFIkOzqI/uPIvFKEywGnoKIZAOOzmCy4Kw+FkPxTO2nbtEkw+Z9
         8yBn8YD5JsC29nOrnKAx4qvd7beQqzTpXUxr9G1MP5hi2+tV0Aw/RJyFPK873JZzCzNs
         m3j60o/7b2kcZIrJeRInDFT5igPaZNrtfFWhq1I+s2Ilo1zBaYRlKToE96iN6QSS/lNl
         giBA==
X-Gm-Message-State: ANoB5pnqzW3QLhPmUg/EX+jZHSlRHtrjAvvKP1/z5lqbrOs4Olipn/Nh
        k9uyBwz7NlHnDG88eA++SFu1VwsO8/StpdC/q6bfpw==
X-Google-Smtp-Source: AA0mqf5iXVWX2bwVrReDgDoOu533hycA5a7wqzgQ45ML+wWl+qML3769oSJyS8ZVNwVXHuYpN2jXiGXSGvIW/68zYxY=
X-Received: by 2002:a2e:a544:0:b0:278:f5b8:82c8 with SMTP id
 e4-20020a2ea544000000b00278f5b882c8mr5820670ljn.228.1669225524334; Wed, 23
 Nov 2022 09:45:24 -0800 (PST)
MIME-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com> <20221115111549.2784927-4-tabba@google.com>
 <Y35M4W46JjeU88e/@monolith.localdoman>
In-Reply-To: <Y35M4W46JjeU88e/@monolith.localdoman>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 23 Nov 2022 17:44:47 +0000
Message-ID: <CA+EHjTzr87z_kQQGfXS0EpHqTLdTD4JU_Y9Z9=MJ2wWuLGPs4Q@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 03/17] Rename parameter in mmap_anon_or_hugetlbfs()
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Nov 23, 2022 at 4:40 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Tue, Nov 15, 2022 at 11:15:35AM +0000, Fuad Tabba wrote:
> > For consistency with other similar functions in the same file and
> > for brevity.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/kvm/util.h | 2 +-
> >  util/util.c        | 6 +++---
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index b0c3684..61a205b 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -140,6 +140,6 @@ static inline int pow2_size(unsigned long x)
> >  }
> >
> >  struct kvm;
> > -void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> > +void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
> >
> >  #endif /* KVM__UTIL_H */
> > diff --git a/util/util.c b/util/util.c
> > index 093bd3b..22b64b6 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -118,14 +118,14 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
> >  }
> >
> >  /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
> > -void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
> > +void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
>
> All the functions that deal with hugetlbfs have "hugetlbfs" in the name,
> and the kvm_config field is called hugetlbfs_path. Wouldn't it make more
> sense to rename the htlbfs_path parameter to hugetlbs_path instead of the
> other way around?

I was going for brevity, but changing it the other way around is more
consistent, as you said.

I'll do that when I respin this.

Cheers,
/fuad

> Thanks,
> Alex
>
> >  {
> > -     if (hugetlbfs_path)
> > +     if (htlbfs_path)
> >               /*
> >                * We don't /need/ to map guest RAM from hugetlbfs, but we do so
> >                * if the user specifies a hugetlbfs path.
> >                */
> > -             return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
> > +             return mmap_hugetlbfs(kvm, htlbfs_path, size);
> >       else {
> >               kvm->ram_pagesize = getpagesize();
> >               return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
> > --
> > 2.38.1.431.g37b22c650d-goog
> >
