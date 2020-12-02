Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811602CB190
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 01:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgLBAcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 19:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBAcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 19:32:32 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78467C0613CF
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 16:31:52 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id t8so70819pfg.8
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 16:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JZt5jnSTjB4ge5bDxNaFAa4gUn7gdODLjRSqk/KQY+I=;
        b=Bfdti1cbXaoax1dKDfEJM3Bf+IfOeC36PzzrsVWdJrVRYod3Cpa0RkgYNjEodwIuXW
         uNqGv6vI9i2AqIEooCnFwwZTLujVHFlUXQmcLU5ASeHqTrkpYHQOxdHro77PXvy56ozU
         zTx3zhVs/uK2zYDIzGJwHIJg6/8RNI2WtBJ9zhVPFq4md4kE2d2UYZAIw9zVTaR+8vhk
         d8VLYQRw5bu27dtVM4E+/Zzeoxz/1z8N30iusQlL4FA3eTtFyKAW3coUyR58TjIrqxU8
         /AO5mOaC+iLMGwWR309B/7vHKTWKQifz/F+JH8ozr1qGlu+lQeOS0oNLZmw43aavl/SN
         nHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZt5jnSTjB4ge5bDxNaFAa4gUn7gdODLjRSqk/KQY+I=;
        b=TxMYM/mowKbTorZawlFMaDK/JOpklKD0ZEFoPu3HD5LW4y8FmX2TLAkFFxS42Ufwxe
         qtbJsvmI0muN3GD6/DYZDnhxPS+EsU2dF6gKAua9TyBucREoN94PwmRTW9kmRIkLyvef
         jhDzkoEdUfVqZZCkrUBPxl74TdstjoRSxuJjxkTGMHdwFI0qBr/7kJkKIfk2pZw19APs
         WGqqN+QepFoza4x2M5eJS5e8i/NnMCW5CgO6XJXHILqOg3+5gUYGcogvyvzw+3szE4gw
         bMbfWg3AJ+HvV4hhNX2wMXvSIFlyCF7JDkiBWC7lyPhMBmLeOPXuEh0Y1QOR2603m/xx
         I6Lw==
X-Gm-Message-State: AOAM530nZ0XQVoKVxJYUnOUU4l0hdTt1HFt5Ov+F2/s46O+fuifXZsmH
        DYKW7W4JgqliXnPB/EBnZvDIveru0301EA==
X-Google-Smtp-Source: ABdhPJzllf3/JRjbn1DKnx/a4SMN5TvUVaSUGO/qE2lsEM2SQ6avnngq0Suu0MGRJQkcpfFvY1hQfQ==
X-Received: by 2002:a62:e103:0:b029:198:4776:b6a3 with SMTP id q3-20020a62e1030000b02901984776b6a3mr4881072pfh.65.1606869111816;
        Tue, 01 Dec 2020 16:31:51 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id n72sm72824pfd.202.2020.12.01.16.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 16:31:51 -0800 (PST)
Date:   Wed, 2 Dec 2020 00:31:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <X8bgc55WroUpG9R9@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119040526.5263f557.zkaspar82@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020, Zdenek Kaspar wrote:
> Hi,
> 
> in my initial report (https://marc.info/?l=kvm&m=160502183220080&w=2 -
> now fixed by c887c9b9ca62c051d339b1c7b796edf2724029ed) I saw degraded
> performance going back somewhere between v5.8 - v5.9-rc1.
> 
> OpenBSD 6.8 (GENERIC.MP) guest performance (time ./test-build.sh)
> good: 0m13.54s real     0m10.51s user     0m10.96s system
> bad : 6m20.07s real    11m42.93s user     0m13.57s system
> 
> bisected to first bad commit: 6b82ef2c9cf18a48726e4bb359aa9014632f6466

This is working as intended, in the sense that it's expected that guest
performance would go down the drain due to KVM being much more aggressive when
reclaiming shadow pages.  Prior to commit 6b82ef2c9cf1 ("KVM: x86/mmu: Batch zap
MMU pages when recycling oldest pages"), the zapping was completely anemic,
e.g. a few shadow pages would get zapped each call, without even really making a
dent in the memory consumed by KVM for shadow pages.

Any chance you can track down what is triggering KVM reclaim of shadow pages?
E.g. is KVM hitting its limit on the number of MMU pages and reclaiming via
make_mmu_pages_available()?  Or is the host under high memory pressure and
reclaiming memory via mmu_shrink_scan()?
