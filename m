Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2583898B8
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhESVmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESVmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:42:39 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEA6C061760
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:41:17 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k16so14506463ios.10
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vgT0cqueYQ35F17EV/w98BJe637HcCWQdSVrM36k57w=;
        b=VS1DsELVUEQIwSJav2W6pVmjTqUn2kC1U0SVlMpEK2GjPoZHGQSfHqu0b/pyG/e3Z9
         vEQg5iVNlrrAg+sG6zrMYLkqdyCJ/tgrUTY5lWek7BzbUjrnC1brA4wokElk642gqR1V
         nYagZSM0XLKtX8czDHmfwkrQZDhgU1IvTa0KYZOY+3OFrlrUERE9LB1HzE6uNddg+nZq
         1R9AVmQbZr4ZICEpe9r3DUsdpUzSEGkgDDC99RHHo5w7GQHRMUbuyn6wPL88ChQX7QR+
         NNSd4GPidClzDDJEY9rHP/DDy1bVNbLpY3c7PsQ9CN4jdF6j8YzjDrGTuWl9V6EX8ovk
         GXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vgT0cqueYQ35F17EV/w98BJe637HcCWQdSVrM36k57w=;
        b=Sd5eTyNELNugiIcQZy5QeSzaj+YhShqA6/QXo03DW4rW2gTHJned0NM4FaUtIo810l
         i09IzwE83KvdPrsWuqnUclOSdSyylV8YeGdAaD01Iw4hQqG1tDKPZMTNHOLN1YVOw5Ug
         WYn//mIK4v9GLwlXL+70ktKefhtlbB5oy/QKmv+edSk4jRO3Z81eDKsAIuxb8QqNC/Ey
         9xiZUGDIgkRksWnyJufcm4alTMJIA3HcsHPiactZBQSRyDojt+6NSvb0MtK6kfnQw+MU
         0StqF+MpHnTKN0vyLjlAf3kSSJFpYFiaA9obep8u68gPOiKkPDYVtyTORFOX3IgGpV19
         ReYQ==
X-Gm-Message-State: AOAM53046ni4AVna/kOoAr7hZbQRg5rpGE4icggN0N2kgix9F/+ph5fL
        zAi23wbfP/o15NNj2we1OIKJJ+W2ZMxgHUiYa2uHxA==
X-Google-Smtp-Source: ABdhPJzMCYo7mCacU8kewSUEr7ktjrK3MXXBaPHCK3qO5XW2iMSrr477pxN9bW5S+VutjgKjZo8YBsx1VxqB6RpHHVE=
X-Received: by 2002:a05:6602:1212:: with SMTP id y18mr1882842iot.189.1621460476160;
 Wed, 19 May 2021 14:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com> <20210519200339.829146-2-axelrasmussen@google.com>
In-Reply-To: <20210519200339.829146-2-axelrasmussen@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 19 May 2021 14:41:05 -0700
Message-ID: <CANgfPd_Sp=D7r4DsgTn_ge3uMw++sF6RNbAJAErRX9bBPKU+5g@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] KVM: selftests: trivial comment/logging fixes
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 1:03 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> Some trivial fixes I found while touching related code in this series,
> factored out into a separate commit for easier reviewing:
>
> - s/gor/got/ and add a newline in demand_paging_test.c
> - s/backing_src/src_type/ in a comment to be consistent with the real
>   function signature in kvm_util.c
>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Thanks for doing this!

> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 5f7a229c3af1..9398ba6ef023 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -169,7 +169,7 @@ static void *uffd_handler_thread_fn(void *arg)
>                 if (r == -1) {
>                         if (errno == EAGAIN)
>                                 continue;
> -                       pr_info("Read of uffd gor errno %d", errno);
> +                       pr_info("Read of uffd got errno %d\n", errno);
>                         return NULL;
>                 }
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..f05ca919cccb 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -663,8 +663,8 @@ int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, vm_vaddr_t gva, size_t len)
>   *
>   * Input Args:
>   *   vm - Virtual Machine
> - *   backing_src - Storage source for this region.
> - *                 NULL to use anonymous memory.
> + *   src_type - Storage source for this region.
> + *              NULL to use anonymous memory.
>   *   guest_paddr - Starting guest physical address
>   *   slot - KVM region slot
>   *   npages - Number of physical pages
> --
> 2.31.1.751.gd2f1c929bd-goog
>
