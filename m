Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B29462540
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhK2WhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhK2WeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:34:16 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC940C0FCB9A
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:46:41 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id n66so37211145oia.9
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nrPrseWscUE4IhSr8TkIOYJ1gP0ci0KUzDXRrSqLs8g=;
        b=Q2xvY2PNqwjEVP0sCLePj+ZmhL0WxqIOxybxKYA41UJRR8f5r/yBTxQ2y+vUhVyYuu
         AGIZkWDFdT1s1l0l1aA+K/qIkmOIbY11XPJD7D+dn0nYEeiF+eynNP5iBm22LX6k00y3
         rI8eUJY9Xu7llXS2fbl/8ROVXmaCNeR4KJFAh/N7u5rRkncW/ISTdlxsxV9BAup0mdx7
         AYTkFz9VeSiZ9JyT2OYRAE1+2AK73Ix5wp4t31FrXhHI9JcY1lXoQuBHGkntgL2XB/j/
         4iw6zCeKMIHhPOsjvt0mgPSIcVu/8F6m3zUEykxl9esRjw9eEmLZeJYM+q7v/SBhr81p
         RIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrPrseWscUE4IhSr8TkIOYJ1gP0ci0KUzDXRrSqLs8g=;
        b=rMQs7qgjB720w66coPcH90zmBEAX3RY8EUkASCoE7igA+elPp9bQgzVXU2YfCNOaOV
         HyCnh7CywyTb6XeyI9hIeNdubGZSZMIrB2OpcRqCVHWYWa9MIOLhTOxSlEPT1v4UVHpy
         +xIjGnd/Vw285AlS7W2AtU2dnMF9kskskaB5a6Io5FWlJJAX2GABthzf/gzROQjoVmwA
         PStJ0nfIrgzOecsiry6i/3FR5YqcySue8tRlwGKdphh7YBsVEYgolLWKV8YRAwbWCeG4
         eAF9lpAnxmDEPMiSd9a8KRWCowMSBtz0J5T+RwLqg7MkzvUJ5oarabMJnloOK/swsCUm
         PzFQ==
X-Gm-Message-State: AOAM531e3tAi6wq80Wd6k8T2ZNiD0XCeuOP7tT2t9yJLCtNXqyHiHwvY
        Mn7LVi/F8vTeD3I1reHs8Jeezdec8q0hRPtXtClhNg==
X-Google-Smtp-Source: ABdhPJyw8Tc0L8xq/2L/ysPALuVEFc1xssQI6LAaUqjZmZ98YWSZPO6a8QkQxE8ql1vZJNeL1BEW13IlE9t5vFUMlQA=
X-Received: by 2002:a54:4515:: with SMTP id l21mr622701oil.15.1638222401064;
 Mon, 29 Nov 2021 13:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20211021114910.1347278-1-pbonzini@redhat.com> <20211021114910.1347278-2-pbonzini@redhat.com>
In-Reply-To: <20211021114910.1347278-2-pbonzini@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 29 Nov 2021 13:46:29 -0800
Message-ID: <CAA03e5FX+C9BaN9VeJAVjLSN0_DknTv5PB0+Q_cmpk1t3a0uJg@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 1/9] x86: cleanup handling of 16-byte GDT descriptors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, aaronlewis@google.com, jmattson@google.com,
        zxwang42@gmail.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 4:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Look them up using a gdt_entry_t pointer, so that the address of
> the descriptor is correct even for "odd" selectors (e.g. 0x98).
> Rename the struct from segment_desc64 to system_desc64,
> highlighting that it is only used in the case of S=0 (system
> descriptor).  Rename the "limit" bitfield to "limit2", matching
> the convention used for the various parts of the base field.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/x86/desc.h         |  4 ++--
>  x86/svm_tests.c        | 12 ++++++------
>  x86/vmware_backdoors.c |  8 ++++----
>  3 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index a6ffb38..1755486 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -172,7 +172,7 @@ typedef struct {
>         u8 base_high;
>  } gdt_entry_t;
>
> -struct segment_desc64 {
> +struct system_desc64 {
>         uint16_t limit1;
>         uint16_t base1;
>         uint8_t  base2;
> @@ -183,7 +183,7 @@ struct segment_desc64 {
>                         uint16_t s:1;
>                         uint16_t dpl:2;
>                         uint16_t p:1;
> -                       uint16_t limit:4;
> +                       uint16_t limit2:4;
>                         uint16_t avl:1;
>                         uint16_t l:1;
>                         uint16_t db:1;
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index afdd359..2fdb0dc 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1876,22 +1876,22 @@ static bool reg_corruption_check(struct svm_test *test)
>  static void get_tss_entry(void *data)
>  {
>      struct descriptor_table_ptr gdt;
> -    struct segment_desc64 *gdt_table;
> -    struct segment_desc64 *tss_entry;
> +    gdt_entry_t *gdt_table;
> +    struct system_desc64 *tss_entry;
>      u16 tr = 0;
>
>      sgdt(&gdt);
>      tr = str();
> -    gdt_table = (struct segment_desc64 *) gdt.base;
> -    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
> -    *((struct segment_desc64 **)data) = tss_entry;
> +    gdt_table = (gdt_entry_t *) gdt.base;
> +    tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
> +    *((struct system_desc64 **)data) = tss_entry;
>  }
>
>  static int orig_cpu_count;
>
>  static void init_startup_prepare(struct svm_test *test)
>  {
> -    struct segment_desc64 *tss_entry;
> +    struct system_desc64 *tss_entry;
>      int i;
>
>      on_cpu(1, get_tss_entry, &tss_entry);
> diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
> index b4902a9..b1433cd 100644
> --- a/x86/vmware_backdoors.c
> +++ b/x86/vmware_backdoors.c
> @@ -133,8 +133,8 @@ struct fault_test vmware_backdoor_tests[] = {
>  static void set_tss_ioperm(void)
>  {
>         struct descriptor_table_ptr gdt;
> -       struct segment_desc64 *gdt_table;
> -       struct segment_desc64 *tss_entry;
> +       gdt_entry_t *gdt_table;
> +       struct system_desc64 *tss_entry;
>         u16 tr = 0;
>         tss64_t *tss;
>         unsigned char *ioperm_bitmap;
> @@ -142,8 +142,8 @@ static void set_tss_ioperm(void)
>
>         sgdt(&gdt);
>         tr = str();
> -       gdt_table = (struct segment_desc64 *) gdt.base;
> -       tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
> +       gdt_table = (gdt_entry_t *) gdt.base;
> +       tss_entry = (struct system_desc64 *) &gdt_table[tr / 8];
>         tss_base = ((uint64_t) tss_entry->base1 |
>                         ((uint64_t) tss_entry->base2 << 16) |
>                         ((uint64_t) tss_entry->base3 << 24) |
> --
> 2.27.0
>
>

I think this patch series was what was blocking the `uefi` branch from
being merged into the `master` branch. I was just trying to apply it
locally, so I could review it, and now see that it's been merged
already. Any reason not to go ahead and merge the `uefi` branch into
the mainline branch?
