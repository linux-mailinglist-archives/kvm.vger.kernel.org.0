Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41EB558AC2
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiFWVad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiFWVab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:30:31 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6151527F4
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:30:29 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l9-20020a056830268900b006054381dd35so469952otu.4
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqoxMpiX3Gf231GDDR9G1b2VInfGIDsRQZcWz3Knh/w=;
        b=duKobLilhDL22sXP3vyLSU2BHZyOr2DEfkeMxf1DgR3Y/mj/UVxd0/FjJUWSHAAhF4
         XTmHTTtJ09Tc1kjquB/l2p06WXyLcldCI7l+B1aOGxHYCGylgl5hK/cz8djVlrS99/Nr
         peXeW1qWKBk2LQb9EaWYmlaQtVSHHNeozxFZ7bisTPZYO06jVn/y8jw5yMvtmv9QQGvW
         29rCl/n6tRgPnRQHVL6RARL+BabO2B3TUqdT8CbdsbKSLtDlnLif4+yL93OesaPwN8ct
         z14R8ml2C+fezKONoCirxhP//Xcsvd2aU3wfL+yQgZyNsA7xlKXGztw4TdQ2Fwe/OGE6
         fseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqoxMpiX3Gf231GDDR9G1b2VInfGIDsRQZcWz3Knh/w=;
        b=zL1Kv2B7i7wz5+PE8icsfMNoI90fTjw7x2SrrvIDLxZa7agIPvdsFtVoJduoEuq3bI
         R5FvAdW5KQg3kOE1SXKLyz8fL2H18vb9KSxZPim4i++R9tluf/Sg6flYNULdtMPF02sT
         OVRqdUiKxmktAF6lWhTU22rvYl0UNGnIrErzuD3Ii+NQ7qX/qME3YlictRCVJ572vnnV
         q+f0BPzq66Qbggs0y5+KIw80Q+3U2dzMSYfIsYpdeWkzdH+4S8J+WojWas7s+VYXmS0v
         Q038S8FpM1ljoFTSO2ztFKgAy07HFuKTex7nauRlVoCBl5EH5chrBceIocp3NMNva2ds
         eQfw==
X-Gm-Message-State: AJIora9ObfbueJ5a28w1VMFOfz19X8hoUFz8EptZEWU+FGG38pkOAnNu
        iF4qcyaX7IsQJFdI9GsKEPlVjaF/QEajZyrLoIwKzw==
X-Google-Smtp-Source: AGRyM1veXOvim13DoOcVFPocfJu+YK8saHoB9/PkjheoBqMOiwNRF5W/rzCDzSmOj5ZWh6liga9mLs9vDiTICXpTFwY=
X-Received: by 2002:a9d:5888:0:b0:606:10d2:2fc1 with SMTP id
 x8-20020a9d5888000000b0060610d22fc1mr4691492otg.29.1656019828771; Thu, 23 Jun
 2022 14:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <8f63961f00fd170ba0e561f499292175f3155d26.1655761627.git.ashish.kalra@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Jun 2022 14:30:17 -0700
Message-ID: <CAA03e5E==P_Ua6UBz+ZBBMkmhSpacZR-z+5OvObpErk09xCfuA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
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

On Mon, Jun 20, 2022 at 4:02 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> entry for a given page. The RMP entry format is documented in AMD PPR, see
> https://bugzilla.kernel.org/attachment.cgi?id=296015.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 27 ++++++++++++++++++++++++
>  arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
>  include/linux/sev.h        | 30 ++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
>  create mode 100644 include/linux/sev.h
>
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 9c2d33f1cfee..cb16f0e5b585 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -9,6 +9,7 @@
>  #define __ASM_ENCRYPTED_STATE_H
>
>  #include <linux/types.h>
> +#include <linux/sev.h>
>  #include <asm/insn.h>
>  #include <asm/sev-common.h>
>  #include <asm/bootparam.h>
> @@ -84,6 +85,32 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K                 0
> +#define RMP_TO_X86_PG_LEVEL(level)     (((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +
> +/*
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
> +struct __packed rmpentry {
> +       union {
> +               struct {
> +                       u64     assigned        : 1,
> +                               pagesize        : 1,
> +                               immutable       : 1,
> +                               rsvd1           : 9,
> +                               gpa             : 39,
> +                               asid            : 10,
> +                               vmsa            : 1,
> +                               validated       : 1,
> +                               rsvd2           : 1;
> +               } info;
> +               u64 low;
> +       };
> +       u64 high;
> +};
> +
> +#define rmpentry_assigned(x)   ((x)->info.assigned)
> +#define rmpentry_pagesize(x)   ((x)->info.pagesize)
>
>  #define RMPADJUST_VMSA_PAGE_BIT                BIT(16)
>
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 25c7feb367f6..59e7ec6b0326 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -65,6 +65,8 @@
>   * bookkeeping, the range need to be added during the RMP entry lookup.
>   */
>  #define RMPTABLE_CPU_BOOKKEEPING_SZ    0x4000
> +#define RMPENTRY_SHIFT                 8
> +#define rmptable_page_offset(x)        (RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
>
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
> @@ -2386,3 +2388,44 @@ static int __init snp_rmptable_init(void)
>   * available after subsys_initcall().
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +       unsigned long vaddr, paddr = pfn << PAGE_SHIFT;
> +       struct rmpentry *entry, *large_entry;
> +
> +       if (!pfn_valid(pfn))
> +               return ERR_PTR(-EINVAL);
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +               return ERR_PTR(-ENXIO);

nit: I think we should check if SNP is enabled first, before doing
anything else. In other words, I think we should move this check above
the `!pfn_valid()` check.

> +
> +       vaddr = rmptable_start + rmptable_page_offset(paddr);
> +       if (unlikely(vaddr > rmptable_end))
> +               return ERR_PTR(-ENXIO);

nit: It would be nice to use a different error code here, from the SNP
feature check. That way, if this function fails, it's easier to
diagnose where the function failed from the error code.

> +
> +       entry = (struct rmpentry *)vaddr;
> +
> +       /* Read a large RMP entry to get the correct page level used in RMP entry. */
> +       vaddr = rmptable_start + rmptable_page_offset(paddr & PMD_MASK);
> +       large_entry = (struct rmpentry *)vaddr;
> +       *level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
> +
> +       return entry;
> +}
> +
> +/*
> + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
> + * and -errno if there is no corresponding RMP entry.
> + */
> +int snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +       struct rmpentry *e;
> +
> +       e = __snp_lookup_rmpentry(pfn, level);
> +       if (IS_ERR(e))
> +               return PTR_ERR(e);
> +
> +       return !!rmpentry_assigned(e);
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> diff --git a/include/linux/sev.h b/include/linux/sev.h
> new file mode 100644
> index 000000000000..1a68842789e1
> --- /dev/null
> +++ b/include/linux/sev.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AMD Secure Encrypted Virtualization
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#ifndef __LINUX_SEV_H
> +#define __LINUX_SEV_H
> +
> +/* RMUPDATE detected 4K page and 2MB page overlap. */
> +#define RMPUPDATE_FAIL_OVERLAP         7
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +int snp_lookup_rmpentry(u64 pfn, int *level);
> +int psmash(u64 pfn);
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
> +int rmp_make_shared(u64 pfn, enum pg_level level);

nit: I think the declarations for `psmash()`, `rmp_make_private()`,
and `rmp_make_shared()` should be introduced in the patches that have
their definitions.

> +#else
> +static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
> +static inline int psmash(u64 pfn) { return -ENXIO; }
> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
> +                                  bool immutable)
> +{
> +       return -ENODEV;
> +}
> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +
> +#endif /* CONFIG_AMD_MEM_ENCRYPT */
> +#endif /* __LINUX_SEV_H */
> --
> 2.25.1
>
