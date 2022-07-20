Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFBB57AB38
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiGTA4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiGTA4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:56:09 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D595422D1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:56:06 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d8so4018633wrp.6
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ibqk5fisgJ/ziZRD3smb5yzx395lJhCMKBmOKX4NldQ=;
        b=CNA/W/uTIUbWX/lOwQw/p6BLCNyrFKSMaE4xaXDyd2kK3EDB7lSYdoWcqB4vJX2Lyv
         9wMOa3UOFVd7t2+JLomPWtwhkJqp8HyG/di+yjjJegDIvBFzD1sDg0z8u2zupohNdge4
         Ia/UxzH/8tqF9pEEwd42G5kzZ0KduPQOfrknHk8TnKQrxn0JEaE3xTlZl5OYnH81QO9C
         T7UKQGb1anI5rRRvtH1REJoJxzMQPt1pwBSj+7w1NUpeIHACPZmQplD4mXTaXakTQ1ls
         C7vMcJ05maM6Ipo83zmuToSSx5C2fF9gT37a89zcNSEYLp79tcAc/+l1YskqF3lApe1l
         ZfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ibqk5fisgJ/ziZRD3smb5yzx395lJhCMKBmOKX4NldQ=;
        b=JG/Q4Bxk06KMmLn/RLOv25m5vQ+XJlrZqEtbedCLULpMmSM+M2wfBLRZLC7d1ScS9H
         ZIAcxF6PTSnDeA0maTAhjwJO5Iw3YdNiN6Q8LQzxmTHQr/k23Iy5NPn1/S+LMt1k29lk
         wF88iP3EAG3a2PcGAhkxz14YLOHidPiJlIjBymvapObEYH20ado/yQFTDe20pgU2bz4R
         yHOuop/01Ry5XHv6B0tSYYI5xjmM5b/ww+B0ZY3rGLydIUjsMJ4wfj/viEjnf/wrRUJx
         09eXt0O6WOFyHtk96ILwy087rnxfYuxVgeTYuULcEXUAPly7aUtCiNBnaOQ7KOpbunrm
         w6sQ==
X-Gm-Message-State: AJIora9gjy3h+JPwBpplZupqmUhpjPDIinpI6cxzFBg4z5+zq3/YulWG
        V/ygtb295Ws2vYz09aviNvEejhv634ZDEOwuYYOWaw==
X-Google-Smtp-Source: AGRyM1sWB+7bN6Q+hdPG/nbCGFYDQBcv40nJ++FCTuumemqbD4hnoAb8q3fE0XNlrJXRmT+Hcl2vH2Z8kwDF4bQCGis=
X-Received: by 2002:a5d:6a4c:0:b0:21e:46d4:6eec with SMTP id
 t12-20020a5d6a4c000000b0021e46d46eecmr1655649wrw.375.1658278564481; Tue, 19
 Jul 2022 17:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-24-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-24-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 17:55:52 -0700
Message-ID: <CAP-5=fWOcK75gc6VicZUu_KPJHVteHES4+rjFMJWyuT09AC56g@mail.gmail.com>
Subject: Re: [PATCH 23/35] perf tools: Add reallocarray_as_needed()
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Add helper reallocarray_as_needed() to reallocate an array to a larger
> size and initialize the extra entries to an arbitrary value.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/util.c | 33 +++++++++++++++++++++++++++++++++
>  tools/perf/util/util.h | 15 +++++++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 9b02edf9311d..391c1e928bd7 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -18,6 +18,7 @@
>  #include <linux/kernel.h>
>  #include <linux/log2.h>
>  #include <linux/time64.h>
> +#include <linux/overflow.h>
>  #include <unistd.h>
>  #include "cap.h"
>  #include "strlist.h"
> @@ -500,3 +501,35 @@ char *filename_with_chroot(int pid, const char *filename)
>
>         return new_name;
>  }
> +
> +/*
> + * Reallocate an array *arr of size *arr_sz so that it is big enough to contain
> + * x elements of size msz, initializing new entries to *init_val or zero if
> + * init_val is NULL
> + */
> +int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x, size_t msz, const void *init_val)

This feels a little like a 1-dimensional xyarray, could we make a
similar abstraction to avoid passing all these values around?

Thanks,
Ian

> +{
> +       size_t new_sz = *arr_sz;
> +       void *new_arr;
> +       size_t i;
> +
> +       if (!new_sz)
> +               new_sz = msz >= 64 ? 1 : roundup(64, msz); /* Start with at least 64 bytes */
> +       while (x >= new_sz) {
> +               if (check_mul_overflow(new_sz, (size_t)2, &new_sz))
> +                       return -ENOMEM;
> +       }
> +       if (new_sz == *arr_sz)
> +               return 0;
> +       new_arr = calloc(new_sz, msz);
> +       if (!new_arr)
> +               return -ENOMEM;
> +       memcpy(new_arr, *arr, *arr_sz * msz);
> +       if (init_val) {
> +               for (i = *arr_sz; i < new_sz; i++)
> +                       memcpy(new_arr + (i * msz), init_val, msz);
> +       }
> +       *arr = new_arr;
> +       *arr_sz = new_sz;
> +       return 0;
> +}
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 0f78f1e7782d..c1f2d423a9ec 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -79,4 +79,19 @@ struct perf_debuginfod {
>  void perf_debuginfod_setup(struct perf_debuginfod *di);
>
>  char *filename_with_chroot(int pid, const char *filename);
> +
> +int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x,
> +                              size_t msz, const void *init_val);
> +
> +#define realloc_array_as_needed(a, n, x, v) ({                 \
> +       typeof(x) __x = (x);                                    \
> +       __x >= (n) ?                                            \
> +               do_realloc_array_as_needed((void **)&(a),       \
> +                                          &(n),                \
> +                                          __x,                 \
> +                                          sizeof(*(a)),        \
> +                                          (const void *)(v)) : \
> +               0;                                              \
> +       })
> +
>  #endif /* GIT_COMPAT_UTIL_H */
> --
> 2.25.1
>
