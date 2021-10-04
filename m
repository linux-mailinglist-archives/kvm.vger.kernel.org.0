Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3E421664
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 20:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhJDS26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbhJDS26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 14:28:58 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D75C061746
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 11:27:08 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id d131so22587785ybd.5
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 11:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIqLRUwkpWrhqoIb+2LbHIi6YwYZzYCnePRyYQW7lLY=;
        b=gjvD3+vx4+r4kREI+kJyLRqAt3T9ueCkkwyrIGXw4kVjsxk4B+g3/MppZhl7N6wTiV
         PMJqtTnyCh8HPiYVaClZKX6vsiy/6Hky+sKMa3Lv0KbQMju9xs4Np2wLdKgAB0JjT9Od
         WKQmaL+SK4LQ59q2qi8GLJ4pEsOTqRJWOl1nQNfc6qULxZIsXFlxrSF4fWxTsGlbaevw
         2YN7Xw8DA2tlSfBVpAcffPslrlDJrVUOjvu3UqCLjaEuFPaWwtlUYBZRaMkFjY1QzZ/Z
         uDOdzZ5anwcBpaqRWOz2jV0W6w/UdOifflY5/OMNNvn9JP/fumSBYvDtWLn74afG0khE
         2vwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIqLRUwkpWrhqoIb+2LbHIi6YwYZzYCnePRyYQW7lLY=;
        b=48cyXpxiRhmjdixvfRyMLSKP8CbXSNsMfQmY90zPmUAMup0cD2SXsCU/L+imSnAWZG
         heh5oBkcmdoP5Pxbb0fbIhN/dyCRFsXQwm2ZaZowVToY2dTOHiqX0Mb8WLSJwFBPGkOS
         BaLOWx+EHjfAtiAySMyRxYcjAAW9mCKKDcs4x9hS3a6pSzueIoKB1cpQhb30Iszsjn4Q
         ZgRFKSn2UT6BiTWR3nAtUv+S/ws89oNEjycMCLgSnEaiIafUev+wAaG/G7ftQjJf6SAo
         N9++f2jNW1iLq94s6KFmdetYQ3NQIbYVw+YrKAjihfzjEwRpp37aPeMFK+dEK1beBaBb
         p1tA==
X-Gm-Message-State: AOAM530VCpnRpgtl84ZoPTrmZmwAM07qzXb6hUtN6ZmiD3yZcXOeUMI2
        625OWJezTrXN/3/1G0xRa3IcXVzOoKiXbt3xBk+LGQ==
X-Google-Smtp-Source: ABdhPJwQO8pJHFNb8p9v0Uv+zTJOyZYyUBFOwoiGCzuPT59UynGevvRHp+VVKupk5VUaX29Kw8b7Zy4woqEdE6YhWDI=
X-Received: by 2002:a5b:283:: with SMTP id x3mr16689301ybl.439.1633372027973;
 Mon, 04 Oct 2021 11:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com> <20210914223114.435273-13-rananta@google.com>
 <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
In-Reply-To: <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 4 Oct 2021 11:26:57 -0700
Message-ID: <CAJHc60yXKdCCpSejxwGpmqoTenm=3589+ahmzkLkSnmy89+YLQ@mail.gmail.com>
Subject: Re: [PATCH v7 12/15] KVM: arm64: selftests: Add basic GICv3 support
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 1:06 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> On 2021/9/15 6:31, Raghavendra Rao Ananta wrote:
> > +static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
> > +{
> > +     /* Align all the redistributors sequentially */
> > +     return redist_base + cpu * SZ_64K * 2;
> > +}
> > +
> > +static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
> > +{
> > +     void *sgi_base;
> > +     unsigned int i;
> > +     void *redist_base_cpu;
> > +
> > +     GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> > +
> > +     redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);
>
> This is not 'gpa' and I'd rather open-code it directly as there's
> just a single caller.
>
> Zenghui

Thanks for catching this. I agree that mentioning 'gpa' oddballs this
function, since it's called from a guest's point of view. If there are
any other major changes in the series, I'll try to change this as
well. Else, I will try to raise a separate patch to resolve this.

Regards,
Raghavendra
