Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7D35FB5E
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 21:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbhDNTKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 15:10:25 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:42773 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbhDNTKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 15:10:24 -0400
Received: by mail-vs1-f48.google.com with SMTP id 66so10870653vsk.9;
        Wed, 14 Apr 2021 12:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3hnQcI7xgmsUuxItoue27NrG4aaS9+tEraOADPkosg=;
        b=KrGxujkCDokuUGN/ReAyrgbtaaoF9OgSrdt+vXPM/hS99xNPWr3L7skUAi7532xC9t
         +54QuzHCnClLvsC5eIibRDW0j7Jip3PwShxKmQaJHbP1E3HbCpMWl8sHQK6P2KWDROgB
         15j6Acm8gx1mZhVIr6gUXqyZu1peUYkEBVvv16JeqkcUCV+RvkC60O5xZK2zYqGTZsJy
         ldxOTewIc4kzSf9GiaHgRRb7WLyGzHAj2O47NihiTDaew5kHXlHGonnGJU4CdHlECKIz
         +ZuW5mEyxUkQHC1aXYcCrbsrJ5VW/dA+ANz4aqtCtwVkoSWCGs6DVhbFctxzVRyNQpTP
         xd5w==
X-Gm-Message-State: AOAM533VJzrRMsHdgPyTFM3FpFAv3/p0D158UKF0ohgXmgIM9AKYZZon
        w/ERdMbp6TnO+H/UJLyqHDps6L5Y9HKA6ZIYUZw=
X-Google-Smtp-Source: ABdhPJxJbGWB0l+pI+e+zsAVHVBLwrtdJbfPrWC2SKJve8ijlw7H6jw/dP0+aFP/QglhH1BBHAHmIOlyMsd9AxB04yU=
X-Received: by 2002:a67:80c4:: with SMTP id b187mr29948111vsd.42.1618427401975;
 Wed, 14 Apr 2021 12:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210414134409.1266357-1-maz@kernel.org> <20210414134409.1266357-5-maz@kernel.org>
In-Reply-To: <20210414134409.1266357-5-maz@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 14 Apr 2021 21:09:50 +0200
Message-ID: <CAMuHMdVfwRv_66mMz79rvszdgXnovrS_FZzPRK9fqOMH5Npu5A@mail.gmail.com>
Subject: Re: [PATCH 4/5] sh: Get rid of oprofile leftovers
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 3:53 PM Marc Zyngier <maz@kernel.org> wrote:
> perf_pmu_name() and perf_num_counters() are unused. Drop them.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
