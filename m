Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D646EA01C
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTXnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 19:43:22 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6A2111
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:43:20 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f192c23fffso175085e9.3
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682034199; x=1684626199;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fhzUGQ0e3jau16rJuaHw7YFz5UmtipEFtsxsVMwlu4=;
        b=UYbLnr16QO4IB0We1VDV539qc+2tWQPauIHMDaQKLDm3M0JNbW99SLR4W9GXxtH4jm
         k6cYUWmZH1WidXx+/XFkpAVTsXEcES9YXeHfx3nUXtl27yMbAeoWRQ6Zg93RfliU7FEs
         6IKPfasPD+g+2NA4qadYnhpUivC2Xwm6KoN6PQGN/4sgNwlLWNZpKkeotpLTkGFn5Ke8
         uUXmbSFLTLEqbwTZt5xt5GdY7wtv4cQpQh446jkBdj6igKPXbGe/00am6xgnSgUq971r
         Mynkjsdpv5PgYjDlO3ar/0U/TdV8AvnIAltXoVv8m1fIFHl+jlgMmbZEr5kc8pbQZu1T
         17pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682034199; x=1684626199;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fhzUGQ0e3jau16rJuaHw7YFz5UmtipEFtsxsVMwlu4=;
        b=FNGTqnjactU4HIpndHudEb+CPDobV/L3a2wf28B9HnB56NUc3eYeQTe1gzDlwCRh+j
         pJIAnplPjtemx3h9C21KNldatd0+0oxeVnLhrH2xrPAibUS/k7439zPFXpyjKWi3+27J
         fw5sDiXhlRHaiG3c5G4wgq7TrnPPfmAtri343cjaiQ4tBbwhjDpQW87G3pFmT0sv02g9
         sPa9fJXOHHv3sqef5UeYXGmbO3aGUFS9HcaeD1/UZOr/Ul/f/zUbHAU6FYWwD6OIxx3J
         k3eMv10MqchjU0ob/AG0CQ8srTHzyxoWI1X7AqnWxAnBCdzjkf6FsU2XoJdFEx7progY
         ykaQ==
X-Gm-Message-State: AAQBX9cc6v0KKWW1pxiwCcM0HwB6MubxLI/Gfz8yrnjYaxYkyAu6h0GR
        KH7e1wStgsl0spUPJ6Meyc/UuVGnwgp+qzYHw+zHvoLAE15xmC7FGDy/3Q==
X-Google-Smtp-Source: AKy350Yc1v1rg4zYV+FiSYexap1BoXIvqOLIjo0EMWVhVfh2m/JOxLdOw+yuxlGGAyVt/JPqC+clOdtqOo/BZV0O4QE=
X-Received: by 2002:a7b:cb96:0:b0:3f0:5519:9049 with SMTP id
 m22-20020a7bcb96000000b003f055199049mr402752wmi.8.1682034198843; Thu, 20 Apr
 2023 16:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
In-Reply-To: <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 16:42:42 -0700
Message-ID: <CAF7b7mqrLP1VYtwB4i0x5HC1eYen9iMvZbKerCKWrCFv7tDg5Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

My reply to Peter earlier bounced from the mailing list due to the
attached images (sorry!). I've copied it below to get a record
on-list.

Just for completeness, the message ID of the bounced mail was
<CAF7b7mo68VLNp=3DQynfT7QKgdq=3Dd1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>

On Wed, Apr 19, 2023 at 2:53=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Wed, Apr 19, 2023 at 2:05=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> > > We considered sharding into several UFFDs. I do think it helps, but
> > > also I think there are two main problems with it...
> >
> > But I agree I can never justify that it'll always work.  If you or Anis=
h
> > could provide some data points to further support this issue that would=
 be
> > very interesting and helpful, IMHO, not required though.
>
> Axel covered the reasons for not pursuing the sharding approach nicely
> (thanks!). It's not something we ever prototyped, so I don't have any
> further numbers there.
>
> On Wed, Apr 19, 2023 at 2:05=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> >
> > > I think we could share numbers from some of our internal benchmarks,
> > > or at the very least give relative numbers (e.g. +50% increase), but
> > > since a lot of the software stack is proprietary (e.g. we don't use
> > > QEMU), it may not be that useful or reproducible for folks.
> >
> > Those numbers can still be helpful.  I was not asking for reproduceabil=
ity,
> > but some test to better justify this feature.
>
> I do have some internal benchmarking numbers on this front, although
> it's been a while since I've collected them so the details might be a
> little sparse.
>
> I've confirmed performance gains with "scalable userfaultfd" using two
> workloads besides the self-test:
>
> The first, cycler, spins up a VM and launches a binary which (a) maps
> a large amount of memory and then (b) loops over it issuing writes as
> fast as possible. It's not a very realistic guest but it at least
> involves an actual migrating VM, and we often use it to
> stress/performance test migration changes. The write rate which cycler
> achieves during userfaultfd-based postcopy (without scalable uffd
> enabled) is about 25% of what it achieves under KVM Demand Paging (the
> internal KVM feature GCE currently uses for postcopy). With
> userfaultfd-based postcopy and scalable uffd enabled that rate jumps
> nearly 3x, so about 75% of what KVM Demand Paging achieves. The
> attached "Cycler.png" illustrates this effect (though due to some
> other details, faster demand paging actually makes the migrations
> worse: the point is that scalable uffd performs more similarly to kvm
> demand paging :)
>
> The second is the redis memtier benchmark [1], a more realistic
> workflow where we migrate a VM running the redis server. With scalable
> userfaultfd, the client VM observes significantly higher transaction
> rates during uffd-based postcopy (see "Memtier.png"). I can pull the
> exact numbers if needed, but just from eyeballing the graph you can
> see that the improvement is something like 5-10x (at least) for
> several seconds. There's still a noticeable gap with KVM demand paging
> based-postcopy, but the improvement is definitely significant.
>
> [1] https://github.com/RedisLabs/memtier_benchmark
