Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC8A57B8FD
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiGTO4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbiGTO4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 10:56:38 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A53247D
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 07:56:37 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a5so26463846wrx.12
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gFaFfhQuDdNcq9NTKFOPtpu0tCvR0SyPhCdMyJvFbcc=;
        b=nmKLfLBL22w5ZwGCQtct0mhoMXTDxZXZWSX9+sHqBplsXjlyfl6ACww3TO2BllA0Kq
         StLiUpr7nvRvw3R1HuCYAAUAqSFRqolsSeGfBWL0hqhUUI8Bf7Z+9rob1e5fZKvVo8Jy
         Jp/gqprpSzF8/7pI3A14yhjq5J2PatkBxEPWW4ZQnp/yqfBaVbGVRNngj9tnZXnYfecm
         nfKUaS9CDCtTi92sOcyFnrU0vgiXjUGg9iG13aBJBfzo27YuR3I/x7seUdRMgiwgqLb5
         ZDSxsjhW82utJhB0QpLUlvxQZxVKDPvO8RQSRW+Ypj5RgpcmsZE1YgrWrVWt5+Fq7fQh
         N9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gFaFfhQuDdNcq9NTKFOPtpu0tCvR0SyPhCdMyJvFbcc=;
        b=wZiAXeKIy1dbGhvFogp4Zr9fQBrVYXj16C2DQzUUxn5b9P+4bFHKqviyXFXt5FmPJV
         GCsKvqbXhjJaMZhcmFdL19Y/XxiQ+6z8fvLVyzgvbNUXJOfMkClLBHao8Gq7Q2sTXGgW
         7S0zKpF/+s9f7pkr6ZHWsR4zm6ax1oycyeMpuVuZKoFJP+Jl8m3A3bLndACvL9dlqpf+
         XTSOgJgNOn7mA/+SPQBuucubU/2rGZBbOMdlEIILbmttIfTC8kaURU/hdfXurqGKnr5C
         Kvebasn9/dCHBDFNzos2bnVe5TJvfVqwFve1TyXIvx89gOw8BP7QG2SYI6g2CFd5Y0df
         zI/w==
X-Gm-Message-State: AJIora9OVIC0S9pFLjPE8Zzgg2CpWKcEAwxJpvEhCnTiXWkMTXBtytGM
        jXn5gwogfpd5dlvwbVlCyv7c4zTRnJaTMvq262M0sQ==
X-Google-Smtp-Source: AGRyM1uGkHMIXlmRm01LO91SN8vvZWqAyDmmWFlXa49gZuK26ZIu98kBLGxblEKerbDtJRU3COg7jgz9/2va9pvgGdI=
X-Received: by 2002:a5d:4d8e:0:b0:21d:68d4:56eb with SMTP id
 b14-20020a5d4d8e000000b0021d68d456ebmr29981723wru.40.1658328996384; Wed, 20
 Jul 2022 07:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-28-adrian.hunter@intel.com> <CAP-5=fXC4SYyV3DJKxy0atW1RRSS8EouD+t=pXuqJPSQ=x_jMA@mail.gmail.com>
 <YtgL0M/jHSC9/BBG@kernel.org>
In-Reply-To: <YtgL0M/jHSC9/BBG@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 Jul 2022 07:56:24 -0700
Message-ID: <CAP-5=fVUHdDZi_EHCe2Ko-7FZjbdaoNvA-u-CrZE4Vs6O=fNAw@mail.gmail.com>
Subject: Re: [PATCH 27/35] perf tools: Add perf_event__is_guest()
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 7:06 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Tue, Jul 19, 2022 at 06:11:47PM -0700, Ian Rogers escreveu:
> > On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
> > >
> > > Add a helper function to determine if an event is a guest event.
> > >
> > > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > > ---
> > >  tools/perf/util/event.h | 21 +++++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > >
> > > diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> > > index a660f304f83c..a7b0931d5137 100644
> > > --- a/tools/perf/util/event.h
> > > +++ b/tools/perf/util/event.h
> >
> > Would this be better under tools/lib/perf ?
>
> In general I think we should move things to libperf when a user requests
> it, i.e. it'll be needed in a tool that uses libperf.

The perf_event_header is defined in libperf. If we're worried about
exposing the API, we could keep it in the internal include files. To
explain my thinking, if something like cpumap or perf_event_header
live in libperf, then it makes sense to me that the structs, accessors
and the like also live there. Having the code standing in both perf
and libperf is a transitory state we should be working to remove.

I don't see this as a big deal, so don't mind the code not being in libperf :-)

Thanks,
Ian

> - Arnaldo
>
> > Thanks,
> > Ian
> >
> > > @@ -484,4 +484,25 @@ void arch_perf_synthesize_sample_weight(const struct perf_sample *data, __u64 *a
> > >  const char *arch_perf_header_entry(const char *se_header);
> > >  int arch_support_sort_key(const char *sort_key);
> > >
> > > +static inline bool perf_event_header__cpumode_is_guest(u8 cpumode)
> > > +{
> > > +       return cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
> > > +              cpumode == PERF_RECORD_MISC_GUEST_USER;
> > > +}
> > > +
> > > +static inline bool perf_event_header__misc_is_guest(u16 misc)
> > > +{
> > > +       return perf_event_header__cpumode_is_guest(misc & PERF_RECORD_MISC_CPUMODE_MASK);
> > > +}
> > > +
> > > +static inline bool perf_event_header__is_guest(const struct perf_event_header *header)
> > > +{
> > > +       return perf_event_header__misc_is_guest(header->misc);
> > > +}
> > > +
> > > +static inline bool perf_event__is_guest(const union perf_event *event)
> > > +{
> > > +       return perf_event_header__is_guest(&event->header);
> > > +}
> > > +
> > >  #endif /* __PERF_RECORD_H */
> > > --
> > > 2.25.1
> > >
>
> --
>
> - Arnaldo
