Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970C952E32A
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 05:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345052AbiETDf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 23:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiETDfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 23:35:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6ADB7DA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 20:35:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e28so9129470wra.10
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 20:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iz8E9Wqores9d4slLEwkkQTwfUp3b5sNzXx3GlKoN9k=;
        b=EoiX9X4PjQip6/zwk77Ut0DguWoasyzn5/OBwNAW3I9FzmI1K1Ji6NrthZRSi9y1Tm
         76OZlBbw67XKaNWnz3MkXHg9IuDWHrq06WXp4UJ7aQGXuwdDv3Oxv6VoG2zmW1Snox6n
         qPYxyq2Y/Rv8Fs9dfUoaai8/ElIphdTQbKTz8LW8E9Zf+gh+cgurelf2hG2tGzjoXPXN
         yZmc5nFgW0QX78GiATsewfOsEs5xzh/V29aprpfe1VfDDTe5EWoYNkioi11o5Wm/xkq3
         wEs2Ftd8pKjqo2QQZADKoltdFDtdnzoa7eQ+chCxu3RMCn7ENNwqZ/A8uYJcSj/I+/Jx
         mSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iz8E9Wqores9d4slLEwkkQTwfUp3b5sNzXx3GlKoN9k=;
        b=hewnu98nyCohAjJw9z8nsfmBlkTmyw52CXOpCHCnkZK97tmlYuO3WS778zWsfaIq2K
         L2JLycXsiGpLrLoQKoY8p11QSFvt6QkVZf0fGMtTgg6bUpILQeq/X5GAew0VqUAxZk15
         SFKyOYMNV6xM0GX8XczXpOVd26vTxvoZ7sOUSsveOq6aDdtdf4r9SPOubN8qV54R5b24
         wY4ioERURMqFX1yk5hOc7I6f/4Fv2gItax/O4OWQusWqqGSVq/+uH9Vf8Uj3iJYWglHn
         zIAJdqjO5+E9fp78pWeW54LiBP/O+SkZJhBRW5+fzbo0bvyLbNlSImblnn/0zaBDOhdq
         mUNQ==
X-Gm-Message-State: AOAM531fl+4A3i0KfBhjTqbpdWRCSx2iQi/ZzwDTCepQzzNe2LkOw4pb
        cRbgE6d4GzSPUAcRNlfjywZ3iNbxW7Ln3XZ5H2MFjdm6/w8X+g==
X-Google-Smtp-Source: ABdhPJzhhw/Q0jnXkep8oUbRoAi2MJltN0zmw2yBi9f0WP+hU3Xv1uItHJl9OBgXBdOC/a5JfDnvxXRwcMjJAW/4cIk=
X-Received: by 2002:a5d:6489:0:b0:20e:549b:4414 with SMTP id
 o9-20020a5d6489000000b0020e549b4414mr6391740wri.86.1653017748963; Thu, 19 May
 2022 20:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220509060634.134068-1-anup@brainfault.org>
In-Reply-To: <20220509060634.134068-1-anup@brainfault.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 20 May 2022 09:05:37 +0530
Message-ID: <CAAhSdy0MQ+Wq-r7Po-OOpVDdPP7xbucz+j4V-zrWGKCt76V9Ug@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update KVM RISC-V entry to cover selftests support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 9, 2022 at 11:37 AM Anup Patel <anup@brainfault.org> wrote:
>
> We update KVM RISC-V maintainers entry to include appropriate KVM
> selftests directories so that RISC-V related KVM selftests patches
> are CC'ed to KVM RISC-V mailing list.
>
> Signed-off-by: Anup Patel <anup@brainfault.org>

Queued this patch for 5.19

Thanks,
Anup

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e8c52d0192a6..ee73a71c1500 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10767,6 +10767,8 @@ T:      git git://github.com/kvm-riscv/linux.git
>  F:     arch/riscv/include/asm/kvm*
>  F:     arch/riscv/include/uapi/asm/kvm*
>  F:     arch/riscv/kvm/
> +F:     tools/testing/selftests/kvm/*/riscv/
> +F:     tools/testing/selftests/kvm/riscv/
>
>  KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>  M:     Christian Borntraeger <borntraeger@linux.ibm.com>
> --
> 2.34.1
>
