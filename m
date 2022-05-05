Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943D751BA3C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 10:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbiEEI1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbiEEI1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 04:27:16 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FBC0CFD
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 01:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651739016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHiS5ONkMB5Lq/fq3dbZCeNjmLoTmpnWP4a2X4gvHsg=;
        b=hV8KhSIpGHH5hNQSnaOK7SVm3QUbCjRgxgpKNrVMhSrxF7MUSEUSE/bIzzzNZmohXSQOFX
        NO+8MTjTMH7MS3eDxZH5usKqeNPfHbaZnDSrLuWz4u09PHbucEx3vHTHMuVPdyLmw3iX9n
        KtUaoqRBegp6VReJ5N6g4lbP5JdcqMg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-8OPE0hDkNzK54PtdO3Djcg-1; Thu, 05 May 2022 04:23:33 -0400
X-MC-Unique: 8OPE0hDkNzK54PtdO3Djcg-1
Received: by mail-lj1-f197.google.com with SMTP id x4-20020a05651c104400b0024f253d777fso1164841ljm.16
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 01:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHiS5ONkMB5Lq/fq3dbZCeNjmLoTmpnWP4a2X4gvHsg=;
        b=d2JO+1ZpgBiKRkFLqK4uqhdap3bN9779BBEjcaQ4y2pRAQWYJICmK9BJKYF3FuwNmR
         AyPBqIzHqxSHHBYw5Vjf5oc2Gbww0/lhZt3VLO8uYLEfJIMbdt/RU/+SFQ4omKYDcIMA
         rplCVwXtBksDL35S5lve+KD9Wzabsq33O8trwtXW2dr/VKVtivpVR27vCPJODeQbd/Hz
         7YOpjVpwSqe8oykUj4Pi1n4IYqA4o+moh25RCo/m2523Fe8kdPEjWkK6HGnuREsl5nBz
         PnXUgU/N/cgDzpclJnyR8DSizF2t12tgeZLKfMg91wEe1s4pcoihxsUIMF2YnnaIpKmJ
         Xeyg==
X-Gm-Message-State: AOAM530uvN0yPG1rcdMOAJNVzHSOxzx9m+7/m2eiS/WgJUc/qOcZfHPI
        EFUDuqbzA5d6x/VPrKA1cEeHJ1QNOUON/psMA6sKiPGCYPS1is/F0+y1+kxstRK1ubtNgfjPpri
        o0OK4OJVm5kitxmGcWj9FMHXMktMn
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id h16-20020a19ca50000000b00471f556092bmr17139223lfj.587.1651739011814;
        Thu, 05 May 2022 01:23:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu7/SW5+4bqy1N6ieFzRxA+JqqARJfwTWHOLRD9CoLyqjlumPR7uuMHg1pie0YRch6E0Y+OKmBTpGKQoJqSCk=
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id
 h16-20020a19ca50000000b00471f556092bmr17139203lfj.587.1651739011384; Thu, 05
 May 2022 01:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220504081117.40-1-xieyongji@bytedance.com> <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
 <CACycT3sdLfJPhm73p8onT1zZF3eyt+uPKBj__cfH_RvEk=FoBw@mail.gmail.com>
In-Reply-To: <CACycT3sdLfJPhm73p8onT1zZF3eyt+uPKBj__cfH_RvEk=FoBw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 5 May 2022 16:23:20 +0800
Message-ID: <CACGkMEtQXk-FsSGvEh1CpAYy9O-Zo+s9_CqwfPX358hBJ7gNBg@mail.gmail.com>
Subject: Re: [PATCH] vringh: Fix maximum number check for indirect descriptors
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 4:06 PM Yongji Xie <xieyongji@bytedance.com> wrote:
>
> On Thu, May 5, 2022 at 3:47 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Wed, May 4, 2022 at 4:12 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > >
> > > We should use size of descriptor chain to check the maximum
> > > number of consumed descriptors in indirect case.
> >
> > AFAIK, it's a guard for loop descriptors.
> >
>
> Yes, but for indirect descriptors, we know the size of the descriptor
> chain. Should we use it to test loop condition rather than using
> virtqueue size?

Yes.

>
> > > And the
> > > statistical counts should also be reset to zero each time
> > > we get an indirect descriptor.
> >
> > What might happen if we don't have this patch?
> >
>
> Then we can't handle the case that one request includes multiple
> indirect descriptors. Although I never see this kind of case now, the
> spec doesn't forbid it.

It looks to me we need to introduce dedicated counters for indirect
descriptors instead of trying to use a single counter?

(All evils came from the move_to_indirect()/return_from_indierct()
logic, vhost have dedicated helper to deal with indirect descriptors -
get_indirect()).

Thanks


>
> > >
> > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > > ---
> > >  drivers/vhost/vringh.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index 14e2043d7685..c1810b77a05e 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -344,12 +344,13 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > >                         addr = (void *)(long)(a + range.offset);
> > >                         err = move_to_indirect(vrh, &up_next, &i, addr, &desc,
> > >                                                &descs, &desc_max);
> > > +                       count = 0;
> >
> > Then it looks to me we can detect a loop indirect descriptor chain?
> >
>
> I think so.
>
> Thanks,
> Yongji
>

