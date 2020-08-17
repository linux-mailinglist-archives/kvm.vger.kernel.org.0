Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC612246D3A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbgHQQuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 12:50:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388998AbgHQQtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 12:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597682984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8q+z38B9DWFm1LA+LIuL33LbBYORvZ+OjUyVjYFfB0E=;
        b=IyJnHyidOI65L5aQfPI5NjTIES4PFrQildDTb3wtBlxPGwJuKUkh0zb3SBcBNhLEEl5WRV
        21Yx9Y344bNXnLVNjwCoyPrkjSfJjY5uD4erDhAlqf4cKsYEgqHl5ytYZw2BjLAv1sGysB
        6WE7cVvPQ2OQDEbN/uGrTFTqpCby2Xs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-Og2MQbuAM_2G2EfxMoziwQ-1; Mon, 17 Aug 2020 12:49:42 -0400
X-MC-Unique: Og2MQbuAM_2G2EfxMoziwQ-1
Received: by mail-wr1-f72.google.com with SMTP id j2so7309048wrr.14
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 09:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8q+z38B9DWFm1LA+LIuL33LbBYORvZ+OjUyVjYFfB0E=;
        b=fHPAbZLzWRM6E4tb0TsxNMrbxspmgspCTJfOjSMDUYasUkfVQIwO2h6+1/6kMnHYLR
         P3xYMo/AG4Qw8WRzKQGf2nCtb9IOkfPvnpgx3Xpb/Sg/UBRwWZyHf9C//asjLnEpd5eR
         B9zDQ4Ioq50ygVvHEujxjACweLpEP52R3qcgMLAFVhxLPt4lNsowqlIgqTsfjoLWVwve
         gj2AgxZsvEaU+hktpw1ia6VdLZaHsv6HXmawdIJ36k5mECrUBcIb+LvkVgFJznxkVtlU
         5sNPix2lpq3yV5P5xPoCViWg5+Z3r3XRHwq5q9CaImFbcNyFd+c0gEghqvs/DyHQTOnc
         MM0g==
X-Gm-Message-State: AOAM533ONOdxOARi02KaJB0UFEfytDEfOabCxk+7TcOgZ5u1thPqg8ZW
        bxgng9POMTUOOrDmC1vY2uMNK/aySbYvdZkqQMXKvfdPXf6hkAwc6MYvvyC3S/v5D3rVwGRRANn
        v9qDKEOk9EOjR
X-Received: by 2002:adf:a112:: with SMTP id o18mr17474273wro.73.1597682981125;
        Mon, 17 Aug 2020 09:49:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/xW85NlVIfGqmvi5BuLFfLVrPJxz81cr3c69wwDtTLnb+SRTiyjKgOHNpekV1J7lfQQZtVw==
X-Received: by 2002:adf:a112:: with SMTP id o18mr17474247wro.73.1597682980876;
        Mon, 17 Aug 2020 09:49:40 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v8sm30770707wmb.24.2020.08.17.09.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 09:49:40 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Oliver Upton <oupton@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
References: <20200722032629.3687068-1-oupton@google.com>
 <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
 <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
 <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
 <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
 <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7775b2a5-37b0-38f6-f106-d8960cb5310c@redhat.com>
Date:   Mon, 17 Aug 2020 18:49:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/20 18:55, Oliver Upton wrote:
> We allow our userspace to decide the host TSC / wall clock pair at
> which the vCPUs were paused. From that host TSC value we reconstruct
> the guest TSCs using the offsets and migrate that info. On the
> destination we grab another host TSC / clock pair and recalculate
> guest TSC offsets, which we then pass to KVM_SET_TSC_OFFSET. This is
> desirable over a per-vCPU read of MSR_IA32_TSC because we've
> effectively recorded all TSCs at the exact same moment in time.

Yes, this should work very well.  But in the end KVM ends up with the
vcpu->arch.cur_tsc_{nsec,write} of the source (only shifted in time),
while losing the notion that the pair is per-VM rather than per-VCPU for
the "already matched" vCPUs.  So that is why I'm thinking of retrieving
that pair from the kernel directly.

If you don't have time to work on it I can try to find some for 5.10,
but I'm not sure exactly when.

Paolo

> Otherwise, we inadvertently add skew between guest TSCs by reading
> each vCPU at different times. It seems that the sync heuristics
> address this issue along with any guest TSC coordination.
>
> Not only that, depending on the heuristics to detect a sync from
> userspace gets a bit tricky if we (KVM) are running nested. Couldn't
> more than a second of time elapse between successive KVM_SET_MSRS when
> running in L1 if L0 decides to pause our vCPUs (suspend/resume,
> migration)? It seems to me that in this case we will fail to detect a
> sync condition and configure the L2 TSCs to be out-of-phase.
> 
> Setting the guest TSCs by offset doesn't have these complications.
> Even if L0 were to pause L1 for some inordinate amount of time, the
> relation of L1 -> L2 TSC is never disturbed.
> 
>>
>> I am all for improving migration of TSC state, but I think we should do
>> it right, so we should migrate a host clock / TSC pair: then the
>> destination host can use TSC frequency and host clock to compute the new
>> TSC value.  In fact, such a pair is exactly the data that the syncing
>> heuristics track for each "generation" of syncing.
>>
>> To migrate the synchronization state, instead, we only need to migrate
>> the "already_matched" (vcpu->arch.this_tsc_generation ==
>> kvm->arch.cur_tsc_generation) state.
>>
>> Putting all of this together, it would be something like this:
>>
>> - a VM-wide KVM_CLOCK/KVM_SET_CLOCK needs to migrate
>> vcpu->arch.cur_tsc_{nsec,write} in addition to the current kvmclock
>> value (it's unrelated, but I don't think it's worth creating a new
>> ioctl).  A new flag is set if these fields are set in the struct.  If
>> the flag is set, KVM_SET_CLOCK copies the fields back, bumps the
>> generation and clears kvm->arch.nr_vcpus_matched_tsc.
>>
>> - a VCPU-wide KVM_GET_TSC_INFO returns a host clock / guest TSC pair
>> plus the "already matched" state.  KVM_SET_TSC_INFO will only use the
>> host clock / TSC pair if "already matched" is false, to compute the
>> destination-side TSC offset but not otherwise doing anything with it; or
>> if "already matched" is true, it will ignore the pair, compute the TSC
>> offset from the data in kvm->arch, and update
>> kvm->arch.nr_vcpus_matched_tsc.
>>
> 
> It seems to me that a per-vCPU ioctl (like you've suggested above) is
> necessary to uphold the guest-facing side of our sync scheme,
> regardless of what we do on the userspace-facing side.
> 
>> Paolo
>>
> 

