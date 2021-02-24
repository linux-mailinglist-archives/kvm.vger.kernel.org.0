Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867D832394C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhBXJT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234454AbhBXJTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 04:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614158306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vp0U3q+0sgS/HbcySQhZCb+9HUsFGTSomVlISyKiOcw=;
        b=Tq9yZkqX56QOuqhwg0yPj7sNNhVgXgU78AsFx+hcGE5Pl0oVyzw+TllN+9Z00obfH0xdTs
        zI+K+6LsIx24tZ3YY6ZcfACTf8BANG1bWaKVrxzVySO18+nV/yYOc2VoDhDQeKZ1oHx65J
        p+1MH2kugLRzeorVqmj2/0svkV6y3T4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-Rs_HcygaPqatkNddmf6BXQ-1; Wed, 24 Feb 2021 04:18:24 -0500
X-MC-Unique: Rs_HcygaPqatkNddmf6BXQ-1
Received: by mail-ed1-f72.google.com with SMTP id t18so560121edr.19
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 01:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vp0U3q+0sgS/HbcySQhZCb+9HUsFGTSomVlISyKiOcw=;
        b=HG+UqE1ahAvrH+x/q66jPvRWUFCaYyt1eIHXNJfEP7U1oM06lb2bQ2woWk7HhWw/4r
         hIFoJck3Farx7yYWivP1nX3Qq27jEP2j8QsTQtxRi+DI2/2VIjF5M/Gm0EAtBCOcnW86
         G4/eXdcaNLcZap9kti9pBItRKzaxQVtwXNaNJNIQDaCkqJqNU7WEDhSNDWhJacNKA941
         CM/7UklyxBd66npCai0sqBrYte8mKUMjCZY6Yx8uODwehZl+Cex6kPnWN26TozbBAc1/
         V11j5+3Kf74eK1rTboA/f1A/ZnJau/HsQVCjSEl/tmxnldzeMmmpFyih6gwiSIVPCNNS
         vGYQ==
X-Gm-Message-State: AOAM530StXw3xG/jghWaakhC8Xoe2yKQHDhQKWYTQlx/T5QRpRDMeLu1
        nyJcpsDS3fm6KNfuH4T6EmGmtHsH6UkewOd03aW5wfbLtLj6k032Ggv246F69KlUxGUUaIAL+A+
        seWIXpp0oXj3r
X-Received: by 2002:a17:906:c455:: with SMTP id ck21mr30749025ejb.354.1614158303291;
        Wed, 24 Feb 2021 01:18:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6t1Drpa4mlzDOAGByAryBQ7NDGB0uxnvERB3U67KA8ZYztRBRziNW7VUBQI+Ex9yM4qKjMQ==
X-Received: by 2002:a17:906:c455:: with SMTP id ck21mr30749016ejb.354.1614158303157;
        Wed, 24 Feb 2021 01:18:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t25sm1055375edt.41.2021.02.24.01.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 01:18:22 -0800 (PST)
To:     Nathan Tempelman <natet@google.com>
Cc:     thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Ashish.Kalra@amd.com, Nathaniel McCallum <npmccallum@redhat.com>
References: <20210224085915.28751-1-natet@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <04b37d71-c887-660b-5046-17dec4bb4115@redhat.com>
Date:   Wed, 24 Feb 2021 10:18:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210224085915.28751-1-natet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[CCing Nathaniel McCallum]

On 24/02/21 09:59, Nathan Tempelman wrote:
> 
> +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_TO
> +-----------------------------------
> +
> +Architectures: x86 SEV enabled
> +Type: system

vm ioctl, not system (/dev/kvm).  But, see below.

> +Parameters: args[0] is the fd of the kvm to mirror encryption context to
> +Returns: 0 on success; ENOTTY on error
> +
> +This capability enables userspace to copy encryption context from a primary
> +vm to the vm indicated by the fd.
> +
> +This is intended to support in-guest workloads scheduled by the host. This
> +allows the in-guest workload to maintain its own NPTs and keeps the two vms
> +from accidentally clobbering each other with interrupts and the like (separate
> +APIC/MSRs/etc).

 From purely an API design standpoint, I think I'd prefer a "set context 
from" API (the other way round) to match the existing KVM_SEV_INIT.

Apart from this, the code is very nice and I would have no issues 
merging this in 5.12 even after the merge window.

As an aside, do you happen to have SEV selftests at Google?  I would 
gladly volunteer to write the selftest myself for this ioctl given the 
infrastructure.

Thanks,

Paolo

