Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828FD4B378E
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 20:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiBLTJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 14:09:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiBLTJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 14:09:56 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C4606C0
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 11:09:52 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so14489945oot.4
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 11:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4L+AiC0eLicjdCs0lKSHKwvFsUDXvwpfyvHmncmdtG0=;
        b=bm+P0OJaowP8nVJcq7x1fra6EwnIg19OiXeiGDQz6KBO8uUXIPKtvsma3m8fN4dNrz
         BW8oYNEVdOWkhX5HZSRREnwIF2BmDo2j1p0Bknq8Jj+fPAESSACv7AgDrDaCoyokNvWv
         gh6FmHvv72gFl6XW8VLOC0Ud84w58teHbRx3OaL3QrRAVVnKaWrXJ3BtWn1fdcjJG6k1
         XPsON9DcR/M+s4QX2I0OylginOySdTYUSPE6EGpUg5pldZhi9hu9XqVuTcFMleTSzX1o
         ESqgtgFqmh7757nVWC/m06SjlsyL0MMYvgoryZBAh4sUFSFuXhAL0UDL5WxXZYOmCffR
         w1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4L+AiC0eLicjdCs0lKSHKwvFsUDXvwpfyvHmncmdtG0=;
        b=qYaLtzB2DQv1u/fcheCjVG0R6PGXb9CRx4cJehDeBaxOeob1EGHSmyeUGIgoruPq2L
         VYoVJ8t4NFXqBs+CRkweeaHUSKe5wxB3kYJZNE5YdctE0vHo+kCqU6HLU4YXF26u22oG
         ilr+JIV9VpidHI4gOz1SQ3dSnkyonlPYko/Vup+bV2DXkiOmNdf5n9yvFhF1Jd6oyFq6
         G22eP1cY5USs3QBkGOHaqxsdFbs3Yc6wNC9LktsACgNYV9Z85e5tzhWj4XKYl1O89jUN
         mPQyBsdPmcdXPqHv78mV6vLy6txgZRehqYW/3lE0JgE2ZiB732a0wJeSQ/Iky/UdbCyT
         tpuw==
X-Gm-Message-State: AOAM530/8sJr6zkadup4aZgxLCPboACHHHiIPMSoTDh5nUOjtSa8Fs8a
        pd+R2Sm8aGZwhyB4EmSHly/jU+eY/IiQZCTmtZAAzg==
X-Google-Smtp-Source: ABdhPJy3NNKEJNg0CcNPgweecOJLz/ap6xmrHxtT0vx2k1o+VchsoyMKjfN2+Zs+1+D3WObSMwe1GSt7IUhXIhUuWsc=
X-Received: by 2002:a05:6870:12d0:: with SMTP id 16mr1850025oam.304.1644692991185;
 Sat, 12 Feb 2022 11:09:51 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-5-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-5-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 11:09:39 -0800
Message-ID: <CAA03e5ECgoC-2aSdVWJOAbMjq6iFZYbswWNWnA7movt5OK5dfw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 04/10] x86: AMD SEV-ES: Pull related
 GHCB definitions and helpers from Linux
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87
>
> Suppress -Waddress-of-packed-member to allow taking addresses on struct
> ghcb / struct vmcb_save_area fields.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev.h   | 106 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/x86/svm.h       |  37 ++++++++++++++++
>  x86/Makefile.x86_64 |   1 +
>  3 files changed, 144 insertions(+)
>
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index afbacf3..ed71c18 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -18,6 +18,49 @@
>  #include "desc.h"
>  #include "asm/page.h"
>  #include "efi.h"
> +#include "processor.h"
> +#include "insn/insn.h"
> +#include "svm.h"
> +
> +struct __attribute__ ((__packed__)) ghcb {
> +       struct vmcb_save_area save;
> +       u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
> +
> +       u8 shared_buffer[2032];
> +
> +       u8 reserved_1[10];
> +       u16 protocol_version;   /* negotiated SEV-ES/GHCB protocol version */
> +       u32 ghcb_usage;
> +};
> +
> +/* SEV definitions from linux's include/asm/sev.h */

nit: "include/asm/sev.h" should be "arch/x86/include/asm/sev.h".

Also, while I feel that I like verbose comments more than many, it
might be best to skip this one. Because when this code diverges from
Linux, it's just going to cause confusion.

> +#define GHCB_PROTO_OUR         0x0001UL
> +#define GHCB_PROTOCOL_MAX      1ULL
> +#define GHCB_DEFAULT_USAGE     0ULL
> +
> +#define        VMGEXIT()                       { asm volatile("rep; vmmcall\n\r"); }
> +
> +enum es_result {
> +       ES_OK,                  /* All good */
> +       ES_UNSUPPORTED,         /* Requested operation not supported */
> +       ES_VMM_ERROR,           /* Unexpected state from the VMM */
> +       ES_DECODE_FAILED,       /* Instruction decoding failed */
> +       ES_EXCEPTION,           /* Instruction caused exception */
> +       ES_RETRY,               /* Retry instruction emulation */
> +};
> +
> +struct es_fault_info {
> +       unsigned long vector;
> +       unsigned long error_code;
> +       unsigned long cr2;
> +};
> +
> +/* ES instruction emulation context */
> +struct es_em_ctxt {
> +       struct ex_regs *regs;
> +       struct insn insn;
> +       struct es_fault_info fi;
> +};
>
>  /*
>   * AMD Programmer's Manual Volume 3
> @@ -59,6 +102,69 @@ void handle_sev_es_vc(struct ex_regs *regs);
>  unsigned long long get_amd_sev_c_bit_mask(void);
>  unsigned long long get_amd_sev_addr_upperbound(void);
>
> +static int _test_bit(int nr, const volatile unsigned long *addr)
> +{
> +       const volatile unsigned long *word = addr + BIT_WORD(nr);
> +       unsigned long mask = BIT_MASK(nr);
> +
> +       return (*word & mask) != 0;
> +}

This looks like it's copy/pasted from lib/arm/bitops.c? Maybe it's
worth moving this helper into a platform independent bitops library.

Alternatively, we could add an x86-specific test_bit implementation to
lib/x86/processor.h, where `set_bit()` is defined.

> +
> +/* GHCB Accessor functions from Linux's include/asm/svm.h */
> +
> +#define GHCB_BITMAP_IDX(field)                                                 \
> +       (offsetof(struct vmcb_save_area, field) / sizeof(u64))
> +
> +#define DEFINE_GHCB_ACCESSORS(field)                                           \
> +       static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)     \
> +       {                                                                       \
> +               return _test_bit(GHCB_BITMAP_IDX(field),                                \
> +                               (unsigned long *)&ghcb->save.valid_bitmap);     \
> +       }                                                                       \
> +                                                                               \
> +       static inline u64 ghcb_get_##field(struct ghcb *ghcb)                   \
> +       {                                                                       \
> +               return ghcb->save.field;                                        \
> +       }                                                                       \
> +                                                                               \
> +       static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)        \
> +       {                                                                       \
> +               return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;    \
> +       }                                                                       \
> +                                                                               \
> +       static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)       \
> +       {                                                                       \
> +               set_bit(GHCB_BITMAP_IDX(field),                         \
> +                         (u8 *)&ghcb->save.valid_bitmap);              \
> +               ghcb->save.field = value;                                       \
> +       }
> +
> +DEFINE_GHCB_ACCESSORS(cpl)
> +DEFINE_GHCB_ACCESSORS(rip)
> +DEFINE_GHCB_ACCESSORS(rsp)
> +DEFINE_GHCB_ACCESSORS(rax)
> +DEFINE_GHCB_ACCESSORS(rcx)
> +DEFINE_GHCB_ACCESSORS(rdx)
> +DEFINE_GHCB_ACCESSORS(rbx)
> +DEFINE_GHCB_ACCESSORS(rbp)
> +DEFINE_GHCB_ACCESSORS(rsi)
> +DEFINE_GHCB_ACCESSORS(rdi)
> +DEFINE_GHCB_ACCESSORS(r8)
> +DEFINE_GHCB_ACCESSORS(r9)
> +DEFINE_GHCB_ACCESSORS(r10)
> +DEFINE_GHCB_ACCESSORS(r11)
> +DEFINE_GHCB_ACCESSORS(r12)
> +DEFINE_GHCB_ACCESSORS(r13)
> +DEFINE_GHCB_ACCESSORS(r14)
> +DEFINE_GHCB_ACCESSORS(r15)
> +DEFINE_GHCB_ACCESSORS(sw_exit_code)
> +DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
> +DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
> +DEFINE_GHCB_ACCESSORS(sw_scratch)
> +DEFINE_GHCB_ACCESSORS(xcr0)
> +
> +#define MSR_AMD64_SEV_ES_GHCB          0xc0010130

Should this go in lib/x86/msr.h?

> +
>  #endif /* TARGET_EFI */
>
>  #endif /* _X86_AMD_SEV_H_ */
> diff --git a/lib/x86/svm.h b/lib/x86/svm.h
> index f74b13a..f046455 100644
> --- a/lib/x86/svm.h
> +++ b/lib/x86/svm.h
> @@ -197,6 +197,42 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
>         u64 br_to;
>         u64 last_excp_from;
>         u64 last_excp_to;

In upstream Linux @ 64222515138e, above the save area, there was a
change made for ES. See below. Maybe we should go ahead pull this
change from Linux while we're here adding the VMSA.

kvm-unit-tests, with this patch applied:

172         u8 reserved_3[112];
173         u64 cr4;

Linux @ 64222515138e:

245         u8 reserved_3[104];
246         u64 xss;                /* Valid for SEV-ES only */
247         u64 cr4;

> +
> +       /*
> +        * The following part of the save area is valid only for
> +        * SEV-ES guests when referenced through the GHCB or for
> +        * saving to the host save area.
> +        */
> +       u8 reserved_7[72];
> +       u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
> +       u8 reserved_7b[4];
> +       u32 pkru;
> +       u8 reserved_7a[20];
> +       u64 reserved_8;         /* rax already available at 0x01f8 */
> +       u64 rcx;
> +       u64 rdx;
> +       u64 rbx;
> +       u64 reserved_9;         /* rsp already available at 0x01d8 */
> +       u64 rbp;
> +       u64 rsi;
> +       u64 rdi;
> +       u64 r8;
> +       u64 r9;
> +       u64 r10;
> +       u64 r11;
> +       u64 r12;
> +       u64 r13;
> +       u64 r14;
> +       u64 r15;
> +       u8 reserved_10[16];
> +       u64 sw_exit_code;
> +       u64 sw_exit_info_1;
> +       u64 sw_exit_info_2;
> +       u64 sw_scratch;
> +       u8 reserved_11[56];
> +       u64 xcr0;
> +       u8 valid_bitmap[16];
> +       u64 x87_state_gpa;
>  };
>
>  struct __attribute__ ((__packed__)) vmcb {
> @@ -297,6 +333,7 @@ struct __attribute__ ((__packed__)) vmcb {
>  #define        SVM_EXIT_WRITE_DR6      0x036
>  #define        SVM_EXIT_WRITE_DR7      0x037
>  #define SVM_EXIT_EXCP_BASE      0x040
> +#define SVM_EXIT_LAST_EXCP     0x05f

nit: There is a spacing issue here. When this patch is applied, 0x05f
is not aligned with the constants above and below.

>  #define SVM_EXIT_INTR          0x060
>  #define SVM_EXIT_NMI           0x061
>  #define SVM_EXIT_SMI           0x062
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index a3cb75a..7d3eb53 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -13,6 +13,7 @@ endif
>
>  fcf_protection_full := $(call cc-option, -fcf-protection=full,)
>  COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
> +COMMON_CFLAGS += -Wno-address-of-packed-member
>
>  cflatobjs += lib/x86/setjmp64.o
>  cflatobjs += lib/x86/intel-iommu.o
> --
> 2.32.0
>
