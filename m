Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BE548AAE4
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 10:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiAKJzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 04:55:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237188AbiAKJzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 04:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641894913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMRIJvycuUhx7h41E38Clut9x9CtptwubWi+vWGBfAc=;
        b=L3pKAUIaTea4T3/JZGoEpjVJtg8B2w/F3/8v8oKZ0VcZ+FQXn0f5eWwAJyhRedLnIzv0k+
        J281avZ5HJvpPlmcNrHta0v3i0WZGbZMghss0gbjKbLRMNhCFtDJJK5fbbT87I+h9CkWFJ
        BwPGe3+ghnKxIQ1xdC0H9fdYRoEWCm8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-283eJoMbPNSpy_X1fI6r2A-1; Tue, 11 Jan 2022 04:55:10 -0500
X-MC-Unique: 283eJoMbPNSpy_X1fI6r2A-1
Received: by mail-qt1-f197.google.com with SMTP id a26-20020ac8001a000000b002b6596897dcso12886124qtg.19
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 01:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMRIJvycuUhx7h41E38Clut9x9CtptwubWi+vWGBfAc=;
        b=v0YCYDD3XneIHgZXJ/gxhVMVvXwVQ++xsD/M388VcFpAyEcQdDZMYxnOjpbtKvH+H+
         vCLj3N7VD9QM0ZRKYb+TPvZKyYCzRconIquADp7DAMMUykkzvWEdbkH4s+AkBH3KK0si
         /Za583bYFKVtwmEm/dJwSdf9aowi061acOpurzVlPylcqYru16kx4DVf/OteXMSc4k+z
         rZqMhtbH48YNOQjZ6uE3euO8agIYx83zVjxGCSJLOXsTTHNDXPLvEQ6txqqEbwOmxsiG
         9o8vtsY4EAkjownQmktymiFVrp+zRvuiYgFzlWQfL5yOAYWaisZrwhiIX2YsiJ0MCKZ9
         85kw==
X-Gm-Message-State: AOAM5333YkIqA6ARyUve+RSyH9W4K8YS7Ld2JhIDL32SfMtV2jhl7Xlq
        9qNtwoKfZMUuWTzSbTkIhfcOhRUNypy7bbfJfZUX3smE3P9DXrpgRKfdgEKNZYE/doO0eX2K/eS
        jtlMicF3RT7W8
X-Received: by 2002:ac8:5cd4:: with SMTP id s20mr1931903qta.426.1641894909877;
        Tue, 11 Jan 2022 01:55:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyt2oY5Iv7+h0zYh5JClHXf+9izVN3nAg8r3JTSwK2sGJu05xeSvkHkTZb5Ua/EfbiSyufcIg==
X-Received: by 2002:ac8:5cd4:: with SMTP id s20mr1931896qta.426.1641894909674;
        Tue, 11 Jan 2022 01:55:09 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id s19sm6646780qtk.40.2022.01.11.01.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 01:55:09 -0800 (PST)
Date:   Tue, 11 Jan 2022 10:55:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for
 dirty log perf test for ARM
Message-ID: <20220111095505.spwflhcdfxwveh3u@gator>
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110210441.2074798-4-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 09:04:41PM +0000, Jing Zhang wrote:
> For ARM64, if no vgic is setup before the dirty log perf test, the
> userspace irqchip would be used, which would affect the dirty log perf
> test result.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1954b964d1cf..b501338d9430 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -18,6 +18,12 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +#ifdef __aarch64__
> +#include "aarch64/vgic.h"
> +
> +#define GICD_BASE_GPA			0x8000000ULL
> +#define GICR_BASE_GPA			0x80A0000ULL
> +#endif
>  
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N		2UL
> @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		vm_enable_cap(vm, &cap);
>  	}
>  
> +#ifdef __aarch64__
> +	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
                                    ^^ extra parameter

Thanks,
drew

> +#endif
> +
>  	/* Start the iterations */
>  	iteration = 0;
>  	host_quit = false;
> -- 
> 2.34.1.575.g55b058a8bb-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

