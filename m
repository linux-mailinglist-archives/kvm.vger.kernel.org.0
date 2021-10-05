Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A586B421B5F
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhJEBFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJEBFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:05:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28464C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:03:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23-20020a17090a591700b001976d2db364so1123837pji.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zzNse5XZD5zqkQVj8assgOpyA3GCGgkuXvEMqCR3Jzw=;
        b=aWMmBTgJQ6GE3fYS3ULud5M/5C3q8Zmtqp6VpCAkzLcwjXs6M7tlduWhVOQTY0Dcj5
         7UZrCvEJv8kCzJAVR9dPCiV3I3Ofu6wMRLxkI5TuRNTIGWmN69slWs1ltcIiIO7v+hye
         ipj/GSKGkCVR7jERaBvXw9APHJaQsTf5Kq1VwP4zAEkaCaMQne1mUiYPGuNT7UazBahS
         PQVleqYaNBE4j6UtyxM6HapEn7g4G+Npdel8YwvLoWi75W7QV32PSEpMCyquqrWQgvhE
         rko4sOkLPds8WlaZ8HIJmuhx5FU3d9v5EOZgCF1x0Mx4lnOMbiglFz/kS0V6YgymmX5L
         IBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zzNse5XZD5zqkQVj8assgOpyA3GCGgkuXvEMqCR3Jzw=;
        b=nxHdf8y6dV2lQwnOFG/49HpXo7LBVHbpR8FsWvYCHnOuSHi8h4Nnhyf0zG4EN6vw8v
         93ZlHQ0Mw/ULfIeaVPvuXrWyc3Ir8f6mRIfJKXu9TWYmc1e0dSSvRYuR5QYuaq0OiW5t
         mM8PQgAzePZuiqJyHMX3me18BnC13KCBpcXp4lz1BLJV6BHBjigvq6fiu1Ont6yLqGtp
         w+mW05WxEz8p4qL2qFx7+Osiga6/hbJEyDrcTNusjNTJ6ilWPfTVXcV658EYKSwYybZK
         ZydEKdIV1qZy/M05zflKtGFE4ZEzD6Ghz9WDkk7Xz4mV2LAck8teORxKkU/66kGu8+tg
         nZvA==
X-Gm-Message-State: AOAM5306lh+9jQNpxDcn7D648MGuyTMMqMJmSddXT0ufkEZlwUvWgOue
        uH78F0/ZhOIg4TTaHNZBRYCIKQ==
X-Google-Smtp-Source: ABdhPJyKyWa2vMeW0C9A0MkBjs1KnK+VrEbgkX0ymrdNQD9TFJX8rUkK9/a66h8v4s/EBc9xidzIsQ==
X-Received: by 2002:a17:90b:f8d:: with SMTP id ft13mr289854pjb.137.1633395831398;
        Mon, 04 Oct 2021 18:03:51 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id t23sm11087609pgn.25.2021.10.04.18.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 18:03:50 -0700 (PDT)
Date:   Mon, 4 Oct 2021 18:03:47 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device
 tests
Message-ID: <YVukc0eMUKfyz3Ps@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
 <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 11:14:02AM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/29/21 2:10 AM, Ricardo Koller wrote:
> > Add some ITS device tests: general KVM device tests (address not defined
> > already, address aligned) and tests for the ITS region being within the
> > addressable IPA range.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > index 417a9a515cad..180221ec325d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
> >  	vm_gic_destroy(&v);
> >  }
> >  
> > +static void test_v3_its_region(void)
> > +{
> > +	struct vm_gic v;
> > +	uint64_t addr;
> > +	int its_fd, ret;
> > +
> > +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
> > +	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
> this may fail if the ITS device has not been registered by KVM (host GICv2)
> 
> Maybe refine the patch title mentionning this is an ITS device "init" test.
> as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
> instantiating the ITS before the GIC and try instantiating several ITSs
> with overlapping addresses.
> But I would totally understand if you consider this out of the scope of
> your  fixes + tests.

Will just send a v4 with init tests for now. ACK on changing the patch
title.

Thanks,
Ricardo

> 
> Thanks!
> 
> Eric
> > +
> > +	addr = 0x401000;
> > +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno == EINVAL,
> > +		"ITS region with misaligned address");
> > +
> > +	addr = max_phys_size;
> > +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG,
> > +		"register ITS region with base address beyond IPA range");
> > +
> > +	addr = max_phys_size - 0x10000;
> > +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG,
> > +		"Half of ITS region is beyond IPA range");
> > +
> > +	/* This one succeeds setting the ITS base */
> > +	addr = 0x400000;
> > +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +
> > +	addr = 0x300000;
> > +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> > +	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
> > +
> > +	close(its_fd);
> > +	vm_gic_destroy(&v);
> > +}
> > +
> >  /*
> >   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
> >   */
> > @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
> >  		test_v3_last_bit_redist_regions();
> >  		test_v3_last_bit_single_rdist();
> >  		test_v3_redist_ipa_range_check_at_vcpu_run();
> > +		test_v3_its_region();
> >  	}
> >  }
> >  
> 
