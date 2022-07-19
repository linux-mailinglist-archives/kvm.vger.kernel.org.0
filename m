Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4220557A46C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 18:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiGSQ5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 12:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiGSQ5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 12:57:00 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419604F1BB
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 09:56:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h17so22581416wrx.0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 09:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HjzI8Y5AFZSjQh4cY4GKqmaCg1K0UQucOPz5+/QiYwM=;
        b=dokUPJWuCe4HUQ2XEI1u/VZC8wAmp4o+IFhtkaeR4iasVCBEWU08xfzK1uv9p5HlPk
         nien7tPJ4L39gthmcuC5oQpFnzwWHeDrGHVC0WQre3cPAv+ZY0fmOH9yZfJTdNYuODv1
         NpL6R8tIlLZ7CY590YIrWi77dKa+Vx0xzaoU4JfYODCon96dB35xbmY5OvRspEaTJVHL
         4mBJnwyNWpwWzGNYi+/7aYINsCK1S0NDyGAeVjxGn6Jlb51FY0tYwW/Mv7rDb+KQaeNO
         m8tnKGu2G7qgdXUp7EVOQGZDiiCQJ5uw5tkFQYkGZNaVA5lTsAcnJvRSf2g/OxzmCd+h
         23oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HjzI8Y5AFZSjQh4cY4GKqmaCg1K0UQucOPz5+/QiYwM=;
        b=bEo/KZzJdDYGcT3piYWRSrAKpT/AguJMNwV7Rzip5cnMlsFDepmxT2RyA/N2ww0R0u
         Camudszl1bhwbap9eDra+yFXC/ghMN4c9YnaLQvnD4zAmesRp/OIJ5Xz33P9mhYwRXq8
         FoEZxlKcZei+/aIAkuTrO6kUtDrQ5X1ixk5J6nk8dpWmq48Jv/NZF/fzNM+IiKPvrtHe
         HHkMDxmc3mhWzH9OsbGPfz7A0ja8khJnIb+q6iMAlZ2wURK9AHcY2C8cjD2GJ7mUBw3I
         Oqty5uinJ9IzUhFGPiRjGNkvMJgTZcloAvwTcq+YJdHV5QlUjEZH2xCY6bo8W9mqH9Bh
         j07g==
X-Gm-Message-State: AJIora++V2NBq6rp6W9fp7IfmdrS1GETZB5jovlJWYTHmMvnChu4UHKw
        U2J1H338yw8ixZNT+7SDCK83OpaIgWXQ/Cd1ruHpLw==
X-Google-Smtp-Source: AGRyM1txVzkio7oKFun4OwE14uQx7ilwn6eAe1/lyvt+pd0N/bzekFoP9cEO6aXKtzhzHB/IAdMFOcmIZVQK6Yj/bbI=
X-Received: by 2002:a05:6000:8e:b0:21d:7e97:67ed with SMTP id
 m14-20020a056000008e00b0021d7e9767edmr26650190wrx.343.1658249817686; Tue, 19
 Jul 2022 09:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com> <20220711093218.10967-4-adrian.hunter@intel.com>
In-Reply-To: <20220711093218.10967-4-adrian.hunter@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 Jul 2022 09:56:45 -0700
Message-ID: <CAP-5=fUHG=-QdsP5dGxZ444DUfgaYLGhXevQuUH3dmcQnyexYg@mail.gmail.com>
Subject: Re: [PATCH 03/35] perf ordered_events: Add ordered_events__last_flush_time()
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

On Mon, Jul 11, 2022 at 2:32 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Allow callers to get the ordered_events last flush timestamp.
>
> This is needed in perf inject to obey finished-round ordering when
> injecting additional events (e.g. from a guest perf.data file) with
> timestamps. Any additional events that have timestamps before the last
> flush time must be injected before the corresponding FINISHED_ROUND event.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  tools/perf/util/ordered-events.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
> index 0b05c3c0aeaa..8febbd7c98ca 100644
> --- a/tools/perf/util/ordered-events.h
> +++ b/tools/perf/util/ordered-events.h
> @@ -75,4 +75,10 @@ void ordered_events__set_copy_on_queue(struct ordered_events *oe, bool copy)
>  {
>         oe->copy_on_queue = copy;
>  }
> +
> +static inline u64 ordered_events__last_flush_time(struct ordered_events *oe)
> +{
> +       return oe->last_flush;
> +}
> +
>  #endif /* __ORDERED_EVENTS_H */
> --
> 2.25.1
>
