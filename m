Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443E2402DD0
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhIGRnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 13:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhIGRnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 13:43:12 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47727C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 10:42:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so2015458pjw.2
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=40HbNUxcF+T20RK2OUdw+aYb/8oENTKJgMKoFCUo07c=;
        b=s6OYBqLpD3/j1aEyb93Oh8WoZXc+VKDanEf2q6xWzGDc28ZW0Em6Bdij9R1Fg+Li2y
         MkdcevWyPzSOePZVZitqkjOcjZXy+mKNnVl+L21B3xAsNBcfYIAmjZWyvtzqb7OPSRgx
         6ZalvZ6QBpLxwizuU23OJrYaLb9W4bV670XhpQ4kJGSeOX1J3YH5v2sLwCuRXjHfm40u
         vzyijciJrEDSITEwzb9clo5E9cVu4p5LqVQzYRx0aQ71DjEtdfF4yvfyhE5lGnO8sAxo
         ekzpK6FoTWsKTfrLJ2vY+8GxM1ePtqe6gcRUFb81EiGCvVh+OyXA58Bz/YzBfZxlBxDH
         01Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=40HbNUxcF+T20RK2OUdw+aYb/8oENTKJgMKoFCUo07c=;
        b=h25HgVNb81foapG3Pk1U2zSmDB3bHbu2zbSpIcjTEuq5qgEx46B7WqkCF5YpvbSerk
         1dTsUiYUmfvEstr0Ms3YUeh/pDxcCSFvoJikbSppi3UT9b7XE5ys45QmWqvLTE/kjgvp
         fvXLxvJQuo7F0CODWmh4XwNJxTprFRsZ8BfmS7UJUXl/mnOcr0w5d2hl3ihoXVFosnnM
         t0an7cJSoexE4a0WUnsaLPUKK4p/0g5ZOh2JRrxyoPJaNtpbl+qqpbq1exh2b1CUK3Pb
         pT9GtFki7OUbrKRrx8dFST5Ae9lSdDfQQPb4i3LDN+cNAAYwqiWcRp3zEhJCx5cih6Aq
         AnYg==
X-Gm-Message-State: AOAM531vblOXkE/hn7IaHsmgev15boTiEF/G+2Ryqxo/6EFYuAIpaZR2
        A+qUbVbfh2O7XeQCF9ClWPsrbg==
X-Google-Smtp-Source: ABdhPJz3Z+k1SXGfmZnqwU2YMASZrpPO/JbNt4ygiAWP7MBg8vyQqvf59hmDoq/FcStuiIFOcTTabw==
X-Received: by 2002:a17:90b:1d83:: with SMTP id pf3mr5363746pjb.158.1631036525474;
        Tue, 07 Sep 2021 10:42:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id q18sm11606686pfj.46.2021.09.07.10.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 10:42:04 -0700 (PDT)
Date:   Tue, 7 Sep 2021 10:42:01 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <YTekaQOHMzNxV8Bl@google.com>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
 <CAOQ_QshLu-EiLdPDY-d1dS3qvNjJBiN=B=a-W7_70Fdt=GbOcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshLu-EiLdPDY-d1dS3qvNjJBiN=B=a-W7_70Fdt=GbOcw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 09:39:12AM -0500, Oliver Upton wrote:
> Ricardo,
> 
> On Fri, Sep 3, 2021 at 6:12 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add memslot_perf_test and memslot_modification_stress_test to the list
> > of aarch64 selftests.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> There isn't anything that prevents these tests from being used for
> s390x too right? Of course, we haven't anything to test on but just a
> thought.

Tbh I'm not sure. Will ask if somebody can try it in the cover letter
for v2.

Thanks,
Ricardo

> 
> Besides Drew's comments:
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
