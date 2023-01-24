Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13237679EAE
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjAXQc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjAXQc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:32:56 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6824815CA8
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:32:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso10135716pjp.3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WEjR3MMUrHfbjILuF7dobsrFdV5OhfxF21ZQLpjye7U=;
        b=oZ0G5N/t1eDXjYcoYiwY41LK0h5eGp3QsK5+D174rof58LylqVRvhMnP8mIJ0k9PAe
         GdcwzYKSVwF4U40oMXci76lh80JgrM+5/pdmAMQj414mN4QzlvrKrFhsigFiVVt2Dwco
         wXxPItYsjXE81AWKqcMStZ87lo4OMt5lKkNfjUOSD8yguvFbE6lD7Fev2F6BmPCg55s9
         I2XCcZNRTTpzkV2z4TSSin/2KswPs9EXw3wsGvonMxbpyIieZaXhXxkJG6PJ9cpfa43I
         1lz1uFK7g5irexIQBYpZmszKSK78r79GCPiNIG1xJeIOQD/ZrnfGNOtk6jVzZmzEXBbO
         b7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEjR3MMUrHfbjILuF7dobsrFdV5OhfxF21ZQLpjye7U=;
        b=QSrNFjkuSRKSQBUQd9tOQlbb5I+okXuDEPlHFMM4rwEKdS5DTk3GT8ZskSffDyq96A
         NdTY35Sm30XOj6kEzDlCyl6Fq/m29NT8Wtzbrha6RJYXZQbnQuDAotYyHTw9ee6UZrAF
         8bNZosD49ImhQ5j99iJmehHbahZJrRGeAPooQrSv0Nayz04H0ImeGHzMP5nqtLyPM8cy
         O0dDG7CaZl0DP6CQs6/Q1NOKDGD57qNU4W0XISbRLzcBNkdOf3w3ORqbEQJa6VjAskH9
         axL0fiKZjcpm+L2p5qLYlK8WXZflU1xj1oopNT3rXFAfvpPFQW0SzevD8/ox3bC4qCXf
         3Cqg==
X-Gm-Message-State: AO0yUKW1kUPKn4Eezp1XsCSmrDFZ/ExZmrEDpUKVisNFh5xU39W/iRDu
        o3Jim6YBwAxLSdOKO8e4PJDSOQ==
X-Google-Smtp-Source: AK7set/DWflTmlF2dzZZVpG42fRxvToZgU8UWyKHB2mCwB11kxSKJSfCxlOy7Dcft8FG9fYFxc9TAw==
X-Received: by 2002:a17:90a:14e5:b0:229:1e87:365f with SMTP id k92-20020a17090a14e500b002291e87365fmr225584pja.2.1674577974493;
        Tue, 24 Jan 2023 08:32:54 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z88-20020a17090a6d6100b00229188a823dsm8672967pjj.20.2023.01.24.08.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:32:54 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:32:50 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into
 ctx->flags
Message-ID: <Y9AIMtJEgEjoVWQA@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
 <Y88sq1cQUzVj9B4D@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88sq1cQUzVj9B4D@google.com>
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

On Tue, Jan 24, 2023 at 12:56:11AM +0000, Oliver Upton wrote:
> On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> > On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > > indicate that the walk is on a removed table not accesible to the HW
> > > page-table walker. Then use it to avoid doing break-before-make or
> > > performing CMOs (Cache Maintenance Operations) when mapping a removed
> > 
> > Nit: Should this say unmapping? Or are we actually going to use this
> > to map memory ?
> 
> I think the *_REMOVED term feels weird as it relates to constructing a
> page table. It'd be better if we instead added flags to describe the
> operations we intend to elide (i.e. CMOs and TLBIs).

What about KVM_PGTABLE_WALK_ELIDE_BBM and KVM_PGTABLE_WALK_ELIDE_CMO?

> That way the
> implementation is generic enough that we can repurpose it for other use
> cases.

Aha, good point. I actually have a use case for it (FEAT_BBM).

> 
> --
> Thanks,
> Oliver
