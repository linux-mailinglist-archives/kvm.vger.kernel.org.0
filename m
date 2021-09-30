Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1163F41E28B
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 22:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344306AbhI3UMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 16:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhI3UMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 16:12:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9649C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 13:10:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 75so7389258pga.3
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 13:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6qQX8FGSXGvNLB2OkI54oxIKxt1ew2e183YmWQIOfeQ=;
        b=XQHp8DRPm3f2VxlgHmiuaVYEEvk6aHZEFiJkodu7vU9Tb1qSPgXWUt+VhTR/AKgEz0
         yZfIXcad5ydtrF6PtkMEJW0f3CsRmFrhtc9OPt84zbPtZzVcx3ahJbrMo5zB8BiNs6i3
         T10UA2ALiCNw9ostYuzy/CBFXRThHdgNs18vDyTbvXWOfJHQfba0wqslP39EALWMCY5l
         WmytgZ+U9CtbX8BHeHbF3H0Nk6SB6jClSAefZDUNXduxjkULSQy80R2B+nHMkCVDN8ft
         qV1FiDqoSgp3Mb7Glh+DX/fSoZrEIKT+y4JTI6iwyJGhSWbppOJg2hH2WiOivBIj5xm9
         QjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6qQX8FGSXGvNLB2OkI54oxIKxt1ew2e183YmWQIOfeQ=;
        b=M2CtgmhJE1ibOXHEbyj6Zd6ZTsbmF8cuBnVpcEeSL9i/w3yKIw9wv6DxAOJ0fplrF4
         A+cFDZYbhF09JMYvvb8uvaOVtGHgiwvwblOFuAnGYAVi6c7DBp8rA3Tz5+SWusPzh1GS
         yH3Cd4t+WHSTWvLg/OZvYthXLLoVOjKLuH3jnj1vmWjBzppu8v1hh/5bjjKKWxlOhYDC
         aqN8pbAL/bsfKCgc81BFNj0Q6sdJKWAbNlVqE4FF4WAIQyyQ3wKOueSBz7vJT/fiDF1f
         B05E8PUReXoIFrSD03J2o94UfL/MRRfCe4oUD7C+BV7L+Jld8KIU6G9bQwWKGYOAI7Xg
         hvxQ==
X-Gm-Message-State: AOAM530Oc8ml8C0lNUhbFZ245y0njVAAFye8WwusIACEHBLPls1UnMmW
        pf8r5jkqB+GQgoNEDUdUZawUrw==
X-Google-Smtp-Source: ABdhPJwVo62/0ALTnBnDedVNgO544Rk8j1ps8d2HWRwbvmqGmnDiqt6GSXTZFO8UYdGDhfAl9twtbQ==
X-Received: by 2002:aa7:8116:0:b0:44b:e0d1:25e9 with SMTP id b22-20020aa78116000000b0044be0d125e9mr7343208pfi.53.1633032636962;
        Thu, 30 Sep 2021 13:10:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id s38sm3656966pfw.209.2021.09.30.13.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 13:10:36 -0700 (PDT)
Date:   Thu, 30 Sep 2021 13:10:32 -0700
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
Message-ID: <YVYZuBrvV7fnWTSs@google.com>
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

Hi Eric,

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

At the moment it's just called in the GICv3 case. It seems that
registering a GICv3 device results in having an ITS registered as well
(from kvm_register_vgic_device()). I'm assuming this won't change;
we might as well check that assumption. What do you think?

Thanks,
Ricardo

> 
> Maybe refine the patch title mentionning this is an ITS device "init" test.
> as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
> instantiating the ITS before the GIC and try instantiating several ITSs
> with overlapping addresses.
> But I would totally understand if you consider this out of the scope of
> your  fixes + tests.
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
