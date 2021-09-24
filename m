Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BA416EDE
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 11:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244462AbhIXJaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 05:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237056AbhIXJaG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 05:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632475712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IoDPw1naO7tilFKWpbIB0mjp/4gXU+WPMdM7pLJKoHA=;
        b=MbRw5X8FSltWsEDRR4ZRCNO4lA+g7O/2b7wKNXGBygNFm0v6MOJNs3nTuVP5Wxo+mx2fhZ
        FGvosjusNakhoRf8/8xxRqm9CXAAAK49DBHWDozcDAVlJJHLreCRlBgBoxRBhBYDuq1BxM
        nourxBEZtnVYF9e1/YYqEj3EF1urGSg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-SsZmmyQMMgezOYk-3i41DA-1; Fri, 24 Sep 2021 05:28:31 -0400
X-MC-Unique: SsZmmyQMMgezOYk-3i41DA-1
Received: by mail-ed1-f69.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so9578252edv.17
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 02:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IoDPw1naO7tilFKWpbIB0mjp/4gXU+WPMdM7pLJKoHA=;
        b=Ox7G89R+lASrC0pTXnhvsa9XgeI47GAiwD7MdxudQx09yqY2K1WLiBGpCWUb0SF5UI
         Up98SH5OCoXNxYN1CiTPXBUn7dsBhK1IDQk5FO8gzjrrG9hLMY8VHO+Ys/g/PB3p9J3n
         K61gjtDF4LdK0DVI98TItrF6MZfxt0X/r0YTGJ0XGdInQmw/PeVm98+PpdU/QuQA9Xhs
         3TzlJ1ZUElZhfHV7OSc5iuWpAv/4bb3MO6EBDPRZG8pxHuyJypHElVdx/t9HQ1GpK8rD
         hzqP5LH7XpWs/4AGk2POPqSHFlErSsDGBGh6bQjYr5JKUFdJY6jKKMtFqY9RXDNluRy4
         2T3g==
X-Gm-Message-State: AOAM533/nhDcKZZeswXCFPp3M2LwN6Et8mWHBV3YwKmPkUtfmeOeM51O
        P00YDjPZ9Tl/zolUoQ9vHd+luiPiVo6hym6WpbLgvCXkVSGBvn3anFSG+XIJm2BCFTWc4ogZgsm
        05/Oko8pgsQGH
X-Received: by 2002:a05:6402:397:: with SMTP id o23mr3937689edv.59.1632475710477;
        Fri, 24 Sep 2021 02:28:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh74xZ8KOA0BU0tWlr2IZ19X6YEnrfIAboOpOI5qSEDDf3VV5te0ekyXZWkyb0hkI6Io5dng==
X-Received: by 2002:a05:6402:397:: with SMTP id o23mr3937667edv.59.1632475710253;
        Fri, 24 Sep 2021 02:28:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b14sm5403970edy.56.2021.09.24.02.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 02:28:29 -0700 (PDT)
Message-ID: <de3ff2de-da79-fd0c-c90b-f767414b0b69@redhat.com>
Date:   Fri, 24 Sep 2021 11:28:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-6-oupton@google.com> <YTEkRfTFyoh+HQyT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YTEkRfTFyoh+HQyT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/21 21:21, Sean Christopherson wrote:
> 
>> +	if (!matched) {
>> +		...
>> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
>> +		kvm->arch.nr_vcpus_matched_tsc = 0;
>> +	} else if (!already_matched) {
>> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
>> +		kvm->arch.nr_vcpus_matched_tsc++;
>> +	}
>> +
>> +	kvm_track_tsc_matching(vcpu);
>> +	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
>
> This unlock is imbalanced if matched and already_matched are both true.  It's not
> immediately obvious that that_can't_  happen, and if it truly can't happen then
> conditionally locking is pointless (because it's not actually conditional).

This is IMO another reason to unify tsc_write_lock and 
pvclock_gtod_sync_lock.  The chances of contention are pretty slim.  As 
soon as I sort out the next -rc3 pull request I'll send out my version 
of Oliver's patches.

Thanks,

Paolo

