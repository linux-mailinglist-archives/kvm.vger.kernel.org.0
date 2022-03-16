Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC504DB7C1
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 19:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348473AbiCPSIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 14:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiCPSIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 14:08:47 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574254D9CF
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:07:33 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v130so5820293ybe.13
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PnmkVyhkE9O12y1T9viSC5Yt4nwOSPLkRDwt3vG/CDc=;
        b=LjuosIEEYYEzAVjUbeyd05n+XRZzzyXQNWGnpxPY2Xw5NcS8D/uvf0EdccSmRJXhKb
         VpxTrEcAMFfOx+DDZGxmQq5X9JqfajNjpZ5oh9YWlyb5XlHxa/e/rgKthm6WmIYj32eH
         mFwav9CCGijv6u7q9+Vsfemo5DDQ58bYM1D38UTdt+0Jv/K0UzeDfncjWD3T+NurGmRP
         KKmJ/jOKi+kl9wQaNhs75a998Db2r2mVDjCdyQkNxWPakeWljy3n5t0Cc9bE6cio7KZy
         BT7qh5hXsLc/8tcJopJD7VEVUlEbMUKZO7CGstjRGP7gfreFy2KLA5m30PoD+ocDI6FR
         FGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PnmkVyhkE9O12y1T9viSC5Yt4nwOSPLkRDwt3vG/CDc=;
        b=CLBk4qd4VzLhrTyBViFViLHlZNOPECtXO16ikg3yimf5NiMUhSrG9uhFWJ8XkwqVf0
         UDhKuYrnJqtcWLVfZTPc2bkMvTyovv/JHQTHAHoB5arDhG35fAtyCu4v1VsuFNz4Kmvu
         YfGFEe/hucRA0ubkvjwmt9KMnombCDG5Y3uqJE3/iLGw10yyBvUsjg8q0meukQImW9ah
         Ib47Un8VM6WDnX1O27f6dSP7BhHE5HOcqqBHyReGzY9/YuJ0PXkq+QFvyNRBJ49PY1Ty
         iLoGQ/5aoa0VqgcDeWyIOJWHrzDMlzQpmV/I6xZc6wr3J/3qNrF/XLKBEy5xyp+xmd81
         jWCQ==
X-Gm-Message-State: AOAM532ViHqq9R1WhODZgt7fYF8YH+kjoZUiCbSK9hl19kRDrvwNSsje
        yPmNdDRkPgSTmwF/nfMhcXFigHYS6z+uC+y+hhKJuQ==
X-Google-Smtp-Source: ABdhPJyyXFoQn1uerPs5goPnQmblKmVx5IKBTpH/PqBXtW4BaLiDyXA8LgJB5YBszNuVqJzUMU8TQOGvQDlBfaX/Z0A=
X-Received: by 2002:a25:d191:0:b0:628:79ad:1e61 with SMTP id
 i139-20020a25d191000000b0062879ad1e61mr1147185ybg.255.1647454052316; Wed, 16
 Mar 2022 11:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com> <20220311060207.2438667-5-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-5-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 16 Mar 2022 12:07:21 -0600
Message-ID: <CANgfPd8u_K3cOpaUPY8+rU+4RFehj8J61gdzuDyOZv4dSDZ+xQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
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

On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

This is very similar to one of the patches in the NX hugepages control
series I sent out last week, I guess we both had similar needs at the
same time.
Your solution introduces way less churn though, so it's probably
better. I might use this commit or wait for it to be merged before I
send out v2 of my NX control series.

In any case,
Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index d6acec0858c0..c8dce12a9a52 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>                               vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>
>  /*
>   * Create a VM with reasonable defaults
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 64ef245b73de..ae21564241c8 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +                       pt_memslot);
> +}
> +
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -       return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +       return vm_alloc_page_table_in_memslot(vm, 0);
>  }
>
>  /*
> --
> 2.35.1.723.g4982287a31-goog
>
