Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9180867D499
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjAZSs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjAZSsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:48:25 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2B03BD8E
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:48:22 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id q10so2107541qvt.10
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fLH9ZOdoHg45jBV1eKjgkwHfBSZHq3Fv8D656dUUk8U=;
        b=BNszFWlK8L8U+KvFYgcxSUMvY6w1qZtFEo3oCwBYKvUNMRnJNJA981K6Z2FoNYgCf7
         vo1fS3JSO0BjUlJuJP0fTLwRsYP4LME7XbEC5XOI6lF8gPrbppM9EgPt3koVxA8ue+au
         tNZznReFTuKLXlwvivRi9HFmrs0DHaQUCHnJqhFzqcUfREHzjIbJYcX8ecfmLSsyXmau
         VnoguBqR2bdoCMHu+uuI6xornb7KADYdeSKarCBX6xWPbkt838cuspB8vA1NRtmFe5Ep
         QvL1ar1LmnoTYnU4QE6guuwVtbEfJz/NncEAOoyDFH+iAiFUCv7IV/qT57Qg1Y63hb4s
         z08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLH9ZOdoHg45jBV1eKjgkwHfBSZHq3Fv8D656dUUk8U=;
        b=hlwmWVi01OZikovbJpLCeeuTMRq1c1j0VoZIqqZk8Zc3/U9nAZUOImfbXOE3ZfieO3
         TdHiEFFe5Kr4j1s3f5ll6ghWYojHnEDHYnSU1xMOkke7wznQzlSzd6WGaA/N2i6eI37O
         qWt2R09AWPGeiNCSuCnC6nx98e8BG9o69xeWZHeOtylOqtCN1a7j7WI9UqOrzDg4DZl8
         7GdaEz1bXQkBxjzL73vu92YWfMhw5YEPVIhWXoyekzwnLQN2YeywVd3HDShEjnnn18vJ
         smzT08eYVivzVA1zSLkJ2En1IW9Ejy4NWowxCYBhbw8skImEkC9TErvmjQGRHfTMBtgT
         P7wg==
X-Gm-Message-State: AFqh2koJAdbQmdmZpjRWy0ItdsBi4lfEwPVCehoBF78kK/zl9WqUGmho
        k5wCs5i+z1QEnkSFi4cNa326RjPsE13J4o1xVvyG9Q==
X-Google-Smtp-Source: AMrXdXt20RB4jLbYdrJWSTj9ty03RzsBeJcJ+4p613qpaI+wgC//hYtkxEVQJ0kZvKw6hAfWJQ5k8Nm46g1E9S80vW4=
X-Received: by 2002:a05:6214:3381:b0:4c7:4573:563 with SMTP id
 mv1-20020a056214338100b004c745730563mr2241875qvb.1.1674758901064; Thu, 26 Jan
 2023 10:48:21 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
 <Y88sq1cQUzVj9B4D@google.com> <Y9AIMtJEgEjoVWQA@google.com> <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
In-Reply-To: <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 26 Jan 2023 10:48:10 -0800
Message-ID: <CAOHnOry+HpotsEbp35L3XhU=pZtZoO3JtbZRvTJAhFWhXqHUwg@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To:     Ben Gardon <bgardon@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
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

On Tue, Jan 24, 2023 at 10:00 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Tue, Jan 24, 2023 at 8:32 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 12:56:11AM +0000, Oliver Upton wrote:
> > > On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> > > > On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > > >
> > > > > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > > > > indicate that the walk is on a removed table not accesible to the HW
> > > > > page-table walker. Then use it to avoid doing break-before-make or
> > > > > performing CMOs (Cache Maintenance Operations) when mapping a removed
> > > >
> > > > Nit: Should this say unmapping? Or are we actually going to use this
> > > > to map memory ?
> > >
> > > I think the *_REMOVED term feels weird as it relates to constructing a
> > > page table. It'd be better if we instead added flags to describe the
> > > operations we intend to elide (i.e. CMOs and TLBIs).
> >
> > What about KVM_PGTABLE_WALK_ELIDE_BBM and KVM_PGTABLE_WALK_ELIDE_CMO?
>
> I like this, but please don't use elide in the code. I'm all for
> vocabulary, but that's not a common enough word to expect everyone to
> know. Perhaps just SKIP?

No problem, SKIP should be fine.

>
> >
> > > That way the
> > > implementation is generic enough that we can repurpose it for other use
> > > cases.
> >
> > Aha, good point. I actually have a use case for it (FEAT_BBM).
> >
> > >
> > > --
> > > Thanks,
> > > Oliver
