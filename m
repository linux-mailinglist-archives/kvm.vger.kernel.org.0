Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0438D3FEDC8
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344420AbhIBMcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 08:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234098AbhIBMcM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 08:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630585874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1bF0+pdPFV1oPqtHYhh2gb/KkOQLq0K7gX0PwtmmkGA=;
        b=iGKkNJW1LysqKv0d01S2ie3jo4e9FI+rss9lrkG2wV89kYI980/O8mT5cA+O2iENiSPPTe
        T+UHSjfzbEKMh5TBoC1JuxS9paSTV/JVfYT/fWH6rTYw3bAb35j3y2wNX6XTFOQBvKI+AP
        JhsYP6gONzunUMONih4YkEeqYXKCzBI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-fjM6TJtXMAG8aMZcWsunXg-1; Thu, 02 Sep 2021 08:31:13 -0400
X-MC-Unique: fjM6TJtXMAG8aMZcWsunXg-1
Received: by mail-wr1-f69.google.com with SMTP id v6-20020adfe4c6000000b001574f9d8336so480109wrm.15
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 05:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1bF0+pdPFV1oPqtHYhh2gb/KkOQLq0K7gX0PwtmmkGA=;
        b=O47uBtWcJuYD7Skw0E2QAx+anaS4SAkYCqv8GAJe6lU1b/p42kH4a6xbA7I6BBy5EY
         PpzXXWrj1CD2aME3M3Gu5YfcvYpcYkwnssYAF+URz1RglzWSKRbutc1A2NTIDbh9Wdoh
         5QniKbLUHvGRLLgs0T6JpMrHJYKp11Cltb7JtkuOYiPCb8cBQQhjrsSfo9i73AxBf3c9
         EOTjIvZ8IPZZjBzTXbbZLkNn4CShLjpIzW3UDQe2637SL5xUv9ZZPVfdiHbm6qlMh0mG
         LUCM0TevWNr5Z9u+m7pOJXB2eQtHdH/k2t6nUkNjbimwviFiyO+OFxZfe5q8vaL1p2SN
         GzFQ==
X-Gm-Message-State: AOAM5334FcJJACdsUZ18snHKDn3nHVNFcYmWAmZW3fQwm3i/Uhki9bbC
        XQ8CIICaVUCLEao6AV2iA3igV/ZApJkJz7DyqmNr0f9S/sIVu8Pn/kxBgUg8OZRVw7/uzA31iSW
        taADwHb4mIpwI
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr3459269wrc.12.1630585872056;
        Thu, 02 Sep 2021 05:31:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzw9OYDFsRzxtUxt8WzFVuzQqX9uKEjP7AudR21ZtDRAs5a3V/WpA+nMGwkaPm1bwnde7r7Lg==
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr3459246wrc.12.1630585871881;
        Thu, 02 Sep 2021 05:31:11 -0700 (PDT)
Received: from gator (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x21sm1539270wmi.15.2021.09.02.05.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 05:31:11 -0700 (PDT)
Date:   Thu, 2 Sep 2021 14:31:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <20210902123110.royrzw4dsykkrcjx@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com>
 <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
 <YTAHYrQslkY12715@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTAHYrQslkY12715@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 11:06:10PM +0000, Oliver Upton wrote:
> On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > > For register names that are unsupported by the assembler or the ones
> > > > > without architectural names, add the macros write_sysreg_s and
> > > > > read_sysreg_s to support them.
> > > > >
> > > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > > arch/arm64/include/asm/sysreg.h.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > >
> > > > Would it be possible to just include <asm/sysreg.h>? See
> > > > tools/arch/arm64/include/asm/sysreg.h
> > >
> > > Geez, sorry for the noise. I mistakenly searched from the root of my
> > > repository, not the tools/ directory.
> > >
> > No worries :)
> > 
> > > In any case, you could perhaps just drop the kernel header there just to
> > > use the exact same source for kernel and selftest.
> > >
> > You mean just copy/paste the entire header? There's a lot of stuff in
> > there which we
> > don't need it (yet).
> 
> Right. It's mostly register definitions, which I don't think is too high
> of an overhead. Don't know where others stand, but I would prefer a
> header that is equivalent between kernel & selftests over a concise
> header.
>

Until now we haven't needed the sys_reg(...) type of definitions for
sysregs in selftests. In case we did, we defined the registers we
needed for get/set_one_reg by their parts, e.g.

 #define ID_AA64DFR0_EL1 3, 0,  0, 5, 0

allowing us to choose how we use them, ARM64_SYS_REG(...) vs.
sys_reg(...).

Bringing over sysreg.h is probably a good idea though. If we do, then
I'd suggest we define a new macro that allows us to convert a SYS_*
register definition from sysreg.h into an ARM64_SYS_REG definition
for get/set_one_reg in order to avoid redundant definitions.

Thanks,
drew

