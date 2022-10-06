Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F374F5F713B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiJFWjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 18:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiJFWjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 18:39:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FE110FFC
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 15:39:42 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d6so4793212lfs.10
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 15:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wtxdX7+EsTds+QSh8AapxyTLq6fHl1RfgKn4dhs60iE=;
        b=q4m/luBSa0xsK2viOJZgOv/RQkXe4CCK3vsjY70XLHSL5tKcHx4HE5jmx+UpZymmz9
         bBBfevTdxUDuLJMNiZ1akGNRWFRcMnHGf582RnfMi9FTkMJRXQa+NdCaQA4fPLZJv2yT
         xBYsk6XG0OgTbvED+LHBn3qSSjZUw2L5P4Ffv9y5Kfjq51FT62RGMclqc5FOPir76UVq
         xMjiNO6/ao0V0BoNZnYqd8IYo5pFHt+6uY+GwVe1pAYQKTIh9PK9CxSJjjSDd7Z1heTj
         2MJRF5Ul7tGZqmgzbdmPWJpfD6inNqC3py+fzPU7/Psf75AgN3h3DQRe1SrwblE3ysZN
         GFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wtxdX7+EsTds+QSh8AapxyTLq6fHl1RfgKn4dhs60iE=;
        b=qhMjM3AkbfF4xtzWPoN2jmL1poIG89EVWmOEI94JIH8jCAV82vx0UyI84NaZZe38/d
         /+mBZrXH7niDsNwXdWdMbktSMktNQr1xTSukgLdMq8Zqb0Ywe966CzHS90KZhW478BN/
         nmS76/UbUDOfkfKR+mrnMggxc0/IdLP8X1M7zeUD7NUH8iNPDuDm84wZ9yOSYUw+WgC/
         iOgvrzlvWtCKtxu9JyO4KvqBVj/lD600MxHjOY8NiKm+iQHCbLYOi+4d05nT5Mi33SSa
         URuEMfcpD81wv3zggbat63WTz8tds/jxv1PQcnQoxCU0iudUkIr4GkZYpDHmM2qLTzNB
         7b8A==
X-Gm-Message-State: ACrzQf0EUmrXez3KQW+DNA1Fq5CfIU5o+7CsVC/jkyhBfKaqSx5T7PXW
        wtNmbwl3+xBIKMPTGt8y1JyLfac91RuIUoHpE9GV7Q==
X-Google-Smtp-Source: AMsMyM6RXvwXzUe4BttZriv3o7eD0xJp0abFXq/ZkBDrIVyTpJvbJ3w7qqyOwRU+SoHjf+PmfzJL+7Xel3qgzM0ilXE=
X-Received: by 2002:a05:6512:139c:b0:48f:da64:d050 with SMTP id
 p28-20020a056512139c00b0048fda64d050mr721274lfa.268.1665095979935; Thu, 06
 Oct 2022 15:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com> <20221006171133.372359-4-vipinsh@google.com>
 <Yz8zYXvhp9WGH4Uz@google.com>
In-Reply-To: <Yz8zYXvhp9WGH4Uz@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 6 Oct 2022 15:39:03 -0700
Message-ID: <CAHVum0cD5R9ej09VNvkkqcQsz7PGrxnMqi1E4kqLv+1d63Rg6A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Oct 6, 2022 at 12:58 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 06, 2022, Vipin Sharma wrote:
> > +int atoi_paranoid(const char *num_str)
> > +{
> > +     int num;
> > +     char *end_ptr;
>
> Reverse fir-tree when it's convention:
>
>         char *end_ptr;
>

Okay, I will do:
        char *end_ptr;
        int num;

I was not aware of reverse christmas tree convention in KVM subsystem.

> > +
> > +     errno = 0;
> > +     num = (int)strtol(num_str, &end_ptr, 10);
> > +     TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);
> > +     TEST_ASSERT(num_str != end_ptr,
> > +                 "strtol(\"%s\") didn't find any valid number.\n", num_str);
>
> s/number/integer ?  And should that be "a valid intenger", not "any valid integer"?
> "any" implies that this helper will be happy if there's at least one integer,
> whereas I believe the intent is to find _exactly_ one integer.
>

I will change it to "a valid integer".

> > +     TEST_ASSERT(
> > +             *end_ptr == '\0',
>
> Weird and unnecessary wrap+indentation.

Clang-format script did it. I think it is because the script is
considering 80 characters limit and the next line "strtol..."
overshoots that 80 character limit.
I will manually change it to:

       TEST_ASSERT(*end_ptr == '\0',

and align "strtol..." to * above.

>
> > +             "strtol(\"%s\") failed to parse trailing characters \"%s\".\n",
> > +             num_str, end_ptr);
> > +
> > +     return num;
> > +}
> > diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > index 9a6e4f3ad6b5..1595b73dc09a 100644
> > --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> > +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > @@ -193,15 +193,15 @@ int main(int argc, char *argv[])
> >       while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
> >               switch (opt) {
> >               case 'c':
> > -                     nr_vcpus = atoi(optarg);
> > +                     nr_vcpus = atoi_paranoid(optarg);
> >                       TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
>
> Many users require a positive and or non-negative value, maybe add wrappers in
> a follow-up?
>
>                         nr_vcpus = atoi_positive(optarg);
>
> and later down
>
>                         targs->tfirst = atoi_non_negative(optarg);
>
> We'll lose custom error messages, but I don't think that's a big deal.  Definitely
> not required, just a thought.
>

I think atoi_positive() and atoi_non_negative() will be useful
additions. I will add one more patch in v5, which replaces
atoi_paranoid() and update/remove TEST_ASSERT() condition from all
test cases.

> > diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> > index 0d55f508d595..c366949c8362 100644
> > --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> > +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> > @@ -407,7 +407,7 @@ int main(int argc, char *argv[])
> >
> >  #ifdef __x86_64__
> >       if (argc > 1)
> > -             loops = atoi(argv[1]);
> > +             loops = atoi_paranoid(argv[1]);
>
> This is a good candidate for atoi_positive().
>
> >       else
> >               loops = 10;
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > index 59ffe7fd354f..354b6902849c 100644
> > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -241,10 +241,10 @@ int main(int argc, char **argv)
> >       while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
> >               switch (opt) {
> >               case 'p':
> > -                     reclaim_period_ms = atoi(optarg);
> > +                     reclaim_period_ms = atoi_paranoid(optarg);
> >                       break;
> >               case 't':
> > -                     token = atoi(optarg);
> > +                     token = atoi_paranoid(optarg);
> >                       break;
> >               case 'r':
> >                       reboot_permissions = true;
> > --
> > 2.38.0.rc1.362.ged0d419d3c-goog
> >
