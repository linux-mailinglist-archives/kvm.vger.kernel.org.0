Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A001402E46
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345794AbhIGSSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345714AbhIGSSt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 14:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631038663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VSRbOlY+OHZP5PtEtcC0z8g882/C6wUmRhyO/ff6igM=;
        b=emSdf472FxbTFQNTijqQg09QObKGNKUD7hCLFyutA5PhrBXKjCldPUojiXWtHCJzEcv1qh
        tF3lznzMB74B+UvYkyN72j5y9Ys8KB2qcZOMVWheQkgef4XrIWji8dfuHlXx34vVerYnz3
        OzlO7gfCLKBle6kpq3VyfqC9uCiw5JU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-zgAvcnT7Pr6-KOJX59KzPg-1; Tue, 07 Sep 2021 14:17:40 -0400
X-MC-Unique: zgAvcnT7Pr6-KOJX59KzPg-1
Received: by mail-ej1-f71.google.com with SMTP id x6-20020a170906710600b005c980192a39so4123494ejj.9
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VSRbOlY+OHZP5PtEtcC0z8g882/C6wUmRhyO/ff6igM=;
        b=npyb9BKJT6O93IXeCzsNomvyNWCTiRs3+s1VBBIQbPgDrHUqN7thET2M3RAsK8otgQ
         3Bw1XmrH4wIwHb/bfM3u2/6WDrsRKyjhC3ztu7gBukqKoTKV2rixKsFvJ/mxzKhiRIHf
         z6q6ZnLpkLIETqlyQ13w+9RN+F0OVbcShUHHl9kBlh9XRIbCu+dX8JidzvRcWQMOBUEp
         us8ekE/oHGOtyKOld5Pi29UgsTOlnd3iJmrR04FKznZxvmqBLVHeI39iGIyyoH2vpsTZ
         tGDycZIeeiG6W053UHlOChIPeS1oFT7cuqcb8MeKJ2brvET2D7/aV5TNahDwj9sid5Zj
         7ORA==
X-Gm-Message-State: AOAM532S+a3hDt+wqPzFbN4ZA1+yEUGNFN9ahHkdKbEqvG4JGs/CJzH0
        M/mMyQ3FRH4t+eFGqqncewk/+SQFasSGO14KGSgbG2FvDOorjL85AgWI4shSn1sgZc0ojB0Lp+7
        Vh1EDRPr1VapS
X-Received: by 2002:a50:bae1:: with SMTP id x88mr794577ede.345.1631038659233;
        Tue, 07 Sep 2021 11:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaCEmwQmWDQZJpKuWe8E9uHqzGgJWY6tNPoUhVwCP6oeVzBnMbBzTJRsKnGs5tkZpfATBS/A==
X-Received: by 2002:a50:bae1:: with SMTP id x88mr794565ede.345.1631038659056;
        Tue, 07 Sep 2021 11:17:39 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id e18sm5706473ejx.46.2021.09.07.11.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 11:17:38 -0700 (PDT)
Date:   Tue, 7 Sep 2021 20:17:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <20210907181737.jrg35l3d342zgikt@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> (second patch). memslot_modification_stress_test builds and runs in
> aarch64 without any modification. memslot_perf_test needs some nits
> regarding ucalls (first patch).
> 
> Can anybody try these two tests in s390, please?
> 
> Changes:
> v2: Makefile tests in the right order (from Andrew).

Hi Ricardo,

You could have collected all the r-b's too.

Thanks,
drew

> 
> Ricardo Koller (2):
>   KVM: selftests: make memslot_perf_test arch independent
>   KVM: selftests: build the memslot tests for arm64
> 
>  tools/testing/selftests/kvm/Makefile          |  2 +
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

