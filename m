Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96DC6151DF
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiKATCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKATCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:02:07 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B1B1D0CE
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 12:02:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso2748439wme.5
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 12:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mn4YfEQWKIJQD//Kju02cktaiRIU2F9W8PwX5XQiQMA=;
        b=Ev57ZBkdyzQC3QaXmi4kVM9gOVMhmYqzkuihkS1E4rktQybXKfIBIuTVv3PENOdYrm
         khvSeOtpsPLYeg3NlQzfJeuBNGzWAHUl69wjAwrmFS6RZ5wbbt+g/Ktufd31etI6zJq7
         ihUBF14WJnJpTBTj8zd/0hXHjhvbKcFfmRAtOT73SAHpxt1Kz4mbPXZJ24of481ndoIn
         2Ef6ZId1rWhq85jMlIVCMXYCPTEurt/fgGtUBfQgEOW1TF+Yb8zamJvT59TYYIoIY0U3
         CCx94Q6ow4WgSl5gY8n6PG4xZlR4Mm9J2mS6qDCV1aSbJVn04BeHX7AstCpa8fRcsXDP
         gYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mn4YfEQWKIJQD//Kju02cktaiRIU2F9W8PwX5XQiQMA=;
        b=TshKn+QGmsBORuUJ5RRpaG9G7p9U67VZlRLixLPXhW9iUiQjvezDFf89m6L9vmLv+a
         TOClngmFp4/vuyF9DR1uWYbMkdNhHP3HctrvcEBIIxzNvkBftIBhhkj2Kx4jtnMg/obV
         2DuFmtDKgCRVl/UMOk637FrfDPl199gWRuN7R3YGDBNDNw7dlHQ19hJjvoB0PwH4xeDZ
         VoUqZo62PEw/8BI+KL+nnz84qlHJBsWcCmXRlY2OISVh7e0CLKxCCJTct+E5IWX2fI9x
         CIqY3j47ACvKYGj+YYDz4a8npNgiVfExhLi9LCuk3Cn8uhCND+a/2OE5ro9QcxV10SIb
         bdUQ==
X-Gm-Message-State: ACrzQf1FiXKkY8pYPBscZ7gs8eNgg3X1wPQwyfiQr8FUvjhprOMejkq5
        PvKGpq0fq5rheUZrV3ykAnszz8KmqdN7HcG9uqJszFFgf9Q=
X-Google-Smtp-Source: AMsMyM7+GVnmCAKMhr+dkuNYvoI/t1UfX+4nYpV1XlZp0R47EfT29ksTiyis4vC+n+46TcYTFLStz1bZh1jEAkCzE9s=
X-Received: by 2002:a7b:cb17:0:b0:3cf:7801:c76f with SMTP id
 u23-20020a7bcb17000000b003cf7801c76fmr6011483wmj.1.1667329323165; Tue, 01 Nov
 2022 12:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221031173819.1035684-1-vipinsh@google.com> <20221031173819.1035684-5-vipinsh@google.com>
 <Y2AmgObslx57+uYt@google.com>
In-Reply-To: <Y2AmgObslx57+uYt@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 1 Nov 2022 12:01:26 -0700
Message-ID: <CAHVum0fhangxMp5ysYdyoKVY+CKWeBAadMFX1V8MgqryRGHQrw@mail.gmail.com>
Subject: Re: [PATCH v7 4/5] KVM: selftests: Add atoi_positive() and
 atoi_non_negative() for input validation
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Oct 31, 2022 at 12:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 31, 2022, Vipin Sharma wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index ec0f070a6f21..210e98a49a83 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -353,3 +353,19 @@ int atoi_paranoid(const char *num_str)
> >
> >       return num;
> >  }
> > +
> > +uint32_t atoi_positive(const char *num_str)
>
> I think it makes sense to inline atoi_positive() and atoi_non_negative() in
> test_util.h.  Depending on developer's setups, it might be one less layer to jump
> through to look at the implementation.
>

I am not sure if this makes life much easier for developers, as
"inline" can totally be ignored by the compiler. Also, not sure how
much qualitative improvement it will add in the developer's code
browsing journey. Anyways, I will add "inline" in the next version.

> > +{
> > +     int num = atoi_paranoid(num_str);
> > +
> > +     TEST_ASSERT(num > 0, "%s is not a positive integer.\n", num_str);
>
> Newlines aren't needed in asserts.  This applies to atoi_paranoid() in the previous
> patch as well (I initially missed them).
>

Okay, I will remove it from the previous patch also.

> > +     return num;
> > +}
> > +
> > +uint32_t atoi_non_negative(const char *num_str)
> > +{
> > +     int num = atoi_paranoid(num_str);
> > +
> > +     TEST_ASSERT(num >= 0, "%s is not a non-negative integer.\n", num_str);
> > +     return num;
> > +}
> > diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > index 1595b73dc09a..20015de3b91c 100644
> > --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> > +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > @@ -193,15 +193,14 @@ int main(int argc, char *argv[])
> >       while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
> >               switch (opt) {
> >               case 'c':
> > -                     nr_vcpus = atoi_paranoid(optarg);
> > -                     TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
> > +                     nr_vcpus = atoi_positive(optarg);
>
> I know I originally made the claim that the assert would provide enough context
> to offest lack of a specific message, but after actually playing around with this,
> past me was wrong.  E.g. this
>
>   Memory size must be greater than 0, got '-1'
>
> is much more helpful than
>
>   -1 is not a positive integer.
>
> E.g. something like this?
>
>   static inline uint32_t atoi_positive(const char *name, const char *num_str)
>   {
>         int num = atoi_paranoid(num_str);
>
>         TEST_ASSERT(num > 0, "%s must be greater than 0, got '%s'", name, num_str);
>         return num;
>   }
>
>   static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
>   {
>         int num = atoi_paranoid(num_str);
>
>         TEST_ASSERT(num >= 0, "%s must be non-negative, got '%s'", name, num_str);
>         return num;
>   }
>
> IMO, that also makes the code slightly easier to follow as it's super obvious
> what is being parsed.
>
>   p.wr_fract = atoi_positive("Write fraction", optarg);
>
>   p.iterations = atoi_positive("Number of iterations", optarg);
>
>   nr_vcpus = atoi_positive("Number of vCPUs", optarg);
>

I will make this change. It is indeed better.

> Last thought: my vote would be to ignore the 80 char soft limit when adding the
> "name" to these calls, in every case except nr_memslot_modifications the overrun
> is relatively minor and not worth wrapping.  See below for my thougts on that one.
>
> >                       break;
> >               case 'm':
> > -                     max_mem = atoi_paranoid(optarg) * size_1gb;
> > +                     max_mem = atoi_positive(optarg) * size_1gb;
> >                       TEST_ASSERT(max_mem > 0, "memory size must be >0");
>
> This assert can be dropped, max_mem is a uint64_t so wrapping to '0' is impossible.
>

I intentionally kept it, as it is also protecting against having
accidently making size_1gb to 0.

> >                       break;
> >               case 's':
> > -                     slot_size = atoi_paranoid(optarg) * size_1gb;
> > +                     slot_size = atoi_positive(optarg) * size_1gb;
>
> Same thing here.
>
> >                       TEST_ASSERT(slot_size > 0, "slot size must be >0");
> >                       break;
> >               case 'H':
> > diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > index 865276993ffb..7539ee7b6e95 100644
> > --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > @@ -175,7 +175,7 @@ int main(int argc, char *argv[])
> >                       p.partition_vcpu_memory_access = false;
> >                       break;
>
> memslot_modification_delay can be converted to atoi_non_negative(), it open codes
> strtoul(), but the "long" part is unnecessary because memslot_modification_delay
> is an "unsigned int", not an "unsigned long".
>
> >               case 'i':
> > -                     p.nr_memslot_modifications = atoi_paranoid(optarg);
> > +                     p.nr_memslot_modifications = atoi_positive(optarg);
>
> To avoid a ridiculously long line, my vote is to rename the test args.  The names
> are rather odd irrespective of line length.  E.g. in a prep patch do
>
>   s/memslot_modification_delay/delay
>   s/nr_memslot_modifications/nr_iterations
>

Okay, I will change this and any other places I find which can be shortened.

> which yields parsing of:
>
>         while ((opt = getopt(argc, argv, "hm:d:b:v:oi:")) != -1) {
>                 switch (opt) {
>                 case 'm':
>                         guest_modes_cmdline(optarg);
>                         break;
>                 case 'd':
>                         p.delay = atoi_non_negative("Delay", optarg);
>                         break;
>                 case 'b':
>                         guest_percpu_mem_size = parse_size(optarg);
>                         break;
>                 case 'v':
>                         nr_vcpus = atoi_positive("Number of vCPUs", optarg);
>                         TEST_ASSERT(nr_vcpus <= max_vcpus,
>                                     "Invalid number of vcpus, must be between 1 and %d",
>                                     max_vcpus);
>                         break;
>                 case 'o':
>                         p.partition_vcpu_memory_access = false;
>                         break;
>                 case 'i':
>                         p.nr_iterations = atoi_positive("Number of iterations", optarg);
>                         break;
>                 case 'h':
>                 default:
>                         help(argv[0]);
>                         break;
>                 }
>         }
>
