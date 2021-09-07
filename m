Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D4E402DCB
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 19:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhIGRkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 13:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhIGRkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 13:40:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7246DC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 10:39:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v123so8729960pfb.11
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N9XNca23yCVuMer6cozayHgHWR6STLiyzFjRVxePEPo=;
        b=EnarTh7cut0Nbx0XzOOv0XDmjBrKae2D4uyjc/WmVXkkwMc04IdFdV1WvtAkSa/ZX6
         FQGBRMyZ6OamW7FeDIUHjTeCvrGMdmkFS8t8+7/ElllUPFIf+0LaGEWOSzpSYS+plt6O
         clF31dL7Et0RmMVQX0PAJSZTaGL6mL19CCUQVhSn7mR1r4FiwPtkSVJMYv0sQZtsa0vG
         b28WEb5XklDYSaOBi/SnChi30NUWzB7T52XEZv6tCgMvQEi5NBFOKYeksSyDyugFx7Y2
         AsAB9Kyh4zxlHLTtHLfNyYtsDjPTh6WfPpAmow9HtvFcvCo0//J0yUNWiWy8lwBgNDOx
         A98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N9XNca23yCVuMer6cozayHgHWR6STLiyzFjRVxePEPo=;
        b=Wd3JiF9BJ8n4VIVrgKN3vi6Cv0ayefaebB2VdvBm/R4bYSgW36Nf69RDSknyHfD0Us
         PxekOmkskHbuVGLS5cprUaeR8hZ7ezNrpQ97Sl2xu+ZawQnJzgcEYxGsBk6K757xsuA2
         aIbSM7x7+gYSeM1+NKImoRwckW/2HLHcpm0Pbs4Swt7MDKKNyiK9ueV/g1FCyDDTH64m
         dXsQmJgbx0DLLwEbbiqgE2B+qPymp1He+cHtQ2WeBvlGExG6B6BkHMtJvBT5QaqSpuWG
         qTXx/P8O0tbmW85ixeQBR8LrfInEZ+kSVg2/UZqHi2LM4Y04AcpeTT4MKb/nhgFuUvVY
         KzUA==
X-Gm-Message-State: AOAM533PYebnuYnrtuTV5NUy0zX8P9NDqzJ/PSv6Mq4Hie8K5gdnrXEc
        P/xISFTZDNL0+CGcus5q7JlYFw==
X-Google-Smtp-Source: ABdhPJzJIhKu/IIbm9AjhTgNXpclcGvl/MPPLV0Ct7sfXulKZXpHFLz2PYWzXiC+ypD//jzEhwqqMg==
X-Received: by 2002:a63:7c58:: with SMTP id l24mr17796563pgn.464.1631036347761;
        Tue, 07 Sep 2021 10:39:07 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id l1sm3130985pju.15.2021.09.07.10.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 10:39:07 -0700 (PDT)
Date:   Tue, 7 Sep 2021 10:39:03 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <YTejt+fOxK9iUwn2@google.com>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
 <20210906065248.c57sluz2764ixe7u@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906065248.c57sluz2764ixe7u@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021 at 08:52:48AM +0200, Andrew Jones wrote:
> On Fri, Sep 03, 2021 at 04:11:54PM -0700, Ricardo Koller wrote:
> > Add memslot_perf_test and memslot_modification_stress_test to the list
> > of aarch64 selftests.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5832f510a16c..e6e88575c40b 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
> >  TEST_GEN_PROGS_x86_64 += steal_time
> >  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  
> > +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> > +TEST_GEN_PROGS_aarch64 += memslot_perf_test
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> 
> These tests need to be added below the aarch64/* tests and in alphabetical
> order.
> 

Sure, will fix this in v2.

Thanks,
Ricardo

> Thanks,
> drew
> 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
