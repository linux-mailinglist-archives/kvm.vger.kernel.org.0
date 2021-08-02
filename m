Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E5D3DD7CD
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhHBNsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhHBNr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:59 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66763C061382
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 06:47:33 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so12036wmd.3
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
        b=iSwcVNXbwMj6bVndtAFh7/bVmULdw+Y4ZH4kvjV+Mb+DxmGuikESzaj9cZHzvQhcFz
         2eSHGQSrKDRpbtKb/YrDbNUibFkKb8uFFnLk+qF8lmUt43Ukaxxq/v2lDPf36NI/ZRr1
         VXf1q8muGbwUkVEgTkW2yIhJfPzY1gVV7HEaMODfE67CUAezeMGlH1xyXDm8GyIAqTSf
         X2Ye+SXcHcjI8EFlHa5CEW/ZYQ/qXGLCRNdkqaBRZhA7vMLLuIJlJUa8IM00fF1ft3l0
         8Jrr8L8IQh/ExzlathQ0Iqs3f13X25ek8ua+hPjVzfA0RJPAWlAii6VnDph3LkL1thD0
         AatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
        b=EzcRvCytp1Q94Uh2rVnoA6w72UyZ4yhbd7gXroLHiLuPrJ9Um9QB2kNVgwMPTwsGKJ
         MpZqp7koU4j5jTrPuhjEAzupPnTY4aEza3nKRlCpWzKLWYAjrVyJKNo5b/11F2DPAAgl
         JhEPrXqWlbDlIv/RuorQRvKgFHGoB50s9CKhyQFqBWl+JcXvfFc6JM66E4Cb5zjoPVbS
         VzOIr3GN6U+OiDowOH48RihpVAlvZ4yPtIckdGGfbDfg0iuoZrkfKCA6SPcEMAxNsGt1
         toAsT4N4hWuWSU6HX5htrr6BB79bxK6LZUtR72jT0UKoMghNW9cjbj1Ao3WbBg20SKQ1
         0HiA==
X-Gm-Message-State: AOAM532R/zv87wpRVJLpyZmPx50IJAkeTg9GjUzJmGm8nnLQzD/LPpjj
        tCzYxfRyrrLO4ZssegM7Ijt2jQ==
X-Google-Smtp-Source: ABdhPJyu3MDRDzEwimKK8eR6XfIVIZgUH41B1Kmkh8eOZJZPZLglJQmXQDBg756DblUv9SmM0jIVwQ==
X-Received: by 2002:a05:600c:2306:: with SMTP id 6mr16843468wmo.115.1627912051856;
        Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:44fe:c9a8:c2b2:3798])
        by smtp.gmail.com with ESMTPSA id b14sm11551749wrm.43.2021.08.02.06.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Date:   Mon, 2 Aug 2021 14:47:28 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <YQf3cKjMa9rrGRqP@google.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
 <YQfu6+3uo6qlxrpv@google.com>
 <87mtq00yqd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtq00yqd.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday 02 Aug 2021 at 14:20:42 (+0100), Marc Zyngier wrote:
> Hi Quentin,
> 
> On Mon, 02 Aug 2021 14:11:07 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Monday 02 Aug 2021 at 13:38:29 (+0100), Marc Zyngier wrote:
> > > The HYP rodata section is currently lumped together with the BSS,
> > > which isn't exactly what is expected (it gets registered with
> > > kmemleak, for example).
> > > 
> > > Move it away so that it is actually marked RO. As an added
> > > benefit, it isn't registered with kmemleak anymore.
> > 
> > 2d7bf218ca73 ("KVM: arm64: Add .hyp.data..ro_after_init ELF section")
> > states explicitly that the hyp ro_after_init section should remain RW in
> > the host as it is expected to modify it before initializing EL2. But I
> > can't seem to trigger anything with this patch applied, so I'll look
> > into this a bit more.
> 
> The switch to RO happens quite late. And if the host was to actually
> try and change things there, it would be screwed anyway (we will have
> already removed the pages from its S2).

Yes, clearly mapping rodata RO in host happens much later than I
thought, so this should indeed be fine.

> I wouldn't be surprised if this was a consequence of the way we now
> build the HYP object, and the comment in the original commit may not
> be valid anymore.

Just had a quick look and that still seems valid, at least for some
things (e.g. see how we set hyp_cpu_logical_map[] early from EL1 while
it is clearly annotated as __ro_after_init in the EL2 code).

> > 
> > > Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")
> > 
> > Not sure this is the patch to blame?
> 
> My bad, this is plain wrong. I'm not sure it can be applied earlier
> though if my rambling above is correct.

By the look of it going all the way back to 2d7bf218ca73 (in David's
PSCI proxy series) should actually be correct. But not sure if that's
really going to make a difference before the patch you've mentioned
above as the kmemleak issue will only be visible once we have a host
stage-2, so no big deal.

Thanks,
Quentin
