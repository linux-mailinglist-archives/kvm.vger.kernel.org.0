Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A551941E2D7
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348301AbhI3UvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 16:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344464AbhI3UvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 16:51:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849EC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 13:49:17 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c4so4885622pls.6
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kLLmidAxMlLrdM1tZPimMc82gDNJKFY7wcdU77wPZiU=;
        b=TBZgEJYjteguWk5616AMItXm6yve+qVhATFjz8gBV5WDFRGP1wZvHZTdm3IDmTtH1D
         1wB4ZcEIFkOupe5TkwbYhi23DS4PmIJ1eMdK3cFrKs3LWEYlApJDgT/x+b7rE/bNl3dG
         YaN+LYmVyVKxypCt4HU650OkabquPf9HEO3eFSvmuIGxqkeUEO2Y5gX+MfqSxp4XKijD
         /u2RhL2p98csvcwvFM4slYvwtqRwToATdc6lFUNHWAP5hcfY92C156Rb9aRciYF+Tzjq
         1jrYkI02ynQ8DlwF3+uHv1+23+LrcGWWGQ7GAfoLWskAgHuw+O7bTI+96CmvwYBVtzb+
         e5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kLLmidAxMlLrdM1tZPimMc82gDNJKFY7wcdU77wPZiU=;
        b=fNJNz7NkopFK+cD/svgYXntEQheefa7oM2VvLB0OXEaal/8cL3VBYHOwg08A0ubO3D
         P5/crcYFDC4vGFTJlJ0HKlr77OYUj+cIXQjw25xpfyAD6U27K9Xas3FwKex7RU9GIQiQ
         tH75Y9eyQ0kUiieRpTBu03kr1M1CLmT+QYN0pY+8XSqdEkabIvEcD9RME6MkiC7DTusO
         lc0f5hqybKRMZBCo0RMdewiJ4NlOvYTaXCAlAj0CCGZZM5/Tirr5OoJCcs18otbId+T7
         g516/FlWj9nBkzxu5g+vzt6nfG1A/dDycKbpjrepNbCvuaszc1DiOGA9+Nr0/MYhJ206
         2Fbw==
X-Gm-Message-State: AOAM530ZOwPOhPciIJLLZsM4SXyQjtijNCI1ope6oqCq1cO/bQdMdfWM
        8TtRmi75FGjmVkTiZ0Z90Zj1dA==
X-Google-Smtp-Source: ABdhPJyqHKzG5RrYTh9IkRhNrJWSMeZUZtw+hXM3xDqdNnmQt9Pjprn1kzoU/PZkNz3EuZS8va2WZw==
X-Received: by 2002:a17:90b:1d01:: with SMTP id on1mr15010347pjb.21.1633034956551;
        Thu, 30 Sep 2021 13:49:16 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d8sm3897581pfu.139.2021.09.30.13.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 13:49:16 -0700 (PDT)
Date:   Thu, 30 Sep 2021 13:49:12 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
Message-ID: <YVYiyLnZtjgt7Zeo@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-9-ricarkol@google.com>
 <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 10:51:05AM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/28/21 8:48 PM, Ricardo Koller wrote:
> > Add tests for checking that KVM returns the right error when trying to
> > set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> > addressable IPA range. Also tighten the IPA range by replacing
> > KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> > guest (i.e., the default).
> >
> > The check for the GICv3 redistributor created using the REDIST legacy
> > API is not sufficient as this new test only checks the check done using
> > vcpus already created when setting the base. The next commit will add
> > the missing test which verifies that the KVM check is done at first vcpu
> > run.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 46 ++++++++++++++-----
> >  1 file changed, 35 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > index 92f5c6ca6b8b..77a1941e61fa 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -31,7 +31,7 @@ struct vm_gic {
> >  	uint32_t gic_dev_type;
> >  };
> >  
> > -static int max_ipa_bits;
> > +static uint64_t max_phys_size;
> >  
> >  /* helper to access a redistributor register */
> >  static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> > @@ -150,16 +150,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
> >  	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
> >  
> >  	/* out of range address */
> > -	if (max_ipa_bits) {
> > -		addr = 1ULL << max_ipa_bits;
> > -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 dist.attr, &addr, true);
> > -		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> > +	addr = max_phys_size;
> > +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 dist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> >  
> > -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > -					 rdist.attr, &addr, true);
> > -		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> > -	}
> > +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> > +
> > +	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
> > +	addr = max_phys_size - dist.alignment;
> > +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 rdist.attr, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG,
> > +			"half of the redist is beyond IPA limit");
> >  
> >  	/* set REDIST base address @0x0*/
> >  	addr = 0x00000;
> > @@ -248,7 +253,21 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
> >  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  
> > -	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
> > +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
> > +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG,
> > +		    "register redist region with base address beyond IPA range");
> > +
> > +	/* The last redist is above the pa range. */
> > +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size - 0x10000, 0, 2);
> > +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> > +	TEST_ASSERT(ret && errno == E2BIG,
> > +		    "register redist region with base address beyond IPA range");
> s/base address/top address

ACK

> > +
> > +	/* The last redist is above the pa range. */
> > +	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
> >  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> Why this second check?

Wanted to test having two redists (just a bonus test). This one is
sligthtly more interesting than the previous one, so will just remove
the previous one.

> >  	TEST_ASSERT(ret && errno == E2BIG,
> > @@ -608,8 +627,13 @@ void run_tests(uint32_t gic_dev_type)
> >  int main(int ac, char **av)
> >  {
> >  	int ret;
> > +	int max_ipa_bits, pa_bits;
> >  
> >  	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> > +	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> > +	TEST_ASSERT(max_ipa_bits && pa_bits <= max_ipa_bits,
> > +		"The default PA range should not be larger than the max.");
> Isn't it already enforced in the test infra instead?
> I see in lib/kvm_util.c
> 
> #ifdef __aarch64__
>         if (vm->pa_bits != 40)
>                 vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> #endif

You are right, and this is a weird place to make that check.

> 
> vm_open()
> > +	max_phys_size = 1ULL << pa_bits;
> >  
> >  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
> >  	if (!ret) {
> Eric
>

Thanks,
Ricardo
