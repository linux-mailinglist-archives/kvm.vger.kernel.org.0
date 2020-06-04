Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0661EE6E7
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgFDOrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:47:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57164 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729065AbgFDOrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 10:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591282064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVjp1+B7Ums2WwjJdbTd0FyIxmI/v180ZJI4Geq4fto=;
        b=hwtPv5asp921Wqp6pTQwUda5PTKqb4BLm4jEQCjzwXlOmrGQTSofv+ZT2nW2ymLiqzTjRk
        cMP5e5wFWfo08NqfaAQLEC/sZh6AfqbYJeLlrmYxu/Fwhg/ZenEteame+4C+1LwMajRHnN
        0gwjXxe89stJDQrDx+SUrwySpkM2vro=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-TKy_HAgtNwSGehk66dCe8w-1; Thu, 04 Jun 2020 10:47:41 -0400
X-MC-Unique: TKy_HAgtNwSGehk66dCe8w-1
Received: by mail-wm1-f71.google.com with SMTP id u11so2080801wmc.7
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 07:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NVjp1+B7Ums2WwjJdbTd0FyIxmI/v180ZJI4Geq4fto=;
        b=l/J63amoS1LgMoh2HnpjRTp/xMV9qzeIQxPjYU08vim7iR46Q2pap4m6JK1DQ1U+uS
         MMIMd/KivSwOSAZq6ukcCS1xpQpkwAG2g803AWtAfCkKytwbTVqo/8kcz1pXaZLyKEgM
         QTREiij4oQifT8Gm91ySofXdsLAUkUcqPuSAdW4MDcvAmoEv3poVyhwkjjcB2G/eQCe/
         UMeVPF9lTasvx0CgrSAfcpYcU//c2peiUSCNYY+hfw7EALYzCR/gKqDbnY30YGWz3PQb
         yMdGx2vomVvYYxM/fIMmda8K8XWYPopbMkeaNbLX9LVmB82fCSe10oafcHv2pFouNV/c
         1JVw==
X-Gm-Message-State: AOAM53061kt07iWG0ZXSg6LBkstTlJ8lQlxH8KoadTrzwmhm/0CHxcr9
        3qUGJEaHsZ5gvuRauK4c6Xfzxw54picL1MwTg1OhoRnqPU2HE4NAUMeBdtlmdWtsOpv7y/uKJlU
        oJ465B8OEJqZM
X-Received: by 2002:a1c:a943:: with SMTP id s64mr4303615wme.103.1591282060089;
        Thu, 04 Jun 2020 07:47:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/oZ/llxbCOXe7Yhr5uisg7entzGeV6RiIoiIueRD3ktLznBItFpSZ9w8E80IqMv2pWELv5Q==
X-Received: by 2002:a1c:a943:: with SMTP id s64mr4303606wme.103.1591282059855;
        Thu, 04 Jun 2020 07:47:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id s8sm8772371wrg.50.2020.06.04.07.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 07:47:39 -0700 (PDT)
Subject: Re: [PATCH 30/30] KVM: nSVM: implement KVM_GET_NESTED_STATE and
 KVM_SET_NESTED_STATE
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-31-pbonzini@redhat.com>
 <eabf694a-68e4-3877-2ad7-3d37f54fd3d4@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0abde9d2-4257-666d-aa2e-6fbb684a5c21@redhat.com>
Date:   Thu, 4 Jun 2020 16:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <eabf694a-68e4-3877-2ad7-3d37f54fd3d4@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry I missed this.

On 02/06/20 02:11, Krish Sadhukhan wrote:
>>
>> +
>> +    /* SMM temporarily disables SVM, so we cannot be in guest mode.  */
>> +    if (is_smm(vcpu) && (kvm_state->flags &
>> KVM_STATE_NESTED_GUEST_MODE))
>> +        return -EINVAL;
>> +
>> +    if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
> 
> 
> Should this be done up at the beginning of the function ? If this flag
> isn't set, we probably don't want to come this far.

So far we have only done consistency checks.  These have to be done no
matter what (for example checking that GIF=1 if SVME=0).

>> +        svm_leave_nested(svm);
>> +        goto out_set_gif;
>> +    }
>> +
>> +    if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
>> +        return -EINVAL;
>> +    if (kvm_state->size < sizeof(*kvm_state) +
>> KVM_STATE_NESTED_SVM_VMCB_SIZE)
>> +        return -EINVAL;
>> +    if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
>> +        return -EFAULT;
>> +    if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
>> +        return -EFAULT;
>> +
>> +    if (!nested_vmcb_check_controls(&ctl))
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * Processor state contains L2 state.  Check that it is
>> +     * valid for guest mode (see nested_vmcb_checks).
>> +     */
>> +    cr0 = kvm_read_cr0(vcpu);
>> +        if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
>> +                return -EINVAL;
> 
> 
> Does it make sense to create a wrapper for the CR0 checks ? We have
> these checks in nested_vmcb_check_controls() also.

Not in nested_vmcb_check_controls (rather nested_vmcb_checks as
mentioned in the comments).

If there are more checks it certainly makes sense to have them.  Right
now however there are only two checks in svm_set_nested_state, and they
come from two different functions so I chose to duplicate them.

Paolo

