Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA3B68DF3A
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjBGRrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjBGRri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:47:38 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCAAA5E0
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:47:37 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id t190so8238403vkb.13
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CY914VzVqB+fSxy9WxpWVLUSp1jcG757pUUHGil8Hd4=;
        b=IsvcsNAUCrPf1/y8inlkYZ/NYs/FAlUp3maKwLZlTe6T5Khs/Ziyc/yV0OepHvm4zx
         lPOZR4HJ4M9VvtqMmHpwabLUvbfVT8m6jeR++Yy6PQJSZQLp8f+UVF0SwvU60JCN4mSJ
         nbTT4rDe7UfV1P13VpovcPEuqUaJw9UOvc/XOVdzsZIU5yXkEmP4Zsi1/jHEV1sAkn6P
         BdJyaZ4v3zR7C1+vESwoOtsIpki427+BLRa1336tF9T0NtK65T9w7wsOrC0N5qRXxvHa
         8H4SpWWktU2HmcEfoNDgp+8G+C/Z1unzafh/nx4n1dRcfxe0i2JEUnrfMTVct12kCaAa
         OnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CY914VzVqB+fSxy9WxpWVLUSp1jcG757pUUHGil8Hd4=;
        b=Z1bWdqkU/54N5QzOMhqVTpVHZ8L5VQ/0LuRB7c/3DuXAp2mJGWQuECFCPecQpoh/S9
         FO3WoHCkQMZj0LUYfBvwNgKxJtRrNBsjV3nNMZWg0/PQA5k5y621lb+MT8A7LC4xsXlf
         u8GO3+21WVDeYnk0s5F4doHnJiAAGfr7ue8dIiqJaZ+glQbFjFiiADf7Goo6brtoYZYq
         OfKQIOHeKzJ1DkOEXbpkwG7VB7OIi5Af0bwCmzWkYGm4fTIE5lxI2ipTPnGAUoGkne6S
         XLSaP/xpD9BcH44Knb+YNo/OgBUiVVD5Z8NJj2CGApZcXGHeYTGNx5/XeWLMcaYnL1u8
         0FRA==
X-Gm-Message-State: AO0yUKWDczLkKXgWAuMctVwyED0qiX9P9UguvtpBnf3d3gIM8s8gzYXR
        KZb0WCm47vfgH6QqvKZ1G+NFYGLJi64paSYCHbbIpw==
X-Google-Smtp-Source: AK7set+u0N05uEmq9E0SdpeF7zfcRTdc9ZgNfmWmpVqNDjLNTyVbkbxMQmMxL3400jLioHuy0QDn5LJEdPsTuSCzdr8=
X-Received: by 2002:a1f:b60f:0:b0:3dd:fce2:8505 with SMTP id
 g15-20020a1fb60f000000b003ddfce28505mr574476vkf.40.1675792056062; Tue, 07 Feb
 2023 09:47:36 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-3-vipinsh@google.com>
 <Y+GQNXDlNbJNvDd2@google.com> <CAHVum0d2dRvNaS+AMqdbF35D05dDQrtZ4TBQ1QOYx6he-Cy6YA@mail.gmail.com>
In-Reply-To: <CAHVum0d2dRvNaS+AMqdbF35D05dDQrtZ4TBQ1QOYx6he-Cy6YA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 7 Feb 2023 09:47:09 -0800
Message-ID: <CALzav=dw8hzbfOtWFo+tb6aKavrdfjrbuJ-o0_F39o=53u95MQ@mail.gmail.com>
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 7, 2023 at 9:37 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Mon, Feb 6, 2023 at 3:41 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Feb 03, 2023 at 11:28:19AM -0800, Vipin Sharma wrote:
> >
> >         if (wrprot || spte_ad_need_write_protect(iter.old_spte))
> >                 clear_bits = PT_WRITABLE_MASK;
> >         else
> >                 clear_bits = shadow_dirty_mask;
> >
> >         if (!(iter->old_spte & clear_bits))
> >                 continue;
> >
> >         iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);
> >
>
> Yeah, this is better. Even better if I just initialize like:
>
> u64 clear_bits = shadow_dirty_mask;
>
> This will also get rid of the else part.

On that topic... Do we need to recalculate clear_bits for every spte?
wrprot is passed as a parameter so that will not change. And
spte_ad_need_write_protect() should either return true or false for
all SPTEs in the TDP MMU. Specifically, make_spte() has this code:

if (sp->role.ad_disabled)
        spte |= SPTE_TDP_AD_DISABLED_MASK;
else if (kvm_mmu_page_ad_need_write_protect(sp))
        spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;

sp->role.ad_disabled is never modified in TDP MMU pages. So it should
be constant for all pages. And kvm_mmu_page_ad_need_write_protect()
will always return false for TDP MMU pages since sp->role.guest_mode
is always false.

So this can just be:

u64 clear_bit = (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MASK :
shadow_dirty_mask;
