Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0541D460
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 09:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348531AbhI3HTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 03:19:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348519AbhI3HTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 03:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632986255;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=snWeCx4RgtM1wdiRtH9U6Dyc5Jjpi/gorOCqlOq2GLc=;
        b=Qj5OUB3XKRo//JXgZMBBu6LWhjyacpPdpBVK1f7DqIlxn2Ilegtin4F0MkSEty+W9cN7yo
        EUvRrulrmO672FIOrFf8/52wD/Cd4dDhqj9m10cq7PlK3co6gPQaXawgv9x4V5iKvnvyVI
        HXbxFErb4OpS+Z7sL0twrf8y71ZoJoY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-sA1W-WZ9OqmH9Nvh0VcJuQ-1; Thu, 30 Sep 2021 03:17:33 -0400
X-MC-Unique: sA1W-WZ9OqmH9Nvh0VcJuQ-1
Received: by mail-wr1-f69.google.com with SMTP id z2-20020a5d4c82000000b0015b140e0562so1337848wrs.7
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 00:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=snWeCx4RgtM1wdiRtH9U6Dyc5Jjpi/gorOCqlOq2GLc=;
        b=QlTbv3qpW3nBxSC5yCwurstRpuBdFWzW54tJDBJOwNnTLptEbNIC7xL0eqXUyu/kPx
         /rlodP/h//noX2oLDO4yuajWbUng7+uV4lJE5yhKcIq+90ZPxUAmWl/guCXGI4D9Krh5
         N6sg2kKg2888gBA1XUp3Hv3dlBbwY3K/WXJ1JPFNE7RM3TTW0bvp3hWk0CSqV2h8l8r5
         gp7yUV6o2OZG1AJ4PGMivksYAjRc6n+yczgnZg/c4ScJ/OdzwCy0q+G8AHSDCZsvSxs7
         uN3XFZAku94I3nKDIE0YIbXfNc26D0GcptSsWJoJAg/Xo8MsXvEdEDHyCXv6PSkB4lS5
         8qsQ==
X-Gm-Message-State: AOAM5320P+dI3Oz8ChqYjFWZYW7ft1q48CDSvDh2dtFcnBJIiP0x0F6K
        uStFjbMrt3Q+t6yf3+3AJBGzziALiPn93gLNu+CVjG8Jxemm6Qxk/qMRKNaDE9QkVw/8odZi2OR
        66BLwVaHT9G1H
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr4368344wri.300.1632986251954;
        Thu, 30 Sep 2021 00:17:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDQeHb7TkaFHnACphcx/QYkXIfwXwftiA6MXlQ9vXrFzaqnyru1pkmOI8TGf+0NQkMPIzhjw==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr4368325wri.300.1632986251801;
        Thu, 30 Sep 2021 00:17:31 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n7sm2097815wra.37.2021.09.30.00.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:17:30 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 06/10] KVM: arm64: selftests: Make
 vgic_init/vm_gic_create version agnostic
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-7-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <7c4d6409-4a49-4046-ccb4-f89851180e9e@redhat.com>
Date:   Thu, 30 Sep 2021 09:17:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-7-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/21 8:48 PM, Ricardo Koller wrote:
> Make vm_gic_create GIC version agnostic in the vgic_init test. Also
> add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.
>
> No functional change.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 21 +++++++++++--------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 896a29f2503d..b24067dbdac0 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -28,6 +28,7 @@
>  struct vm_gic {
>  	struct kvm_vm *vm;
>  	int gic_fd;
> +	uint32_t gic_dev_type;
>  };
>  
>  static int max_ipa_bits;
> @@ -61,12 +62,13 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
>  	return 0;
>  }
>  
> -static struct vm_gic vm_gic_v3_create(void)
> +static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr_vcpus)
>  {
>  	struct vm_gic v;
>  
> -	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
> -	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	v.gic_dev_type = gic_dev_type;
> +	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
> +	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
>  
>  	return v;
>  }
> @@ -153,6 +155,8 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>  	uint64_t addr, expected_addr;
>  	int ret;
>  
> +	TEST_ASSERT(VGIC_DEV_IS_V3(v->gic_dev_type), "Only applies to v3");
Is that really needed? why here and not in other locations. I would remove.
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric
> +
>  	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
>  	TEST_ASSERT(!ret, "Multiple redist regions advertised");
> @@ -257,8 +261,7 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
>  	struct vm_gic v;
>  	int ret, i;
>  
> -	v.vm = vm_create_default(0, 0, guest_code);
> -	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
>  
>  	subtest_v3_dist_rdist(&v);
>  
> @@ -278,7 +281,7 @@ static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
>  	struct vm_gic v;
>  	int ret;
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
>  
>  	subtest_v3_dist_rdist(&v);
>  
> @@ -295,7 +298,7 @@ static void test_v3_new_redist_regions(void)
>  	uint64_t addr;
>  	int ret;
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
>  			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> @@ -306,7 +309,7 @@ static void test_v3_new_redist_regions(void)
>  
>  	/* step2 */
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  
>  	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
> @@ -320,7 +323,7 @@ static void test_v3_new_redist_regions(void)
>  
>  	/* step 3 */
>  
> -	v = vm_gic_v3_create();
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>  	subtest_v3_redist_regions(&v);
>  
>  	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,

