Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77C1E8D19
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgE3CIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbgE3CIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:08:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC6C08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id r2so1403886ioo.4
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dN58wg3nEA9rldEIDlifhFJsdB2tbWLhvBZmgq9Fpto=;
        b=Jc2Qe6+f9rFpviKD4nVc6kV2khBM7inMHFWAV3Qm7elegCyxfFVGRcHxq/J5owBV9A
         egyoxYdPg1H2AIlEMxnpjmMPHeHiQKkgUbIqwOPMiYRs3tSXA2Sjzusa1G0yAVs4dqZZ
         CO7TCR7OWs4/RiupwbIJ2b7RmXY/B+M+KWJfbBjAMug9uObCEovwWRaXncVxCJJxVPYn
         JLXBWYvXIgwL9CNTPYf5KgIRkL5kyH3XFB09fgsGsHbEeWsjRbQTfAekrHqR/3XkY35X
         yfjk+NKpW1qLplGRy1FMilzF5bB1wCIN4VFojLsza5qGdLcAhnSAK7niB48Tm3wsklca
         fF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dN58wg3nEA9rldEIDlifhFJsdB2tbWLhvBZmgq9Fpto=;
        b=lnXL3CTKx31P0av7Vthy9HCjwCeBKvMyIhzPKxUaueFWCwuqLzuGKmr8IvBP25qQHV
         2qsd/7KJJM6iwq5X5FfK+jO+JBjeEio6H8KX+IaRP8H1nRJieBRo/jYo3xZY3XyV7Koy
         AaDR0H9oeDnnfxvjPrnvClV7G3abJP/9MF5iyRQVIykZHK8ily4OBxdgC92KFk0IFv4b
         lXjoAbr9BwoSnOHW5K9iAWac/odYowp0Oqkan+xMVeyICcazd/qv5k/OY/v1jGC5QbMi
         vXKDgEkmWhmvUBzidoegHT1PdSwNdymrCV1f1+MAZC2gU7PJSME1ATwqiN+FFJX/eewx
         EbFw==
X-Gm-Message-State: AOAM532jkOb/QiUKt11E2aPrZKecLkn8Lt+i15wGACOUXHjg7orcMdkv
        PCuLdxWG5o7f7EpIAM6M8TDgx2hvhgNBlBDlDIb6QQ==
X-Google-Smtp-Source: ABdhPJwIZ0rq8DVrs10SZZhuOkSscD7hplgkOhNO5MiFM9hNmmv+Q9+faNxj8iyeSPJZafjcQlb3UDI9l1joNcRFQKk=
X-Received: by 2002:a5d:8914:: with SMTP id b20mr9520538ion.34.1590804527793;
 Fri, 29 May 2020 19:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <02cde03d5754c84cfa0dc485f62d85507a2a9dd5.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <02cde03d5754c84cfa0dc485f62d85507a2a9dd5.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:08:11 -0700
Message-ID: <CABayD+dTB-XbR6=FVYdn3FuCzrn-M_Y-pfLxky3WhCkKFmu+pw@mail.gmail.com>
Subject: Re: [PATCH v8 16/18] KVM: x86: Mark _bss_decrypted section variables
 as decrypted in page encryption bitmap.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:20 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Ensure that _bss_decrypted section variables such as hv_clock_boot and
> wall_clock are marked as decrypted in the page encryption bitmap if
> sev liv migration is supported.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kernel/kvmclock.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 34b18f6eeb2c..65777bf1218d 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -334,6 +334,18 @@ void __init kvmclock_init(void)
>         pr_info("kvm-clock: Using msrs %x and %x",
>                 msr_kvm_system_time, msr_kvm_wall_clock);
>
> +       if (sev_live_migration_enabled()) {
> +               unsigned long nr_pages;
> +               /*
> +                * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
> +                */
> +               early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
> +                                               1, 0);
> +               nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
> +               early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
> +                                               nr_pages, 0);
> +       }
> +
>         this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
>         kvm_register_clock("primary cpu clock");
>         pvclock_set_pvti_cpu0_va(hv_clock_boot);
> --
> 2.17.1
>

Reviewed-by: Steve Rutherford <srutherford@google.com>
