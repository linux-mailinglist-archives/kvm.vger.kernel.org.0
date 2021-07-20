Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC093CF807
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhGTJ7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 05:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbhGTJ6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 05:58:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E528AC0613DC
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 03:38:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t5so25424147wrw.12
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 03:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S2sNXLvJ4dwORJ7M5/nfuYVqqM+rERqyTBGgtikYXaE=;
        b=mPoeiN3M2AOmzdQgoZ+DsS2PhTUq2lw5i1UCT1ddfJG9kUVbabmUf6v6T/MJAnkcik
         Ud4mVQ2cHb5Bg2HqtZvCddGuPnOeb8RhDgH3SzMzXKHj4uvX2jEN8Bw0VcGbglQe2Dsq
         vouf/5a7Mc3Pn/bkqJbHrfvkh70Dq9nxzGQBXEDXMaQzIFsYiHlqx2FuNizQXtVY7UNp
         Kv41e6ik1XPLx4m6TiqW4Ngp46rhtMgmWDFnv+zX1TtY4Da+Ls+n3zuQMIb5C0HXeGY9
         c0JEnJGW7vgmMokunPk94EwP213E7vP7VRB1R/sKUjGSVeoOAqC0hBSVX+t0qmsR8XOf
         aT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S2sNXLvJ4dwORJ7M5/nfuYVqqM+rERqyTBGgtikYXaE=;
        b=hi+VKwRXWOBsFjmY9+3C83tKejJhhV1jQlhHrJI0+l+BDsxpPYnLZl5kcAB9Zt34eJ
         qPfgrq+p5Y1/HY0EnQxaermkaNib7jXifZp6HNqqrSM9CSoPYD3dvhEzHDST6yqE5j9s
         0p4e/aFDt1AYTiAjrxYIsEfUzy49Re2WC8QfMcjxkVz+9C1cfSJ82sPbOwqVZ8P1kDLC
         fG8oRNN8BoCtwslPQvHWfo/YfxCEfbovVqMHNmCYhLUsq9BSz/Luaf4bufEJYXQygqb2
         XNOKBYtMcI8U4v/svNeXHawuECulTLie5NiyCqkckdVrr1QcjUdElTEL50XxOw0BLPif
         QBZQ==
X-Gm-Message-State: AOAM531noL8loBLbweq7uOAC0Ig0aFENLWnQwCfHFBMXtzwkeV1zyCH1
        Or9GjGg+v338lmLNIhmtRQZrVA==
X-Google-Smtp-Source: ABdhPJy7g7Xq2cQ/7zmh8X/o4J7TfkA9+eUT4oUX5FYEN6LxPQ9LUW/2mD3SHGS2l5+cFKz+ca5WyA==
X-Received: by 2002:a5d:6992:: with SMTP id g18mr35879296wru.118.1626777501471;
        Tue, 20 Jul 2021 03:38:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
        by smtp.gmail.com with ESMTPSA id a10sm22857100wrm.12.2021.07.20.03.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:38:20 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:38:17 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Message-ID: <YPanmXfdr9rqnICK@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-4-maz@kernel.org>
 <YPag0YQHB0nph5ji@google.com>
 <871r7t9tgi.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871r7t9tgi.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday 20 Jul 2021 at 11:21:17 (+0100), Marc Zyngier wrote:
> On Tue, 20 Jul 2021 11:09:21 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Thursday 15 Jul 2021 at 17:31:46 (+0100), Marc Zyngier wrote:
> > > @@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > >  		.arg		= &map_data,
> > >  	};
> > >  
> > > -	if (owner_id > KVM_MAX_OWNER_ID)
> > > +	if (!annotation || (annotation & PTE_VALID))
> > >  		return -EINVAL;
> > 
> > Why do you consider annotation==0 invalid? The assumption so far has
> > been that the owner_id for the host is 0, so annotating a range with 0s
> > should be a valid operation -- this will be required when e.g.
> > transferring ownership of a page back to the host.
> 
> How do you then distinguish it from an empty entry that doesn't map to
> anything at all?

You don't, but that's beauty of it :)

The host starts with a PGD full of zeroes, which in terms of ownership
means that it owns the entire (I)PA space. And it loses ownership of a
page only when we explicitly annotate it with an owner id != 0.
