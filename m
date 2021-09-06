Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53640169F
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 08:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhIFGx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 02:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239458AbhIFGx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 02:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630911172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVvCRd48vUd0s8Qhx9wbKeg3e9TGn2LMc3TD1wv0YoU=;
        b=QJtutbsE8oHC7KJ0lTrVo/826RF+B2k/tZjWnxa1qNWh2uVfhXnQWK/JeXMo/MkArRsvOc
        bBFuo0T3bzjEcIk/IUsXiKmdmZ1cs7MLp4PRvVHumlt1u4gFUjYWbYzbPyf/i9iK6ddt72
        AIRe2wQf/fbjOKGfh/R15aqOxTWYFns=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-0aeZy5cwNSWjvqK1z6Y0Ww-1; Mon, 06 Sep 2021 02:52:51 -0400
X-MC-Unique: 0aeZy5cwNSWjvqK1z6Y0Ww-1
Received: by mail-ed1-f72.google.com with SMTP id y21-20020a056402359500b003cd0257fc7fso3203911edc.10
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 23:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVvCRd48vUd0s8Qhx9wbKeg3e9TGn2LMc3TD1wv0YoU=;
        b=BIhpQmn+VZn1bpI6+MPnfoqibZ4jIu0YD7wK4ipPGA90hwwx9w+J1Yami+j2ddAVNa
         gh7x4MEY0DUPxrmBY6aqi/v7GL+OHmiMzXeLc47nHabU3i197oF05/F4Jsb+upzUT/ZF
         ccHHCGhqg39JO8Fkxb7gOj93lwcbgWN6RZB7IuaLRGZ8amdHR7TstLIJJ/uhKFW/J9NP
         yMhcIFuQm15i//52tWOJETguPGjYgApgh+pWyXiy9AC7nPpet1/Lecnh6H+O8VhSixK4
         ScgHlJeCUveiBUIjiXRDk5oSGDHp2iqLCxik0L99TxrKXb1VlQPVXsZB7paH+DtnS+3s
         Hdxw==
X-Gm-Message-State: AOAM532zLujaRsKBBv4jeSJy8ufEERLdMkILlZsVJXNAYMlvcaXWYuYa
        NUKgGWMdm2+a5IIha+km+mDbJ+R2uMaGCMK+4gRslMpX2C8uiTh5hBeSlqPp7lU2GbCn5yswU8V
        QgiKjk/ULQ85H
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr12121004edd.65.1630911170673;
        Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvQtH1K6Jl6Ax+4IS9Z1Fidzt0mgTUD+ttCz7gh3k7oW9A0+M0GapKR8goF6sKX6zAEV6ZVg==
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr12120993edd.65.1630911170505;
        Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id e3sm3315715ejr.118.2021.09.05.23.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 23:52:50 -0700 (PDT)
Date:   Mon, 6 Sep 2021 08:52:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <20210906065248.c57sluz2764ixe7u@gator.home>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903231154.25091-3-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 04:11:54PM -0700, Ricardo Koller wrote:
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5832f510a16c..e6e88575c40b 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> +TEST_GEN_PROGS_aarch64 += memslot_perf_test
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init

These tests need to be added below the aarch64/* tests and in alphabetical
order.

Thanks,
drew

> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

