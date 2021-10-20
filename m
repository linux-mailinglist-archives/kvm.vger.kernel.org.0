Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2E4354C2
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 22:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJTUsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhJTUsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 16:48:54 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704C1C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:46:39 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id n15-20020a4ad12f000000b002b6e3e5fd5dso2377384oor.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1lkg4Nfx7G3x+RiY9KVOqV5F+nosxNjlybZ7kzex2gg=;
        b=j/yPYwwSVLkRF7vaprNAxYVIqgcpK2ui2dz1MFVwHoTwCsTN9VBb3igIED3/XT/qGD
         Hk4frXouwTKCAVH9bX3wBMlvJsZvlezi/nLet98ABAOKsLKNX+gKxcxndJ92oFpD0bVx
         nv8JtmV0S8d9UsQUaOjuxE/o11P3755vJrbPx5mg1Z4pJp0AlymL7tQH50wWF/zMk2Lz
         TDqRHwF0SSq7V/oAf6VxoqG/9gALzMYTp/7wWB6aJrJagKrLTOcUXlVo1aBvbnxOl1JE
         ZHmykI4pxPVR6wJ8u6/d1u8UowHI8cbzC6aWrhAqspqxS+BrC+FF7zFj18w4woo0hr2a
         SjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1lkg4Nfx7G3x+RiY9KVOqV5F+nosxNjlybZ7kzex2gg=;
        b=vRS/TktRlDa7wCT8+BzCa9d66l4G6P9WtqskExEv+8540pDuNgogUEm0Jtq9bLDMDR
         3tiI1csAV32Cd8hZblQCN82fRCH7HoS3K7fggkXXu4x6YCNQZV3/XTt9/4cw1MVWqBts
         vS0TBBzdSjgIroLhCARVBjxKrziZ4KC+QkoEWlVmcrSmw9KW5oO8r15EKuOiLTSnW2PJ
         a5D2Ow8Iebl6Xjc8Pxje6Qt4g8OeoeuUAcStIbGORlOvB7DGdnMpx7lSpk5RGqeHfH25
         areGN6oiVavVjI/g/SLaxwN883VAEWfJesINAmFlSd18AK+ngV4uXhtBzVcpAUKulX/w
         m8Uw==
X-Gm-Message-State: AOAM5306mgWZZfqIjgRAM2EaXM/vOhOxf9nh90IdJQGx+sFfK3qu1TDR
        Pcj4nyfdtN9SuZdqzS0VCBMI4LEyYumCLMjB0bMQeQ==
X-Google-Smtp-Source: ABdhPJzLhpoNHbE72QAO14tyQ5TkYF20ltjyRvtC/is93xRdGWf7OUh/ywqTdCdmUoNRL1H3wa4/Mfji6ELmeh/0ouA=
X-Received: by 2002:a4a:d099:: with SMTP id i25mr1168740oor.86.1634762798487;
 Wed, 20 Oct 2021 13:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211020192732.960782-1-pbonzini@redhat.com> <20211020192732.960782-3-pbonzini@redhat.com>
In-Reply-To: <20211020192732.960782-3-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Oct 2021 13:46:27 -0700
Message-ID: <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a function
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Aaron Lewis

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

Technically, only bits 12:8 must be zero. The rest are ignored. See
the APM, volume 2, figure 4-22. But, perhaps that's a bit too
pedantic.

> -} __attribute__((__packed__));
> +} __attribute__((__packed__)) gdt_entry16_t;
>  #endif
>
> -#define DESC_BUSY ((uint64_t) 1 << 41)
> +#define DESC_BUSY 2
>
>  extern idt_entry_t boot_idt[256];
>
...
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

Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
doesn't the VMware backdoor test assume there's room for an I/O
permission bitmap?

>         vmcs_write(GUEST_AR_CS, 0xa09b);
>         vmcs_write(GUEST_AR_DS, 0xc093);
> --
> 2.27.0
>
