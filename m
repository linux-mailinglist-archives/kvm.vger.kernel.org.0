Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC742201D
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhJEIIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:08:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhJEIIS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633421188;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhjykuBR6EQX00L0VGf5i7raTTT82lQIt3kyQcFUbRI=;
        b=XummsF73EDq2kdV/4Stc9+7awRPlMZXcvrjNQPvpqkj8x9ZlGIbx4W5mw9f/y8XMNJUzhI
        62Wl7KQnkjzo29LlOa8bVsTp7dVLSxnXM9fog5sIhOFlXnM93frZlgj7hR1JhUJyY3ICB4
        moScOWq1q4GKdu1naGwOZqJG6P1sG/w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-dVj4D7LFMHOwLfa_Vp-KWg-1; Tue, 05 Oct 2021 04:06:27 -0400
X-MC-Unique: dVj4D7LFMHOwLfa_Vp-KWg-1
Received: by mail-wr1-f71.google.com with SMTP id n18-20020adff092000000b001609d9081d4so2472535wro.18
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=vhjykuBR6EQX00L0VGf5i7raTTT82lQIt3kyQcFUbRI=;
        b=iE17itRxSre4uWcXSxD4U41LHV8i0r++5dQnK4tviMH7Kw+zIv0A2V4zgsZ0pbKI3D
         Jv99KXTOiD9R8EmT20xgvXBVEWsbWbjgFy/l6Q5b+LPs18J9Uwf7d27FqEjPwATQqxVL
         F6RnRCswvgA+DExV9prBd5RW10fkWJMabHZHmJpLMLtZlZ+OpNvFndf/Sxdd8P716eCs
         yh9W8UF3JUvAJOri+w56tAajLmtpcgXgAFFghjNCOaOKuMef93rpukWbODXIscuR0Fnw
         l6yn2OjcrNWe9moFuTPwYdtXwECHwKYNkFOpiIbL5gjJ7NpJsJ2qie9/w6WRmNriRYgV
         SY7w==
X-Gm-Message-State: AOAM531BRc92qH/WYSaUpX/gPDwScobqPu9GfIBy52Fz9yYr9n0AwS+P
        g7kHCxPsfBP9VXpxZrbqp4CYHrN6LaSMH/0s6WuWpuWJi9Zsx8QqBUiweDxvV1fgIV8uDoDYCeS
        tKZ22x0amgEpL
X-Received: by 2002:adf:e309:: with SMTP id b9mr19580257wrj.81.1633421186297;
        Tue, 05 Oct 2021 01:06:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1n5X+5Mw7xswtFTlINtzSIttQkeQeko39X/73gUrdJh9mS6qkvianazsge358CdgTo8lYBw==
X-Received: by 2002:adf:e309:: with SMTP id b9mr19580229wrj.81.1633421186151;
        Tue, 05 Oct 2021 01:06:26 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c185sm1047398wma.8.2021.10.05.01.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:06:25 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-12-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <42b14187-3865-6b56-8c09-b0dde4884487@redhat.com>
Date:   Tue, 5 Oct 2021 10:06:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-12-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/5/21 3:19 AM, Ricardo Koller wrote:
> Add some ITS device init tests: general KVM device tests (address not
> defined already, address aligned) and tests for the ITS region being
> within the addressable IPA range.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 80be1940d2ad..c563489ff760 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -598,6 +598,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +static void test_v3_its_region(void)
> +{
> +	struct vm_gic v;
> +	uint64_t addr;
> +	int its_fd, ret;
> +
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
> +	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
> +
> +	addr = 0x401000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +		"ITS region with misaligned address");
> +
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"register ITS region with base address beyond IPA range");
> +
> +	addr = max_phys_size - 0x10000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		"Half of ITS region is beyond IPA range");
> +
> +	/* This one succeeds setting the ITS base */
> +	addr = 0x400000;
> +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +
> +	addr = 0x300000;
> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
> +	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
> +
> +	close(its_fd);
> +	vm_gic_destroy(&v);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -650,6 +691,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
> +		test_v3_its_region();
>  	}
>  }
>  

