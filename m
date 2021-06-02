Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9213986F5
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhFBKwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhFBKvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 06:51:46 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB2AC061761
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 03:49:55 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so3487876wmk.1
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 03:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iBPgoenc4+VXFgVYv4Mb1skeP6ikfbF6DUFZDuY5ah0=;
        b=qMBk9o3bcP5GtSnrBEjM+uWb62KPrE2rQIg+ZFejyIJ7KDc7EuHbWv6Ier5kZTigIR
         5mXf3/3MmGJskgrxiaqGw4px5jD+G+hWfPNKX0VB3Q90xVaVC9W2ub5I3+4rYkIr8C6L
         chxtaxQI8hnb/YGqTd3MdhmSJpqeWk8UrZcTCfv9IvFWRmdLQcBX8tWbGKN4KBvbOEJ+
         EETPihJUuo8Fv747IZjxQehWVelRce/UwRVy83oJFO+hbvPTHpQi+IVjW3yMXgmJzK+H
         F27yNQMNOwh5K9XYmMwdm2gEuDDNQoEjQcctogIZhgnGP8eVl1utqqHRhFOj1a+KnMcs
         NNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iBPgoenc4+VXFgVYv4Mb1skeP6ikfbF6DUFZDuY5ah0=;
        b=rsg0zKO6bg1vtYFqicyAG7ud71/2ROcadeJwlu9j/Hx7MsZHMIsExP5sdG5UaRf1NB
         4y+D1ik5Y5ogTPkZGW4bOElIbDc81I6NKVivqIrsQ0ItTolcUlcHl71Y5nvVmHRTh4NY
         pihNm2iMlEhEKFTTYD8c6MGO9r7Ows8hGlVJ6L9coYzFdcH49PH2JElgfd4PG3q82EMP
         qJhOLQSXoVpe93CNbKzhPNP6/9dtWekaO63IduDLmLpCElT2YPQosNNjuMpgvzrUs5Cq
         y8tbzqMntP//VDtovcUlV4hSFtHcmCYwvASivHjtAjxGHBWZEY6mGChAFOYhBSPSYkYC
         Q5Vw==
X-Gm-Message-State: AOAM531ShdB4g6ApOsZLWsvmluwQXDL+DXrtlTOpTz0nWDg3gwYLV9II
        IK3ApKPGcMmdT6krnEpdoQJKwA==
X-Google-Smtp-Source: ABdhPJxJX3H2bjJ6ZWWGMvygaz55JMVzxmecp5Rkf4VcZ3RHRl9KDTV+xgJcccrQmFsHPJCg9w3A/w==
X-Received: by 2002:a7b:cc8f:: with SMTP id p15mr4585583wma.111.1622630993639;
        Wed, 02 Jun 2021 03:49:53 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id a123sm2687146wmd.2.2021.06.02.03.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 03:49:53 -0700 (PDT)
Date:   Wed, 2 Jun 2021 10:49:50 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Yanan Wang <wangyanan55@huawei.com>, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v5 2/6] KVM: arm64: Move D-cache flush to the fault
 handlers
Message-ID: <YLdiTnfuhMimU4dE@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-3-wangyanan55@huawei.com>
 <877djc1sca.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877djc1sca.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday 02 Jun 2021 at 11:19:49 (+0100), Marc Zyngier wrote:
> On Thu, 15 Apr 2021 12:50:28 +0100,
> > @@ -583,6 +589,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  {
> >  	kvm_pte_t new, old = *ptep;
> >  	u64 granule = kvm_granule_size(level), phys = data->phys;
> > +	struct kvm_pgtable *pgt = data->mmu->pgt;
> >  	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> >  
> >  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> > @@ -606,6 +613,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> >  	}
> >  
> > +	/* Perform CMOs before installation of the guest stage-2 PTE */
> > +	if (pgt->flags & KVM_PGTABLE_S2_GUEST) {
> > +		if (stage2_pte_cacheable(pgt, new) && !stage2_has_fwb(pgt))
> > +			__flush_dcache_area(mm_ops->phys_to_virt(phys),
> > +					    granule);
> > +	}
> 
> Rather than this, why not provide new callbacks in mm_ops, even if we
> have to provide one that is specific to guests (and let the protected
> stuff do its own thing)?

Ack, an optional callback in the mm_ops sounds much nicer.

> One thing I really dislike though is that the page-table code is
> starting to be littered with things that are not directly related to
> page tables. We are re-creating the user_mem_abort() mess in a
> different place.

+1, we should probably keep the page-table code as close as possible
to a standalone and architecturally-compliant library as opposed to a
mess of unrelated logic, simply because that will lead to a cleaner and
more maintainable design in the long run, and because that will ease the
interoperability with EL2 in protected mode.

Thanks,
Quentin
