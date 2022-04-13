Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C024FFB1D
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbiDMQ0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 12:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiDMQ0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 12:26:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D45C2E083
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:23:47 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5so2561616pjr.0
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QwAp5ZCu0p0TMnJCdnQ/4LbgDVsTeliKoklQkUbeF7w=;
        b=et9evsLEEU/rcAgWPDHaoBiVV7G0o9KpZVKCDK+aOBL5zbIwVpB03rJw9dWDX7z10T
         gQv099zyDFUd1tQiEH4fuXNpXdEQx0mM5Ns/7LcsipFIprpYX+tHo1mUbfZrQIz7bz3T
         mshp/b99zyusUpyKtFUlUMiY4T41oC1Cl+XZl3r/8m5iF//eNpED0BpE4gxJ50ezcdl7
         9oRunsWTd5u+0KNyFjg6b+PVlXaWyDU8F4qbmu69aNDl/N7BzJPlYI4s8HaRXrLQY/iL
         Hfqbpc2lLgkS/jaL/7AGwTTucRgJ/EKPouQqvs4AQLe0XYJrrpsraMr9SJFE4FVjjxB+
         3hkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwAp5ZCu0p0TMnJCdnQ/4LbgDVsTeliKoklQkUbeF7w=;
        b=1MMN96Q5JDlkDkEb4DaJgSjiUuveGXK01q0lOfXELzYI5jIAkAa+zX7+bc+BQtW3C1
         ++IBR/budH4F+O1Z0xRGxZRkX4V/er16cdIFyvl9yKU6zwdn3gnqVu/dx67Fiub1rIZF
         gebMog2jvY3zGlT/ndo6a2HyYGoLAPLlzRAJKS+3uQC2/ib4jcbWBsBfOj7CpscPEYR2
         QI6oU/5yXvTfXh3BBQgCBmmjqawdtCEc+9H1aFqqydY6b0gZjq7ZCPA60z6pbSSsAkcd
         OTx1yCgeCYyuYrV7lbMfhRn1gF1+kB7nkBtDhlxfqEcu2NE0B/ggknDVHCdcDbtGLaGM
         ZbSw==
X-Gm-Message-State: AOAM532c6we0W4Ta2f7KdXzfFP7jTq6qoXEDJGgD05D5BEyxMxzpC2lC
        alFLfYQ8wiExJeJPzo6bEnBAPw==
X-Google-Smtp-Source: ABdhPJxiI2vqfyGsL+dRzfcRIj4/k1PYT0eBHEG4z/gaKMwtVA6xeiht7i2HzK3i308XdBqbBxTGtw==
X-Received: by 2002:a17:903:2451:b0:158:7868:e93d with SMTP id l17-20020a170903245100b001587868e93dmr12384672pls.6.1649867026699;
        Wed, 13 Apr 2022 09:23:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v8-20020a056a00148800b004fa9bd7ddc9sm43527940pfu.113.2022.04.13.09.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 09:23:46 -0700 (PDT)
Date:   Wed, 13 Apr 2022 16:23:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 06/10] x86: efi: Stop using
 UEFI-provided %gs for percpu storage
Message-ID: <Ylb5DmIjc8NPjzQ9@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-7-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-7-varad.gautam@suse.com>
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

On Tue, Apr 12, 2022, Varad Gautam wrote:
> UEFI tests do not update MSR_GS_BASE during bringup, and continue
> using the GS_BASE set up by the UEFI implementation for percpu
> storage.
> 
> Update this MSR during setup_segments64() to allow storing percpu
> data at a sane location reserved by the testcase, and ensure that
> this happens before any operation that ends up storing to the percpu
> space

It's worth noting in the changelog that reset_apic() needs to be moved below
setup_gdt_tss() as it depends on per-cpu setup.  That definitely won't be obvious
to most people.

> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/setup.c      | 9 ++++++---
>  x86/efi/efistart64.S | 7 +++++++
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 7dd6677..5d32d3f 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -170,7 +170,8 @@ void setup_multiboot(struct mbi_bootinfo *bi)
>  #ifdef CONFIG_EFI
>  
>  /* From x86/efi/efistart64.S */
> -extern void setup_segments64(void);
> +extern void setup_segments64(u64 gs_base);
> +extern u8 stacktop;
>  
>  static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
>  {
> @@ -271,12 +272,14 @@ static void setup_page_table(void)
>  static void setup_gdt_tss(void)
>  {
>  	size_t tss_offset;
> +	u64 gs_base;
>  
>  	/* 64-bit setup_tss does not use the stacktop argument.  */
>  	tss_offset = setup_tss(NULL);
>  	load_gdt_tss(tss_offset);
>  
> -	setup_segments64();
> +	gs_base = (u64)(&stacktop) - (PAGE_SIZE * (pre_boot_apic_id() + 1));

Rather than follow the (IMO awful) non-EFI behavior of hijacking a chunk of the
stack, which is a symptom of doing everything in asm, since this is now C we
can declare a proper percpu array and index that.  Disclaimer, this has only been
tested with smp=1 at this point, haven't reached the end of the series :-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 6131ea2..91a06f7 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -169,6 +169,8 @@ void setup_multiboot(struct mbi_bootinfo *bi)

 #ifdef CONFIG_EFI

+static struct percpu_data __percpu_data[MAX_TEST_CPUS];
+
 static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
        int i;
@@ -285,6 +287,8 @@ static void setup_gdt_tss(void)
                     "1:"
                     :: "r" ((u64)KERNEL_DS), "i" (KERNEL_CS)
        );
+
+       wrmsr(MSR_GS_BASE, (u64)&__percpu_data[pre_boot_apic_id()]);
 }

 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
@@ -326,8 +330,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
                return status;
        }

-       reset_apic();
        setup_gdt_tss();
+       reset_apic();
        setup_idt();
        load_idt();
        mask_pic_interrupts();
