Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE41A62F4
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 08:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgDMGOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 02:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgDMGOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 02:14:31 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC1C008651;
        Sun, 12 Apr 2020 23:14:30 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id h6so8304267iok.11;
        Sun, 12 Apr 2020 23:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jCqUMGGUenYfmoVwgXjhS0dJxR72enCIJgvwl4G68tE=;
        b=Ez9wTmvQupP6PCsa3kb0IT4H0YnWLMVJ7dULcMYhdhFyPNDI6i9aoyJ18sZvHLp5ib
         e7p9AaT/1GxNduOtUoxauDlrKktGguez4444hsjbx3EiB3km7QQ6MW7C0WXx4c4yHY6e
         q8feJk5hlTO35r+oO9CTSdHpPSvVr2SDHyb0RxgZHSrIkZG2S7cwHa3CKORf4RqGwGRf
         tbTwFak5o6klQ/RIarADkIAu6Vadg924JUVeMMiGEi5tsa0rJBgcaoHGp2FbknZ5DtFi
         cLleJEQcATQLb9G84TwF2HPgcz8NmwZylLRKWyT0VKXBMutadMEf1/NOyJLylvoZo1x2
         W1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jCqUMGGUenYfmoVwgXjhS0dJxR72enCIJgvwl4G68tE=;
        b=a8bKUj0g0qBtrwBFK2cZlpVGuQYAKJwN/l/249rNyYvpCJbyXsyykhKBobak3nVE74
         +eAsCZ+q51WC3elSxp3f2p1xGkTCGuR7MNW96TNQqJtl/80PYqBzfJHfhnj7vWMZK/q9
         9cWYQizF+BxJ2TnHAKFfqdQW2UAhAoEPBkpta5MhRaBXBvzQkKx3tH3h75RKznmteoVB
         oHm+M9Vwo6kWDjRtdg/BKzHCgz7r2+dqEEG3dUsyQIOOAqL6rtwo0W+aV6uUCt7cLTSr
         3B/o7j8jtOv0STUwVtpU3Nnvoo0JMfvjtyy5BUrbhOFHq8LFS6S5PhgoeYSs9PAEkCr8
         r8Sg==
X-Gm-Message-State: AGi0PuaHOs/rDXN9V+wtCb3Xp6GHUweuXf2B6umU4ZJ2KfaWWbuF6766
        kq5PhixoPNqM+/ymCbLyOFaLNQo8qBa78H0KH3o=
X-Google-Smtp-Source: APiQypJr/7Y30/qSupKKzUhtTFP/1OZ364sIEHdlKIG9QjTV+/CC/CPY7e/niHiYgcLG+4mAzQzIjH6B/rwqfxLrrwU=
X-Received: by 2002:a6b:8b4b:: with SMTP id n72mr15041934iod.72.1586758470225;
 Sun, 12 Apr 2020 23:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200402081614.5696-1-rppt@kernel.org>
In-Reply-To: <20200402081614.5696-1-rppt@kernel.org>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 13 Apr 2020 14:21:38 +0800
Message-ID: <CAAhV-H7+swFnqoVk9VS=4UoM+OVW4PX5G0mqSPAbM1WfXC44rA@mail.gmail.com>
Subject: Re: [PATCH] mips: define pud_index() regardless of page table folding
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, maobibo <maobibo@loongson.cn>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Huacai Chen <chenhc@lemote.com>

On Thu, Apr 2, 2020 at 4:17 PM Mike Rapoport <rppt@kernel.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> Commit 31168f033e37 ("mips: drop __pXd_offset() macros that duplicate
> pXd_index() ones") is correct that pud_index() & __pud_offset() are the
> same when pud_index() is actually provided, however it does not take into
> account the __PAGETABLE_PUD_FOLDED case. This has broken MIPS KVM
> compilation because it relied on availability of pud_index().
>
> Define pud_index() regardless of page table folded. It will evaluate to
> actual index for 4-level pagetables and to 0 for folded PUD level.
>
> Link: https://lore.kernel.org/lkml/20200331154749.5457-1-pbonzini@redhat.com
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/mips/include/asm/pgtable-64.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
> index f92716cfa4f4..ee5dc0c145b9 100644
> --- a/arch/mips/include/asm/pgtable-64.h
> +++ b/arch/mips/include/asm/pgtable-64.h
> @@ -172,6 +172,8 @@
>
>  extern pte_t invalid_pte_table[PTRS_PER_PTE];
>
> +#define pud_index(address)     (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> +
>  #ifndef __PAGETABLE_PUD_FOLDED
>  /*
>   * For 4-level pagetables we defines these ourselves, for 3-level the
> @@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
>         p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
>  }
>
> -#define pud_index(address)     (((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> -
>  static inline unsigned long p4d_page_vaddr(p4d_t p4d)
>  {
>         return p4d_val(p4d);
> --
> 2.25.1
>
