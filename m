Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5843275E41
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgIWRH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:07:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWRH2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600880847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lCCKD50VB6ysGiusHqpWTIv/KmfW8J9HjWEMiCZ49xs=;
        b=JKu/cKpudogF92POa1HicZLcpbtbiE+KM7Sf6foGD2pVNrCpXXg+TEUop4Z1jJcSlhXgmq
        DMpDE68QjAKwy+6WCpzBmi4A1GLKDKm6DUOkeu7RMHpC3a7SsIn7L2AxTZAslP6kQMViiG
        ZQ9NQNp/VB9MFbjP91fk2jjUYUeqUbs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-2mHh4Ey0PkGwHbRYw6C18g-1; Wed, 23 Sep 2020 13:07:25 -0400
X-MC-Unique: 2mHh4Ey0PkGwHbRYw6C18g-1
Received: by mail-wm1-f70.google.com with SMTP id a7so174895wmc.2
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lCCKD50VB6ysGiusHqpWTIv/KmfW8J9HjWEMiCZ49xs=;
        b=YSe5dEkbUmK38ehYu3CWRTWZizm4PQGPrLeqZZxApWODc1/+k6Xrr4etnvcw9CdbGO
         u2rhMimP95tlqi+o1T7AIzKcHrLse9QP7l1baNb4GWe113eel1/6JYghgTDp6wNqbdE8
         yb5kHizkOZhacRxrsNajv6TA6fO3/7Nyyq5sopawYPFCKOrGdMHnmAUfHQ83fJCpLaSu
         +qPORcCUmthzMRGv2p6+ULddq1h4eNe4rWCuPLiRs6PVZGkkTznPqG7DHz03TJ/o+U2E
         1k0sYqHr+7fgqLQazH7DINvs/J/ps6Gno2PfLCzsn4rR3RNGbzlOYd9LvhLp4tu9BDgh
         1+pg==
X-Gm-Message-State: AOAM533ZJid2juMq/wKStDbCjLal3em2lZfnSoNRdBulTq5YvTmi3Bzy
        33rRZH1lhpEFAJYwiDXockB+6KlbQqC4D1llLnN8TeBoOmbUauFu2lyulM01jj6lsrTf7xLNnQe
        EOI/8bYdOqIBx
X-Received: by 2002:a1c:4886:: with SMTP id v128mr510598wma.139.1600880844310;
        Wed, 23 Sep 2020 10:07:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCTnefL3+7phQEIxiRq7WpGLt9gBwjnmt9g3u/ONU7vVvcSqUmmyhcncSU48t9tHwhf48huw==
X-Received: by 2002:a1c:4886:: with SMTP id v128mr510585wma.139.1600880844128;
        Wed, 23 Sep 2020 10:07:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id c14sm400588wrm.64.2020.09.23.10.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:07:23 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK
 with helper function
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923163629.20168-1-sean.j.christopherson@intel.com>
 <20200923163629.20168-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a215e25-798d-3f17-0fcb-885806f2351b@redhat.com>
Date:   Wed, 23 Sep 2020 19:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923163629.20168-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 18:36, Sean Christopherson wrote:
> +static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
> +{
> +	/* The base must be 128-byte aligned and a legal physical address. */
> +	return !(base & (~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f));
> +}

The fact that you deemed a comment necessary says something already. :)
What about:

        return !kvm_mmu_is_illegal_gpa(vcpu, base) && !(base & 0x7f);

(where this new usage makes it obvious that mmu should have been vcpu).

Paolo

