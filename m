Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7313451B988
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiEEIBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 04:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiEEIBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 04:01:32 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAA731DA55
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651737472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxVyeeA0vsxT8elMPkNvdn0CN7YUxrlE1lm5Xe1E2fU=;
        b=UW2gL69i4gs4MGWfFw/4BACkJ0eG+8Om1X6kw+Lb4UYn7SkPog+knElpBJFYlepc8+6HtC
        WzG8Fg47u/DLtPnFetZMq4AwhrypkZzgb5AexBnmpYZYuxNAFYFXtw4gkWQigR+g24XqX7
        j4cmTT+fiWKoqTmZQ8LYqhcLHv2qD0A=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113--8EhqYWMOFy1Nwq0gXp74A-1; Thu, 05 May 2022 03:57:51 -0400
X-MC-Unique: -8EhqYWMOFy1Nwq0gXp74A-1
Received: by mail-lf1-f72.google.com with SMTP id br16-20020a056512401000b004739cf51722so1454623lfb.6
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 00:57:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kxVyeeA0vsxT8elMPkNvdn0CN7YUxrlE1lm5Xe1E2fU=;
        b=jFo/JdFcWX0D77fBdfue/uUfWKp923q6mRfhynJPd4R3Okud4ClevkWAKtogwmFPjM
         bYD7fPRgH6Olc3Q0IgeXhe/RhgCLDmqLdyZ7CwYyYsk9S4o71s8rSomQyImLzMRdeCeB
         KrL6QHM67J4+P4Vygneti63MJC+EEZcememNrC1oH2y9BzdSzXecjck1bfPIk9lMXwlI
         chfqT8U5oEaLy+jLJWZxbMyXlMbItrYSUs5Eo1QXQW8wk3bfGoHX86qu0gN5M0BkZPRx
         pJgeZOunRf6lPcJYH/cppcRFDKLn4rcC8TwDa4ihi4Xyz1tkbeM3MXsaR+rfRqtsCfF4
         NnxA==
X-Gm-Message-State: AOAM531i1vmJLLKjsKPCMFIelSmr8Uf7gzWPw5pTv8Z/mtYSPOkEK3fd
        4hmdwx4qyKcxwGSskx+z2oazTBUOgLjjLIOeEtC7PVDKazpGo83VO/pcochXB+FLHmMmFd+VLPV
        2Tfh5fh13Aga0h9gV4veE8BnPr6vy
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id p21-20020a056512139500b00446d38279a5mr16729629lfa.210.1651737470115;
        Thu, 05 May 2022 00:57:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjJxbj6pxp88uCeMqD4HMl6ElzDbNFpVGxstrfDiWk+GsCcN4qIRoZ+VBjvNqNuJhGFvEy/ffX+bXGVnCHCQc=
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id
 p21-20020a056512139500b00446d38279a5mr16729622lfa.210.1651737469940; Thu, 05
 May 2022 00:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220504081117.40-1-xieyongji@bytedance.com> <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
In-Reply-To: <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 5 May 2022 15:57:39 +0800
Message-ID: <CACGkMEu62=vUXu6r_bCrc_QCQPnhMs7K1svTx-nVmdN9bbVowA@mail.gmail.com>
Subject: Re: [PATCH] vringh: Fix maximum number check for indirect descriptors
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 3:46 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, May 4, 2022 at 4:12 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > We should use size of descriptor chain to check the maximum
> > number of consumed descriptors in indirect case.
>
> AFAIK, it's a guard for loop descriptors.
>
> > And the
> > statistical counts should also be reset to zero each time
> > we get an indirect descriptor.
>
> What might happen if we don't have this patch?
>
> >
> > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > ---
> >  drivers/vhost/vringh.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 14e2043d7685..c1810b77a05e 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -344,12 +344,13 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >                         addr = (void *)(long)(a + range.offset);
> >                         err = move_to_indirect(vrh, &up_next, &i, addr, &desc,
> >                                                &descs, &desc_max);
> > +                       count = 0;
>
> Then it looks to me we can detect a loop indirect descriptor chain?

I meant "can't" actually.

Thanks

>
> Thanks
>
> >                         if (err)
> >                                 goto fail;
> >                         continue;
> >                 }
> >
> > -               if (count++ == vrh->vring.num) {
> > +               if (count++ == desc_max) {
> >                         vringh_bad("Descriptor loop in %p", descs);
> >                         err = -ELOOP;
> >                         goto fail;
> > @@ -410,6 +411,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >                         if (unlikely(up_next > 0)) {
> >                                 i = return_from_indirect(vrh, &up_next,
> >                                                          &descs, &desc_max);
> > +                               count = 0;
> >                                 slow = false;
> >                         } else
> >                                 break;
> > --
> > 2.20.1
> >

