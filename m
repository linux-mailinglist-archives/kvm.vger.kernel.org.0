Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9C3A2BE6
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFJMtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhFJMs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623329222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIo7QsXKfR+Ud9QvSm9SxMz/ksJEa+v8MBZQvrHcOtU=;
        b=X9C/+d+P4sGkkYwcHjkK3PzJzHaxgVs0xSTeVqNT9SD8+2MebGmpWg2ROFtfgPwvjE98WQ
        KtywsohztsYBQ0WDq1j7f5tmA+dE0u9ms/ieZ9t5SkMk7NNP+1CsznVIlyjosJ+xC8rt0H
        7qaKTx5WFMl5pT793U0n2ZUyINC/vRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-vdVBE_DKPLCJ19wSOJf0Cg-1; Thu, 10 Jun 2021 08:47:01 -0400
X-MC-Unique: vdVBE_DKPLCJ19wSOJf0Cg-1
Received: by mail-wr1-f70.google.com with SMTP id z13-20020adfec8d0000b0290114cc6b21c4so821575wrn.22
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 05:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rIo7QsXKfR+Ud9QvSm9SxMz/ksJEa+v8MBZQvrHcOtU=;
        b=rtCuZCNYaDH8Qay5AVsHPAQNMSE2QecmF6ugurS7A2l9U2a4AYV59T3YMxHMZdvdTs
         v0WzhQRGwFjopCDF+KUf4WE4u+E/94s7pzJ7ctrVboL7dDhAkzdG6zAVKwO01yfk92c/
         yTX0gb/8nRCUHbxwcVoe4pUERoLIi+N9W+l3JTp/BAtHrC+8oMjeRmwviplock48nwFE
         fQajTUEnf1E/lWNGnRE8tjgTRsUMIsbzMbeEyuqBsC/xk0Tl7vlbUB5q2zDwHZPQejQO
         J6f4WhjwqibTzzcbJBWAsQDGkyhcslbEWl+GKWMnHVAKFe22FNQunk9GOF6EhxKoRQai
         5tng==
X-Gm-Message-State: AOAM533K7BW8PVv1/xIbj76+WZAyF2/fpkr6/doo3fx3QkpWnjZeBH4q
        pYxGCRvAjTLvrOrohd0ed/VbO2ReTpG5ZJzPMFUVL4M1SRbEWNgEj9K/t1+Ih1BwczY5WiNOQo3
        mdPb+rAdNfqkE
X-Received: by 2002:adf:ea49:: with SMTP id j9mr5194298wrn.366.1623329219956;
        Thu, 10 Jun 2021 05:46:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZB3xjQhnCDxz2y3ZgDSZ1YuFlZYtPAav5/zpKGksBc1bg3v3xqk2UE+bf+zKEzQRX61XFLg==
X-Received: by 2002:adf:ea49:: with SMTP id j9mr5194286wrn.366.1623329219801;
        Thu, 10 Jun 2021 05:46:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f14sm8341494wmq.10.2021.06.10.05.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 05:46:59 -0700 (PDT)
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, isaku.yamahata@gmail.com
References: <cover.1618914692.git.isaku.yamahata@intel.com>
 <YK65V++S2Kt1OLTu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
Date:   Thu, 10 Jun 2021 14:45:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YK65V++S2Kt1OLTu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 23:10, Sean Christopherson wrote:
>    - Have kvm_mmu_do_page_fault() handle initialization of the struct.  That
>      will allow making most of the fields const, and will avoid the rather painful
>      kvm_page_fault_init().
> 
>    - Pass @vcpu separately.  Yes, it's associated with the fault, but literally
>      the first line in every consumer is "struct kvm_vcpu *vcpu = kpf->vcpu;".
> 
>    - Use "fault" instead of "kpf", mostly because it reads better for people that
>      aren't intimately familiar with the code, but also to avoid having to refactor
>      a huge amount of code if we decide to rename kvm_page_fault, e.g. if we decide
>      to use that name to return fault information to userspace.
> 
>    - Snapshot anything that is computed in multiple places, even if it is
>      derivative of existing info.  E.g. it probably makes sense to grab

I agree with all of these (especially it was a bit weird not to see vcpu 
in the prototypes).  Thanks Sean for the review!

Paolo

