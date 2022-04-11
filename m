Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9E64FC76A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 00:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350327AbiDKWRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 18:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348793AbiDKWRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 18:17:36 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A859419030
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:15:20 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s13so21878556ljd.5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUJXQhFUIN7iCsj9QS5jIjGRNk+z+TdH4UZzpSxdCm4=;
        b=RV/micvGsZe9mZ8Hgcs7Y5/k/VpZqPkSFY9zXkPpDEr9tcgeW8eWFBzd1f0+r4k5b2
         N+Qvt9c2zBrO8T4mdohRydU1bT1n+NID9YwvUsYGWgQ1nrgNLVYNhDVxNHEXtgHSRSlp
         LsMVSXHAZVAPhJRV/XSulcUDl5A5GS/Jjk/eEu6w3I29s/enzaet88wKF2ziHk8j/XwB
         7F2Mjjngkfe8b8q8CBwHsDxw2oGefncdNKdWSn5qBAIEqRitrYsW6uC0iyumiYkTPAF/
         +bz/TnRbM8rqQZW49yUg5+zbOjGbwPwCO4kGomjTwV+hTEMAR5PeItnQ/JsKIbAbDkm6
         iTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUJXQhFUIN7iCsj9QS5jIjGRNk+z+TdH4UZzpSxdCm4=;
        b=1gBa5qFjnmfbOvpqLk30RtrF5ePZgTR6EL6enJQizWPoWAlL8k35xeEH4w/nGYdf4+
         HM8n7dhf5eldn1QE9RnspVQjvJpa/CYY1jIUTyPt7nKmb4L7oMgJscbP2xDa+or1mCzE
         p7lWaDifrTFFfC9/qWD898qjjMjnOU0/0nbs7Rt3efLn2hMowjo4sZH+t0ydt+sNPC+e
         vwmBTjeSwkvWsa0rdUydoj0P8R/gt6mjlTSMUrtF1Wa8uhQak39qvS0KQIRF51COrsYp
         PH5OE1GdIn4MPfYV40B1m5S/bZfwzAw9A31v2lfoGDi4B1vUVCSYwrze+Xnzy4V/VQFL
         OO+A==
X-Gm-Message-State: AOAM532Dn8ipl6/AuBWGRK2fhq1f8OXPF9zBEtmnPcftAwlLtQ4hI9a4
        3iDJw5GXBy0GpM9NxVwgGKXqsPpvquFcifZbsqen4A==
X-Google-Smtp-Source: ABdhPJxHm2gkf3/2gRmHVdxJHdV/qOMQszeZjvP243YyKawT1vGPDZrKQZgHVscnRhkeI3BWITudiXRPRM/zsnKNpYA=
X-Received: by 2002:a05:651c:54c:b0:249:9d06:24ef with SMTP id
 q12-20020a05651c054c00b002499d0624efmr21807549ljp.331.1649715318743; Mon, 11
 Apr 2022 15:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-5-bgardon@google.com>
In-Reply-To: <20220411211015.3091615-5-bgardon@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Apr 2022 15:14:52 -0700
Message-ID: <CALzav=fCnRX=JZ-knxf9_Aq_A_JOVjTq34ACe5JOmVr5Ms=vVw@mail.gmail.com>
Subject: Re: [PATCH v4 04/10] KVM: selftests: Read binary stat data in lib
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
>
> Move the code to read the binary stats data to the KVM selftests
> library. It will be re-used by other tests to check KVM behavior.
>
> No functional change intended.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +++
>  .../selftests/kvm/kvm_binary_stats_test.c     | 20 +++++-------------
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
>  3 files changed, 29 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index c5f34551ff76..b2684cfc2cb1 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -405,6 +405,9 @@ struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
>                                           struct kvm_stats_header *header);
>  void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
>                         struct kvm_stats_desc *stats_desc);
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> +                  struct kvm_stats_desc *desc, uint64_t *data,
> +                  ssize_t max_elements);
>
>  uint32_t guest_get_vcpuid(void);
>
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> index e4795bad7db6..97b180249ba0 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> @@ -20,6 +20,8 @@
>  #include "asm/kvm.h"
>  #include "linux/kvm.h"
>
> +#define STAT_MAX_ELEMENTS 1000
> +
>  static void stats_test(int stats_fd)
>  {
>         ssize_t ret;
> @@ -29,7 +31,7 @@ static void stats_test(int stats_fd)
>         struct kvm_stats_header header;
>         char *id;
>         struct kvm_stats_desc *stats_desc;
> -       u64 *stats_data;
> +       u64 stats_data[STAT_MAX_ELEMENTS];

What is the benefit of changing stats_data to a stack allocation with
a fixed limit?

>         struct kvm_stats_desc *pdesc;
>
>         /* Read kvm stats header */
> @@ -130,25 +132,13 @@ static void stats_test(int stats_fd)
>                         pdesc->offset, pdesc->name);
>         }
>
> -       /* Allocate memory for stats data */
> -       stats_data = malloc(size_data);
> -       TEST_ASSERT(stats_data, "Allocate memory for stats data");
> -       /* Read kvm stats data as a bulk */
> -       ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> -       TEST_ASSERT(ret == size_data, "Read KVM stats data");
>         /* Read kvm stats data one by one */
> -       size_data = 0;
>         for (i = 0; i < header.num_desc; ++i) {
>                 pdesc = (void *)stats_desc + i * size_desc;
> -               ret = pread(stats_fd, stats_data,
> -                               pdesc->size * sizeof(*stats_data),
> -                               header.data_offset + size_data);
> -               TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
> -                               "Read data of KVM stats: %s", pdesc->name);
> -               size_data += pdesc->size * sizeof(*stats_data);
> +               read_stat_data(stats_fd, &header, pdesc, stats_data,
> +                              ARRAY_SIZE(stats_data));
>         }
>
> -       free(stats_data);
>         free(stats_desc);
>         free(id);
>  }
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e3ae26fbef03..64e2085f1129 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2593,3 +2593,24 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
>         TEST_ASSERT(ret == stats_descs_size(header),
>                     "Read KVM stats descriptors");
>  }
> +
> +int read_stat_data(int stats_fd, struct kvm_stats_header *header,

I would like to keep up the practice of adding docstrings to functions
in kvm_util. Can you add docstring comments for this function and the
other kvm_util functions introduced by this series?

> +                  struct kvm_stats_desc *desc, uint64_t *data,
> +                  ssize_t max_elements)
> +{
> +       ssize_t ret;
> +
> +       TEST_ASSERT(desc->size <= max_elements,
> +                   "Max data elements should be at least as large as stat data");

What is the reason for this assertion? Callers are required to read
all the data elements of a given stat?

> +
> +       ret = pread(stats_fd, data, desc->size * sizeof(*data),
> +                   header->data_offset + desc->offset);
> +
> +       /* ret from pread is in bytes. */
> +       ret = ret / sizeof(*data);
> +
> +       TEST_ASSERT(ret == desc->size,
> +                   "Read data of KVM stats: %s", desc->name);

Won't this assertion fail when called from kvm_binary_stats_test.c?
kvm_binary_stats_test.c looks like it reads all the stat data at once,
which means ret will be the total number of stat data points, and
desc->size will be the number of stat data points in the first stat.

> +
> +       return ret;
> +}
> --
> 2.35.1.1178.g4f1659d476-goog
>
