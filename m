Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334BA679EA7
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjAXQaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAXQai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:30:38 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65420134
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:30:37 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jm10so15191445plb.13
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WH8dogHFrbtrUPEbTBAkEB7mODqHtTEzSy6ZDTyFYCI=;
        b=WqiILCejXByq7mamwSjvTiYhIhl53/a2879xufNpHveZ8AIUNVb+4zlySeCSihVmSm
         gJf66uxD1WRxyv/4BCgTGAqbglO6dw8+pTFOPnclDIc+YSPpQB57ZAy33aD13BdzzPI1
         dInQeQMWl3qD/4PKwtrmTJa5ing9r20v+i372/Nfy49LOkBayOWmfA5WmeWivFXZxYP2
         1AHUKId0tUghQm3anOW//uwwdVWqPmqsNCcVSZ0RM2A1nFyWRQdkiGbHsSytDqdkGzUC
         3tzXB4DQntgwPvMNUXciOpDlA5KWVPh1AU9Qx3B9BYntzBmHvB5il8FiQFoj11LlVFKR
         wFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WH8dogHFrbtrUPEbTBAkEB7mODqHtTEzSy6ZDTyFYCI=;
        b=G27ivGT2txzOGpFqAXTdx4gV5s9pKmkNzuaGgz7QyqLgELCWApgk9ollW4+ZeLRamb
         8+TLgxw3wD5gseZ2iRbgYpeFsRg091yWIuOUEzrWhez9arHBi6ZDbm1EwCbE+6kCRdfe
         WTyYyelePylz4hyR+MVeHfpHJCddCKPXQ4/eeraJpMmeDb1ePoZr966+PwuHQxYyuVmr
         mEBJsBF1FDzy3C32nP6n/rn491nbF5l8f0WXT3uA2LPSPzTkQ2G7+mlNCYaTycHsXfdP
         mLN716TChL3ioTQyEw727DcsoT5kDiVsW8QLo08m34Sec6IhrzKXqUT9zWA+TXDti+MD
         gp6g==
X-Gm-Message-State: AO0yUKVMDpcSb0THFx1pP+DC14uj7xy4KMXoRQhFRWVZ5TXJRpxjFDeB
        sz3I2D/H3JodrYBUJMLDp0E75Q==
X-Google-Smtp-Source: AK7set9UXN5qqN6aG70o6t5zKAA4Z3NA/q+UNHRg2aZrGkThFvPzI7xb17REn2KRR4XlOebyQhldiw==
X-Received: by 2002:a17:90a:300e:b0:227:679:17df with SMTP id g14-20020a17090a300e00b00227067917dfmr231535pjb.0.1674577836722;
        Tue, 24 Jan 2023 08:30:36 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id nm1-20020a17090b19c100b0022717d8d835sm8814272pjb.16.2023.01.24.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:30:36 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:30:32 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into
 ctx->flags
Message-ID: <Y9AHqM2eYM11gIB9@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
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

On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > indicate that the walk is on a removed table not accesible to the HW
> > page-table walker. Then use it to avoid doing break-before-make or
> > performing CMOs (Cache Maintenance Operations) when mapping a removed
> 
> Nit: Should this say unmapping? Or are we actually going to use this
> to map memory ?

As you mentioned in the next commit, this will be clearer if I use
"unliked" instead of "removed". Might end up rewriting this message as
well, as I will be using Oliver's suggestion of using multiple flags,
one for each operation to elide.

> 
> > table. This is safe as these removed tables are not visible to the HW
> > page-table walker. This will be used in a subsequent commit for
> ...
