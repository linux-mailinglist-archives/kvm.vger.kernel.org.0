Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1953561F703
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKGPCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiKGPCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:02:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBDF209B5
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 06:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667833185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
        b=b8q//+eiFm3P5Vxr9VD4DgwtaJ8i1s5Dod4O2e1mRtM52Ucsy8kBntiGbRwXp0dKYNoJZ8
        KTsZ3T1JZC1+f6MjvKCg/zjCq2wOuNgKZZ9x7A8xOrx33e+kCvhiZv52gYtQrHsUwQYFw9
        C3kewh8Ln8L+YQsFIqcON3USov06yAk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-380-9rfi7FOnNUaROBNiUen-WA-1; Mon, 07 Nov 2022 09:59:44 -0500
X-MC-Unique: 9rfi7FOnNUaROBNiUen-WA-1
Received: by mail-qv1-f71.google.com with SMTP id b2-20020a0cfe62000000b004bbfb15297dso7746308qvv.19
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
        b=mgsvblK/z/Pf/Q4jLDaK3zNDV5cysJ5IsAKuzSSUZSo/NxefpRyM2MabvQtOOEfwgA
         DNlTuh3GIzlOjFRv/NBzMjg7VD7s4/83x0+ank27vsgJ62AzvBW43yGCgtWfXirGGUss
         zcvrG1/y0NYu9FtE0BzKsgS7qOF1hV5C0QTVuy4CvS+yHUFaaPUiUmGfSGs9BCarhq2K
         8cL4dLxW3xqZ0T8B94PZU+St9MfkyB9sD+ypxC/58i0k/LLU3f6XkS6zBRY+OaIXT1yl
         3WeXUgR71y0OHEFIwD7eh4ZdFj/GLw3L0I1qHrOlE0z8f2Z3MqDGxPQGEFn8syr/Sa7Y
         /A3A==
X-Gm-Message-State: ACrzQf0yZ51e1dvUb7ljyZlzgjj0inj/8O+9EaHoW7rj54CHIr/hMx4v
        +cgTrs2CMaoeTKCoHz3gVfmPJhH0YqOsZd6ChIFSGPdoy1bZf23FySHhzWLNK/SddC1m7wD8tKQ
        JSXj67/v5sFwS
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id bs19-20020a05620a471300b006fa330cfb05mr734577qkb.73.1667833183469;
        Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-Smtp-Source: AMsMyM65yBkuWsX7foV0D07w/+0OUFO1k03g8uWqP5eTrlq70LuV1+/X8Nl2aCAIrOhqBUEvgBBIiQ==
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id bs19-20020a05620a471300b006fa330cfb05mr734561qkb.73.1667833183175;
        Mon, 07 Nov 2022 06:59:43 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a40ca00b006f3e6933bacsm7057304qko.113.2022.11.07.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:59:42 -0800 (PST)
Date:   Mon, 7 Nov 2022 09:59:41 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kdXTn6X3O08sFv@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
 <Y2gh4x4MD8BJvogH@x1n>
 <867d07qfvk.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <867d07qfvk.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 09:21:35AM +0000, Marc Zyngier wrote:
> On Sun, 06 Nov 2022 21:06:43 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
> > > Hi Peter,
> > > 
> > > On Sun, 06 Nov 2022 16:22:29 +0000,
> > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > Hi, Marc,
> > > > 
> > > > On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > > > > > +Note that the bitmap here is only a backup of the ring structure, and
> > > > > > +normally should only contain a very small amount of dirty pages, which
> > > > > 
> > > > > I don't think we can claim this. It is whatever amount of memory is
> > > > > dirtied outside of a vcpu context, and we shouldn't make any claim
> > > > > regarding the number of dirty pages.
> > > > 
> > > > The thing is the current with-bitmap design assumes that the two logs are
> > > > collected in different windows of migration, while the dirty log is only
> > > > collected after the VM is stopped.  So collecting dirty bitmap and sending
> > > > the dirty pages within the bitmap will be part of the VM downtime.
> > > > 
> > > > It will stop to make sense if the dirty bitmap can contain a large portion
> > > > of the guest memory, because then it'll be simpler to just stop the VM,
> > > > transfer pages, and restart on dest node without any tracking mechanism.
> > > 
> > > Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
> > > in general. It only makes sense if the source of the dirty pages is
> > > limited to the vcpus, which is literally a corner case. Look at any
> > > real machine, and you'll quickly realise that this isn't the case, and
> > > that DMA *is* a huge source of dirty pages.
> > > 
> > > Here, we're just lucky enough not to have much DMA tracking yet. Once
> > > that happens (and I have it from people doing the actual work that it
> > > *is* happening), you'll realise that the dirty ring story is of very
> > > limited use. So I'd rather drop anything quantitative here, as this is
> > > likely to be wrong.
> > 
> > Is it a must that arm64 needs to track device DMAs using the same dirty
> > tracking interface rather than VFIO or any other interface?
> 
> What does it change? At the end of the day, you want a list of dirty
> pages. How you obtain it is irrelevant.
> 
> > It's
> > definitely not the case for x86, but if it's true for arm64, then could the
> > DMA be spread across all the guest pages?  If it's also true, I really
> > don't know how this will work..
> 
> Of course, all pages can be the target of DMA. It works the same way
> it works for the ITS: you sync the state, you obtain the dirty bits,
> you move on.
> 
> And mimicking what x86 does is really not my concern (if you still
> think that arm64 is just another flavour of x86, stay tuned!  ;-).

I didn't mean so, I should probably stop mentioning x86. :)

I had some sense already from the topics in past few years of kvm forum.
Yeah I'll be looking forward to anything more coming.

> 
> > 
> > We're only syncing the dirty bitmap once right now with the protocol.  If
> > that can cover most of the guest mem, it's same as non-live.  If we sync it
> > periodically, then it's the same as enabling dirty-log alone and the rings
> > are useless.
> 
> I'm glad that you finally accept it: the ring *ARE* useless in the
> general sense. Only limited, CPU-only workloads can make any use of
> the current design. This probably covers a large proportion of what
> the cloud vendors do, but this doesn't work for general situations
> where you have a stream of dirty pages originating outside of the
> CPUs.

The ring itself is really not the thing to blame, IMHO it's a good attempt
to try out de-coupling guest size in regard of dirty tracking from kvm.  It
may not be perfect, but it may still service some of the goals, e.g., at
least it allows the user app to detect per-vcpu information and also since
there's the ring full events we can do something more than before like the
vcpu throttling that China Telecom does with the ring structures.

But I agree it's not a generic enough solution.  Hopefully it'll still
cover some use cases so it's not completely not making sense.

Thanks,

-- 
Peter Xu

