Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DD43544E
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 22:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhJTUIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 16:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhJTUIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 16:08:20 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0492AC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:06:06 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id v77so11059466oie.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wq6oet9g8hv+e/X+J0XtN62AZRTPo6MAkzC9yPJ/4nA=;
        b=iPhF+H55hafSFzI/3Kc9WhAEnUoURV43GhKZ63Fy2bJpF1Ocn2WJ9c1t6SG644l3q1
         yZKVEhVmQqglG+qpUPuMPS23KuFKR8s0l9mneJ6koO/pBrHmYyAAnnfkLxYiscRMoXit
         l2C8TMzJTF8wJ6nr8oqPgYydkKWq3U/JLVUaBLEuzorTG0RVwVyvFD8sacVOMxjYl2aB
         oaCN1MOs1H7ErJAVsXUusQ8fbeOT2Q1ehMToW28YAzgYCLLPMHMMGSA6fws4K52R8dH3
         TgvKf1HVGzSEIX+AeY/ithVN3Sxb8ej6yLi2IKvxuqRnxtdq1ykCyvIMZINh3alaXxsI
         dlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wq6oet9g8hv+e/X+J0XtN62AZRTPo6MAkzC9yPJ/4nA=;
        b=IIcKMbgIMe/KXhiGvxgspy3+EIzHPRiloGklHa4HVrr3xZVd++CBBjBb93b2V87BUs
         ir1A0XhoA0l59UlKbFo2NvYqdiApXbHsPqOxo/sA4fVQdE+HTgv1ge0ee3D7Wp8U7t+5
         FxU/jqKZkMLHrN/d7I7GkP+lfXEDJs6iOfPm0879KMbw1FeRT6DQODKHPyPR3gDwhFPt
         zl7p3AscSxeoB/qBAWhxlsc/kTtyYiVsNYayO/QKC23tReVYh13zw2B8KaPuohR6Mhmt
         QibvzydezpVu+iS6Qu/lvRpi+2Rcqg7QuXaq6xxoa+UIGh4yqxDOb68U5H/m/lZYneky
         fuSg==
X-Gm-Message-State: AOAM531THQSjmx7sLBUN+T8YfRm2uHR2rBLX78+9AZDL7kiU64lzZZR5
        z3ONPyTdMYX131loIqfiPR3/iySjWsNyWrneTqqRkA==
X-Google-Smtp-Source: ABdhPJxVAvxxev432TPdvteehWsta9gIwS7XV+wMbbNsfOqpSUlFdBqDZL1tArfCMX/DjJ3KozXtcuEGNxAkpffQyrw=
X-Received: by 2002:a05:6808:1a0a:: with SMTP id bk10mr924616oib.66.1634760364685;
 Wed, 20 Oct 2021 13:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211020165333.953978-1-pbonzini@redhat.com> <20211020165333.953978-2-pbonzini@redhat.com>
In-Reply-To: <20211020165333.953978-2-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Oct 2021 13:05:53 -0700
Message-ID: <CALMp9eS_peankkdripp=s995XR2+5E2oBEb01Uom1sY5hku8jA@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 1/2] unify structs for GDT descriptors
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Aaron Lewis

On Wed, Oct 20, 2021 at 9:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Use the same names and definitions (apart from the high base field)
> for GDT descriptors.  gdt_entry_t is for 8-byte entries and
> gdt_desc_entry_t is for when 64-bit tests should use a 16-byte
> entry.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/x86/desc.c         | 16 ++++++----------
>  lib/x86/desc.h         | 36 ++++++++++++++++++++++++++----------
>  x86/svm_tests.c        | 12 ++++++------
>  x86/taskswitch.c       |  2 +-
>  x86/vmware_backdoors.c |  8 ++++----
>  5 files changed, 43 insertions(+), 31 deletions(-)
>
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index e7378c1..3d38565 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -285,17 +285,13 @@ void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
>         int num = sel >> 3;
>
>         /* Setup the descriptor base address */
> -       gdt32[num].base_low = (base & 0xFFFF);
> -       gdt32[num].base_middle = (base >> 16) & 0xFF;
> -       gdt32[num].base_high = (base >> 24) & 0xFF;
> +       gdt32[num].base1 = (base & 0xFFFF);
> +       gdt32[num].base2 = (base >> 16) & 0xFF;
> +       gdt32[num].base3 = (base >> 24) & 0xFF;
>
> -       /* Setup the descriptor limits */
> -       gdt32[num].limit_low = (limit & 0xFFFF);
> -       gdt32[num].granularity = ((limit >> 16) & 0x0F);
> -
> -       /* Finally, set up the granularity and access flags */
> -       gdt32[num].granularity |= (gran & 0xF0);
> -       gdt32[num].access = access;
> +       /* Setup the descriptor limits, granularity and flags */
> +       gdt32[num].limit1 = (limit & 0xFFFF);
> +       gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((gran & 0xF0) << 8) | access;
>  }
>
>  void set_gdt_task_gate(u16 sel, u16 tss_sel)
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index a6ffb38..3aa1eca 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -164,15 +164,28 @@ typedef struct {
>  } idt_entry_t;
>
>  typedef struct {
> -       u16 limit_low;
> -       u16 base_low;
> -       u8 base_middle;
> -       u8 access;
> -       u8 granularity;
> -       u8 base_high;
> -} gdt_entry_t;
> -
> -struct segment_desc64 {
> +       uint16_t limit1;
> +       uint16_t base1;
> +       uint8_t  base2;

These names are even more horrible than their predecessors. How about
something like:

limit_15_0
base_15_0
base_23_16

> +       union {
> +               uint16_t  type_limit_flags;      /* Type and limit flags */

/* Type, limit[19:16], and flags */

> +               struct {
> +                       uint16_t type:4;
> +                       uint16_t s:1;
> +                       uint16_t dpl:2;
> +                       uint16_t p:1;
> +                       uint16_t limit:4;

Perhaps limit_19_16?

> +                       uint16_t avl:1;
> +                       uint16_t l:1;
> +                       uint16_t db:1;
> +                       uint16_t g:1;
> +               } __attribute__((__packed__));
> +       } __attribute__((__packed__));
> +       uint8_t  base3;

base_31_24?

> +} __attribute__((__packed__)) gdt_entry_t;
> +

Why specify 'gdt'? Aren't ldt descriptors the same format?

> +#ifdef __x86_64__
> +typedef struct {
>         uint16_t limit1;
>         uint16_t base1;
>         uint8_t  base2;
> @@ -193,7 +206,10 @@ struct segment_desc64 {
>         uint8_t  base3;
>         uint32_t base4;
>         uint32_t zero;
> -} __attribute__((__packed__));
> +} __attribute__((__packed__)) gdt_desc_entry_t;
> +#else
> +typedef gdt_entry_t gdt_desc_entry_t;
> +#endif
>
>  #define DESC_BUSY ((uint64_t) 1 << 41)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index afdd359..014fbbf 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1876,22 +1876,22 @@ static bool reg_corruption_check(struct svm_test *test)
>  static void get_tss_entry(void *data)
>  {
>      struct descriptor_table_ptr gdt;
> -    struct segment_desc64 *gdt_table;
> -    struct segment_desc64 *tss_entry;
> +    gdt_entry_t *gdt_table;
> +    gdt_entry_t *tss_entry;
>      u16 tr = 0;
>
>      sgdt(&gdt);
>      tr = str();
> -    gdt_table = (struct segment_desc64 *) gdt.base;
> -    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
> -    *((struct segment_desc64 **)data) = tss_entry;
> +    gdt_table = (gdt_entry_t *) gdt.base;
> +    tss_entry = &gdt_table[tr / sizeof(gdt_entry_t)];
> +    *((gdt_entry_t **)data) = tss_entry;
>  }
>
>  static int orig_cpu_count;
>
>  static void init_startup_prepare(struct svm_test *test)
>  {
> -    struct segment_desc64 *tss_entry;
> +    gdt_entry_t *tss_entry;
>      int i;
>
>      on_cpu(1, get_tss_entry, &tss_entry);
> diff --git a/x86/taskswitch.c b/x86/taskswitch.c
> index 889831e..b6b3451 100644
> --- a/x86/taskswitch.c
> +++ b/x86/taskswitch.c
> @@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
>
>         tss.eip += 2;
>
> -       gdt32[TSS_MAIN / 8].access &= ~2;
> +       gdt32[TSS_MAIN / 8].type &= ~2;

Is this right? I got the impression that there was one TSS descriptor per CPU.

>
>         set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
>  }
> diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
> index b4902a9..24870d7 100644
> --- a/x86/vmware_backdoors.c
> +++ b/x86/vmware_backdoors.c
> @@ -133,8 +133,8 @@ struct fault_test vmware_backdoor_tests[] = {
>  static void set_tss_ioperm(void)
>  {
>         struct descriptor_table_ptr gdt;
> -       struct segment_desc64 *gdt_table;
> -       struct segment_desc64 *tss_entry;
> +       gdt_entry_t *gdt_table;
> +       gdt_desc_entry_t *tss_entry;
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
> +       tss_entry = (gdt_desc_entry_t *) &gdt_table[tr / sizeof(gdt_entry_t)];
>         tss_base = ((uint64_t) tss_entry->base1 |
>                         ((uint64_t) tss_entry->base2 << 16) |
>                         ((uint64_t) tss_entry->base3 << 24) |

It seems like there should be a library function for reconstructing a
base address from a segment descriptor.

> --
> 2.27.0
>
>
