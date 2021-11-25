Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1D45D36D
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 04:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhKYDJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 22:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344081AbhKYDHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 22:07:38 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD1FC0619D9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 18:23:47 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y7so3434862plp.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 18:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xFLS5Osf0Yq9hrh1R+jPqQbxrd4QeHBJiKo15Rlwxss=;
        b=gt+CnbIhXSWZFRXO+JyoFnk7WgmjKBbkUkhF9Hto5JtuBqgdv4VEkkEN7LTIMqcNo3
         fJa3lV7sl7T6tVrE5Qxf/hDkbDePK91LPbOxfpI8k9AvkVK5KzLK/K1Weiax6SB0wkdF
         3n14xLxD1mBRl6dFCKL6GdrGNaTItauZtatK0NnbKxrMw/oyNH8TWvWdSL2IQuAI5IhY
         roZLPPRcMD3QsruezRFnclk5QhgurJim6oRq3veff6G+nYO6JhYAURzFW3Xf4kb8ylz5
         KvfgIDali36j+6mqKA/FEpC+Lltqm0xWo0zxvRLD4yPKz8Brr0r8j62VYQoWqHsL4RAv
         j4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xFLS5Osf0Yq9hrh1R+jPqQbxrd4QeHBJiKo15Rlwxss=;
        b=LY2yXVHfbJ4dPY1VmQSGZblmsVkUwDcRHPGduPUcMqASC6wxNOzx3liAEWEim6Z34K
         9SyKkIn6Pfj69lB0gRqW0A6OuefhJ4KrjHVD4uZC/5yMMuHCnLhHNN0R8dT9fZH9mgeG
         aRECG2M6L33uIWQmGDjr2rFNLQGUeLzGcsxSp3zaXkhqheGnFo2nF7daKEIyr8vvy85l
         xqHclEX6K0POIpwonptTiJYFyXfB6B3nToIAsXM0WOnJnHCy0xQcRjq/qbi4mLAJ40Ef
         od/IcIPn19xRe1lQ0gV2vOlq2C96csqIAWGOyvOgtlDuTCVJKFLNjEuomPJTVaQr/uJV
         B6AQ==
X-Gm-Message-State: AOAM532rsAIs0PoCEBYOUlvpCuK+FUaS8qBwoll5D768J4XlcXboJxzx
        EdBrVVloQS8fquyKwwau7I97nQ==
X-Google-Smtp-Source: ABdhPJyFZuUHjsN9HP6H4qPfFRhjwow47Wx9NzNMHdvs7iUWMDG4eO/Sk4e4+s2lEUImw4f5MDk9ww==
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr2597640pjb.232.1637807026679;
        Wed, 24 Nov 2021 18:23:46 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id z19sm1032446pfe.181.2021.11.24.18.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 18:23:46 -0800 (PST)
Date:   Wed, 24 Nov 2021 18:23:42 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ
 injection
Message-ID: <YZ7zruK4ox/Qge90@google.com>
References: <20211109023906.1091208-1-ricarkol@google.com>
 <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123142524.4bjhdvw5pkx3g5ct@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021 at 03:25:24PM +0100, Andrew Jones wrote:
> On Mon, Nov 08, 2021 at 06:38:49PM -0800, Ricardo Koller wrote:
> > This series adds a new test, aarch64/vgic-irq, that validates the injection of
> > different types of IRQs from userspace using various methods and configurations
> > (when applicable):
> > 
> >     Intid        Method     |       |          Configuration
> >                             |       |
> >                IRQ_LINE     |       |
> >     SGI        LEVEL_INFO   |       |
> >     PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
> >     SPI        ISPENDR      |       | edge-triggered      EOIR only
> >     bogus      ISACTIVER    |       |
> >                             |       |
> > 
> > vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
> > configurations above.  The guest then "asks" userspace to inject all intids of
> > a given IRQ type using each applicable method via a GUEST_SYNC call.  The
> > applicable methods and intids for a given configuration are specified in tables
> > like this one:
> > 
> >     /* edge-triggered */
> >     static struct kvm_inject_desc inject_edge_fns[] = {
> >             /*                            sgi    ppi    spi */
> >             { KVM_IRQ_LINE,               false, false, true },
> >             { IRQFD,                      false, false, true },
> >             { ISPENDR,                    true,  false, true },
> >     };
> > 
> > Based on the (example) table above, a guest running in an edge-triggered
> > configuration will try injecting SGIs and SPIs.  The specific methods are also
> > given in the table, e.g.: SGIs are injected from userspace by writing into the
> > ISPENDR register.
> > 
> > This test also adds some extra edge tests like: IRQ preemption, restoring
> > active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
> > nr_irqs).
> > 
> > Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
> > test the vITS (no MSIs).
> > 
> > - Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
> >   priority of an IRQ.
> > - Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
> >   wrapper for KVM_IRQ_LINE.
> > - Commit 6 adds the basic version of this test: inject an SPI using
> >   KVM_IRQ_LINE.
> > - Commits 7-17 add other IRQs types, methods and configurations.
> >
> 
> Hi Ricardo,
> 
> I didn't review this in detail, but it looks good and quite thorough.

Thanks Andrew!

> Out
> of curiosity did thoroughness come from attempting to get coverage on KVM
> code?

Yes, that was the main reason. Although, keep in mind that there are a
lot of features not covered, like routing and the ITS.

> I.e were you running some sort of code coverage tool on KVM with
> these tests?

No, not really. It would be nice to know how much coverage (and
distribution) we are getting from all tests (selftests and KUT) at the
moment and maybe use that to decide on future tests.

> 
> Unfortunately I probably won't have a chance to look much closer than the
> scan I just did, so FWIW
> 
> For the series
> 
> Acked-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks,
> drew
> 

Thanks,
Ricardo
