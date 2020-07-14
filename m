Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA3221E712
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 06:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgGNEl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 00:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNEl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 00:41:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DBCC061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:41:26 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m26so10574045lfo.13
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YVDgrJdHzM8uoyNTq9BgOe1+GZ11KZO3hdKYo2QdCc=;
        b=sUXZoTzjDls8yRvCgGsdck8hAHfsv05P8NLqWEbkSpeX5SlTik2hmDmnWK10Aaxbzp
         5R0ChZPCeeJ+AJ0Z8QTQpBCEuXdlivaoRdK7RUX8snzcy4QGWLSP+/wJ493tjPkSYTQn
         CYPuyqbOBJ2opxUytpNYSJ0h0belr6GW3gmmPl9qK0p9MJ3I1nl3jxZsUAt8GK/6+0Bt
         oPSzJGchmIWe1qNwyazUAfh9YIKnhuEMJP715OsNUOVa7ytBHhVTXcjHuNNDMoeyQlT5
         LCec6fxy0V9sE3O2zhNdD9fLxKrulxbgjqeYwBV2bqGp2fq3XhlSPgBi09GP4xCLh41d
         hXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YVDgrJdHzM8uoyNTq9BgOe1+GZ11KZO3hdKYo2QdCc=;
        b=PPVUnbRkXs39rYVHzUmh0JJA++CIslsB8gfZgtCVS2rdwv2zs4rcLv2sLSK9UUE1MA
         /n2KIRszXYTqD8EGcdLbfJTk0YuTANzt4sADgpquQB7L/KTyoZ5+3twmfLHuJfU8hz3C
         yorV2H8jHlKliQr0f8QM5WqdV9d6O4cEnHktDJZOQB87yCajwofIBOlea3WPoXl5DdX9
         hJbdBx23wrs7hRnwVq32oxLu3RsiAFvXasv6SnCNryCXMRRqFnCws5ZXsO/RAS/q8Gzl
         iPzD47v764MH8nSlCNsKJSZEs1QEkLcoz1ue31hpOlOpPfvIGjdFGeGu3+8xIQ/sWgXv
         Cp6A==
X-Gm-Message-State: AOAM532kHP7dbxK2S96ur2QLzNJhkDPhLN/bn2fJibFhtHdHMecL42V4
        h6+CQWkpkB1rNgd1Wjs7k1iyhNr1ewMkhWvRmncCUg==
X-Google-Smtp-Source: ABdhPJyqyGXhcZA48fv4iirhHpjrFw9JphAtThKpGNfMb88W1oe8IHuMg20ZXegU2A0QLwOKgRdNR+pxs7Q4tk3H22E=
X-Received: by 2002:a19:8253:: with SMTP id e80mr1239733lfd.199.1594701684604;
 Mon, 13 Jul 2020 21:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200714002355.538-1-sean.j.christopherson@intel.com> <20200714002355.538-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200714002355.538-3-sean.j.christopherson@intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 13 Jul 2020 21:41:13 -0700
Message-ID: <CAOQ_QsiUPnD3BAefMm=D8tusJc9a7Rp1xC31RQJSWmqYLEPa6Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] nVMX: Use the standard non-canonical
 value in test_mtf3
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 5:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use the standard non-canonical value of repeating 'a' instead of a
> custom (1 << 63) value in test_mtf3.  When PCID is enabled, bit 63 is
> a flag that controls TLB swithching on MOV CR3 and is not included in
> the canonical check of CR3, i.e. if CR4.PCIDE=1 then the test will load
> 0 into CR3 and all manner of confusion things happen.
>
> Fixes: 46cc038c6afb8 ("x86: VMX: Add tests for monitor trap flag")
> Cc: Oliver Upton <oupton@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  x86/vmx_tests.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index cb42a2d..32e3d4f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5107,7 +5107,7 @@ static void test_mtf_guest(void)
>               * MOV RAX is done before the VMCALL such that MTF is only enabled
>               * for the instruction under test.
>               */
> -            "mov $0x8000000000000000, %rax;\n\t"
> +            "mov $0xaaaaaaaaaaaaaaaa, %rax;\n\t"
>              "vmcall;\n\t"
>              "mov %rax, %cr3;\n\t"
>              "test_mtf3:\n\t"
> --
> 2.26.0
>
