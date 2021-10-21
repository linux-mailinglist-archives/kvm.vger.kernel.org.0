Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7321435988
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 05:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhJUDwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 23:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUDww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 23:52:52 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE12C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 20:50:37 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n63so12205395oif.7
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 20:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/IKRMz4UbplhQtWgMkmQSQez6SzmAuZJN10Hs8BTzsE=;
        b=gqDlL+SGF0z4BLunu91cUqAyJXG1TEeQyhS6KTPXBWdKLxhuktznjR0K5RhRQx4kEX
         padN+3Y/nGv/YHYjUC5MZcDe4QJTUZ280qEi62DvEwDiI17vxbmmQKb1DA3y/+qRwLYd
         tvtzgNDxV1wp9l8Qs4RdXuh13dhRmO/+YpX77wvSdeFsqpRCsgVLJLoWAHaIT6WO7A/z
         wkzrd/Bpc50YQkpLogVWVV4Zsfb2391R6UhEUS0/FApJZribI1+yU3kfO+Ud7qvnvHWO
         nvn91u1DkkvdaTaYNVX5QJZYq5yR8sI0I/gBENEK5i0xWJEZQcAyTTeZ/fGgE0YWKK/M
         ax5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/IKRMz4UbplhQtWgMkmQSQez6SzmAuZJN10Hs8BTzsE=;
        b=Bo87jAKdgh1E3fxm3Xj3DcVo67UEsJmqCZ92GHyx1BUpqD0ZTE5an4t3TBBfM9xQgL
         3QPFXb9YPXVW4IbuFnUP5B/VfOoz5kBlhlCxED6hIPwq8Y/01P+4g9Ix1rqUhtXrccAg
         jXoXQDt6aLwDYCFeT3KgTuo6XIkD9U3kEnWdi1aVdhp/AoU0SzRpBovf2IhOrrkINEyy
         8NE1r/8Y9pFC0ipDLwO/Ox/ENdqtppgPn9Jugm/+aNVqMzkAoQLawkCp9En5e8JCmO7w
         urFnxYMwg5BuhtnIRswvQU27EsaDHm59IxpSYZfHjh0BGORfzjc77DearCGp2wcQljYd
         8jjw==
X-Gm-Message-State: AOAM531Xzso3cNNuepKkQBQVG6OqxxrTnzFVMYJqCzgWkDQB+Im4rd9Q
        fuprwBNE5UHmqdODfQRPtuQvBEyfX0A1IrHuM1ZXCw==
X-Google-Smtp-Source: ABdhPJxAfGbV2uTCelCJQj65qsEYuE3qSZJACP3MSuuZhaHnHIRy8vClBA0Sg6U7EOdar+F46zXC8iZ5qLMXVeULsNY=
X-Received: by 2002:aca:3306:: with SMTP id z6mr2779558oiz.164.1634788236310;
 Wed, 20 Oct 2021 20:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211020192732.960782-1-pbonzini@redhat.com> <20211020192732.960782-3-pbonzini@redhat.com>
In-Reply-To: <20211020192732.960782-3-pbonzini@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 20 Oct 2021 20:50:24 -0700
Message-ID: <CAA03e5Es5FrSHQtO-ze=3txL9xsJx4TQ8Un+6ifbPTbS+KGeTQ@mail.gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a function
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> tss_descr is declared as a struct descriptor_table_ptr but it is actualy
> pointing to an _entry_ in the GDT.  Also it is different per CPU, but
> tss_descr does not recognize that.  Fix both by reusing the code
> (already present e.g. in the vmware_backdoors test) that extracts
> the base from the GDT entry; and also provide a helper to retrieve
> the limit, which is needed in vmx.c.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/x86/desc.c         | 22 ++++++++++++++++++++++
>  lib/x86/desc.h         | 28 +++++++---------------------
>  x86/cstart64.S         |  1 -
>  x86/svm_tests.c        | 15 +++------------
>  x86/vmware_backdoors.c | 22 ++++++----------------
>  x86/vmx.c              |  9 +++++----
>  6 files changed, 43 insertions(+), 54 deletions(-)
>
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 3d38565..cfda2b2 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -409,3 +409,25 @@ void __set_exception_jmpbuf(jmp_buf *addr)
>  {
>         exception_jmpbuf = addr;
>  }
> +
> +gdt_entry_t *get_tss_descr(void)
> +{
> +       struct descriptor_table_ptr gdt_ptr;
> +       gdt_entry_t *gdt;
> +
> +       sgdt(&gdt_ptr);
> +       gdt = (gdt_entry_t *)gdt_ptr.base;
> +       return &gdt[str() / 8];
> +}
> +
> +unsigned long get_gdt_entry_base(gdt_entry_t *entry)
> +{
> +       unsigned long base;
> +       base = entry->base1 | ((u32)entry->base2 << 16) | ((u32)entry->base3 << 24);
> +#ifdef __x86_64__
> +       if (!entry->s) {
> +           base |= (u64)((gdt_entry16_t *)entry)->base4 << 32;
> +       }
> +#endif
> +       return base;
> +}
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 0af37e3..e8a6c21 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -185,31 +185,14 @@ typedef struct {
>  } __attribute__((__packed__)) gdt_entry_t;
>
>  #ifdef __x86_64__
> -struct segment_desc64 {
> -       uint16_t limit1;
> -       uint16_t base1;
> -       uint8_t  base2;
> -       union {
> -               uint16_t  type_limit_flags;      /* Type and limit flags */
> -               struct {
> -                       uint16_t type:4;
> -                       uint16_t s:1;
> -                       uint16_t dpl:2;
> -                       uint16_t p:1;
> -                       uint16_t limit:4;
> -                       uint16_t avl:1;
> -                       uint16_t l:1;
> -                       uint16_t db:1;
> -                       uint16_t g:1;
> -               } __attribute__((__packed__));
> -       } __attribute__((__packed__));
> -       uint8_t  base3;
> +typedef struct {
> +       gdt_entry_t common;
>         uint32_t base4;
>         uint32_t zero;
> -} __attribute__((__packed__));
> +} __attribute__((__packed__)) gdt_entry16_t;
>  #endif
>
> -#define DESC_BUSY ((uint64_t) 1 << 41)
> +#define DESC_BUSY 2
>
>  extern idt_entry_t boot_idt[256];
>
> @@ -253,4 +236,7 @@ static inline void *get_idt_addr(idt_entry_t *entry)
>         return (void *)addr;
>  }
>
> +extern gdt_entry_t *get_tss_descr(void);
> +extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
> +
>  #endif
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 5c6ad38..cf38bae 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -4,7 +4,6 @@
>  .globl boot_idt
>
>  .globl idt_descr
> -.globl tss_descr
>  .globl gdt64_desc
>  .globl online_cpus
>  .globl cpu_online_count
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index afdd359..8ad6122 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1875,23 +1875,14 @@ static bool reg_corruption_check(struct svm_test *test)
>
>  static void get_tss_entry(void *data)
>  {
> -    struct descriptor_table_ptr gdt;
> -    struct segment_desc64 *gdt_table;
> -    struct segment_desc64 *tss_entry;
> -    u16 tr = 0;
> -
> -    sgdt(&gdt);
> -    tr = str();
> -    gdt_table = (struct segment_desc64 *) gdt.base;
> -    tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
> -    *((struct segment_desc64 **)data) = tss_entry;
> +    *((gdt_entry_t **)data) = get_tss_descr();
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
> @@ -1905,7 +1896,7 @@ static void init_startup_prepare(struct svm_test *test)
>
>      --cpu_online_count;
>
> -    *(uint64_t *)tss_entry &= ~DESC_BUSY;
> +    tss_entry->type &= ~DESC_BUSY;
>
>      apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP, id_map[1]);
>
> diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
> index b4902a9..bc10020 100644
> --- a/x86/vmware_backdoors.c
> +++ b/x86/vmware_backdoors.c
> @@ -132,23 +132,13 @@ struct fault_test vmware_backdoor_tests[] = {
>   */
>  static void set_tss_ioperm(void)
>  {
> -       struct descriptor_table_ptr gdt;
> -       struct segment_desc64 *gdt_table;
> -       struct segment_desc64 *tss_entry;
> -       u16 tr = 0;
> +       gdt_entry_t *tss_entry;
>         tss64_t *tss;
>         unsigned char *ioperm_bitmap;
> -       uint64_t tss_base;
> -
> -       sgdt(&gdt);
> -       tr = str();
> -       gdt_table = (struct segment_desc64 *) gdt.base;
> -       tss_entry = &gdt_table[tr / sizeof(struct segment_desc64)];
> -       tss_base = ((uint64_t) tss_entry->base1 |
> -                       ((uint64_t) tss_entry->base2 << 16) |
> -                       ((uint64_t) tss_entry->base3 << 24) |
> -                       ((uint64_t) tss_entry->base4 << 32));
> -       tss = (tss64_t *)tss_base;
> +       u16 tr = str();
> +
> +       tss_entry = get_tss_descr();
> +       tss = (tss64_t *)get_gdt_entry_base(tss_entry);
>         tss->iomap_base = sizeof(*tss);
>         ioperm_bitmap = ((unsigned char *)tss+tss->iomap_base);
>
> @@ -157,7 +147,7 @@ static void set_tss_ioperm(void)
>                 1 << (RANDOM_IO_PORT % 8);
>         ioperm_bitmap[VMWARE_BACKDOOR_PORT / 8] |=
>                 1 << (VMWARE_BACKDOOR_PORT % 8);
> -       *(uint64_t *)tss_entry &= ~DESC_BUSY;
> +       tss_entry->type &= ~DESC_BUSY;
>
>         /* Update TSS */
>         ltr(tr);
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 20dc677..063f96a 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -75,7 +75,6 @@ union vmx_ept_vpid  ept_vpid;
>
>  extern struct descriptor_table_ptr gdt64_desc;
>  extern struct descriptor_table_ptr idt_descr;
> -extern struct descriptor_table_ptr tss_descr;
>  extern void *vmx_return;
>  extern void *entry_sysenter;
>  extern void *guest_entry;
> @@ -1275,7 +1274,7 @@ static void init_vmcs_host(void)
>         vmcs_write(HOST_SEL_FS, KERNEL_DS);
>         vmcs_write(HOST_SEL_GS, KERNEL_DS);
>         vmcs_write(HOST_SEL_TR, TSS_MAIN);
> -       vmcs_write(HOST_BASE_TR, tss_descr.base);
> +       vmcs_write(HOST_BASE_TR, get_gdt_entry_base(get_tss_descr()));
>         vmcs_write(HOST_BASE_GDTR, gdt64_desc.base);
>         vmcs_write(HOST_BASE_IDTR, idt_descr.base);
>         vmcs_write(HOST_BASE_FS, 0);
> @@ -1291,6 +1290,8 @@ static void init_vmcs_host(void)
>
>  static void init_vmcs_guest(void)
>  {
> +       gdt_entry_t *tss_descr = get_tss_descr();
> +
>         /* 26.3 CHECKING AND LOADING GUEST STATE */
>         ulong guest_cr0, guest_cr4, guest_cr3;
>         /* 26.3.1.1 */
> @@ -1331,7 +1332,7 @@ static void init_vmcs_guest(void)
>         vmcs_write(GUEST_BASE_DS, 0);
>         vmcs_write(GUEST_BASE_FS, 0);
>         vmcs_write(GUEST_BASE_GS, 0);
> -       vmcs_write(GUEST_BASE_TR, tss_descr.base);
> +       vmcs_write(GUEST_BASE_TR, get_gdt_entry_base(tss_descr));
>         vmcs_write(GUEST_BASE_LDTR, 0);
>
>         vmcs_write(GUEST_LIMIT_CS, 0xFFFFFFFF);
> @@ -1341,7 +1342,7 @@ static void init_vmcs_guest(void)
>         vmcs_write(GUEST_LIMIT_FS, 0xFFFFFFFF);
>         vmcs_write(GUEST_LIMIT_GS, 0xFFFFFFFF);
>         vmcs_write(GUEST_LIMIT_LDTR, 0xffff);
> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
> +       vmcs_write(GUEST_LIMIT_TR, 0x67);

optional: It would be good to add a comment explaining the `0x67` value here.

>
>         vmcs_write(GUEST_AR_CS, 0xa09b);
>         vmcs_write(GUEST_AR_DS, 0xc093);
> --
> 2.27.0
>

Reviewed-by: Marc Orr <marcorr@google.com>
