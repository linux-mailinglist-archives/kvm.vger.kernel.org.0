Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC951F3C0
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 07:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiEIFMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 01:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiEIFLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 01:11:18 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC1B50014
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 22:07:25 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p189so7690640wmp.3
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 22:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdhxBHkeZJKhLSAPI6OAJv4xkfu7sQGGwYGe9PwcdxY=;
        b=NcUwvkHBJUKCv0MFOi0aoimKs0nJQK03BTN3eOVPeiwTolHlhov3OuBgLwnc613hjZ
         D+vg5/Kr1EdeTsBtz/UTHpY53F8sayW0x4Z05Q469bh2TCvnRUUM9gSbkyI/Ni1gPQLE
         RCxch8rhsnYcYKxi3lWtFVyMbCjAqTWJMVsYygV8X/enVf8x71AJ/991FvAQdSsPljg+
         TMay8lCypCIRilGJdXsvQpOKwT3tF5E7WlIPRSNBm0rPFsFQukMIqSidMBTz4XSQbuZn
         JfHggLWPByhiIq/F9nBtYUa7lNYxtAxH6l42cHcX/zZc2XJHUtMBSRjaCKbXiTKGd96k
         F4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdhxBHkeZJKhLSAPI6OAJv4xkfu7sQGGwYGe9PwcdxY=;
        b=pznNnXxSW/7WUvPGWgAU9rHB9q3ZDEmZgwj4oN9IfuZV1q+sz7IfRpaI5v1Xl4Ih2g
         O1jRU3A+zqovgiE1L4Wx+z+JHbZLJM/1rjuJZwyIsLDYrz6HRQHPgIuATJn3upV0E5X1
         9jncco57b4l+I5lWqx/eoglKAM4ygou1hMiyiJIb0XSuCALnorwgxflDwVZffmNYjUp7
         3KQPjKTOlQ3JoodhJ0zg+qbBBXaLxV+ToTyxQwa59QjWj60zFIldXkOYqqRkqw+NYr2i
         EJvBjeUOjZp8fffHjc93UjTmtMQh29X6W5vX8yICH1p2+DVThXU0rE3Z0qIojQO/gtzR
         Algg==
X-Gm-Message-State: AOAM531qxn+JJPRd17GUrEj6hVyC2QZmkvDhtdvpzjoQwYbDT1fVFcIo
        PJ1zhU63+Z6g0EQgdVwNbtsp9bBnSnEVf97DzPcW7Q==
X-Google-Smtp-Source: ABdhPJyRvxJOp8dQf/hnmLk5CPnu/T4DwM8Qpg0kXrVvEiVm0ZjDRLI/md+TzxFB02jc58meQUAs1NVUyDWkIjd5bqw=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr3482746wmb.105.1652072844025; Sun, 08
 May 2022 22:07:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220506094512.116729-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220506094512.116729-1-jiapeng.chong@linux.alibaba.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 9 May 2022 10:37:12 +0530
Message-ID: <CAAhSdy15CE5ZUROH-mOwhpR0AuwsK8h+8W-Kd0jxwsTixpQOQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: riscv: Remove unneeded semicolon
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 6, 2022 at 3:15 PM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Fix the following coccicheck warnings:
>
> ./tools/testing/selftests/kvm/lib/riscv/processor.c:353:3-4: Unneeded
> semicolon.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

In future, please CC kvm-riscv@lists.infradead.org for KVM RISC-V related
patches.

I have queued this patch for 5.19

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index 3961487a4870..e17333518af2 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -350,7 +350,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
>                 case 7:
>                         id = RISCV_CORE_REG(regs.a7);
>                         break;
> -               };
> +               }
>                 set_reg(vm, vcpuid, id, va_arg(ap, uint64_t));
>         }
>
> --
> 2.20.1.7.g153144c
>
