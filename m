Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2869137EF3D
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhELXAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347405AbhELVrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 17:47:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B31FC0613ED
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 14:39:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n3so1105636plf.7
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 14:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BNg4kTd5SLAMSl9nUrWUBRKEh5HkNeMUwgmskhslRNs=;
        b=U7AmCspc+NKI4McHAH1rudSMGLwK+I02SzQrYxMWAiD03kvkdOAM1bjgn46KPxtIAy
         zD7hDrzZZvhAJWgQnKTmLPLVtak7IjPvtS0dtSNfpCzPWYaBmlvoMKGNqgC2NIzOV7J4
         T/iXWp8YypJBLv+lM3ZvTrEFzhX7af77Sa/MZcuESFw6bRBb1wvxGJoRVEmqt6i/nh0n
         sWqBktxferE45AyQkNN77OTD69q4sgAmd33+wLp/7xDravzm26OJFh/6D/Q1/kgc6LXN
         gJnp+zatdO3UNrDnnJiXj7guH7XLt4Z7Q1ws3lJdxSpmHi06VhnjXzWCVspfXrNdd+Xj
         +QzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BNg4kTd5SLAMSl9nUrWUBRKEh5HkNeMUwgmskhslRNs=;
        b=FC0yjJPtZ1/Jnlf+PMN+5PTfL/8wQYkM1G3pUmHbXNV/PckWKBDRcL4ejw8KQRuoUN
         4rYaNojv/UrVnZFLlSiPf/Krisix9wY9paSQ4h0fBY+K2Rdkc9PJsiKcJipPt4d7QfTz
         2reHk453aXytwmOE4N2oq4oh2j+Rh45Y0ApTtZSvLOFOG1GLyLg8teNgeQV+7xezucug
         Iz2p8O1e2vGYnK1RK9DBehaN3lUcOczBZxdj8zNOCnwGo22eUJVSh1gGKnsRnX2hQiZ2
         m6Jw200qX/46iGqB2cy5Hqxt4s1v2XEQSmlSZpY5nAUAGVzpt1l5stzr8ZMZ4MvN5Dtf
         rQlQ==
X-Gm-Message-State: AOAM531BqtmxSrmM6v2kgQ6K5q0CEwUIe2l5gLWvOWE4Pllcjeq2+DUu
        z3X2IPDyUMlL1oiji+h41IbMtQ==
X-Google-Smtp-Source: ABdhPJxFIvIxMHoGwfDJlIWjrv0SaQjaHREE+5/7TMqB3FC4NhsGO+4TuRNCVHV6IB8C75ArwyXUNQ==
X-Received: by 2002:a17:902:32b:b029:ee:fa93:9551 with SMTP id 40-20020a170902032bb02900eefa939551mr37200846pld.47.1620855560729;
        Wed, 12 May 2021 14:39:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id ga1sm596064pjb.5.2021.05.12.14.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:39:20 -0700 (PDT)
Date:   Wed, 12 May 2021 14:39:16 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJxLBFBgM29hjtYN@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
 <YJv8NUtKilXPDYpY@google.com>
 <ad3fd18571983a08952f523ad5091360@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad3fd18571983a08952f523ad5091360@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 05:18:42PM +0100, Marc Zyngier wrote:
> On 2021-05-12 17:03, Ricardo Koller wrote:
> > On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
> > > On 2021-05-12 13:59, Zenghui Yu wrote:
> > > > Hi Eric,
> > > >
> > > > On 2021/5/6 20:30, Auger Eric wrote:
> > > > > running the test on 5.12 I get
> > > > >
> > > > > ==== Test Assertion Failure ====
> > > > >   aarch64/debug-exceptions.c:232: false
> > > > >   pid=6477 tid=6477 errno=4 - Interrupted system call
> > > > >      1	0x000000000040147b: main at debug-exceptions.c:230
> > > > >      2	0x000003ff8aa60de3: ?? ??:0
> > > > >      3	0x0000000000401517: _start at :?
> > > > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> > > > > aarch64/debug-exceptions.c:105
> > > > > 	values: 0, 0x401794
> > > >
> > > > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
> > > > seemed to work for me. Is the ISB a requirement of architecture?
> > > 
> > > Very much so. Given that there is no context synchronisation (such as
> > > ERET or an interrupt) in this code, the CPU is perfectly allowed to
> > > delay the system register effect as long as it can.
> > > 
> > >         M.
> > > --
> > > Jazz is not dead. It just smells funny...
> > 
> > Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
> > suggestion)!
> > 
> > As per Zenghui test, will send a V3 that includes the missing ISBs.
> > Hopefully that will fix the issue for Eric as well. It's very
> > interesting that the CPU seems to _always_ reorder those instructions.
> 
> I suspect that because hitting the debug registers can be a costly
> operation (it mobilises a lot of resources in the CPU), there is
> a strong incentive to let it slide until there is an actual mandate
> to commit the resource.
> 
> It also means that SW can issue a bunch of these without too much
> overhead, and only pay the cost *once*.
> 
> Your N1 CPU seems to be less aggressive on this. Implement choice,
> I'd say (it probably is more aggressive than TX2 on other things).
> Also, QEMU will almost always hide these problems, due to the nature
> of TCG.
> 
> Thanks,
> 
>          M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you, this is very informative.
