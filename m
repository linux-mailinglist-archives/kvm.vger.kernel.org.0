Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EA168DF43
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjBGRtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjBGRs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:48:59 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D46166E6
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:48:58 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-52770ee8cf0so128791777b3.2
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JrzI39N/h1oUtp7dQNjXU/5GxHTaJKmnRqKdVD7Yatw=;
        b=McWCOwFTZSfjfKZxB2zQbrS4QvXkfcg90QiOqbpltMP0Oglux0ZDpvlb6SdGo4meHY
         Hws8k9FsUUFmExTkTohCxagc2RqKNmV/4H4ow7APIp1dKJKdgGfvukWJmUygairDR4K4
         mIjG2Nc011tAsKGcC/EGcSjwzhRIg88O72MvLQYUz7M5hnYinrFzfVp+bgQAc24AoDCJ
         8MiW0MmOLw7Z75KwcPKGUgTtVVO7U2djSFs0DZlWG3DVsZIrnbDzU+ZNy6g7D9x0ZokD
         aEuyKgBcPBLFyLcVw+atxGUpD/XCVnQsU3VnU/TwCt0VsBgtq4crP6KS1/9mZneZwR9u
         ul8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrzI39N/h1oUtp7dQNjXU/5GxHTaJKmnRqKdVD7Yatw=;
        b=uFvFUk3AmY55j5C3/wvTwWFhXBcLitdriuiXtxaDnfZiIkVXdv1rnlme1ClLllGFiw
         57ToQfaQKI6pzKsdid7jNfUlqGLkffHlAk+cxRXGtBaDAYw+nsb182GVy+BGnHgAzkTV
         VcjvcVtqa6S14Tr0hcFIkNR7qut92RW7nChNBXPfpvvjiV7QCTLkfLxmjQ3P5sI3oUUG
         jCJJuoG+0rQeaFMnWp53A1l+ue0kY7V76GfCNUb8p5bIgIGdHCOB5UUqGn954EqOqM5n
         p9D/ovWn7PBZsMeLYHQ/jvEzsvDLmWENJAKEtQWsyPwSuTlL4xom0GaMkkx5WfB2/thE
         fYXQ==
X-Gm-Message-State: AO0yUKUxmjU1bJXF59NMtElOongniboKtDz3T+3BiuWvYLy1ltUi2Z7E
        gUluF/j/MsYJ51AxhGre/EK3BGN+ZdP9A+5lktakCA==
X-Google-Smtp-Source: AK7set8KT1SDSOUA1uUK383O0w+mNyRuu+DdczIn0dybdTQww4QdUEiYYR/lvikhWukuGvQ9RZ02VWGFAtdGVCdetpE=
X-Received: by 2002:a0d:fd86:0:b0:525:d3c2:7258 with SMTP id
 n128-20020a0dfd86000000b00525d3c27258mr370070ywf.175.1675792137738; Tue, 07
 Feb 2023 09:48:57 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-4-vipinsh@google.com>
 <CANgfPd8NF88V+ddqeCBsz=NRgm-YV7nH1DwDhRsHpA_AnFBB7g@mail.gmail.com>
In-Reply-To: <CANgfPd8NF88V+ddqeCBsz=NRgm-YV7nH1DwDhRsHpA_AnFBB7g@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 7 Feb 2023 09:48:21 -0800
Message-ID: <CAHVum0e+Dih_+hx2-k6Cf8V=udWkqcSKT+JoCo=8+0EMOCMKcw@mail.gmail.com>
Subject: Re: [Patch v2 3/5] KVM: x86/mmu: Optimize SPTE change for aging gfn range
To:     Ben Gardon <bgardon@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, Feb 6, 2023 at 2:17 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:

> > - * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
> > + * _tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
>
> Nit: Not sure how we got to the point of having a single and double
> underscore of the function, but what do you think about just calling
> this one tdp_mmu_set_spte and the other tdp_mmu_iter_set_spte?

I like your idea. I also don't like the single and double underscore
prefix on functions.
