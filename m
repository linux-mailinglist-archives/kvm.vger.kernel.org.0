Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08241D3D7
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbhI3HEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 03:04:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbhI3HEA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 03:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632985337;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHSiUrkZvCsxOeU5xfKaRYm9wqLGK3XFjTD1F2kLbP0=;
        b=KuB0ODgd7374RzbPyp+hf0lIAXYL2Qs3oEUygawB43lHPBJze0sFL5jNeZAKh8ReXOY26G
        WpM+sDDt62dDKucah2UaKJqY3S4QjmoplhXRPy5t2Br9yktStKGZGOVdaTx2hWtR2JwUTA
        16RIyR4OvWh3H9XEhYnhYqTfKLTHpms=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-4zIrh3vRNWqCAUDbRa1mdg-1; Thu, 30 Sep 2021 03:02:16 -0400
X-MC-Unique: 4zIrh3vRNWqCAUDbRa1mdg-1
Received: by mail-wr1-f70.google.com with SMTP id k16-20020a5d6290000000b00160753b430fso1318199wru.11
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 00:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=ZHSiUrkZvCsxOeU5xfKaRYm9wqLGK3XFjTD1F2kLbP0=;
        b=EDstQC2AVXSPouISypxDXbw+7pKnN0cW58GicmFnJ8oVgB2XrdCycnPEs311Mgrwwv
         iVjuVyekz9j7zeY4+wI7btzsVOzrTkw9E3aSLjJOz70Fg7cdA7sYlgdamrZjN2ld3/Yu
         N3WPY2u0jtIH6T02TjX8AOcgLugabXK4nBRRel4nhShXyvWIalI1zDFleuCBcqXk6IPO
         a5Ed8lc4Dx56KYqkRqwjITCNoWO7SlLLkfICn0GDUWohj1O5fqnvYJ0wvNFiVojJCkHE
         qqlhGOOcn9MlWBmEspuYWpdenb3nSnU2Tt2eDLArs9CPGJel9Ntlgp8nPIRQ8uNgQnkR
         PPXA==
X-Gm-Message-State: AOAM533XXwomv/+eSTzWhxprLEi6GZs9VRT7lAfmCIUCsE0dS055jJP4
        ri1mFcm1cXh0H03pluo1JeUzWkxeGUWI0lxfZsWA5y4u0H0uApU7dCaazkp/nv4KUwHOqnIN1G1
        bY/3kC6H54yp9
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr3707471wmc.14.1632985335364;
        Thu, 30 Sep 2021 00:02:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF78XOIE/kiNSNg9Ko30J2+7Orfs0VyPIx6WyeXUiutZXvna7Xlsl7/OC8dJdC85oi6yDVfg==
X-Received: by 2002:a1c:2c3:: with SMTP id 186mr3707452wmc.14.1632985335175;
        Thu, 30 Sep 2021 00:02:15 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w17sm1878500wmi.42.2021.09.30.00.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:02:14 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
Date:   Thu, 30 Sep 2021 09:02:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YVTX1L8u8NMxHAyE@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/29/21 11:17 PM, Ricardo Koller wrote:
> On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 9/28/21 8:47 PM, Ricardo Koller wrote:
>>> Add the new vgic_check_iorange helper that checks that an iorange is
>>> sane: the start address and size have valid alignments, the range is
>>> within the addressable PA range, start+size doesn't overflow, and the
>>> start wasn't already defined.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
>>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
>>>  2 files changed, 26 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> index 7740995de982..f714aded67b2 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>>>  	return 0;
>>>  }
>>>  
>>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
>>> +		       phys_addr_t addr, phys_addr_t alignment,
>>> +		       phys_addr_t size)
>>> +{
>>> +	int ret;
>>> +
>>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
>> nit: not related to this patch but I am just wondering why we are
>> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
>>
>> vgic_check_iorange()? This must be a leftover of some old code?
>>
> It's used to check that the base of a region is not already set.
> kvm_vgic_addr() uses it to make that check;
> vgic_v3_alloc_redist_region() does not:
>
>   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
>   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
Yes but I meant why a pointer?

Eric
>
> Thanks,
> Ricardo
>
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	if (!IS_ALIGNED(size, alignment))
>>> +		return -EINVAL;
>>> +
>>> +	if (addr + size < addr)
>>> +		return -EINVAL;
>>> +
>>> +	if (addr + size > kvm_phys_size(kvm))
>>> +		return -E2BIG;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int vgic_check_type(struct kvm *kvm, int type_needed)
>>>  {
>>>  	if (kvm->arch.vgic.vgic_model != type_needed)
>>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
>>> index 14a9218641f5..c4df4dcef31f 100644
>>> --- a/arch/arm64/kvm/vgic/vgic.h
>>> +++ b/arch/arm64/kvm/vgic/vgic.h
>>> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
>>>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>>>  		      phys_addr_t addr, phys_addr_t alignment);
>>>  
>>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
>>> +		       phys_addr_t addr, phys_addr_t alignment,
>>> +		       phys_addr_t size);
>>> +
>>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>>>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
>> Besides
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Eric
>>

