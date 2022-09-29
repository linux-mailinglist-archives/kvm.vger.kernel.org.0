Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9227C5EFA16
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiI2QTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 12:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbiI2QTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 12:19:13 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E356D1E1132
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:19:04 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-324ec5a9e97so19412637b3.7
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=90pUeluDL+Ba7o/bnw0JwEij8vaj+hq5mvA9BKLCGl8=;
        b=W/d+fVCNmSR9A+FujVdZ/+3SxizZuRZmpV4YxYO/l9NHpG5fn8+nOGa+0Cfc/hw0Jb
         yRzu/ZixTGT8vqNzAqYXzbE/kwA0Er9wobzFKgffKW5OBY+n5vLy6fekTdfoT6PDLvkf
         T/kKRe/0Wn9uVM/Blj04l/uRrIAv7w+WyMJ4dRDMJZ9DACVKlrIXOcAJcJ0xhy+QbftW
         gPJHKLq34Xmce6836eJdu1pSFdbBa708QN8HUXZCztXk0kq4EHHRhaeXzlKYpLg0Ba7/
         owE6jXTSALCbdYjuOcByb7NpkhTwYyKyLR/FPmnR6B9YPAbwWJiGi9/wXzDM/M3eHGKR
         ylQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=90pUeluDL+Ba7o/bnw0JwEij8vaj+hq5mvA9BKLCGl8=;
        b=unpGlH7FbbfusqgA1efuDpbWdo2M+ZMxpfHkkt4oLU5fU/wX0lYfiEMzRNk88wf1GA
         6cualfEGmzm4YjP8VdbG1yVoDiso1koxqljdvtOUHeyJAj9jzFtxikiWLd+AdYp1aE9A
         qHbhkppdS9OG2Tuhu7nLAnHeQwJ6PTftjBS/K08DLmFUhq6Fa+emfJKxLuv666JxgdOa
         Pnhh7I5H7NGiLRH7c+xCUrSfWqYDBhZbs9qlLvB/ShQig7z4sJ/t/WQcJMmsCoqGuGow
         Fs24pDKu6E9flSQlY5CVgo6qSM/NJzLfYUTRSdj2jr9/PLymwi6ahrgueI6tkrMCc2DV
         Ynhg==
X-Gm-Message-State: ACrzQf0Z31+jaE2f3UhYVafwNj6cpnhx+MoVr6rn71F/Qk22wbNR8gn4
        0cktrw1HT93zJP3+OxWUUKOJ3YAtGfeh0ELjhg8rsQ==
X-Google-Smtp-Source: AMsMyM6Pl6UV86xI/khxBKMMRZ1UJWm2JOfNjL7HdNihUeEFpZSluv0cNt1Ozo9RnOVhDrDGpLuRqrfwPKNLj1Cx1s0=
X-Received: by 2002:a81:1e0d:0:b0:33b:fb67:9895 with SMTP id
 e13-20020a811e0d000000b0033bfb679895mr4161557ywe.188.1664468343819; Thu, 29
 Sep 2022 09:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220928184853.1681781-1-dmatlack@google.com> <20220928184853.1681781-3-dmatlack@google.com>
 <YzTP8xBkBkxzB1gn@google.com>
In-Reply-To: <YzTP8xBkBkxzB1gn@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 29 Sep 2022 09:18:37 -0700
Message-ID: <CALzav=f-KDP02i5vjNuR3wjUea93Dm0aWUGwOV22JpKo9-QVPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: Add helper to read boolean module parameters
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm list <kvm@vger.kernel.org>
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

On Wed, Sep 28, 2022 at 3:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 28, 2022, David Matlack wrote:
> > @@ -114,6 +115,36 @@ void print_skip(const char *fmt, ...)
> >       puts(", skipping test");
> >  }
> >
> > +bool get_module_param_bool(const char *module_name, const char *param)
> > +{
> > +     const int path_size = 1024;

(Unrelated to your review but I noticed 1024 is overkill. e.g.
"/sys/module/kvm_intel/parameters/error_on_inconsistent_vmcs_config"
is only 67 characters. I will reduce this in v3.)

> > +     char path[path_size];
> > +     char value;
> > +     FILE *f;
> > +     int r;
> > +
> > +     r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
> > +                  module_name, param);
> > +     TEST_ASSERT(r < path_size,
> > +                 "Failed to construct sysfs path in %d bytes.", path_size);
> > +
> > +     f = fopen(path, "r");
>
> Any particular reason for using fopen()?  Oh, because that's what the existing
> code does.  More below.

Heh, yes. I write C code to do file I/O about once every 2 years so I
always need to reference existing code :)

>
> > +     TEST_ASSERT(f, "fopen(%s) failed", path);
>
> I don't actually care myself, but for consistency this should probably be a
> skip condition.  The easiest thing would be to use open_path_or_exit().
>
> At that point, assuming read() instead of fread() does the right thin, that seems
> like the easiest solution.

Fine by me!

>
> > +     TEST_FAIL("Unrecognized value: %c", value);
>
> Maybe be slightly more verbose?  E.g.
>
>         TEST_FAIL("Unrecognized value '%c' for boolean module param", value);

Will do.

>
> > +}
> > +
> >  bool thp_configured(void)
> >  {
> >       int ret;
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 2e6e61bbe81b..522d3e2009fb 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -1294,20 +1294,9 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> >  /* Returns true if kvm_intel was loaded with unrestricted_guest=1. */
> >  bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> >  {
> > -     char val = 'N';
> > -     size_t count;
> > -     FILE *f;
> > -
> >       /* Ensure that a KVM vendor-specific module is loaded. */
> >       if (vm == NULL)
> >               close(open_kvm_dev_path_or_exit());
> >
> > -     f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> > -     if (f) {
> > -             count = fread(&val, sizeof(char), 1, f);
> > -             TEST_ASSERT(count == 1, "Unable to read from param file.");
> > -             fclose(f);
> > -     }
> > -
> > -     return val == 'Y';
> > +     return get_module_param_bool("kvm_intel", "unrestricted_guest");
>
> Since there are only three possible modules, what about providing wrappers to
> handle "kvm", "kvm_amd", and "kvm_intel"?  I'm guessing we'll end up with wrappers
> for each param we care about, but one fewer strings to get right would be nice.

Will do.
