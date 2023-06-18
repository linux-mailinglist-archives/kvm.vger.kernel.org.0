Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518047344A3
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFRCL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 22:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjFRCL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 22:11:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A63ABA3;
        Sat, 17 Jun 2023 19:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59CE660B30;
        Sun, 18 Jun 2023 02:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3BEC433C8;
        Sun, 18 Jun 2023 02:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687054284;
        bh=hrbm6au2VGNBIFNhWA1SNgCyBekbxhSckbGJy7ygoK0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ya9PdseP5WKgielreKKNKz2v6XO+JHq7gXQiUk3htMSv9iwKT4lgTCGTVZJ2MFbMk
         dEZEgpKnQM4x0TBmGdJe+jx+EGsGwgB3l4mfVbrNn/YrQbPQYaAuLUZA+2MhJBIH/8
         vrbQqI/fZTFqtX3/G3AVaODItl823e/eRfW3mkvspzpDfKmNZKjk9iMx8pI68fa7pU
         Ap+PQ4GUvuIpfjLavr0SNfT/VcAWeUXm4M8HVzbYeOei0qDN8dylbTfwOhyEZh5weu
         MCwXhYhOvoDeOFqhyUWhIWmU8HpPJ5FB1ZkIJ4lU0ypENEB9Abfezr0jUQAhx2Fvh/
         NxhqZ4hXxjRRQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-9768fd99c0cso665059866b.0;
        Sat, 17 Jun 2023 19:11:24 -0700 (PDT)
X-Gm-Message-State: AC+VfDyPKf/SvjVaVGIADPZ3AU/5cIC9MbU0wcHvD+Y5ro2d9aW0f9ro
        BfbND2vuy6QBzeH8iTDkbMS01xGNgEC82MFgG5Q=
X-Google-Smtp-Source: ACHHUZ5PRIJVD6PSGfwwUDJfcbff85dKyWLrYQFmq7HH0Jj0ecCvtJ3i2o1T4TZVJIDzKWrSRrubRTMKJKab6W2v1n0=
X-Received: by 2002:a17:907:9624:b0:987:9852:603a with SMTP id
 gb36-20020a170907962400b009879852603amr2734046ejc.26.1687054282890; Sat, 17
 Jun 2023 19:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230617185335.2025859-1-yuzhao@google.com>
In-Reply-To: <20230617185335.2025859-1-yuzhao@google.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sun, 18 Jun 2023 10:11:10 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Z4eCumeykwcD8B-5K+ur5SWjufSv6oZw4Y9uSsE+wXg@mail.gmail.com>
Message-ID: <CAAhV-H5Z4eCumeykwcD8B-5K+ur5SWjufSv6oZw4Y9uSsE+wXg@mail.gmail.com>
Subject: Re: [PATCH] kvm/mips: update MAINTAINERS
To:     Yu Zhao <yuzhao@google.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Huacai Chen <chenhuacai@kernel.org>

On Sun, Jun 18, 2023 at 2:53=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote:
>
> Aleksandar Markovic was last seen in Oct 2020 [1] and cannot be
> reached for multiple days because of "Recipient inbox full".
>
> [1] https://lore.kernel.org/all/1602103041-32017-4-git-send-email-aleksan=
dar.qemu.devel@gmail.com/
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6992b7cc7095..9de60ba04b6d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11379,7 +11379,6 @@ F:      tools/testing/selftests/kvm/aarch64/
>
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>  M:     Huacai Chen <chenhuacai@kernel.org>
> -M:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>  L:     linux-mips@vger.kernel.org
>  L:     kvm@vger.kernel.org
>  S:     Maintained
> --
> 2.41.0.162.gfafddb0af9-goog
>
