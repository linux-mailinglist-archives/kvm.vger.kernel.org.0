Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C4A3EBC31
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 20:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhHMSpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 14:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhHMSpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 14:45:18 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E70C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 11:44:51 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id z24so9031687qtn.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 11:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SNXandYhUOxS7oPSs20qMYKFYu/PNMg3HF+rzxu9Ino=;
        b=iWrVy/Isj7vDkyRo1jnXyEGmcKub6nEFPRzN2yRQwUf/yy7PFqt1cE23pa1rPIXUD3
         wIo2ReBtzZ5b4fIs7QPtA59uqnamqWnejGm/iqRlBe9VefKeRAxbn7EwrwJy8vWWz7G1
         v1GDGwxJ1tMJgnyOsu7hkYQdNqQuwOwH8gBqZgWmFLhZDpc7Kyv3sn98zyVJsr7l5wlh
         f6IyofzfKuc+MrWOetHjvHirClFLHtzy3meno/WPltvAcHQ9P4NZCvfGG2Rm7p80GYXD
         9xMXB4yjuyO8FypAu7ULl/D3esxOTJf5eeg7R/7yYuNwWm0/kE+0edsLXXZDhBa2YgNN
         LBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SNXandYhUOxS7oPSs20qMYKFYu/PNMg3HF+rzxu9Ino=;
        b=GmxqWh6uYV2cNNSnyPTNyNRF7PBmMFGsfDqieoMoGuUrsc7FDxX6ljq/aWLQY8IXU5
         s5Lst0nqTYQUQm3NQUySU/frpHBMexXY5lD6+E5N/T1QTcTZ6WdSozkhk9gY1tCAnqIZ
         2q36ZGG+6M0GsxswONZDIP4Q5wlwrMXGVWIX4fqr0shu2TlYwS7exGNcmvhiyuE3e86p
         MH0PNRF97y+De7h1ac0q56sLllU/rhY16av37dcMpQKJrId3ZJToAVwodlXwguQmS1ZC
         BYsWC+RmPEoe+0+CrhRNw9xmo6Tn1tzTyADz8CSR/82pcUqOJGcLXRRei37ufh2i8bKL
         4l1Q==
X-Gm-Message-State: AOAM530SJg+9FqvGZQd8Uz50FEu2eJ/IiYyXtS5fF2x7hcG8MVOzB1hs
        M3S1ur14A2edgfjIjsnGJhqDqOQVbcXRcvq5I2NGig==
X-Google-Smtp-Source: ABdhPJx+2fXBNtq/rnC2cLlt3TODQwgOHg4vYosBnSjB7WjNeXZNhqIQ3naWpLz+Dnh6Pm35r8qP8dgDDCy3OIV1fkE=
X-Received: by 2002:ac8:5183:: with SMTP id c3mr3259022qtn.251.1628880290108;
 Fri, 13 Aug 2021 11:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com>
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 13 Aug 2021 11:44:39 -0700
Message-ID: <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>, drjones@redhat.com,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 2, 2021 at 4:48 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> This series brings EFI support to a reduced subset of kvm-unit-tests
> on x86_64. I'm sending it out for early review since it covers enough
> ground to allow adding KVM testcases for EFI-only environments.
>
> EFI support works by changing the test entrypoint to a stub entry
> point for the EFI loader to jump to in long mode, where the test binary
> exits EFI boot services, performs the remaining CPU bootstrapping,
> and then calls the testcase main().
>
> Since the EFI loader only understands PE objects, the first commit
> introduces a `configure --efi` mode which builds each test as a shared
> lib. This shared lib is repackaged into a PE via objdump.
>
> Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> relocate ELF .dynamic contents.
>
> Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
>
> Commit 6 patches out some broken tests for EFI. Testcases that refuse
> to build as shared libs are also left disabled, these need some massaging.
>
> git tree: https://github.com/varadgautam/kvm-unit-tests/commits/efi-stub

Thanks for this patchset. My colleague, Zixuan Wang
<zixuanwang@google.com>, has also been working to extend
kvm-unit-tests to run under UEFI. Our goal is to enable running
kvm-unit-tests under SEV-ES.

Our approach is a bit different. Rather than pull in bits of the EFI
library and Linux EFI ABI, we've elected to build the entire
kvm-unit-tests binaries as an EFI app (similar to the ARM approach).

To date, we have _most_ x86 test cases (39/44) working under UEFI and
we've also got some of the test cases to boot under SEV-ES, using the
UEFI #VC handler.

We will post our patchset as soon as possible (hopefully by Monday) so
that the community can see our approach. We are very eager to see
kvm-unit-tests running under SEV-ES (and SNP) and are happy to work
with you all on either approach, depending on what the community
thinks is the best approach.

Thanks in advance,
Marc
