Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688C3460DD0
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 04:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376902AbhK2Dvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 22:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376960AbhK2Dti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 22:49:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46F4C061792
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:44:01 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so33500140wrs.12
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 19:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QDxtMYsiGpTbjQ64wPI5k5f7+JtFNl3ARwWkRt14a8=;
        b=ZU1Eln/9SfoVq+B1U5sfkGF2CKQj0m12USLmliZF8vtG281sSfnKd1llBqsKNcuqc2
         8N5fgyQytGWDCJcq36yzg17WxrxXioox9VRTAfRnldAXTNEp37nVe8IechsY1OXtWqmT
         +1peJdK+SSGcJwBQrdIZu4l/IIJXoUr4NSG4jK2hWbBB2oroBW5p+6DMWALBuFNs00oE
         yMtPXtXwPlRH38pIp3gZBltyLvbPamz2XjmQtJ+J3Z4+XxIBEXmozVRZ/SePp8ecprth
         WM9my2Gykuzd4pOFMsuZiVkqv1Jzi9fnhLbPO7pmX7iwo4SGyvjXsJ6stCH3cM13JSPE
         Q0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QDxtMYsiGpTbjQ64wPI5k5f7+JtFNl3ARwWkRt14a8=;
        b=Hyq/G20Szj5fC4WV/d61Ho0zXp4PdwiQWZtyLapakyMQARo6jk95wg5pVj2QMDEkNG
         yadSAoAt4FRHx1Ojf0Msx1NvdoHVOwvFi6t7YciyA1oT5FQCSQXsNLm8nTMg50nOXG+y
         bBJVEp+P3OfjdCQL3wnNdke+emv9iaQEOM/8SiRRP34c9dVwK1CwiUKU2dX/YPwhxH6z
         C3EUEl3AmTPS6IlauXbhKsmvwuZGI/m/gjK3bDjJeQgNf6LDsfq24pgeCwYrYdGlwXYU
         l6uS/AwxKvjHltwgm6jwCJdx7dFDpV/rjyzUKlAZfa3IpIB6a374T5qtbghZYbk6lc/r
         Riqw==
X-Gm-Message-State: AOAM531ri3ScvGXmaOJIe83gDgPl8lOi6J+NfhCNQkhrnqTVGbj0Ee8y
        23qmKtO1zN1yPsMCq9Q3nVxU0ERpyh0qGGqFKUmX9w==
X-Google-Smtp-Source: ABdhPJxVfNspMPegX0nnAqIOrb8ixJr5KGAdRv5R05/KZLzp7MAcQcov9DD8ovNlUXIEHNvkgRgpGDqR8pC579umDK8=
X-Received: by 2002:adf:e848:: with SMTP id d8mr31758948wrn.3.1638157440427;
 Sun, 28 Nov 2021 19:44:00 -0800 (PST)
MIME-Version: 1.0
References: <20211126154020.342924-1-anup.patel@wdc.com> <20211126154020.342924-4-anup.patel@wdc.com>
 <9545cab7-6365-b20d-fc05-82ace6368661@redhat.com>
In-Reply-To: <9545cab7-6365-b20d-fc05-82ace6368661@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 29 Nov 2021 09:13:49 +0530
Message-ID: <CAAhSdy0v=CrxJwiMtkPaR9y2WHcwqZZC9-mgc0ZncJ--69rVag@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup.patel@wdc.com>, Shuah Khan <shuah@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 9:45 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/26/21 16:40, Anup Patel wrote:
> > We add EXTRA_CFLAGS to the common CFLAGS of top-level Makefile
> > which will allow users to pass additional compile-time flags such
> > as "-static".
>
> Is this just for debugging?  I cannot understand if it's used in patch 4.

Yes, this is just for debugging.

I am using it to add selftests ELFs to any arbitrary initrd so that I can
try selftests on Spike, FPGA, or even HW simulators.

Regards,
Anup

>
> Paolo
>
