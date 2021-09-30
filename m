Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880E841D613
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349272AbhI3JPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 05:15:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349263AbhI3JPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 05:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632993248;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5i00CB+tDLW94gAUllzqnCmt6UVPauV4nQL/hdD8AIo=;
        b=dK1w64uxld0Gp51PRIDovytzfddnQKrwqh6HKukV9JiFEUeG8IszX2G7QdZZxXV5rcbxSW
        fN6LjQRgE3x6Hycj81lJ9CR9OIP73L6yq0WCnMAuU+hxEMaEPecsgTtiyNIsDd+uJw24V/
        g+FSAOPdKkfBb+cZ+2Tskxu5zK3Cwuc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-t61XzqqhMBaH2ff6zUcrhQ-1; Thu, 30 Sep 2021 05:14:07 -0400
X-MC-Unique: t61XzqqhMBaH2ff6zUcrhQ-1
Received: by mail-wm1-f72.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so2645936wmc.2
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 02:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=5i00CB+tDLW94gAUllzqnCmt6UVPauV4nQL/hdD8AIo=;
        b=bQbzJTcDfOG0vrfuagPREQdoiNQcejVynjIEZycTl7PAmOof6W0bBZQYA5yqkwgW0C
         uLAvtt1ithGa7Vl5YEdwyJuX2duVYUcHcjQfb5ebgIsKiSJLADUcc3Hmt8ja4mKNpRPn
         nXHg4s2I+4DVcnb5jS01OHlZt4Zt5+pEmfS8gBSPbCOcF0aL5TaIRopjfTxUkH56y/oP
         4uVA1yonAj6b5SEQrJ36XDcCyO4i941UaW8zRug+LNEbiCtOe6Xq8NF3jm+3fCqNgXT5
         eiwcTq+RErHgIViuZCWafR8lxB6pMbAk06Ql1R8XHsCwDocaUVXk7BWmacbVLc6jOY1H
         Ahiw==
X-Gm-Message-State: AOAM532igtSM/0UppuMamgVrPReyVcepaopevlU6bq0wx/ZK6sKosuXQ
        LT7YbW62NcvjGKhMd1vNVI7w1bj+2M6b7EwkMqu1ZS8klqZ7es4t66A1DoqTvwDGQPrPcpwuVrn
        jFYRxlrEngMij
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr14773846wmk.141.1632993245865;
        Thu, 30 Sep 2021 02:14:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXnJJHykF2wK68naO4trA+VWC8AvHvLKrCrkS+NvdwtjLKTrVSexNUWshv4izEe7G3+3ZnWQ==
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr14773822wmk.141.1632993245686;
        Thu, 30 Sep 2021 02:14:05 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r4sm2456106wma.48.2021.09.30.02.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 02:14:04 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device
 tests
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
Date:   Thu, 30 Sep 2021 11:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210929001012.2539461-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/29/21 2:10 AM, Ricardo Koller wrote:
> Add some ITS device tests: general KVM device tests (address not defined
> already, address aligned) and tests for the ITS region being within the
> addressable IPA range.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 417a9a515cad..180221ec325d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
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
this may fail if the ITS device has not been registered by KVM (host GICv2)

Maybe refine the patch title mentionning this is an ITS device "init" test.
as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
instantiating the ITS before the GIC and try instantiating several ITSs
with overlapping addresses.
But I would totally understand if you consider this out of the scope of
your  fixes + tests.

Thanks!

Eric
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
> @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
>  		test_v3_redist_ipa_range_check_at_vcpu_run();
> +		test_v3_its_region();
>  	}
>  }
>  

