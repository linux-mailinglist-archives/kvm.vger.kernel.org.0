Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EAD42201A
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhJEIGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232942AbhJEIGw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 04:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633421102;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gklNfVRGxQIjBCi8Hh1zAoj858irX/ymXQQZNwnJwkc=;
        b=MA55ZnEyPt9/HddKhdEBkEW4M7Eeu52HhGeyDdikr90HEm5rz56503tJt9roLoJ8TwKUKc
        YF0XV+oMnwL9ivHg+r+Z2I9DVBCrFHvSHTQHQr3mnYjGAVQjdP1/Ki6YWqLeYGBfr9fiCz
        Bc35/5Xonh/ZbiBptHbwdb+DfBQE5VE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-7hFjNxRuNouvSn260ygUCw-1; Tue, 05 Oct 2021 04:05:01 -0400
X-MC-Unique: 7hFjNxRuNouvSn260ygUCw-1
Received: by mail-wm1-f69.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso1544689wmc.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 01:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=gklNfVRGxQIjBCi8Hh1zAoj858irX/ymXQQZNwnJwkc=;
        b=FVNSipEZJf2T26U3S6OSpc7ujBpp3AO0FcOjpOwD7i4xeqoywvVffbRiQBm/t+iA67
         u5T2LKqP+0ZqZjgWa3UCtQE4CFj82Ef7cwpVB8vPaJGSKcFSUurQsLN2I50NyuLPxlZj
         B/kbbKlnPt2LDwZ25DRf4azRJ0v4bk/yTy5+QbEs0EVdRBp83u1AGxpxNbNh6iRMPkz/
         hQX/GEs1i6jtqJDVtfdLMvTNu2xaPS3zP6OuqllkjVKC42nJUJSu7Z90kq5P4eNzSzvP
         0OLvtQVNO3vcCkLNbnt/qUmIO09lAtrIiViQhAf2TLwUV3+nAcv1p6HQhCS3Nc6ZvxLe
         TwzQ==
X-Gm-Message-State: AOAM533AM+Wz0uIx6/w7SGkVKg5qNWpVMoJRHq/CdWmeSoU+Dl4Pv1A5
        JiERDEPwS0Ny8UMM4jM4DlPDk7GGReqAyRcpiFsVQi2VRV1Gnl0N+xNPCkpNGhToQX9MRlTBGOR
        gzd3cfJtf2p7f
X-Received: by 2002:adf:a2c8:: with SMTP id t8mr20005805wra.215.1633421098344;
        Tue, 05 Oct 2021 01:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlaPijAZfsA34o02kPUXvRBvIjJlj4e1qsBu/2dROHMbJpyeCYXCFroKPG5UkjU22RNIOuIg==
X-Received: by 2002:adf:a2c8:: with SMTP id t8mr20005572wra.215.1633421095940;
        Tue, 05 Oct 2021 01:04:55 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n17sm9626078wrw.16.2021.10.05.01.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 01:04:55 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device
 tests
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
 <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
 <YVYZuBrvV7fnWTSs@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <3b7dfd42-5bb2-1fe1-3283-96a1141e68e4@redhat.com>
Date:   Tue, 5 Oct 2021 10:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVYZuBrvV7fnWTSs@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/30/21 10:10 PM, Ricardo Koller wrote:
> Hi Eric,
>
> On Thu, Sep 30, 2021 at 11:14:02AM +0200, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 9/29/21 2:10 AM, Ricardo Koller wrote:
>>> Add some ITS device tests: general KVM device tests (address not defined
>>> already, address aligned) and tests for the ITS region being within the
>>> addressable IPA range.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>>>  1 file changed, 42 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
>>> index 417a9a515cad..180221ec325d 100644
>>> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
>>> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
>>> @@ -603,6 +603,47 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
>>>  	vm_gic_destroy(&v);
>>>  }
>>>  
>>> +static void test_v3_its_region(void)
>>> +{
>>> +	struct vm_gic v;
>>> +	uint64_t addr;
>>> +	int its_fd, ret;
>>> +
>>> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
>>> +	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
>> this may fail if the ITS device has not been registered by KVM (host GICv2)
> At the moment it's just called in the GICv3 case. It seems that
OK I missed that. in that case that's fine.

Thanks

Eric
> registering a GICv3 device results in having an ITS registered as well
> (from kvm_register_vgic_device()). I'm assuming this won't change;
> we might as well check that assumption. What do you think?
>
> Thanks,
> Ricardo
>
>> Maybe refine the patch title mentionning this is an ITS device "init" test.
>> as per Documentation/virt/kvm/devices/arm-vgic-its.rst we could also try
>> instantiating the ITS before the GIC and try instantiating several ITSs
>> with overlapping addresses.
>> But I would totally understand if you consider this out of the scope of
>> your  fixes + tests.
>>
>> Thanks!
>>
>> Eric
>>> +
>>> +	addr = 0x401000;
>>> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
>>> +	TEST_ASSERT(ret && errno == EINVAL,
>>> +		"ITS region with misaligned address");
>>> +
>>> +	addr = max_phys_size;
>>> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
>>> +	TEST_ASSERT(ret && errno == E2BIG,
>>> +		"register ITS region with base address beyond IPA range");
>>> +
>>> +	addr = max_phys_size - 0x10000;
>>> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
>>> +	TEST_ASSERT(ret && errno == E2BIG,
>>> +		"Half of ITS region is beyond IPA range");
>>> +
>>> +	/* This one succeeds setting the ITS base */
>>> +	addr = 0x400000;
>>> +	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
>>> +
>>> +	addr = 0x300000;
>>> +	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>>> +			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
>>> +	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
>>> +
>>> +	close(its_fd);
>>> +	vm_gic_destroy(&v);
>>> +}
>>> +
>>>  /*
>>>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>>>   */
>>> @@ -655,6 +696,7 @@ void run_tests(uint32_t gic_dev_type)
>>>  		test_v3_last_bit_redist_regions();
>>>  		test_v3_last_bit_single_rdist();
>>>  		test_v3_redist_ipa_range_check_at_vcpu_run();
>>> +		test_v3_its_region();
>>>  	}
>>>  }
>>>  

