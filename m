Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C8F44DB81
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhKKSV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbhKKSVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 13:21:50 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9F0C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:19:01 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id x10so8034225ioj.9
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xx4rnLukH63BA1dsCAAfgQ0vMXXRjT66zoQDivL5INE=;
        b=UfGiPPORZYo7oNRFti+yU3zFk1Pg7REobC38MITBnSxw7i4nByt2LTQM6Xi4WrLEDB
         OHdF4pIJxR78Nm0Bl2v7qiMJZpk3w6AJ+iCRfhFdbAXLjWihdscg3rt1Gk8iE27TxWAb
         cDNBA85SwHI03oQnxg+GWYLynZLfshZ60u/5AyUgx1KSqaZgdz22zyqvPTHEb1fDENoY
         +dIYJzWcXAhOvzlU5/TxHizUs9k460fdqc45TtUzJV2Lz1g1tfD2rrr5l+n54sF2cAHN
         Y2fEDIx5Js+Dcq87aSxKOxB4AmGQaeA8MjEuwzX6vpiRztRD6mfQE7E1oEnNQh+kA1Db
         fRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xx4rnLukH63BA1dsCAAfgQ0vMXXRjT66zoQDivL5INE=;
        b=jpXQn/HbRCVLb1Byt9dnmfnH41SZuWRWGMU/KyWnbnAAxpeHLVOqBjVfHjVOMvIRYf
         av1wWmH3c57UdTYjnvYdv9KdVeRku/DKGMdr6kr2dAipayQ+SQYNHdSWRK3nmfOkqQ0Q
         njKIHCN6NELOY9AEI1D3i90CDQx7Jj0oO5NnWkULLeDvBvPWcwyCFpmF5ynrRStqgmpl
         4m2RQPrtaMwF+5ixJ4wGptD8pRBSNuFnlfll95Y1egbRvHmd50U0rpOXBv2xYCqwg92B
         jnd0ACiPr+80QhwpbRJHDt3bT6IxNj/VyUT+lGieYvmueJfGgw08ceLeC01JLGfHQbdw
         Qljg==
X-Gm-Message-State: AOAM532Kc0D9TsAKgGgyszmDGuAnW/aj16K3VRIO115+aloNI0/EZ/Ic
        yVJCN0PhZ6S5QUFyjgrv6A/Sl4d+6dVZjcRetnm3cw==
X-Google-Smtp-Source: ABdhPJym1kXVuIwUPlwHWc97aEsoc9OP4IWka2OeUEM3LoKeLQsnw5DVlFo6wycMAcZz02hIrLBK3LxQBllCGAPTAJk=
X-Received: by 2002:a05:6638:35a0:: with SMTP id v32mr6881399jal.61.1636654740441;
 Thu, 11 Nov 2021 10:19:00 -0800 (PST)
MIME-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com> <20211111001257.1446428-5-dmatlack@google.com>
In-Reply-To: <20211111001257.1446428-5-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 10:18:49 -0800
Message-ID: <CANgfPd-sWiOEHiDzGLwGYZSMEShiMAXCyPj7z40jgXyDt0j1Ww@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Use perf_test_destroy_vm in memslot_modification_stress_test
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 4:13 PM David Matlack <dmatlack@google.com> wrote:
>
> Change memslot_modification_stress_test to use perf_test_destroy_vm
> instead of manually calling ucall_uninit and kvm_vm_free.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/memslot_modification_stress_test.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 5bd0b076f57f..1410d0a9141a 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -116,8 +116,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         perf_test_join_vcpu_threads(nr_vcpus);
>         pr_info("All vCPU threads joined\n");
>
> -       ucall_uninit(vm);
> -       kvm_vm_free(vm);
> +       perf_test_destroy_vm(vm);
>  }
>
>  static void help(char *name)
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
