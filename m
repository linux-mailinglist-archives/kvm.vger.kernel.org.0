Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB9768E726
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 05:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBHEa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 23:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjBHEaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 23:30:18 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E2441B6C
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 20:29:55 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g2so20933308ybk.8
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 20:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fhzeGnuICiPT2nrHJ6smEzbh41VKTVGE82e8/64PlQM=;
        b=oAKD3y+xr/ym/8alzfe5iPecB5XDrzMt7d+dv9BB/BB7u4F4WzBRW1M29Rev6GNFGn
         QMyM8q9EetdVsfmj+ACA6LwS+cvf0OJjz9vglnImwBdaLI5w+sYM5FSCcCB0YqC0PVvf
         sp/d9nq9slG56HUgVNucOhSOorawa3CvGIxd18q/+FNVa2d/Eb+yCrCV2ZZFuqrBTF1P
         r4bhSjN13EuVwtfnlBjLX+PubODVREgFrs9awGcedSpL6yQDAmqDjzgnBhH8e2SZelxM
         7/IoWZONhPbe7XUDdw4o3FQYTYyAb1VDbK0trsvZGIjYP0meSxx4kooJPFacjtu8Srkh
         C+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fhzeGnuICiPT2nrHJ6smEzbh41VKTVGE82e8/64PlQM=;
        b=7lXl96VBBuPtJe8Mo8nDPgHVcZ3AsNEqC30mgXMEWaynvUkyDvVpvDZVxnz3/+RJlt
         Gxmj44ljfYGqevr2RZ/IFtUsu+4Z9hXNC3cyXean/uLC+ICpBXBZsEhRczuJBKOFnGkM
         jDoc7EgYtNl/Qc1yswZN2Myw0Oi9QXQwN1wMqDFXjE3oOMnAG4llMVdDJctJikT0cpMN
         qhyWu1i69nwldLSjEad4ocqB8Du4eK5ewoA2EQTyBLV35LZhuUAIcZwfa6+y77E8ukQY
         RHKKF4mbhcvUuxcAc0hPrUEN38LX4fO/Ym7Vu0YsaAhEkMVJVitWSdc/flUPKOZYXNRR
         2tng==
X-Gm-Message-State: AO0yUKW0O7TRmsMhzxHwa1Hdf6vivIxl5+aeRer/vwVghJWZXSu6jmBr
        S0cAJuUiLxYNFeAsjOJ1yHNg5ZXjckPy6Fuee9Smwg==
X-Google-Smtp-Source: AK7set+LttiKihHYlrzSgPN7LWtawaDSHE8vLY8wcxInWN2E3/8zSOtO95vAG+OOzodb+SbYXZumxfkB/znQ1PqBn1Q=
X-Received: by 2002:a25:fe0c:0:b0:80b:69f5:3966 with SMTP id
 k12-20020a25fe0c000000b0080b69f53966mr717422ybe.519.1675830594250; Tue, 07
 Feb 2023 20:29:54 -0800 (PST)
MIME-Version: 1.0
References: <20230111183408.104491-1-vipinsh@google.com> <167582135970.455074.533102478332510041.b4-ty@google.com>
In-Reply-To: <167582135970.455074.533102478332510041.b4-ty@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 7 Feb 2023 20:29:18 -0800
Message-ID: <CAHVum0e0ZL-Q7DwZ-SYSuqX1n_9EU85mYhyvUA=75zpJ6a29ow@mail.gmail.com>
Subject: Re: [Patch v2] KVM: selftests: Make reclaim_period_ms input always be positive
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Feb 7, 2023 at 6:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, 11 Jan 2023 10:34:08 -0800, Vipin Sharma wrote:
> > reclaim_period_ms use to be positive only but the commit 0001725d0f9b
> > ("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
> > validation") incorrectly changed it to non-negative validation.
> >
> > Change validation to allow only positive input.
> >
> >
> > [...]
>
> Applied to kvm-x86 selftests, thanks!

Just FYI, this patch has already been applied to kvm/master branch.
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=c2c46b10d52624376322b01654095a84611c7e09

>
> [1/1] KVM: selftests: Make reclaim_period_ms input always be positive
>       https://github.com/kvm-x86/linux/commit/4dfd8e37fa0f
>
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes
