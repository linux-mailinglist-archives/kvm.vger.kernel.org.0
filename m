Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B9B7417A2
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjF1R5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjF1R4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:56:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CD2689
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:56:11 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57059f90cc5so854507b3.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687974971; x=1690566971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oft31F5mAAnY3y8JHizHeZojVgGUNJAYwhDFnTgpg8o=;
        b=yzU2JoIQ6C81Hm062cJ2Hc3EmkrShnx3KDof7OpjrvrceMW2p/JIqkFL3bPzaIzfQi
         V0Dc3dj9921O8AA28Eb8uR90sAND7PQjSUi3zuhfCUzdQxBhnZVZsYvTlt3X7kuQYZp2
         KjoOs6xj0SFu1apHoMQ0Luhg6NI5lnYXDv0N0Mko9n7j5Y4SbNUrBHzkXz29K2cpjBMT
         6cWrkLt8pVICK6OZ+FHUiEg5csnak4W+YtNqidraNd5gfTgRYXcfZLtfLwAwEiMQcEjR
         MS6a30GfaRHxg0cP3WbpBtjznhW8uoJXj5dkOCiweAp9Kwj2cDsBt61bjdnFUtxW6njJ
         otXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687974971; x=1690566971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oft31F5mAAnY3y8JHizHeZojVgGUNJAYwhDFnTgpg8o=;
        b=iNs7rD5zrx6mxl8H7Q/tc5Ko1r946A6uK1LZ+MC3jNT38sQOKlZr5s6I0Kqx2PDPaA
         YfnFJ4zr0iARjhgvv9EVwkmevVLtnfWfW7ZoertFnuHJaeI+5BnlK1x1CYR2mmqpjuZY
         7rEm9ldvG97qY4zOZU1IreY1dBOCOibT8IAokAOBfqemgr40lNfuBaI8rwplkvrql+6F
         hM+1XswZaDswWXquMGW66Wo2PaAFQTBp/LnQWAojEK/8J5pgDpCYezdrxOZ34xePNEeL
         Y6Gzcu6zfpXQmclVUhemkrO+8SKuKxRiaMTpJSGsC3FVj+S8jg/EjJM23DFizfArbzml
         Q7ZQ==
X-Gm-Message-State: AC+VfDxWsurVERky2PtVg99NQBqM6EQfQwn+sr475aYjgEB77Hlo580d
        sHkuuqk3IKicbEF/9jPoFhEAIEv0jfk=
X-Google-Smtp-Source: ACHHUZ5/HawWcuOHI8uZBuEAt0m4vKfLDhoPBp3MHo3Wacm6ZrRpEToDO+6/6KfJozZIuzIqSu5wFGU5F90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae5d:0:b0:573:ab97:578 with SMTP id
 g29-20020a81ae5d000000b00573ab970578mr8329623ywk.2.1687974971110; Wed, 28 Jun
 2023 10:56:11 -0700 (PDT)
Date:   Wed, 28 Jun 2023 10:56:09 -0700
In-Reply-To: <20230608024504.58189-1-npiggin@gmail.com>
Mime-Version: 1.0
References: <20230608024504.58189-1-npiggin@gmail.com>
Message-ID: <ZJx0OVEphb/OqQ+t@google.com>
Subject: Re: [PATCH] KVM: PPC: Update MAINTAINERS
From:   Sean Christopherson <seanjc@google.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023, Nicholas Piggin wrote:
> Michael is merging KVM PPC patches via the powerpc tree and KVM topic
> branches. He doesn't necessarily have time to be across all of KVM so
> is reluctant to call himself maintainer, but for the mechanics of how
> patches flow upstream, it is maintained and does make sense to have
> some contact people in MAINTAINERS.
> 
> So add Michael Ellerman as KVM PPC maintainer and myself as reviewer.
> Split out the subarchs that don't get so much attention.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

Thanks for documenting the reality of things, much appreciated!

Acked-by: Sean Christopherson <seanjc@google.com>

>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0dab9737ec16..44417acd2936 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11379,7 +11379,13 @@ F:	arch/mips/include/uapi/asm/kvm*
>  F:	arch/mips/kvm/
>  
>  KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
> +M:	Michael Ellerman <mpe@ellerman.id.au>
> +R:	Nicholas Piggin <npiggin@gmail.com>
>  L:	linuxppc-dev@lists.ozlabs.org
> +L:	kvm@vger.kernel.org
> +S:	Maintained (Book3S 64-bit HV)
> +S:	Odd fixes (Book3S 64-bit PR)
> +S:	Orphan (Book3E and 32-bit)

Do you think there's any chance of dropping support for everything except Book3S
64-bit HV at some point soonish?  There haven't been many generic KVM changes that
touch PPC, but in my experience when such series do come along, the many flavors
and layers of PPC incur quite a bit of development and testing cost, and have a
high chance of being broken compared to other architectures.
