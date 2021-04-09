Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE835972A
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhDIII2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhDIII2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:08:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC8EC061761
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 01:08:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f12so4741585wro.0
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 01:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4n5XQyXIMcAvvSVHJa1+lHKqEgUtFQKp+M5Ydfb4ys4=;
        b=PBaL3LS2SQBr213UpbZLcQZtzq8Tftnqxcf972qOnt5LcxDOzXyTUP4oKSW2ZS5/Vd
         FP1LTP3r747Omm5WJgBItRP4SGiXHuPPovxyhQIKcRyh/azg5wC6tC3NmdUHtNIFjWfR
         /c+crwDj4lx11ztCTwZ6v5qIRbyzblZUGR76rTxW5lvCggLHC38yKc9lzTubbRdV+rEr
         3x1pGsyZe9omFLP2X4dBbpzV+uMYZgdKJoIU/im8w88aFlyHzl9r8K2GIjNtxIVLFMj4
         JvQ191AvXnwi+/vhXtdnlXOwaKdGcBqLEow+QVLGlr34TIa2H/HuNu65/tO1/PuG/Qbp
         IO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4n5XQyXIMcAvvSVHJa1+lHKqEgUtFQKp+M5Ydfb4ys4=;
        b=V+KyJJ5GZNR30xZxnNSPQpXs+BJR+PyhQ1AvhIYKQHqSouE1cXQfgGhJmaHBU1015+
         +kqtfwS2qSjZTAZ/Ytvu3eiwTUuFhATlHd9NsTC14+PFgt2x88tItqJVxSDE7kNkhzvA
         93IGJuOmPmB5Jr9A1yJErNby8kBXtHsPnLTH1nJrpPP60zZzy9ePv0lewT5ELNzFH9y6
         bWD7DeKAzRVfXXzww9sRXXetbCaIqXF0FWv3/k2LRby2Lja/RgKJNcaZxZG7OOgyp03O
         4V41vpdO4v/9cvDQ0QLnZ5yzWsoW2wQEnsqOIoX0l0+HljnB1AGNfk471A+NULZF3NXh
         ttVQ==
X-Gm-Message-State: AOAM530eBTpuzjXqbUwuqiadApxg7rkHltc9APHPzHccAhGxblJIhyEJ
        Cj3Ljx21KRx8h0UvWwjTTwqAGg==
X-Google-Smtp-Source: ABdhPJxINGm2Cs/J55+AIsgzJGyjQFvX8rWJi0ktXHgRlfGG7RsZH/UItz3GB7TR9I/PNd+/Ulb7Vg==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr16279163wre.183.1617955694111;
        Fri, 09 Apr 2021 01:08:14 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id z1sm3276489wrt.8.2021.04.09.01.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:08:13 -0700 (PDT)
Date:   Fri, 9 Apr 2021 08:08:11 +0000
From:   Quentin Perret <qperret@google.com>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v4 1/2] KVM: arm64: Move CMOs from user_mem_abort to the
 fault handlers
Message-ID: <YHALa38PPQBceqF9@google.com>
References: <20210409033652.28316-1-wangyanan55@huawei.com>
 <20210409033652.28316-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409033652.28316-2-wangyanan55@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On Friday 09 Apr 2021 at 11:36:51 (+0800), Yanan Wang wrote:
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> +static void stage2_invalidate_icache(void *addr, u64 size)
> +{
> +	if (icache_is_aliasing()) {
> +		/* Flush any kind of VIPT icache */
> +		__flush_icache_all();
> +	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
> +		/* PIPT or VPIPT at EL2 */
> +		invalidate_icache_range((unsigned long)addr,
> +					(unsigned long)addr + size);
> +	}
> +}
> +

I would recommend to try and rebase this patch on kvmarm/next because
we've made a few changes in pgtable.c recently. It is now linked into
the EL2 NVHE code which means there are constraints on what can be used
from there -- you'll need a bit of extra work to make some of these
functions available to EL2.

Thanks,
Quentin
