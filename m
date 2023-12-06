Return-Path: <kvm+bounces-3731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C7780760E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF51C1F21636
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A30D4F1F3;
	Wed,  6 Dec 2023 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mZFriFSN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BB1D4E
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:07:40 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2c9f572c4c5so67290751fa.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882459; x=1702487259; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVDl0W64scqWE1Z8AX7nRmNMJAFAUWb+DRtdm5KXlE4=;
        b=mZFriFSNl3+XfgqdHwa0GFcwvywsrXu6YtaLdk6lKW5dC2HoQnJjYrNqxh56pNh1xO
         Mn6BHCj21T96UGf4Lx6XDp7z/wKGYPBCqpJZQ+6Th/p0cxxvj4zQeLz1NQAdAZlk7j/h
         nRn8CPUZAddAWzFcJlk45DfSxhFRdgTKIb7nj4RAHedbe/N+PHvPiN+nlTxZhTf+yOio
         WoB7f8ROD4tOyRivz/szecXTAn05KMaES98LnW/rHIg7sgnlTyijf0SFiQth4WyVHERK
         T5DU61uGyiAwoktBWBRYj7jvwn4U/7fGy3XvF/hNDOHRZyMdnjNblgNQPL2ccWWXbtpL
         P9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882459; x=1702487259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVDl0W64scqWE1Z8AX7nRmNMJAFAUWb+DRtdm5KXlE4=;
        b=bJx9J32BFSjQE+wGJ+mTABVLk8trYKd+vgiXuIMjSuSPrU4KSGwGiUU+j80NMyMy8y
         XwXHBM2Fwcv1ob6Y2Iljbjw74qoS/W2ZSKYHP6SsYEbnLjdlnO6P0mMLrKFTx1rUuvYf
         UzJl+BBQzTLicWwGHpFFdfB4kPp4ee2Jhv/xnNLAzwq7GQOfAhlVcdmDYrQW7HEc4+Qe
         twSLh3dKJBYLrmf1ifKRJfC8DglgpNF6lAm0Dv8icaEKAykeOpVJMEQiY9/yYZMEuxFn
         FUG9IMO6QNqTRoeOTG1nsAZnamY30P7idY/QMQXy5HAbZrQlk+dvFmD4IBSYwWvFYbGJ
         H5og==
X-Gm-Message-State: AOJu0YxkAYhE0ny/nfJBtN5HVqcgSBBZwZYa1iuO2oBZ/l9Q/4KGNNhV
	4LNrQVqsOre75dOM/AYXXW5HOzwmuRmYE/H04j0=
X-Google-Smtp-Source: AGHT+IGeQ+chN8itji8iVK88ohy3+dv9u0czbDONNHlaOKS0xWPMsN/mkH2BtWaLEtpakXlc6flIbA==
X-Received: by 2002:a05:6512:507:b0:50c:c7d:9ef5 with SMTP id o7-20020a056512050700b0050c0c7d9ef5mr827625lfb.10.1701882458751;
        Wed, 06 Dec 2023 09:07:38 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id fx14-20020a170906b74e00b00a1cc1be1158sm171675ejb.165.2023.12.06.09.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:07:38 -0800 (PST)
Date: Wed, 6 Dec 2023 18:07:37 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, anup@brainfault.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [PATCH 0/5] KVM: selftests: Remove redundant newlines
Message-ID: <20231206-6c869e5bc8ddf3b93e5b6fd6@orel>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>

On Wed, Dec 06, 2023 at 06:02:42PM +0100, Andrew Jones wrote:
> This series has a lot of churn for dubious value, but I'm posting it
> anyway since I've already done the work. Each patch in the series is
> simply removing trailing newlines from format strings in TEST_* function
> callsites, since TEST_* functions append their own. The first patch
> addresses common lib and test code, the rest of the changes are split
> by arch in the remaining patches.
> 
> Figuring out which newlines to delete was done with a long, ugly
> grep regular expression[*] and then highlighting '\n' in the output
> and manually skimming to find, and then manually fix, each instance.
> I'm sure there's some AI tool that would have done everything for me,
> but this was my chance to prove I'm still as capable as AI (well,
> unless I missed some...)
> 
> [*] grep -rn . tools/testing/selftests/kvm |
>     grep -Pzo '(?s)\n[^\n]*TEST_(ASSERT|REQUIRE|FAIL)\(.*?\)\s*;' |
>     tr '\0' '\n'
> 
> 
> Andrew Jones (5):
>   KVM: selftests: Remove redundant newlines
>   KVM: selftests: aarch64: Remove redundant newlines
>   KVM: selftests: riscv: Remove redundant newlines
>   KVM: selftests: s390x: Remove redundant newlines
>   KVM: selftests: x86_64: Remove redundant newlines
>

I forgot to mention that this series is based on kvm-x86/selftests.

Thanks,
drew

