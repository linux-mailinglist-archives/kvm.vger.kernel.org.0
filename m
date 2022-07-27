Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4424582CE4
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 18:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbiG0Qvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240649AbiG0QvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 12:51:02 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8095E61DA4
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 09:33:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q7so4973200ljp.13
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 09:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzahODgMNuon2IeUr2EuuHPWt8+D9EzcvbJbwRZcpkA=;
        b=q37f8MYDml0WJQ6tALjGlG5Vm7UhkOtu+hluMsitRxWmOAPmVBZWNmPWNbjHKSc1N9
         QGY6rimQfE6pvxDGfLLTJtOLancrwW4USdDDzbqGrxGxoJBos/6bKm2yrdmFi6rpMHb8
         JSSk01V4sXf1ecwSzunHRWz+9wQkpvuLuzE2z+T1GGoDaJPCDx3DA6L7qxDhrV3XXjcO
         nzjlX+BpVDXctxfyqiIOZu57hV6UNdMJgKgMlcKeS/bo03JKmsks6tn9htHJk9XlMXWW
         zNBpRKP8AVoaaaRaBqsXUg08ZVrekrYI5Fhq0tJqY8Cbtes3dNJxM+xPEYI7d7APDGsl
         y8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzahODgMNuon2IeUr2EuuHPWt8+D9EzcvbJbwRZcpkA=;
        b=vwlQJWex5y26Mivg8gTENU1P7/Cml/fI3rDr1AfrLO+x6+SMsOkbHvgB4R8u9qTOFm
         3lZZC3L01SsaaVB1Kz9MwocXQ2yUah6tLa0atVU2aMDnT/vV2K5tdn1XcT55aBP46v8P
         8vnhErPCSG4pnLXnftJP3MC7POiPSAy+bNkto8gS2nCe0CJisHT7zHjSQ/7J6HeZngSD
         ojjgO2uEo3ZswJg33k9A5+nlwj8AZLt/UqBl2R6uAjfG8H/XscWLlGo+9dj4OGwHZug5
         UNSboHy1bw0a9RwZOsAEVWt7WXrrtspYA3UCLZ/biKCfNLzPIluy6tGOvxlwFRQxs7bD
         FB+Q==
X-Gm-Message-State: AJIora+76ChIjjJ5sXWC93pOP48JgYeclXFsXujbYMvQdS+8pjaW13sJ
        MKsZGTf0NlIMwMHXNPHXuqIno9fs9NMtQfvA9YUsBw==
X-Google-Smtp-Source: AGRyM1u+ugCfHWSJfs+Xcjaw0Npmkbnj0H+gh0RdJaFTfS9O/IUFRBKCCuHQG2kHb0WKS/09gAr8JI7by1jmQn8McKM=
X-Received: by 2002:a2e:a914:0:b0:25d:f74a:54c0 with SMTP id
 j20-20020a2ea914000000b0025df74a54c0mr8116851ljq.290.1658939598105; Wed, 27
 Jul 2022 09:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAPm50aKursUrDpgqLt7RT-VoSfBJswsnR2w1sVAt5mburmdd8g@mail.gmail.com>
In-Reply-To: <CAPm50aKursUrDpgqLt7RT-VoSfBJswsnR2w1sVAt5mburmdd8g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 27 Jul 2022 09:32:51 -0700
Message-ID: <CALzav=eccuGWGpBs=tp5RO_wJqQecGRwDAPi+tyPkMcYrbrPoA@mail.gmail.com>
Subject: Re: [PATCH] kvm: mmu: fix typos in struct kvm_arch
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 3:58 AM Hao Peng <flyingpenghao@gmail.com> wrote:
>
> From: Peng Hao <flyingpeng@tencent.com>
>
> No 'kvmp_mmu_pages', it should be 'kvm_mmu_page'. And
> struct kvm_mmu_pages and struct kvm_mmu_page are different structures,
> here should be kvm_mmu_page.
> kvm_mmu_pages is defined in arch/x86/kvm/mmu/mmu.c.
>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8281d64a431..205a9f374e14 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1272,8 +1272,8 @@ struct kvm_arch {
>         bool tdp_mmu_enabled;
>
>         /*
> -        * List of struct kvm_mmu_pages being used as roots.
> -        * All struct kvm_mmu_pages in the list should have
> +        * List of struct kvm_mmu_page being used as roots.

I agree that "struct <name>s" is a bad/misleading way to make a struct
plural in comments. The way I prefer to do it is "<name> structs".
That avoids changing the <name> and still makes it clear it's plural.
So in this case the comment would be:

/*
 * List of kvm_mmu_page structs being used as roots.
 * All kvm_mmu_page structs in the list should have
 * tdp_mmu_page set.
 */

> +        * All struct kvm_mmu_page in the list should have
>          * tdp_mmu_page set.
>          *
>          * For reads, this list is protected by:
> @@ -1292,8 +1292,8 @@ struct kvm_arch {
>         struct list_head tdp_mmu_roots;
>
>         /*
> -        * List of struct kvmp_mmu_pages not being used as roots.
> -        * All struct kvm_mmu_pages in the list should have
> +        * List of struct kvm_mmu_page not being used as roots.
> +        * All struct kvm_mmu_page in the list should have
>          * tdp_mmu_page set and a tdp_mmu_root_count of 0.
>          */
>         struct list_head tdp_mmu_pages;
> --
> 2.27.0
