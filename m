Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942BA67A0BC
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjAXSAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 13:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjAXSAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 13:00:15 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D3E269A
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 10:00:14 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id tz11so41294184ejc.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 10:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CR+eHZCmsOLVBVRRoVChzcJ1AsBE6lpJW9PrVgj0s6g=;
        b=Cw9Uwe174EgmcP/g2cdQN1+pRybaMlnnAYILSsNY+vuKby8RRfgI1dnaPXI+gE9hQ4
         cS/fqaYsYCl9yWS8Ay34UpMeiINfEOLW/Rahvho2fg/OnL6hAQ1E2DWdohi84leH1qDf
         MFGPb6vAW3ckr+0elwyuygSwMNf3FLT1vXlJxyPJ+lfdd/k9n69yQT2wmkRx4kSiWXNo
         aI2W090+PQsyPBmwI9SxxYZsadOhAhMtCoWGryybeLpMKLqhirXqnAVeT5P1k+u35ywA
         iHmxHNcGoTtxsCoePJz8ilgyv9Gx2nm0iXNocygop9bMKa5ANJI4wV4AYhjHIQvKP7Ae
         YLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CR+eHZCmsOLVBVRRoVChzcJ1AsBE6lpJW9PrVgj0s6g=;
        b=qc2mLxb10mMRFEWhC/nx2HRlhjMmk/iA5J1NPwHjALosmAwSp2yiKoQyw5Fxt/BPxm
         8DXH/htqioxzxpJnrb/UdK1bt8QP4SuHxRJC8fRdQvorE80TxItDkQTTDfo5ZhmYwwLg
         qpENsK7PjUwtKNbEOOJ2FXan6dOwLBKkWHtZtHRjfvoNFbnNVAKAuQAkfVBXT3pxVtet
         MVWNONMbFzYH4sPGUJJRbGLY1h1xMueMcKpIUHemQ3ubRfTuyUz9d8TdtpwsElDSu8sD
         qDSZpobagA7TTbTLC230eSBi9V+oaybKAYX1MaoOXgxyFp7ZFc0yhRLsmkkTipRksgSr
         pE5w==
X-Gm-Message-State: AFqh2kpzXrha1QTWTBWFdiHpSQ28fJO4Q2sw2wKpT1sYy4DUlIif8TEz
        +BL9uFDb2WzZxJgQGF4NXrQFF6ajex5moamnoT506Q==
X-Google-Smtp-Source: AMrXdXsyAdxT43V4WRGbyl0sxPk45SihpP4dVySllPpRGdgMUYJr09b/AHZjrbtjI9nYF3SnZ7hc/fywRlBC5zkQsgI=
X-Received: by 2002:a17:906:2e94:b0:84d:ac8:ec37 with SMTP id
 o20-20020a1709062e9400b0084d0ac8ec37mr3361379eji.138.1674583212949; Tue, 24
 Jan 2023 10:00:12 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
 <Y88sq1cQUzVj9B4D@google.com> <Y9AIMtJEgEjoVWQA@google.com>
In-Reply-To: <Y9AIMtJEgEjoVWQA@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 24 Jan 2023 10:00:01 -0800
Message-ID: <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To:     Ricardo Koller <ricarkol@google.com>
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

On Tue, Jan 24, 2023 at 8:32 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Tue, Jan 24, 2023 at 12:56:11AM +0000, Oliver Upton wrote:
> > On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> > > On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > >
> > > > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > > > indicate that the walk is on a removed table not accesible to the HW
> > > > page-table walker. Then use it to avoid doing break-before-make or
> > > > performing CMOs (Cache Maintenance Operations) when mapping a removed
> > >
> > > Nit: Should this say unmapping? Or are we actually going to use this
> > > to map memory ?
> >
> > I think the *_REMOVED term feels weird as it relates to constructing a
> > page table. It'd be better if we instead added flags to describe the
> > operations we intend to elide (i.e. CMOs and TLBIs).
>
> What about KVM_PGTABLE_WALK_ELIDE_BBM and KVM_PGTABLE_WALK_ELIDE_CMO?

I like this, but please don't use elide in the code. I'm all for
vocabulary, but that's not a common enough word to expect everyone to
know. Perhaps just SKIP?

>
> > That way the
> > implementation is generic enough that we can repurpose it for other use
> > cases.
>
> Aha, good point. I actually have a use case for it (FEAT_BBM).
>
> >
> > --
> > Thanks,
> > Oliver
