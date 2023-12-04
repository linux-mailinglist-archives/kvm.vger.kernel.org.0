Return-Path: <kvm+bounces-3341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C0880368B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A70791C20A57
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785BF28DBC;
	Mon,  4 Dec 2023 14:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="J3vg7aAj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353AF2735
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 06:26:34 -0800 (PST)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DF9D6402D4
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1701699992;
	bh=yrj69QBqcJ2/0+no6KMFGYnNPrNFydkA4S5q1Y5aJZw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type;
	b=J3vg7aAjNXfnVhLRb4Qi1RKB7+xK+ra1JfJ90fDolMS3l5dNTIHIgnBU2grA2Hec2
	 aULyD3TXt3X/3EnodFBgXL6KIGgariG7YurhjK+ztkZCPpLAyW4L06u5Sd+imWSPdk
	 d21leoJLEVTtocVtdDytV31M96XtUaJkoeZkpHmK/EZR57fLYgQ96zNL1/Or2JEgdN
	 RMKH5pGeyScN3yOssQeej0U+cS9Q4iUEv5PvxbdActET/YWqTDL9+l3YtLQF5Rs3cJ
	 ilOCS23GLTskCo6799D3OewnLZmuYuwT1rIAXfwEJJ+VJdD41NEVeoAk/uOGAsbL8/
	 jJELu3vj/3hdw==
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-333120f8976so3885763f8f.3
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 06:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701699992; x=1702304792;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yrj69QBqcJ2/0+no6KMFGYnNPrNFydkA4S5q1Y5aJZw=;
        b=Bbo3N+T4zyU2ppT4Dl5/7/lnilbn+/8QYDjG0ufXiGoPuLw25v9s0S2PHoM+zgQeFB
         /IRE5UdNIVO6OhXrAjoot7XW+WzcixwRZ0gIrKOX/A2pBqD1ByBwTOS+rMsWOmeLzvZV
         eROkMfH5bn+YKAiNFR1/SxYZsI+oWYGO0rfcIA7yv/wHjjg/LTCqSqVaWsVOGsNNAcES
         lOBiPO0SzOAeKlANsO6bvctaMcNaa9yOG6IMarbMWWviAKCjjwriFYPIcM+m+R95duwE
         cT03jVpnj4ru19brMLFfdWmCtkrfz+xHMHICmJe93eaFGLNYMkQhjAU+8uyweGXfUFy9
         eNYA==
X-Gm-Message-State: AOJu0YzaW/ktjvi+UirgyUyzLMm+lwYvW9nwZiYZBO1CTdjR+/3LB3l5
	0Pqbm3hmhopCkXsJErFb5ysikV73R8zUcC1CaojneS/XfVhtJRd8/YkomXsABv2mdDgRJ/7NsiO
	ljYuXmXNqLXCzI/0laR6xThxfJ6/of49uLE6fYvnLHUjQ4Q==
X-Received: by 2002:a05:600c:54ef:b0:40c:33d:9b92 with SMTP id jb15-20020a05600c54ef00b0040c033d9b92mr1375218wmb.62.1701699992498;
        Mon, 04 Dec 2023 06:26:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvLlHhcU3Gc7h3Rn17LrfqyAPp8cApuaxpodpxOeyeSvrgZgV4xsXZkpEJttjlTW+azdLXQTQw0bYhJ6MkzM0=
X-Received: by 2002:a05:600c:54ef:b0:40c:33d:9b92 with SMTP id
 jb15-20020a05600c54ef00b0040c033d9b92mr1375215wmb.62.1701699992188; Mon, 04
 Dec 2023 06:26:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date: Mon, 4 Dec 2023 14:25:56 +0000
Message-ID: <CADWks+Z=kLTohq_3pk_PdXs54B6tLn25u6avn_Q1FyXN2-sVDQ@mail.gmail.com>
Subject: Converting manpages from asciidoc to rst2man ?
To: linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

I was going through build-depends on linux kernel in Ubuntu and I
noticed that whilst most documentation and man-pages are written in
Rst format, there are a few that require asciidoc.

$ git grep -l asciidoc -- '*Makefile*'
tools/kvm/kvm_stat/Makefile
tools/lib/perf/Documentation/Makefile
tools/perf/Documentation/Makefile
tools/perf/Makefile.perf

$ git grep -l rst2man -- '*Makefile*'
Documentation/tools/rtla/Makefile
Documentation/tools/rv/Makefile
tools/bpf/bpftool/Documentation/Makefile
tools/testing/selftests/bpf/Makefile.docs

Are both Rst and asciidoc preferred in the kernel Documentation? Or
should we upgrade kvm_stat & perf manpages from asciidoc to rst2man?

-- 
Dimitri

