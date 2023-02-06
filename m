Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEFB68C80F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 21:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjBFUwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 15:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjBFUwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 15:52:35 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0B2B097
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 12:52:34 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id q4so11415771ybu.7
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 12:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KypDhZVz2qSeMAGxH9f9Ozlfj2EbuuxANzifbY7fWPw=;
        b=lK8LjcYIVj09SoWXb5ftxHXrEcnFscJgw+rfKm75AK/XSgz31c9CbMkMR1XGNgqssU
         qRfxI/OGvOpilh87IrsP124kQRsETKU8Q8a8ltGR7EONO0jDJMc9pw7KEdlCX1ViVy/Q
         hOHuKlF8y+emlRAerrdkKvJ3FsVo9G4pWzI4T+rCyMRzNp1von9Qjo3Mx6H0Iey0lYCz
         GG8MyjXN67++SvkQcRT4Txnlob992f6Yr6vj1hpRqWutQJ2phHDu49r4wdTAPMMiLf8L
         0TlldccMtVAwGi4diwZmAs++skbY5Wz04pR743JqghQJ4HR9P4dzCZOkLrWU72GibaH1
         JooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KypDhZVz2qSeMAGxH9f9Ozlfj2EbuuxANzifbY7fWPw=;
        b=wNTEMMgd8Bfm9fzopI9q8ATGkOk7d8lmLq8+m5t10OIlOGrHsYpe6lH8hzyGeKyPvO
         hSjxtYxYccxVudVezLV0vpRz1VlDQjV5b7+p0Z6zG0ZMTXwovCR2w4E26veN7yUl+Sqb
         M1FjRlx7whyCnA5Q8USOZv789UuuzxWQB8XcJzMd2tbBe7IELZjqKGYF2JsUQDdf6eQG
         2qHvxfiHaUB7aP6sv5GNKIEjyygUPUXVAd3ys40L7KmgEkxsrNEu5LW/NPi/3R9gOwq5
         +ALDyX/5QbPqawlxjeBImkht9zLedoSe1+HHvvGTgOoyUvgr1Xk2wb+w5mswQymPHRiI
         Pdcw==
X-Gm-Message-State: AO0yUKU3yLNfHOeqYpaMAH/wpRgiQ2GPFYSi2kw0ym0zberQwnSYz+Hp
        Sdfx6fK4rUp+SWbDtC1g0qKEqDtHZX9n0DVKbxhtxA==
X-Google-Smtp-Source: AK7set8ZK6VKS7OKGzwpw7bBfHr0g2viQDPrXIaRcDDOZelPLV/WzJEl0YZvkglrQVcNwp4NUeKoB0Th1HUbzpKESS4=
X-Received: by 2002:a25:fe0c:0:b0:80b:69f5:3966 with SMTP id
 k12-20020a25fe0c000000b0080b69f53966mr107483ybe.519.1675716753812; Mon, 06
 Feb 2023 12:52:33 -0800 (PST)
MIME-Version: 1.0
References: <20230204014547.583711-1-vipinsh@google.com> <20230204014547.583711-4-vipinsh@google.com>
In-Reply-To: <20230204014547.583711-4-vipinsh@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 6 Feb 2023 12:51:57 -0800
Message-ID: <CAHVum0cgjGSKjFWBANeVzNURb0wwj80nn-BdFMYsQ6KdxqO=6g@mail.gmail.com>
Subject: Re: [Patch v2 3/4] KVM: selftests: Add macro to generate KVM exit
 reason strings
To:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 5:46 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add and use a macro to generate the KVM exit reason strings array
> instead of relying on developers to correctly copy+paste+edit each
> string.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 52 +++++++++++-----------
>  1 file changed, 27 insertions(+), 25 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 56d5ea949cbb..2413ce511d20 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1815,37 +1815,39 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>                 vcpu_dump(stream, vcpu, indent + 2);
>  }
>
> +#define KVM_EXIT_STRING(x) {KVM_EXIT_##x, #x}
> +
>  /* Known KVM exit reasons */
>  static struct exit_reason {
>         unsigned int reason;
>         const char *name;
>  } exit_reasons_known[] = {
> -       {KVM_EXIT_UNKNOWN, "UNKNOWN"},
> -       {KVM_EXIT_EXCEPTION, "EXCEPTION"},
> -       {KVM_EXIT_IO, "IO"},
> -       {KVM_EXIT_HYPERCALL, "HYPERCALL"},
> -       {KVM_EXIT_DEBUG, "DEBUG"},
> -       {KVM_EXIT_HLT, "HLT"},
> -       {KVM_EXIT_MMIO, "MMIO"},
> -       {KVM_EXIT_IRQ_WINDOW_OPEN, "IRQ_WINDOW_OPEN"},
> -       {KVM_EXIT_SHUTDOWN, "SHUTDOWN"},
> -       {KVM_EXIT_FAIL_ENTRY, "FAIL_ENTRY"},
> -       {KVM_EXIT_INTR, "INTR"},
> -       {KVM_EXIT_SET_TPR, "SET_TPR"},
> -       {KVM_EXIT_TPR_ACCESS, "TPR_ACCESS"},
> -       {KVM_EXIT_S390_SIEIC, "S390_SIEIC"},
> -       {KVM_EXIT_S390_RESET, "S390_RESET"},
> -       {KVM_EXIT_DCR, "DCR"},
> -       {KVM_EXIT_NMI, "NMI"},
> -       {KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
> -       {KVM_EXIT_OSI, "OSI"},
> -       {KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
> -       {KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
> -       {KVM_EXIT_X86_RDMSR, "RDMSR"},
> -       {KVM_EXIT_X86_WRMSR, "WRMSR"},
> -       {KVM_EXIT_XEN, "XEN"},
> +       KVM_EXIT_STRING(UNKNOWN),
> +       KVM_EXIT_STRING(EXCEPTION),
> +       KVM_EXIT_STRING(IO),
> +       KVM_EXIT_STRING(HYPERCALL),
> +       KVM_EXIT_STRING(DEBUG),
> +       KVM_EXIT_STRING(HLT),
> +       KVM_EXIT_STRING(MMIO),
> +       KVM_EXIT_STRING(IRQ_WINDOW_OPEN),
> +       KVM_EXIT_STRING(SHUTDOWN),
> +       KVM_EXIT_STRING(FAIL_ENTRY),
> +       KVM_EXIT_STRING(INTR),
> +       KVM_EXIT_STRING(SET_TPR),
> +       KVM_EXIT_STRING(TPR_ACCESS),
> +       KVM_EXIT_STRING(S390_SIEIC),
> +       KVM_EXIT_STRING(S390_RESET),
> +       KVM_EXIT_STRING(DCR),
> +       KVM_EXIT_STRING(NMI),
> +       KVM_EXIT_STRING(INTERNAL_ERROR),
> +       KVM_EXIT_STRING(OSI),
> +       KVM_EXIT_STRING(PAPR_HCALL),
> +       KVM_EXIT_STRING(DIRTY_RING_FULL),
> +       KVM_EXIT_STRING(X86_RDMSR),
> +       KVM_EXIT_STRING(X86_WRMSR),
> +       KVM_EXIT_STRING(XEN),
>  #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
> -       {KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
> +       KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
>  #endif
>  };
>
> --
> 2.39.1.519.gcb327c4b5f-goog
>

Sean,
I had to manually create this commit in my tree, your patch in the
email was complaining about some non-existent SHA.
https://lore.kernel.org/lkml/Y9r0q9cuK%2Fifu+OW@google.com/

Only difference from your patch is that KVM_EXIT_STRING(HYPERV) is not
present in the patch above. As this exit reason is not available in
kvm/queue.
