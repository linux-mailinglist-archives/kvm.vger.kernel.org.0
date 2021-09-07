Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BABE402E4A
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345796AbhIGSTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:19:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345714AbhIGSTp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 14:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631038718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LUu7mpwr2jWyNZjk6B2vNYIBEH3XQErYN13Ykm4FJUs=;
        b=Zlv2XlJuz6/fCPCbkjkdKdtC2znDykQM3UFbYGmy4kBiBC8s+jcM0RFkq9uFdyc5rbbqG3
        Wr+LT7/zpa0qNOfQ2Fz4ZcN9mj29PQGO5aJrSZBgJGAV31aYToreF5RajXMQATXtem+MNX
        9svEyhKifRefQcLShB2HvLCt1vOqCqI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-Q85vsq-eN0Cb3nOjpovM8w-1; Tue, 07 Sep 2021 14:18:37 -0400
X-MC-Unique: Q85vsq-eN0Cb3nOjpovM8w-1
Received: by mail-ed1-f70.google.com with SMTP id bf22-20020a0564021a5600b003c86b59e291so5619608edb.18
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LUu7mpwr2jWyNZjk6B2vNYIBEH3XQErYN13Ykm4FJUs=;
        b=A8Xf05QCEbH5gGwgYTMeaMHLUqDIPu1kJml9l2WkGiRROF2NFDnn0/ykjXNWrk7roY
         XdrXz3cnEP2v7wC/Ky5CBngA6k/oX/X/mofxhUP48r51ateK+NwASVPTzfoKyRuwLudG
         pGAzI2nHTG7Tr4fJQ2Wt9RZV1uIUyXBQzXr/GHINe3Jpg7syhuUnK8WOFf9Akd4d5efG
         PcbSFuxLD0m6oG3yAo7TEqbzaiUaMNH8vwj0bxhhhlOcCvWY7uHkw6UFaFnmOxnX36Uw
         y51Hualn+E++IZG34mDeajapVoj/R+93uESSeF62HyK/3IM+glbzUaePS9tCu9XhR7D/
         FK/Q==
X-Gm-Message-State: AOAM5322T6WZn952Dq8gFsnBxLjJyuqJ7kreeLhTf7PnCnwl3pODdNGu
        4ukmtIJFCIs7r97eD09wCz/GX9uniAHaMBSHDZkAhaWXLRCMQ75C24GC8X/HbVZ5C24QLl9f9Dz
        AQ42ZSuB/QqF3
X-Received: by 2002:a17:906:6dcb:: with SMTP id j11mr19706639ejt.202.1631038716450;
        Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ16MXBVuMZi4LPFWDJ41bJqO5hzeQF793u0WWbWMrnfuEmtTm1ev6ELecKdk1XtNTMtystg==
X-Received: by 2002:a17:906:6dcb:: with SMTP id j11mr19706624ejt.202.1631038716320;
        Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id p16sm6895261eds.63.2021.09.07.11.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
Date:   Tue, 7 Sep 2021 20:18:34 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <20210907181834.uqecqygvvlvmetbl@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907180957.609966-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907180957.609966-3-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 11:09:57AM -0700, Ricardo Koller wrote:
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5832f510a16c..5ed203b9314c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -92,6 +92,8 @@ TEST_GEN_PROGS_aarch64 += dirty_log_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
>  TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>  TEST_GEN_PROGS_aarch64 += kvm_page_table_test
> +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> +TEST_GEN_PROGS_aarch64 += memslot_perf_test
>  TEST_GEN_PROGS_aarch64 += set_memory_region_test
>  TEST_GEN_PROGS_aarch64 += steal_time
>  TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

