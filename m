Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7E37AF38
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 21:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhEKTT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 15:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhEKTT2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 15:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620760701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ASevTwJo9RjR5FJ3MgTE2V9jTzfajAcmo8SCFELc9CM=;
        b=GXpgHQ4wouo2QI01cc7SneCn1ClNhv6neDAc2UtVh9pK+YbgqMXuNw8AHkKaMrDobOQbnK
        GzQqPLvJVG/2o/05ng5UbRp+UNaprzHhC2hXS+vOVq+pSM3gXx2hlYnRsMYpwgVw1Fb0kn
        5pqJiUbiBXPCjYaXsVjEe5HF2y2WTBs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-unUZYjrpPe6pYxDNvAReow-1; Tue, 11 May 2021 15:18:19 -0400
X-MC-Unique: unUZYjrpPe6pYxDNvAReow-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a0000b0290387e0173bf7so11556931edi.8
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 12:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ASevTwJo9RjR5FJ3MgTE2V9jTzfajAcmo8SCFELc9CM=;
        b=PiED+pnRLsuyEQHVM6F1kQntBSWXnQ9gEJy+qhZCtQqnXkfFZDsU4P/J7XMLdTPDin
         f45SpsMlB4yita4lFN1fpJZ9cznKWAINdcpsIMCaT6v4ZaBOeYaHWarLK4CzHlogYKHF
         Bx0I1MS9aCm7dv3MB3v2tI+eFSKYClCkB03u8ruftWCPiHO6Ogu7aB1TeGYkRCKFmPhe
         aHD1cWtXeh4rKbd/MkkSvf5+MMeHO1K1Ti3XTZshX/q/A+MS7z+VwD0SUZRU54WG0i6h
         BkEQEo/Dmidc2tAf9/Ntxbr5+yRahyqBZ2knOgVyYfGL+9MSTutxgMClohUtWIlVzAnh
         rJqw==
X-Gm-Message-State: AOAM531GfrhV1rxhpDv3nFs8oDfv2lIHL0Rw2BNl1bO0vaslQGYYT9ZN
        khruXCGLEY3zwKBgIK+AF3UgX6PmxOAt6vbZk+ZPOM3BUnFS+/D8tlHuqAHDPFm0jh+59P7Ayuu
        K0GYE9Pm3exud
X-Received: by 2002:a50:f41a:: with SMTP id r26mr38166509edm.339.1620760698616;
        Tue, 11 May 2021 12:18:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEgndHOF+FNcJBpFdohiUsrh2jxtvw70fQLY6ZJfG5npvkMy2xKCx4y7FbS6l4FDVEiMNZgw==
X-Received: by 2002:a50:f41a:: with SMTP id r26mr38166482edm.339.1620760698379;
        Tue, 11 May 2021 12:18:18 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h4sm13971430edv.97.2021.05.11.12.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:18:18 -0700 (PDT)
Date:   Tue, 11 May 2021 21:18:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org
Subject: Re: [PATCH] selftests: kvm: make allocation of extra memory take
 effect
Message-ID: <20210511191816.v3zoukkq7la5a4pw@gator>
References: <20210512043107.30076-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512043107.30076-1-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 12:31:06PM +0800, Zhenzhong Duan wrote:
> The extra memory pages is missed to be allocated during VM creating.
> perf_test_util and kvm_page_table_test use it to alloc extra memory
> currently.
> 
> Fix it by adding extra_mem_pages to the total memory calculation before
> allocate.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..159f4d62241d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -295,7 +295,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  	 */
>  	uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
>  	uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> -	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
> +	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages + extra_pg_pages;
>  	struct kvm_vm *vm;
>  	int i;
>  
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

