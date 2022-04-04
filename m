Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB364F0DC3
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 05:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352591AbiDDDsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Apr 2022 23:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377021AbiDDDsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Apr 2022 23:48:03 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1BD28980
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 20:46:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bi13-20020a05600c3d8d00b0038c2c33d8f3so6909454wmb.4
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 20:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIEWjwIftCsbXsyVaKrbxiQ3YI3B53hkXz7cL3Cg4Hk=;
        b=5NLJ/H5VwJU9/XJjgnCvziAUiVTZmUTWR+QTk5YqSNeNhj6yLp5udBH8IXnkRyqfen
         7ZMH7/kbxkU3fVc6e7d+20rQRfniY5BwYwRN1bTzqBHuoFPd4gjk6Crt17D/Ksd+WFBN
         YC24GmWYZZrG59JApll5m8/7lxBs3UV9MWI5+k+Od/BrzhtJ2E2QTr8RuOh+yOpBcvhj
         /gdekB1g6P+n/7lc7AqNcSR7dVbLUBfkvnw+VANgZor1xLG7MbPj6G32g8aEhsgczqTQ
         nupBrMvFISqcO3bnR+8PmjHidV4jhgdyjY3yxzgHjJt7aB73xNayUU/HkBphiwCVDdLB
         8GsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIEWjwIftCsbXsyVaKrbxiQ3YI3B53hkXz7cL3Cg4Hk=;
        b=2ny61Z/MBEjO4bGbn5mI7XH+8j7a53+29KaTezKr3oe8py4QJ6PSfpqwkpKsL3GRo4
         rE/ntkWpg4z1zsiS4mwjYSGsdFfeK/9ur3U/4/UY1HVcVmduD0oZXzZmzFJ3smjVKoud
         YmKngNYspdcRpbpKUAYl5cmOUkI1FMDn2Isb8iEcKeXxQtKtufqu/9pSc0SnZOgi0MKe
         Y01LozkS4MV/IkAFXxPhAsuK0VuB9dMnuuNmiJ/9A48G53x8+rGU7Kih3xgC5ogYTZgD
         DCql4AajwEh+UkYgdWGUAyuGxsiUk+0Enj4pYU4h2Of2Nqqd0MlIqn6lMP7G/VYh3XVW
         72lw==
X-Gm-Message-State: AOAM533UBsXj/KTlXdDTVrQjkRJ5Am5tle64SUGZz5AFpOAWbAAycoE4
        00f/wBy2SWXY3gK2AgkKo59hVWDXqKEHO3Wkoqyq+g==
X-Google-Smtp-Source: ABdhPJxWy3ASdc1fdzlTkh/icaTSsaUSRXwwU+/7EXnNF1pjk9RZzqkcq+Ab3qtG3iS4I7Z32SL1kMxGGrKs6m5vxIg=
X-Received: by 2002:a05:600c:6d4:b0:38e:7622:9983 with SMTP id
 b20-20020a05600c06d400b0038e76229983mr450885wmn.93.1649043963147; Sun, 03 Apr
 2022 20:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220403065735.23859-1-bagasdotme@gmail.com>
In-Reply-To: <20220403065735.23859-1-bagasdotme@gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Apr 2022 09:14:53 +0530
Message-ID: <CAAhSdy0G4o16Qdt2ZPDAD5M6Updopdm43La2q4t6xVA540WXdw@mail.gmail.com>
Subject: Re: [PATCH RESEND] Documentation: kvm: Add missing line break in api.rst
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 3, 2022 at 12:28 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> Add missing line break separator between literal block and description
> of KVM_EXIT_RISCV_SBI.
>
> This fixes:
> </path/to/linux>/Documentation/virt/kvm/api.rst:6118: WARNING: Literal block ends without a blank line; unexpected unindent.
>
> Fixes: da40d85805937d (RISC-V: KVM: Document RISC-V specific parts of KVM API, 2021-09-27)
> Cc: Anup Patel <anup.patel@wdc.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-riscv@lists.infradead.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

For KVM RISC-V related patches, please CC kvm-riscv@lists.infradead.org

Otherwise, this looks good to me. I have queued this for RC fixes.

Thanks,
Anup

> ---
>  Documentation/virt/kvm/api.rst | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9f3172376ec3a6..a529f94b61edcd 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6115,6 +6115,7 @@ Valid values for 'type' are:
>                         unsigned long args[6];
>                         unsigned long ret[2];
>                 } riscv_sbi;
> +
>  If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
>  done a SBI call which is not handled by KVM RISC-V kernel module. The details
>  of the SBI call are available in 'riscv_sbi' member of kvm_run structure. The
>
> base-commit: f443e374ae131c168a065ea1748feac6b2e76613
> --
> An old man doll... just what I always wanted! - Clara
>
