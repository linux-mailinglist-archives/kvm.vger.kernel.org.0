Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63B46B199
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 04:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhLGDrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 22:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhLGDru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 22:47:50 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E9C061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 19:44:21 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id t9-20020a4a8589000000b002c5c4d19723so4989664ooh.11
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 19:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+AUC/SPF19A+z67eIhGXAhCjUvmPyx6Rc7nHGBufL8=;
        b=kYdWUCaW89LJll+elV+31Pof6n+9G4l9jTjQS1/Emb+YsvlomNu4chItFDrKymr4d4
         q9d9fzuncv/4oJ5bpOBcy1UoMA2GRFGYYYR8WtDs+1vjO1e2GAHtuzzoZba47ESAsM7G
         KCpjOUwYLiQ/U/vcmYHwGbOKFle3VIwhCH3fgveoRGdxL6eLGKSycPGD6YcEHIvFuSTa
         b0ioMWT82c6L6+EuX/aJFkjJ4pfxWSAQAEdB6MtwIi8A5uFdHbVicyM3gWwht2gv6vAf
         aKvzsbCdFJRKSwWHOBIzsDrNY25hZSp2DwXx8BjG7VoS1qDeEqeeD5cp8QvSUXtbfgIV
         EkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+AUC/SPF19A+z67eIhGXAhCjUvmPyx6Rc7nHGBufL8=;
        b=XNWvqMxCljO2QD9E/3CW+FI9y47BZVShp+Y8g1YemjBrMdL+pH9juUCXvll956curO
         hLk0uoQ8tr9B2dMOgum2KgOkaEF28q4Se/wTUYf8qwvQK3hCbuhy5i4D+BNaMDZ6QxCp
         Dezcvux0cDZHxyyVcATnbTAoYuLgB+l29/7nkTnj5C8b1felQFwCyoo5R+7NykXVIVd4
         xpPfitbBLUoFvZ5Qa6y+hBKoSJFBoiXkjiIQrL+CU4Kzhn5Q++xwhnhAdFMxp9R+fsC6
         /+ornjjQpFV1CJZOCfWjxFDYZ05G9nG4M+15sFvAg1RcBffhqM7qPWfG0EFaC2I0H33j
         h8Eg==
X-Gm-Message-State: AOAM531P2m/sC5AP6A6hTLWbLiPEosnF+KMEYOGbIMBRumhSoLwfMXar
        J53HrAT7qM85ilSgyu1+fXtQc8CHj4VIAy9iB+9TslXYZps=
X-Google-Smtp-Source: ABdhPJzcfutBJV4kaUY13T/av0lYMI3PvhkxUTnEc8N+I1peLvRn07z5t6wgS13+pVavFErTjPob0ViMb2R81R5qOwc=
X-Received: by 2002:a4a:e50e:: with SMTP id r14mr25797377oot.27.1638848660169;
 Mon, 06 Dec 2021 19:44:20 -0800 (PST)
MIME-Version: 1.0
References: <20211117134752.32662-1-varad.gautam@suse.com> <20211117134752.32662-2-varad.gautam@suse.com>
In-Reply-To: <20211117134752.32662-2-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 6 Dec 2021 19:44:09 -0800
Message-ID: <CAA03e5E7RK4uZXruLgUCAfWMdcKqhpQR3d=QxOFhSgS_VURDJA@mail.gmail.com>
Subject: Re: [RFC kvm-unit-tests 01/12] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Varad Gautam <varadgautam@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 5:49 AM Varad Gautam <varadgautam@gmail.com> wrote:
>
> AMD SEV-ES defines a new guest exception that gets triggered on
> some vmexits to allow the guest to control what state gets shared
> with the host.
>
> Install a #VC handler on early bootup to process these exits, just
> after GHCB has been mapped.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev.c    |  3 ++-
>  lib/x86/amd_sev.h    |  1 +
>  lib/x86/amd_sev_vc.c | 14 ++++++++++++++
>  lib/x86/desc.c       | 17 +++++++++++++++++
>  lib/x86/desc.h       |  1 +
>  lib/x86/setup.c      |  8 ++++++++
>  x86/Makefile.common  |  1 +
>  7 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 lib/x86/amd_sev_vc.c
>
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index 6672214..bde126b 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -14,6 +14,7 @@
>  #include "x86/vm.h"
>
>  static unsigned short amd_sev_c_bit_pos;
> +phys_addr_t ghcb_addr;
>
>  bool amd_sev_enabled(void)
>  {
> @@ -126,7 +127,7 @@ void setup_ghcb_pte(pgd_t *page_table)
>          * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
>          * found, and unsets the c-bit of GHCB's L1 pte.
>          */
> -       phys_addr_t ghcb_addr, ghcb_base_addr;
> +       phys_addr_t ghcb_base_addr;
>         pteval_t *pte;
>
>         /* Read the current GHCB page addr */
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index 6a10f84..afbacf3 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -54,6 +54,7 @@ efi_status_t setup_amd_sev(void);
>  bool amd_sev_es_enabled(void);
>  efi_status_t setup_amd_sev_es(void);
>  void setup_ghcb_pte(pgd_t *page_table);
> +void handle_sev_es_vc(struct ex_regs *regs);
>
>  unsigned long long get_amd_sev_c_bit_mask(void);
>  unsigned long long get_amd_sev_addr_upperbound(void);
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> new file mode 100644
> index 0000000..8226121
> --- /dev/null
> +++ b/lib/x86/amd_sev_vc.c
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "amd_sev.h"
> +
> +extern phys_addr_t ghcb_addr;
> +
> +void handle_sev_es_vc(struct ex_regs *regs)
> +{
> +       struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
> +       if (!ghcb) {
> +               /* TODO: kill guest */
> +               return;
> +       }
> +}
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 16b7256..8cdb2f2 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -3,6 +3,9 @@
>  #include "processor.h"
>  #include <setjmp.h>
>  #include "apic-defs.h"
> +#ifdef TARGET_EFI
> +#include "amd_sev.h"
> +#endif
>
>  /* Boot-related data structures */
>
> @@ -228,6 +231,9 @@ EX_E(ac, 17);
>  EX(mc, 18);
>  EX(xm, 19);
>  EX_E(cp, 21);
> +#ifdef TARGET_EFI
> +EX_E(vc, 29);
> +#endif
>
>  asm (".pushsection .text \n\t"
>       "__handle_exception: \n\t"
> @@ -293,6 +299,17 @@ void setup_idt(void)
>      handle_exception(13, check_exception_table);
>  }
>
> +void setup_amd_sev_es_vc(void)
> +{
> +#ifdef TARGET_EFI

Is this ifdef necessary? The SEV-ES check seems sufficient.

> +       if (!amd_sev_es_enabled())
> +               return;
> +
> +       set_idt_entry(29, &vc_fault, 0);
> +       handle_exception(29, handle_sev_es_vc);
> +#endif
> +}
> +
>  unsigned exception_vector(void)
>  {
>      unsigned char vector;
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index b65539e..4fcbf9f 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -220,6 +220,7 @@ void set_intr_alt_stack(int e, void *fn);
>  void print_current_tss_info(void);
>  handler handle_exception(u8 v, handler fn);
>  void unhandled_exception(struct ex_regs *regs, bool cpu);
> +void setup_amd_sev_es_vc(void);
>
>  bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
>                         void *data);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 24fe74e..a749df0 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -346,6 +346,14 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
>         phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
>         setup_efi_rsdp(efi_bootinfo->rsdp);
>         setup_page_table();
> +
> +       if (amd_sev_es_enabled()) {
> +               /*
> +                * Switch away from the UEFI-installed #VC handler.
> +                * GHCB has already been mapped at this point.
> +                */
> +               setup_amd_sev_es_vc();

Can we make this controllable with a configure flag? (It's fine for
configure to default to use the built-in #VC handler.) I think it's
useful to use kvm-unit-tests to test the UEFI #VC handler.

> +       }
>  }
>
>  #endif /* TARGET_EFI */
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index deaa386..18526f0 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -24,6 +24,7 @@ cflatobjs += lib/x86/fault_test.o
>  cflatobjs += lib/x86/delay.o
>  ifeq ($(TARGET_EFI),y)
>  cflatobjs += lib/x86/amd_sev.o
> +cflatobjs += lib/x86/amd_sev_vc.o
>  cflatobjs += lib/efi.o
>  cflatobjs += x86/efi/reloc_x86_64.o
>  endif
> --
> 2.32.0
>
