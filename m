Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1E3182D0
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 01:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhBKAyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 19:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhBKAx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 19:53:29 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6918C0613D6
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:52:49 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id o15so2689758ilt.6
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8N9hPSbBu5axkXydL7by5ffIfcZ5d4zvwt+JbttAFg=;
        b=Z6E3jYo8SXInmt+VQduKkHUsMGMP8M1WWWItAepulVPM18vllH/qJOyrs0+LxyW4/i
         IFtNhPIK6xkYHujt1/Q5bOZop475K2CeaG/rYSqYg2QlHaA3M55KUsXwDGi0U7M4rTfB
         2EaXoj7oe+sepcoxLiG0ZNIIdImxYD6M/257nRA6TLuYuG/HkplYGLbNff6MnFDtuFf0
         iBcUAZ95j15uX0Ek6JEyKtRlxoihg6ytWkjr1bEjYE+oRBhui/v9AEwWq3Do7L98PwAg
         abN38cf+7L4FvbyS4l2RocfRexRTG2EZ2l7Zalp63XZO16qp976IOC+0oIFjClyrBJbd
         +HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8N9hPSbBu5axkXydL7by5ffIfcZ5d4zvwt+JbttAFg=;
        b=UqgUhGpW2y+yJ4lE/wuZ5EdR0pJjxt42oEACA0OuJJXTIovZv3Vd/+y2CK8sBQr8B/
         GSGFzLRgkC8oersDfFHJpkYgwjjrGpUA3gbmZRnZrg+3tWBug+T8lk3n8wvr4+Hxc6Bw
         /PP7Fw5V5fOpHtM032Uu73IANwFo8iCpB1y7tG1jv1Q5DV/+PM7a6pRNnrItIxorXNN7
         TIVi7u6zIo0pHAJmwOfkYKmpNwLofsV0fRnMkmaCpYUiykZBzc/W5pGY/z84QhyESHsc
         3lgLaoVbk1kLrGvo+hRgpMkbV5eQ9eA+DgaOUN2B7/IbsQlGfl/omTaehLaR6oljW/wy
         Cdbg==
X-Gm-Message-State: AOAM531WBCfGOXv7ln7zzx0ALbWMtHIMhR9ImGRQV/rmjz0RKm/XS9aj
        tXg2eYQGoaqSMhWnCKVH/+2xNRDND8UQJvXTXZez1A==
X-Google-Smtp-Source: ABdhPJwJvt0uUQvh/UMgQHG+oW5Vwa7L0sy+WKKMNFnZ81BGJ20vc1ltaCpJT4cGZiayoqAuf26/Dj5PgNtgeqfJZ3c=
X-Received: by 2002:a92:c54e:: with SMTP id a14mr1089471ilj.285.1613004769134;
 Wed, 10 Feb 2021 16:52:49 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-4-seanjc@google.com>
In-Reply-To: <20210210230625.550939-4-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 16:52:38 -0800
Message-ID: <CANgfPd_ozRcsXR9_SsZpEk3_q6epL--=8FbktygNnCKLi5W5Cw@mail.gmail.com>
Subject: Re: [PATCH 03/15] KVM: selftests: Align HVA for HugeTLB-backed memslots
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Align the HVA for HugeTLB memslots, not just THP memslots.  Add an
> assert so any future backing types are forced to assess whether or not
> they need to be aligned.
>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 584167c6dbc7..deaeb47b5a6d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -731,8 +731,11 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>         alignment = 1;
>  #endif
>
> -       if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> +       if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
> +           src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
>                 alignment = max(huge_page_size, alignment);
> +       else
> +               ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
>
>         /* Add enough memory to align up if necessary */
>         if (alignment > 1)
> --
> 2.30.0.478.g8a0d178c01-goog
>
