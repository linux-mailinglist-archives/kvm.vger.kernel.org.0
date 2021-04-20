Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC1366144
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhDTU65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 16:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234015AbhDTU6r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 16:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618952295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mpm+umBp9i5PdTbF9zxZd06VbUs52T4BvoqV6aLO3NE=;
        b=S6GUTfGkMX1Rs8EhGIuU2l7cLbvx/siYUKwoDSrPMlRM2lGhKgcys9iIHho6CPl4w1lhr7
        MIExW8N2uwSIhQLighwigtSTn64aE+yKhfYpxfJIGJ9lQyKMW7q/3cjAlygD7+kywh5ZEs
        lO0mVYeOuXccwxxdAg6oU0Hq7rpscHI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-_iv5jnaiOYWU5nakAuFPOA-1; Tue, 20 Apr 2021 16:58:13 -0400
X-MC-Unique: _iv5jnaiOYWU5nakAuFPOA-1
Received: by mail-ej1-f71.google.com with SMTP id bx15-20020a170906a1cfb029037415131f28so5282992ejb.18
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 13:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mpm+umBp9i5PdTbF9zxZd06VbUs52T4BvoqV6aLO3NE=;
        b=TQkci8jkhzseNdn8GD7No2+L/EIxCBnHu0+bvOgCpX74BvoRM/c5eFGMT3TH1cMn18
         m/hv4p2CXhcSzS8O4s6W+Y0tiCk1znRWyaLp1T4H/k6Vh0XWJmWzCrx+BTjlmO16XWvr
         5l7d9pbcke7O0jkxiFBVfoQfpICxG2B+p94N3fu/WGwFhH0WYssRhrzmo0H4VYd/QTps
         vVnz/ophWJOE15pb0PsMwefCZa66RPkfi23wZwO1kVD8vCzNqZQdnendj8BWxJf1cwqI
         ZSUtzvzImBk2JTZtjm1MI/HpDwR1mUrSx+6vzISXtME3likcLsGnchrJ6k2gLUSY0pql
         UCNw==
X-Gm-Message-State: AOAM531b/3bZtjqE/XsdTQWndNUuEXCFMU/N2gkmlOgZzS+1vySZRJy1
        3ZpPINFzDFLaGiIHaW5XkjHscbbVk7+84xUm4VabmZl7BVZBLLLTA09Wpf8IeJhoC+KvbAABUCd
        WUqX4w+90b36G
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr35346387edu.57.1618952292002;
        Tue, 20 Apr 2021 13:58:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgUgxfeE2uP62AR7HelR6+IeaQjmDmV6Oz7xfkKF+OWIDoUMhrRG5MuCmAOx+ZIrhs/ojBsg==
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr35346361edu.57.1618952291783;
        Tue, 20 Apr 2021 13:58:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u15sm261115edx.34.2021.04.20.13.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 13:58:11 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <05129de6-c8d9-de94-89e7-6257197433ef@redhat.com>
 <YH8lMTMzfD7KugRg@google.com> <YH82qgTLCKUoSyNa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b96c4fc-23a4-0bd2-ea58-fa6d81e50b15@redhat.com>
Date:   Tue, 20 Apr 2021 22:58:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH82qgTLCKUoSyNa@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 22:16, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Sean Christopherson wrote:
>> On Tue, Apr 20, 2021, Paolo Bonzini wrote:
>>> In this particular case, if userspace sets the bit in CPUID2 but doesn't
>>> handle KVM_EXIT_HYPERCALL, the guest will probably trigger some kind of
>>> assertion failure as soon as it invokes the HC_PAGE_ENC_STATUS hypercall.
>
> Oh!  Almost forgot my hail mary idea.  Instead of a new capability, can we
> reject the hypercall if userspace has _not_ set KVM_CAP_ENFORCE_PV_FEATURE_CPUID?
> 
> 			if (vcpu->arch.pv_cpuid.enforce &&
> 			    !guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS)
> 				break;

Couldn't userspace enable that capability and _still_ copy the supported 
CPUID blindly to the guest CPUID, without supporting the hypercall?

(BTW, it's better to return a bitmask of hypercalls that will exit to 
userspace from KVM_CHECK_EXTENSION.  Userspace can still reject with 
-ENOSYS those that it doesn't know, but it's important that it knows in 
general how to handle KVM_EXIT_HYPERCALL).

Paolo

