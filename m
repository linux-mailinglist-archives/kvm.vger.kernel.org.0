Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619044FE849
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356729AbiDLS7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243777AbiDLS7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:59:16 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739E61B7A5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:56:57 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id f17so3841924ybj.10
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHMwq1hCh/WshGI8cTMIpUbiFRbaWH2+E/KWSNCulF0=;
        b=DMyoyas2eSkhhVmvnWgufXkDHSzqfnS6ZOW9Mf+ms7554uhXbpQDI7yMDzmNZsI6jY
         12Gss+w65bvDjdAkZKLMft7FGFtykJXlNLTH6mbkPY8t4bQlaxksxrjzw1fhh5iNun3H
         j3Hxub+s20/83m+ZnppQ9RKkKl41NV+HbUWNv4hRHfRulyiz8z3X3ipzxpjMCAGEh+w1
         0Ufk1VETl6NHXwfolyiiAUL5lo5/tVBFuHWTG5osvxeZqdbjswmlCOuzxfTTex2AQH3W
         UM07xvjisCrHhNoN3smZgSpuGKAAKOCUOlbgud+rxRCep97226Lxnei5LWF5rjG+UT9r
         1fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHMwq1hCh/WshGI8cTMIpUbiFRbaWH2+E/KWSNCulF0=;
        b=aKQoXBYHIaRAcDn7xr538CfKx89HSFvSiXXuPzDzslj2TbhRqbt1wszuRxMDhTN4jd
         1AfQ76nmgcoQXCidkFiMDkhDp6BYEEyeProvaNiSiJJNgt0v/1OPOsi1mk9q9jgYYdT7
         UbgY0pquTZlgtLyYjzvigeWbc4NUfegFLVsIUdpey3XhPIby8JAXcZjCmWpUgLfmvI+a
         UTjW4EHATbj7g3ydfkV5Vh72wl475HT4GFF/pVQLNCqJ87m6q0Od8pEQLkEvLDMiJM1a
         pSv6GwjSIxvMAtHe7U68BnAsFkJWQ3EXFf5Xtx/Qou5y/mnCQk5HBNLKa+M0z/gStEpS
         vHDw==
X-Gm-Message-State: AOAM533ruVl5799AAaX/Gq0Op4Gq6R0oW3KZRl8xYOoK9LqV0sVj6Exm
        6/P1G/3bze+hWFsFdH9kn1O+Mwr52javdjaL+QcrpQ==
X-Google-Smtp-Source: ABdhPJzaWphCzALFcxOPkJ8Yh4i0c37CrY2FUZ4X7yXa/GXuJWd2LYCi4Ydsj2f/4IW3w4Qu/3+zGMTf/7Sfq4hcyHI=
X-Received: by 2002:a25:add6:0:b0:641:2562:4022 with SMTP id
 d22-20020a25add6000000b0064125624022mr11431719ybe.391.1649789816478; Tue, 12
 Apr 2022 11:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-4-bgardon@google.com>
 <YlTN3yq1iBPkw6Aa@google.com>
In-Reply-To: <YlTN3yq1iBPkw6Aa@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 12 Apr 2022 11:56:45 -0700
Message-ID: <CANgfPd8mZ9-zQBvK=OASQ+n7eq_FpvpStMc_yD-UsmFdQ3OCvA@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] KVM: selftests: Read binary stats desc in lib
To:     Mingwei Zhang <mizhang@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 5:55 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Mon, Apr 11, 2022, Ben Gardon wrote:
> > Move the code to read the binary stats descriptors to the KVM selftests
> > library. It will be re-used by other tests to check KVM behavior.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  4 +++
> >  .../selftests/kvm/kvm_binary_stats_test.c     |  9 ++----
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
> >  3 files changed, 35 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 5ba3132f3110..c5f34551ff76 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -401,6 +401,10 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
> >  int vm_get_stats_fd(struct kvm_vm *vm);
> >  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> >  void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header);
> > +struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
> > +                                       struct kvm_stats_header *header);
> > +void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> > +                     struct kvm_stats_desc *stats_desc);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > index 22c22a90f15a..e4795bad7db6 100644
> > --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -62,14 +62,9 @@ static void stats_test(int stats_fd)
> >                                                       header.data_offset),
> >                       "Descriptor block is overlapped with data block");
> >
> > -     /* Allocate memory for stats descriptors */
> > -     stats_desc = calloc(header.num_desc, size_desc);
> > -     TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> >       /* Read kvm stats descriptors */
> > -     ret = pread(stats_fd, stats_desc,
> > -                     size_desc * header.num_desc, header.desc_offset);
> > -     TEST_ASSERT(ret == size_desc * header.num_desc,
> > -                     "Read KVM stats descriptors");
> > +     stats_desc = alloc_vm_stats_desc(stats_fd, &header);
> > +     read_vm_stats_desc(stats_fd, &header, stats_desc);
> >
> >       /* Sanity check for fields in descriptors */
> >       for (i = 0; i < header.num_desc; ++i) {
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 0caf28e324ed..e3ae26fbef03 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2564,3 +2564,32 @@ void read_vm_stats_header(int stats_fd, struct kvm_stats_header *header)
> >       ret = read(stats_fd, header, sizeof(*header));
> >       TEST_ASSERT(ret == sizeof(*header), "Read stats header");
> >  }
> > +
> > +static ssize_t stats_descs_size(struct kvm_stats_header *header)
> > +{
> > +     return header->num_desc *
> > +            (sizeof(struct kvm_stats_desc) + header->name_size);
> > +}
> I was very confused on header->name_size. So this field means the
> maximum string size of a stats name, right? Can we update the comments
> in the kvm.h to specify that? By reading the comments, I don't really
> feel this is how we should use this field.

I believe that's right. I agree the documentation on that was a little
confusing.

>
> hmm, if that is true, isn't this field a compile time value? Why do we
> have to get it at runtime?

It's compile time for the kernel but not for the userspace binaries
which ultimately consume the stats.
We could cheat in this selftest perhaps, but then it wouldn't be as
good of a test.

>
> > +
> > +/* Caller is responsible for freeing the returned kvm_stats_desc. */
> > +struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
> > +                                       struct kvm_stats_header *header)
> > +{
> > +     struct kvm_stats_desc *stats_desc;
> > +
> > +     stats_desc = malloc(stats_descs_size(header));
> > +     TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> > +
> > +     return stats_desc;
> > +}
> > +
> > +void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> > +                     struct kvm_stats_desc *stats_desc)
> > +{
> > +     ssize_t ret;
> > +
> > +     ret = pread(stats_fd, stats_desc, stats_descs_size(header),
> > +                 header->desc_offset);
> > +     TEST_ASSERT(ret == stats_descs_size(header),
> > +                 "Read KVM stats descriptors");
> > +}
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
