Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CCF3F8DF0
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 20:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbhHZSiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 14:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243241AbhHZSiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 14:38:11 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337D5C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:37:24 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id r6so4225630ilt.13
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 11:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GAm5JijN4AEU/TD6X36+sfhDVS1/JaYRosKzetCw9x8=;
        b=PPK/6+9m5AQ/XQzVFR/xTbLDZ/dRbaed67pEoNOOMVIZEE9TZQd/gk5FMd0cUjk+Qy
         Rrif6nuaETT+ljaqlca+hXX40AeeBPw4T7UD1nQopn6c/n/lHFQ3a8s/9fgdJCqu2eMl
         GSSoRuXAy4Pm45MYm2sVaZ3USvODlJDxj96X9mXulrcvms+IF/UiHOBfSrjGqH45aDqe
         yOIawDyn9lubhVDh+CdABbSJIzwQ+Y30w1zYdRec9TbJsgp4oZt5vJR0atPImx4p0nLr
         vowSoEQUKN25nbcrV+A3hwwWLmvRnIon1buasyF7dOEfHpzPHDWoGh22n0geWmzd9Fxr
         xdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GAm5JijN4AEU/TD6X36+sfhDVS1/JaYRosKzetCw9x8=;
        b=SO9wL4W98K2EQfCRDizf043609wBLBBEtigcHVVbb1XWB4qjuo+Qqse8TRG8JU+2z9
         UeD7fwLtrDc91ILYbcrnOhwcT8gB0CWtlFe47+yc9EvYTP6f2YyYNNmIgXwHC49AD0On
         wH2kmJQMV2mU9WAolleZB4YPuLhghGPTapLRRVaFOIgCoRgO2+G3QF6CRtgeozCG+EEV
         qxf1QboiD0x5Puz5wMiP1mUcTE+GQdm2eHVfzcLFEY5Dbpe3C3WWqKE4YPsulll4ZLem
         Ws2702fOmaTqHjTmNeZeijNyiUoFjDY7StAdGI1WHZAAl/QuKXmAVJMCs0Ydp0qYuB3c
         kyeg==
X-Gm-Message-State: AOAM531E7ZjRip+IjHoSWUC6WmiXpFmIz8OBeMgWxdM4jKvaxJyFzW3v
        rAJfF+IKZkNKzps8l6v08OfePw==
X-Google-Smtp-Source: ABdhPJysNNpP1xRFngN1wyjZTHG7MW1CVdGV6b7GojI1wMIWgW3JN+jRUMXWcEvm/BNIa+DsEc6I3A==
X-Received: by 2002:a05:6e02:1846:: with SMTP id b6mr3880671ilv.264.1630003043324;
        Thu, 26 Aug 2021 11:37:23 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b2sm2012209ioe.23.2021.08.26.11.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 11:37:22 -0700 (PDT)
Date:   Thu, 26 Aug 2021 18:37:19 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
Message-ID: <YSffX53jVJsVzbv+@google.com>
References: <20210819223640.3564975-1-oupton@google.com>
 <CAOQ_QsgaACbcW276TAqrmq2E5ne-C2JiEDVGjVXg9-WRds8ZQA@mail.gmail.com>
 <8735qwpjhn.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735qwpjhn.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 11:51:00AM +0100, Marc Zyngier wrote:
> > > Patch 1 is unrelated, and is a fix for "KVM: arm64: Enforce reserved
> > > bits for PSCI target affinities" on the kvmarm/next branch. Nothing
> > > particularly hairy, just an unused param.
> > 
> > Title line may not have been clear on this series, Patch 1 is a fix
> > for the PSCI CPU_ON series that's in kvmarm/next to suppress a
> > compiler warning.
> 
> I'm not getting this warning. What are you compiling with? In general,
> the compiler should shout about unused function parameters.

Gah, this is just with local tooling. I'm unable to repro using
GCC/Clang. I see that '-Wno-unused-parameter' is set alongside
'-Wunused' when W=1.

> > > Patch 5 is indirectly related to this series, and avoids compiler
> > > reordering on PSCI calls in the selftest introduced by "selftests: KVM:
> > > Introduce psci_cpu_on_test".
> > 
> > This too is a fix for the PSCI CPU_ON series. Just wanted to raise it
> > to your attention beyond the new feature I'm working on here.
> 
> I'm not sure this actually need fixing. The dependencies on the input
> and output will effectively prevent such reordering. That will
> definitely be a good cleanup though, but maybe not worth taking out of
> this series.

Yep, you're right. There's an obvious dependency in the test that
maintains program order. I realize that it is only the second test
(patch 6 in this series) where things get hairy.

Apologies for the noise.

--
Thanks,
Oliver
