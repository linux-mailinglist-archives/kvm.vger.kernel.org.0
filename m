Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A33DDD01
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhHBQAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbhHBQAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:00:51 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F9EC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:00:41 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id f26so8595030ybj.5
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7d1KMKhPVAtFt+6yJPpWyisqBodVhLAGaJc1MWHIj4=;
        b=oZ1mFdH2xiPvMLs7SyzZtWVNTZrMCQ8MrOf20ldeffjQurnN+yGxHpdacTaSR62QZ8
         lD6eTlmej3jRRWwulaxe1VvjownKMAlt1HvWPORiELogu7OJlCO6AAWrUBOw7cLx4KuJ
         DhQfqM8q/4e0lFYHfQPw0RTgcjc0qnDWb8zXa6y6oCBU8BgnVzc7Gm12ogvPchchbCVh
         X7LmmV/31z3w01G2uamaFdtAb2ACWMUCRutDy0nUERe66NaVsrHJRuUGX4+yTMufwHTs
         cviV+/wHElFSBOnhdjyoSOR8wNo5l5ireF4dMUsZCwvFV12UuHzcl5N5WGIZRkYi+dFi
         c0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7d1KMKhPVAtFt+6yJPpWyisqBodVhLAGaJc1MWHIj4=;
        b=LlVs23DOKaO45I6XatWsAuW/lhzSSsmXPtHRECtcsyEHe6GmSnDQrnFnJr6ionB+du
         PbNPvpRWCNLMLaHqrUiuYWJj4AmX6vaa5u5I9S/f6ep4VmP6aKOVgslEQqLjb5WpJteb
         iCp6G7lk9joFUZdec+cAJp87BftHMSIn3aJaHPQ4PUjyTKxefdD9+GARDtaAvtEPMdB3
         6HiwepCCPBQNT0+mDRSxUt1Zstamme87JuoGDLm/nQdAHVDCTlFJadyvt0c2CS/92hHG
         FYvO7aVjfBhtCWUuSxxUlogYuGRd/ZVjoowm3KJw0hHNrYJOW2FZkogPPWurgbCre3TU
         Z81Q==
X-Gm-Message-State: AOAM53238XZwPz5BBeHHc+vvzbe66LjsGKErNJJ5mydCRlpVlWAhwgmp
        RKf6T3pGaVEW4LAga3MuT0aoBsOos2XlUqVzXEbR+w==
X-Google-Smtp-Source: ABdhPJxEEbrzE4pCSuIuPs9REd9iyhRO0tbVpKI3os05SgbRTCQ/KcrPwXZlPkGCRUJst9uyv0WHivv9H+hck3Apnt0=
X-Received: by 2002:a25:10d4:: with SMTP id 203mr21855236ybq.454.1627920040251;
 Mon, 02 Aug 2021 09:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210731011304.3868795-1-mizhang@google.com> <YQf1SDrEi8zl03Dv@8bytes.org>
In-Reply-To: <YQf1SDrEi8zl03Dv@8bytes.org>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 2 Aug 2021 09:00:29 -0700
Message-ID: <CAL715WJo_sAmnZ170iJ7TenehJcm3KYLLhjyHi8Jw61whUU-zA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: improve the code readability for ASID management
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right, it does not fix any bugs but improves readability. I will
remove this primitive.

On Mon, Aug 2, 2021 at 6:38 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> On Fri, Jul 30, 2021 at 06:13:04PM -0700, Mingwei Zhang wrote:
> > Fix the min_asid usage: ensure that its usage is consistent with its name;
> > adjust its value before using it as a bitmap position. Add comments on ASID
> > bitmap allocation to clarify the skipping-ASID-0 property.
> >
> > Fixes: 80675b3ad45f (KVM: SVM: Update ASID allocation to support SEV-ES guests)
>
> This looks more like an optimization to me, or does this fix any real
> bug?
>
