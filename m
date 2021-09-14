Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE440A4A4
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 05:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbhINDfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 23:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbhINDfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 23:35:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEFAC061764
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 20:33:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q22so10884815pfu.0
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 20:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vi+6Oqzw5KxlySzgQbdJRDGWe6tPJCzCtUhaRDBd7v0=;
        b=sx8egWgqFJdVg3oPrF2H/aMEWHH1fVFnCjLuhahKZJkxB5zim7av5ZHPiWAux7YLu4
         /QvAsTtpu1bY2KFKwQDqqKT24Xq0gVO2HdvHIbTP5rwCfvYJmTA0XoYlhyqxIYGBGVSN
         b1GpiZRgPxOXmKBhyBae38JdmOZmVRqCovCyd9qO53zTFTK5IHN7J8Uu0/cupFgXB29O
         w1A65ec5e+yvYMP6d0uUdFg2bThTc8n8wbKrnDibWKb3ekrd4bghP4xEfTDwqFeZZrR4
         55rUjD1IgbRJ5cqEPWjTHpFurBakE0mj0gF29cNihRJygPfjSZ4ViB3PWNbLTIX+O5Md
         +fPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vi+6Oqzw5KxlySzgQbdJRDGWe6tPJCzCtUhaRDBd7v0=;
        b=aTGu8sb1ws/WhJIgAYMwOp5nbkH851bhbupQhimjW4Oi1bKZ7RwESkpVnjlHVXxr3v
         T9OqAeVkgcYywThgyR8PC6Ij+llx4NRPrTn3oEV43ueLWXKuMICP+2qtFvEQbHMJqlpA
         qjjLKxH4I99e+zXGNZpivvl39N8hK1w65FZGFwocU74wVE7jqlHsxpAhcMFUZyUfdLTL
         QiB10jnSYUUbJei9w0V/bH1qKcwk7GLxNniXD1MhgLuLk2xLbwpcAa9e6wc2RwRdY7Qm
         OKh0xUw5+04kiBR50BhsGRUsa4NBI+YQOspr28tl7xDCWgwjMO/PH1DYLSJUakDQALAr
         dRjw==
X-Gm-Message-State: AOAM532GbzjznrtiyUKOMSicyyUqMHrwbFoYMSibAdURHuskyKK4+kGr
        ZZR6cX4Wa7x6MFRPFMPf9BQX0mtCEUNm+oDIRX21FA==
X-Google-Smtp-Source: ABdhPJzw2S/YgGBtO+1c3RPc29HGMQ/BkgHUl3KdPyLmldqI8eb6LknV3uVQi6FfdOHbKpFzUguwneEzrAZEpaVH5hI=
X-Received: by 2002:a63:d806:: with SMTP id b6mr13920055pgh.395.1631590426624;
 Mon, 13 Sep 2021 20:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com> <20210913230955.156323-10-rananta@google.com>
In-Reply-To: <20210913230955.156323-10-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 13 Sep 2021 20:33:30 -0700
Message-ID: <CAAeT=Fyd-K6OSLuCTBsxwqv77yw8YzPouOM2Oiocw4R0qW-0mQ@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 4:10 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you for creating this utility !
Reiji
