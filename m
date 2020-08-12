Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611AD242A80
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 15:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgHLNld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 09:41:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30777 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726804AbgHLNlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 09:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597239689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNPM/DXVd+hsYv1RDubHUxvCynTtgxX6FLHW6tCPxqU=;
        b=LHfYg/HgbFrjabzMwPnjxItlmWZS2cjB944XeHIp2mhQNxB5j4pbYaJLLpKGaLNOtg1oT+
        klq+5mKuu1i511yFsHIKPTcVIpOewjLsA5OzkntUTAA//hzQaX+LlrTyrvLPkOU5t1KsRL
        wdU/K87GKZoA0NsixWoPBBFrZmKDmts=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-vi0bUIV2MommglXH2I3Xdw-1; Wed, 12 Aug 2020 09:41:26 -0400
X-MC-Unique: vi0bUIV2MommglXH2I3Xdw-1
Received: by mail-wm1-f71.google.com with SMTP id k204so725050wmb.3
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 06:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dNPM/DXVd+hsYv1RDubHUxvCynTtgxX6FLHW6tCPxqU=;
        b=VB7706RMW9TX4hEhPYhVsi39i+GJRtr4HSDSXS16QJk+AlFUIbD3leYEufz5lsSMG6
         ejhRM9zvdUt1GX2QBHa2VHzxENDQoYKJOr51gTsiUync4klISCTcxHMuisqSX4ADsNHi
         uXLZYQLymw4tlrvoReBp7533Vh/BZWxP2p5AxRSevnnh4mPRM4fTouqIAAKFnAwnKUU4
         v8Wu8NlQxnZkuGNSUdJG1BWlYgJ99SGKdPZ6rbkAc+xI4W8ZGQjwSQaGS67LahQaYysa
         2nWEj+dJKbOVrIVHlVI1HHTjc2wQJfn8FuMe9pedOj4VYnis0AVvlpGjFMbYcF4kcNHc
         lqXA==
X-Gm-Message-State: AOAM533xzk1v0zWSHAAeHatLigYlV5a3bFU2IJfQGfqzbRDlL60SFf59
        qG2hPCa9jMFEvyEAGjMq1U93ABwXTmLs2uS2NOkFPmKzpkXM5hNCxVFGX08XWVL2MitSOLA6vl7
        8pzmtlk6/YGgK
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr32294086wrx.270.1597239685348;
        Wed, 12 Aug 2020 06:41:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsZAyLlGMKkmspkC3Ujq3SXzql6HdlBCQz4aqSQCFcEI2BkaH+Mm2AfMOpYonmRerOxlObdQ==
X-Received: by 2002:a05:6000:12c1:: with SMTP id l1mr32294056wrx.270.1597239685013;
        Wed, 12 Aug 2020 06:41:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fcdc:39e8:d361:7e30? ([2001:b07:6468:f312:fcdc:39e8:d361:7e30])
        by smtp.gmail.com with ESMTPSA id q5sm4188720wrp.60.2020.08.12.06.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 06:41:24 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
References: <20200722032629.3687068-1-oupton@google.com>
 <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
 <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
 <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
Date:   Wed, 12 Aug 2020 15:41:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/08/20 00:01, Jim Mattson wrote:
>>> but perhaps I'm missing something obvious.
>> Not necessarily obvious, but I can think of a rather contrived example
>> where the sync heuristics break down. If we're running nested and get
>> migrated in the middle of a VMM setting up TSCs, it's possible that
>> enough time will pass that we believe subsequent writes to not be of
>> the same TSC generation.
>
> An example that has been biting us frequently in self-tests: migrate a
> VM with less than a second accumulated in its TSC. At the destination,
> the TSCs are zeroed.

Yeah, good point about selftests.  But this would be about the sync
heuristics messing up, and I don't understand how these ioctls improve
things.

>> My immediate reaction was that we should just migrate the heuristics
>> state somehow
> 
> Yeah, I completely agree. I believe this series fixes the
> userspace-facing issues and your suggestion would address the
> guest-facing issues.

I still don't understand how these ioctls are any better for userspace
than migrating MSR_IA32_TSC.  The host TSC is different between source
and destination, so the TSC offset will be different.

I am all for improving migration of TSC state, but I think we should do
it right, so we should migrate a host clock / TSC pair: then the
destination host can use TSC frequency and host clock to compute the new
TSC value.  In fact, such a pair is exactly the data that the syncing
heuristics track for each "generation" of syncing.

To migrate the synchronization state, instead, we only need to migrate
the "already_matched" (vcpu->arch.this_tsc_generation ==
kvm->arch.cur_tsc_generation) state.

Putting all of this together, it would be something like this:

- a VM-wide KVM_CLOCK/KVM_SET_CLOCK needs to migrate
vcpu->arch.cur_tsc_{nsec,write} in addition to the current kvmclock
value (it's unrelated, but I don't think it's worth creating a new
ioctl).  A new flag is set if these fields are set in the struct.  If
the flag is set, KVM_SET_CLOCK copies the fields back, bumps the
generation and clears kvm->arch.nr_vcpus_matched_tsc.

- a VCPU-wide KVM_GET_TSC_INFO returns a host clock / guest TSC pair
plus the "already matched" state.  KVM_SET_TSC_INFO will only use the
host clock / TSC pair if "already matched" is false, to compute the
destination-side TSC offset but not otherwise doing anything with it; or
if "already matched" is true, it will ignore the pair, compute the TSC
offset from the data in kvm->arch, and update
kvm->arch.nr_vcpus_matched_tsc.

Paolo

