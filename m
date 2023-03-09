Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D1B6B2E0F
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 21:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjCIUAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 15:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjCIUAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 15:00:41 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52B5FA0A1
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 12:00:25 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 82so3160162ybn.6
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 12:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678392025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRVfqzOHtxGfCOD/hmq5ZCFI3R/AhSmM69LhJPZlq7U=;
        b=FTWdr5VUtQTk2dzVnzWpz5cXvej4xF8WCdYrQwTsknU6hKfGhe4UHUGfyw0Bu2425/
         tqJ22veMT0/Th/qvPSzFtkd+ASBuwPe9WU83r+VVL3QzZgSlsH4JLqXpc17eKQN2NvOX
         wSaKy/bge58jNDiUvFzN8sUZF9jtMVzt5dfotHBo2mE5rghOpXcGREm63j+ZhFqgR0YN
         j2cuJb4N/vHr07aYBEvvoegKfRNJOzApIgcB/Gr0Ikw1zDLYxWSKLdhyqAju1XBVtM/b
         epPozqqqdNkff4+Vrym14hTz//lIcnGaflEjG5vhVba2Bq0+oXhr1Jw+/oOo6l4DgX0s
         3U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678392025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRVfqzOHtxGfCOD/hmq5ZCFI3R/AhSmM69LhJPZlq7U=;
        b=4cwYVY3jsSxhpdLU+FjUvdDIhEJs8loZ2SbEH3RwrzsMOIXDocyAcEhP9Pe+kdrU0H
         HLr7SSajhAVJ4nm33w6NA82tWINpieW0/J9TxB29jX6hXByjKVATTuWqnicGcKDHP78D
         NrlHTB1r64mnDoyzkok7Czy448Fy+Slc7v+daDGQTAbDE+bqm/nJlW8D8kyuNsvJgczD
         0DCxNV6E27uKDfcvfyAtZxNVp3Hc01m0MchlW9F7PSNzP0zomd1xjm3uECiA5H6U12W+
         551YdxHmwqUJlmY2NyJXRqfcH0ialZTsiBS5GmgxhxsTlESWTYnQVr0wI4M+5fkQxY1a
         cpsA==
X-Gm-Message-State: AO0yUKWswHfa7jZQxEoY5KnGQM+r/lzLW3UJANcKQeQXYEv0SzMbk2Yv
        kh/24lSstZT9vMCCyOjuBl3octX8NiKGL8RYQS4J2w==
X-Google-Smtp-Source: AK7set/yHnG/9RXusfxXy2Y3OUlsTTSG233SidOIxR8aFoF7LJ4oqFfGvYqVVqWWh9cFIa3D1tS2bTgQ9T6cbE3qFis=
X-Received: by 2002:a25:8e92:0:b0:914:fc5e:bbec with SMTP id
 q18-20020a258e92000000b00914fc5ebbecmr11155039ybl.13.1678392024664; Thu, 09
 Mar 2023 12:00:24 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-7-vipinsh@google.com>
 <20230309180135.000043fe@gmail.com>
In-Reply-To: <20230309180135.000043fe@gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 9 Mar 2023 11:59:48 -0800
Message-ID: <CAHVum0f+k=AX4yM=04SLEfuaLVOQVozMk10O9OuzJjj-NMjh9g@mail.gmail.com>
Subject: Re: [Patch v4 06/18] KVM: x86/mmu: Shrink split_shadow_page_cache via
 MMU shrinker
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, mizhang@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 9, 2023 at 8:01=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com> =
wrote:
>
> On Mon,  6 Mar 2023 14:41:15 -0800
> Vipin Sharma <vipinsh@google.com> wrote:
>
> > Use MMU shrinker to free unused pages in split_shadow_page_cache.
> > Refactor the code and make common function to try emptying the page cac=
he.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 34 +++++++++++++++++++++-------------
> >  1 file changed, 21 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0ebb8a2eaf47..73a0ac9c11ce 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6696,13 +6696,24 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *=
kvm, u64 gen)
> >       }
> >  }
> >
>
> After adding the lock in the kvm_mmu_memory_cache, the cache_lock doesn't=
 need
> to be passed here and in mmu_shrink_scan().
>
Agree. Let us see what is the decision on moving the lock inside the cache.
