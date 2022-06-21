Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CBE553964
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 20:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiFUSLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 14:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiFUSLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 14:11:32 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2841E19006
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 11:11:30 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j21so10620808lfe.1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OSsNJ8sjhHVo8wfzEftOtkr5HcPtOIMNqFox2iufIY=;
        b=KfpRIF7uvdbQP1hWnFLJ+wpZPfbpqsrugXnGuBN4Y2LuuBPaadL720Ip9F4FODWsdT
         VM2j0PB8vjwQRVjuQToTj6i29KrZVTNE+QMAvS3+6HqT9yurtX34jlaqW6+JLTqkHKPa
         skmol3spbDfgOnTVWWODiSdu/2ZDcdYZhc0h5mQBzLxrzbKg2HAM8W4laB/s5SWWc9VM
         iBFc1MaF6aaxT4b8v1GCvc9D1YL01eGPpZyzbtsnzaZBQRZTYWCcih8VNdNv1wdRcaKP
         uA2sE9f38hN0pSnYgZaS3peHv6Gu5t6F6GktqAdvmdJS19+hl6JgNbGekkmN2ZsCd2Z/
         sDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OSsNJ8sjhHVo8wfzEftOtkr5HcPtOIMNqFox2iufIY=;
        b=A7sV9cfz1Mn4J3ZUq1x0QRTpRperUpVwzv02DQu0atmhXvISzpRRXHQQIJJJ33j1br
         EK1/kvlS/4f8lpN/sloUU1j/R/mTkcPm3xcp1l/lIjSSbuBI9rReiLql99vBA8gOB9rX
         WHztmO2WV3giBzz2sgb8llKbzjsUO4KwqK+X4OP6nex7INdEm93CiEPtaUOm9gLuEElv
         Z41sOZ9cqL2hGD8nabqc1PEUt9o+vudgukU8BSI8pzBgt+LcrllBHmfTaOCbbaD3FIqZ
         eQG32IAvxsOomzxUgR7AmGNSPFgzZUkPlTuPIwxG7+4GIvMJMx94uKt7twUwuI3NR4tW
         QseA==
X-Gm-Message-State: AJIora8O+/XV3mMCcVeI5w18PC0wFOZejJVUiOpOZ2BIX0W+hs8iWUR/
        Tcfica1qwuJplPn4k9NBE3c8DSnzwcLRy9DeEUdAnA==
X-Google-Smtp-Source: AGRyM1u3cNzkcdbb03ARGSv06yGgZax05RL/7AWsD9zEB9NhJk5fSjh68eGxcM8/9z7NrHB5xxdny2TUaHEWAkam0zc=
X-Received: by 2002:a05:6512:401a:b0:47f:6ea5:dace with SMTP id
 br26-20020a056512401a00b0047f6ea5dacemr6981952lfb.402.1655835088052; Tue, 21
 Jun 2022 11:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 12:11:16 -0600
Message-ID: <CAMkAt6ruxMazN3NmWHsemDNQj6Uj0PhCVeaxw2unCxU=YZFRWw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
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

On Mon, Jun 20, 2022 at 5:05 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
>
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satify new requirements for the SNP. Continue

satisfy

> allocating a 1mb region for !SNP configuration.
>
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 173 +++++++++++++++++++++++++++++++++--
>  include/linux/psp-sev.h      |  11 +++
>  2 files changed, 178 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 35d76333e120..0dbd99f29b25 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -79,6 +79,14 @@ static void *sev_es_tmr;
>  #define NV_LENGTH (32 * 1024)
>  static void *sev_init_ex_buffer;
>
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
> +#define SEV_SNP_ES_TMR_SIZE    (2 * 1024 * 1024)
> +
> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;

Why not keep all this TMR stuff together near the SEV_ES_TMR_SIZE define?

> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +static int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>         struct sev_device *sev = psp_master->sev_data;
> @@ -177,11 +185,161 @@ static int sev_cmd_buffer_len(int cmd)
>         return 0;
>  }
>
> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)
> +{
> +       WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
> +       while (npages--) {
> +               memory_failure(pfn, 0);
> +               dump_rmpentry(pfn);
> +               pfn++;
> +       }
> +}
> +
> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
> +{
> +       struct sev_data_snp_page_reclaim data;
> +       int ret, err, i, n = 0;
> +
> +       for (i = 0; i < npages; i++) {

What about setting |n| here too, also the other increments.

for (i = 0, n = 0; i < npages; i++, n++, pfn++)

> +               memset(&data, 0, sizeof(data));
> +               data.paddr = pfn << PAGE_SHIFT;
> +
> +               if (locked)
> +                       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +               else
> +                       ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);

Can we change `sev_cmd_mutex` to some sort of nesting lock type? That
could clean up this if (locked) code.

> +               if (ret)
> +                       goto cleanup;
> +
> +               ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (ret)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /*
> +        * If failed to reclaim the page then page is no longer safe to
> +        * be released, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +       return ret;
> +}
> +
> +static inline int rmp_make_firmware(unsigned long pfn, int level)
> +{
> +       return rmp_make_private(pfn, 0, level, 0, true);
> +}
> +
> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> +                            bool need_reclaim)

This function can do a lot and when I read the call sites its hard to
see what its doing since we have a combination of arguments which tell
us what behavior is happening, some of which are not valid (ex: to_fw
== true and need_reclaim == true is an invalid argument combination).
Also this for loop over |npages| is duplicated from
snp_reclaim_pages(). One improvement here is that on the current
snp_reclaim_pages() if we fail to reclaim a page we assume we cannot
reclaim the next pages, this may cause us to snp_leak_pages() more
pages than we actually need too.

What about something like this?

static snp_leak_page(u64 pfn, enum pg_level level)
{
   memory_failure(pfn, 0);
   dump_rmpentry(pfn);
}

static int snp_reclaim_page(u64 pfn, enum pg_level level)
{
  int ret;
  struct sev_data_snp_page_reclaim data;

  ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
  if (ret)
    goto cleanup;

  ret = rmp_make_shared(pfn, level);
  if (ret)
    goto cleanup;

return 0;

cleanup:
    snp_leak_page(pfn, level)
}

typedef int (*rmp_state_change_func) (u64 pfn, enum pg_level level);

static int snp_set_rmp_state(unsigned long paddr, unsigned int npages,
rmp_state_change_func state_change, rmp_state_change_func cleanup)
{
  struct sev_data_snp_page_reclaim data;
  int ret, err, i, n = 0;

  for (i = 0, n = 0; i < npages; i++, n++, pfn++) {
    ret = state_change(pfn, PG_LEVEL_4K)
    if (ret)
      goto cleanup;
  }

  return 0;

cleanup:
  for (; i>= 0; i--, n--, pfn--) {
    cleanup(pfn, PG_LEVEL_4K);
  }

  return ret;
}

Then inside of __snp_alloc_firmware_pages():

snp_set_rmp_state(paddr, npages, rmp_make_firmware, snp_reclaim_page);

And inside of __snp_free_firmware_pages():

snp_set_rmp_state(paddr, npages, snp_reclaim_page, snp_leak_page);

Just a suggestion feel free to ignore. The readability comment could
be addressed much less invasively by just making separate functions
for each valid combination of arguments here. Like
snp_set_rmp_fw_state(), snp_set_rmp_shared_state(),
snp_set_rmp_release_state() or something.

> +{
> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
> +       int rc, n = 0, i;
> +
> +       for (i = 0; i < npages; i++) {
> +               if (to_fw)
> +                       rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
> +               else
> +                       rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
> +                                           rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (rc)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /* Try unrolling the firmware state changes */
> +       if (to_fw) {
> +               /*
> +                * Reclaim the pages which were already changed to the
> +                * firmware state.
> +                */
> +               snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
> +
> +               return rc;
> +       }
> +
> +       /*
> +        * If failed to change the page state to shared, then its not safe
> +        * to release the page back to the system, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +
> +       return rc;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
> +{
> +       unsigned long npages = 1ul << order, paddr;
> +       struct sev_device *sev;
> +       struct page *page;
> +
> +       if (!psp_master || !psp_master->sev_data)
> +               return NULL;
> +
> +       page = alloc_pages(gfp_mask, order);
> +       if (!page)
> +               return NULL;
> +
> +       /* If SEV-SNP is initialized then add the page in RMP table. */
> +       sev = psp_master->sev_data;
> +       if (!sev->snp_inited)
> +               return page;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, true, locked, false))
> +               return NULL;

So what about the case where snp_set_rmp_state() fails but we were
able to reclaim all the pages? Should we be able to signal that to
callers so that we could free |page| here? But given this is an error
path already maybe we can optimize this in a follow up series.

> +
> +       return page;
> +}
> +
> +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> +{
> +       struct page *page;
> +
> +       page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> +
> +       return page ? page_address(page) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> +
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +       unsigned long paddr, npages = 1ul << order;
> +
> +       if (!page)
> +               return;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, false, locked, true))
> +               return;

Here we may be able to free some of |page| depending how where inside
of snp_set_rmp_state() we failed. But again given this is an error
path already maybe we can optimize this in a follow up series.



> +
> +       __free_pages(page, order);
> +}
> +
> +void snp_free_firmware_page(void *addr)
> +{
> +       if (!addr)
> +               return;
> +
> +       __snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL(snp_free_firmware_page);
> +
>  static void *sev_fw_alloc(unsigned long len)
>  {
>         struct page *page;
>
> -       page = alloc_pages(GFP_KERNEL, get_order(len));
> +       page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), false);
>         if (!page)
>                 return NULL;
>
> @@ -393,7 +551,7 @@ static int __sev_init_locked(int *error)
>                 data.tmr_address = __pa(sev_es_tmr);
>
>                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -               data.tmr_len = SEV_ES_TMR_SIZE;
> +               data.tmr_len = sev_es_tmr_size;
>         }
>
>         return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -421,7 +579,7 @@ static int __sev_init_ex_locked(int *error)
>                 data.tmr_address = __pa(sev_es_tmr);
>
>                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -               data.tmr_len = SEV_ES_TMR_SIZE;
> +               data.tmr_len = sev_es_tmr_size;
>         }
>
>         return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> @@ -818,6 +976,8 @@ static int __sev_snp_init_locked(int *error)
>         sev->snp_inited = true;
>         dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>
> +       sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>         return rc;
>  }
>
> @@ -1341,8 +1501,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>                 /* The TMR area was encrypted, flush it from the cache */
>                 wbinvd_on_all_cpus();
>
> -               free_pages((unsigned long)sev_es_tmr,
> -                          get_order(SEV_ES_TMR_SIZE));
> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +                                         get_order(sev_es_tmr_size),
> +                                         false);
>                 sev_es_tmr = NULL;
>         }
>
> @@ -1430,7 +1591,7 @@ void sev_pci_init(void)
>         }
>
>         /* Obtain the TMR memory area for SEV-ES use */
> -       sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +       sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
>         if (!sev_es_tmr)
>                 dev_warn(sev->dev,
>                          "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 9f921d221b75..a3bb792bb842 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -12,6 +12,8 @@
>  #ifndef __PSP_SEV_H__
>  #define __PSP_SEV_H__
>
> +#include <linux/sev.h>
> +
>  #include <uapi/linux/psp-sev.h>
>
>  #ifdef CONFIG_X86
> @@ -940,6 +942,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
>  int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
>
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
> @@ -981,6 +985,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
>         return -ENODEV;
>  }
>
> +static inline void *snp_alloc_firmware_page(gfp_t mask)
> +{
> +       return NULL;
> +}
> +
> +static inline void snp_free_firmware_page(void *addr) { }
> +
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>
>  #endif /* __PSP_SEV_H__ */
> --
> 2.25.1
>
