Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3616D5D9F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbjDDKhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjDDKhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:37:06 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72641713;
        Tue,  4 Apr 2023 03:37:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 184so4679162pga.12;
        Tue, 04 Apr 2023 03:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680604625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuAO/TXt1co2Yl/jE9f+m6f2f1iw8gMZ65fgjuKcqFk=;
        b=i+InxZv9vctTwvYJfOhr3IXiEJtQTdgq3FWlV7VrMh8MAQSk5o0oAYpnljO5NRRl2W
         Nj6BVO477s8Olgu1uQ6iw0i3zNybyIvrZkGzMPYbVO+ERb5UiiImi461t7g7WJUwXDiG
         LUE07ykWmtn1ukS7zNFgsGCUWFqrgek/SuWlrcpu/udR3MKyp6cga/YhKcpiXqXZShUR
         N4kNSc033fYBMU1oU336mWuwwENheza2114WYsg/8HSLYp2LqVBwI+hythwbITjs+D6q
         oe9ZF6NQQ2Coyp5UfD253HKcPhmFcZsbMVmXapl5bVsEOUqAdNKyOY7lq9i8gl7POMqB
         vwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680604625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuAO/TXt1co2Yl/jE9f+m6f2f1iw8gMZ65fgjuKcqFk=;
        b=NBoAgK2or4sB90N/NPnOF94itohYVXKsoTwF7oReDVe6oKhYEUq8DuaWYy09WnHHHA
         2QJaZ1tKA4Tgf/EbMctz9tZ5TzIBzOGCZ/5wgYC5w13Utx61OR6efOptfpTiKGE7Oiyj
         cLvotyU3KZ4YEVFSQgNjGecsDweTikNa75aFKOY94+o5Q4D8rhG7XeVStQaZQxMrVwty
         EwavTjOYNnaI6mwt0pOJhxDFHN/E2EsoL6PfN+WCb9G0nuDNb+3dXZvPgQtGiJb3xtLa
         yBm0M333WKe3KniwOjJrBAn8g7D10LcOyvqwgq2FX38TUZ2x+Ka22tcoJgjSiftWaD0e
         xi3A==
X-Gm-Message-State: AAQBX9dhitS+8IEXVfix8b/Ff0S8bB5hdYjw/TF2sCV4gdezrHbYpId7
        nZhf+sNw/P9fBhkzVIZsuI6F+XllC6O+MSLKmFE=
X-Google-Smtp-Source: AKy350ZLMiwfQ0OYpYPabzR/YEcjjfk0uwyQ/gfJTgITHcf5YGeISd1e8jdWC9U7i3r6VQVA7eDzoxcoEcDxyLHByQI=
X-Received: by 2002:a63:ea4d:0:b0:513:a748:c7d5 with SMTP id
 l13-20020a63ea4d000000b00513a748c7d5mr544257pgk.3.1680604624434; Tue, 04 Apr
 2023 03:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230403095200.1391782-1-korantwork@gmail.com> <4235f3f7-bae5-1f5e-582e-077bc5d03306@gmail.com>
In-Reply-To: <4235f3f7-bae5-1f5e-582e-077bc5d03306@gmail.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Tue, 4 Apr 2023 18:38:13 +0800
Message-ID: <CAEm4hYUOkPT4mHa0NQyUcSzaaCeLnco79-fU=bkRBROuwbT0VQ@mail.gmail.com>
Subject: Re: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about VMCB_AVIC_APIC_BAR_MASK
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Xinghui Li <korantli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        mlevitsk@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 4:40=E2=80=AFPM Like Xu <like.xu.linux@gmail.com> wr=
ote:
>
> On 3/4/2023 5:52 pm, korantwork@gmail.com wrote:
> > From: Xinghui Li <korantli@tencent.com>
> >
> > VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
> > which is meaningless. Delete the duplicate one.
> >
> > Fixes: 391503528257 ("KVM: x86: SVM: move avic definitions from AMD's s=
pec to svm.h")
> > Signed-off-by: Xinghui Li <korantli@tencent.com>
>
> Reviewed-by: Like Xu <likexu@tencent.com>
>
> Do we have any tool to find out more similar issues across numerous subsy=
stems ?
>
As far as I know, there is no such tool.
But It seems possible to develop one, I will research it.

Thanks~
