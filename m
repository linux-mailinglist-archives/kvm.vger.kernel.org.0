Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2995A7264
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiHaA3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiHaA3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:29:03 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6AE9F0FC
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:29:02 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-11eb44f520dso16499094fac.10
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hQSQ2t7pP/IrhN8cc8IxfDAA5qJwx3EBn20OUJ8e824=;
        b=gXU09nL1FZDT/NiNH6BzjQIvxgEpNbKmNOuJ5Y9ld61xdcnMk4bZ2Y4wwtZOjc4IjS
         b/CadcuFLNoAhYpOGE/9v67ayb1O3nUZOvZ+HK2hQYazfOys+qjx3WrPe8BRwVyO2T/2
         Z7a1yEKJRrIkSy0nKsDiHG3R43qGjMVKaHI7PuHcTYnzf+WwVn1bNkibxIx+0sB2EqUD
         PuluCgxx/6Bj40MH/9US67dBJz8llTLfFgZaC9wDsmrBn0xKIZAF7XKYu1lqLs9M3KPA
         lxYBphTghIeUQ+sqichlfd839bOOVt8nmmc86SAnEYCrksVFmqaczDCiiZ6z1lbOY7yU
         RzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hQSQ2t7pP/IrhN8cc8IxfDAA5qJwx3EBn20OUJ8e824=;
        b=1KAhXzNkW1PDlGun4zruEl5q9UKBj536PoK/bJxDZGdG3CTGn/wdKWqKCjXZv5qHPI
         zI8Lzydxgtj2Zp0NR/bEVcCjXu/mhtD0ETZQB1HNOcoeyhLrhIZY/dB0lYfxmu49V+cv
         Cu8Qhl7bKsSO2NrzRNT3qhspH0hs30hdRqBM+rhwOgktQlgEwlD40faJk9r3RmxpFTLC
         wGGcF2jlhBYY0bTwSxrXg6Q6cE0/Kn7ASbkwrjZrkE/QIJ6Fo0Kf1ok/SjVN/EI+VqTK
         gdOFty1rdtFCrepYs5ghfGEn4usd/F7j3jJKzPu21VsJmTooUx0DwSfO+huEFEJ5A1y2
         Hcrg==
X-Gm-Message-State: ACgBeo08OG6L6GvJaCY3UwCquDcCyn+gMPIUgptYuEVhJppkqxqjG9V+
        mWSIFQTV6B3vRbWqz7Yd7go9vnQo7vrJY/Vkosfl4/0+190=
X-Google-Smtp-Source: AA6agR4/a4IL9f29Af20SDpmYJsn+mOKbowLXYovGrFOJDBUWqoq7xnux+Mj/PtmwXhdYMdOLqvNOZX0OVmTqZbJj1c=
X-Received: by 2002:aca:170f:0:b0:343:171f:3596 with SMTP id
 j15-20020aca170f000000b00343171f3596mr221718oii.181.1661905741375; Tue, 30
 Aug 2022 17:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220831000721.4066617-1-seanjc@google.com>
In-Reply-To: <20220831000721.4066617-1-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 Aug 2022 17:28:50 -0700
Message-ID: <CALMp9eToxFXZVz=8ZXWdrZAdQRn9V54g0VEaKDmmpqvPrYXQoA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Reword comments about generating nested CR0/4
 read shadows
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 5:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Reword the comments that (attempt to) document nVMX's overrides of the
> CR0/4 read shadows for L2 after calling vmx_set_cr0/4().  The important
> behavior that needs to be documented is that KVM needs to override the
> shadows to account for L1's masks even though the shadows are set by the
> common helpers (and that setting the shadows first would result in the
> correct shadows being clobbered).
>
> This also fixes a repeated "we we" reported by Jason.
>
> Cc: Jason Wang <wangborong@cdjrlc.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
