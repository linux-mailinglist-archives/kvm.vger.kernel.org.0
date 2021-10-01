Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A5341F0C9
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354806AbhJAPOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 11:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbhJAPOJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 11:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633101144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LW6fp9rG/lvp5l8prGyc0xe8qMlUDZGZChEO4If5ox0=;
        b=cuh1A0UdTnY4C7/r5YpXA/HDZdcZRHAH0A4gSo61eS6Q6bvNilXlPMVfGSUCyuwmKis9UW
        d9Zjldz9t86jJba30rS0Y4gkuAlD+rwF25Vi+mJFOhOOQ36ncRL+sI2aA4IN494+ZZ04yL
        F8X4X6KLO+EiK9dnDq4ILEMbegAALHc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-CqBgkAwoO12iTrT9UGR6uw-1; Fri, 01 Oct 2021 11:12:23 -0400
X-MC-Unique: CqBgkAwoO12iTrT9UGR6uw-1
Received: by mail-ed1-f69.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so10769058edb.3
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 08:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LW6fp9rG/lvp5l8prGyc0xe8qMlUDZGZChEO4If5ox0=;
        b=IEi7p2KDidZ4+PRytJowgmd5dcJ1hUX14SvaFl3/6XD7ldWdS2UxdQqICPLEH4xOZp
         8Nqs/1AXGE4i8eCpVkofb72wS+auYCnNxQ1xA4Fo+WTJM7LyiqBBjTkgZuXmPgOk+G1n
         UGtPzLPdBf6VLgUQ6zyEU+0nii/zCWzuXKmLSHBkc6jJiFMeRucEdrEPVvLqhm32ZR+Z
         sX4Lf9KAGZDMzyEGzzTjoZU4y0FAPGrz++WUWDFKc4uhVh8NQfNjxJThIktu8qGgiS1k
         bq3MLdXLWPQTK74E9OJBsiET7cAVc0oJvwF1nlRBxuTz672Ne/oWJn6qsz1cJDn6eGrN
         rQgA==
X-Gm-Message-State: AOAM530L918AEOwQGzc0RBZJHRBFbHRfDputxh2cyFJVI/5Jwfo1zPr7
        I9g+WphC3KjdPGryj1IlL1st6yRE+02eLNkkJG7mBtjMoVPli1b5lMN8bXJCz5K5xL1IMvJ02x1
        nqybSDEZQ46uJ
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr6732921ejc.183.1633101142618;
        Fri, 01 Oct 2021 08:12:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSleQpwCGZXW71w2qzpx6TzvbZz4Gx6iqhZH1Md89m/5OKOBFh+S0Y4ZfLrRfA1AXKxqbKQQ==
X-Received: by 2002:a17:907:3e03:: with SMTP id hp3mr6732898ejc.183.1633101142335;
        Fri, 01 Oct 2021 08:12:22 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.162.200])
        by smtp.gmail.com with ESMTPSA id ee13sm1227751edb.14.2021.10.01.08.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 08:12:21 -0700 (PDT)
Message-ID: <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
Date:   Fri, 1 Oct 2021 17:12:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Content-Language: en-US
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
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
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
 <20211001103200.GA39746@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211001103200.GA39746@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/21 12:32, Marcelo Tosatti wrote:
>> +1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0), +
>> kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0). + [...]
>>  +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock
>> nanoseconds +   (k_0) and realtime nanoseconds (r_0) in their
>> respective fields. +   Ensure that the KVM_CLOCK_REALTIME flag is
>> set in the provided +   structure. KVM will advance the VM's
>> kvmclock to account for elapsed +   time since recording the clock
>> values.
> 
> You can't advance both kvmclock (kvmclock_offset variable) and the
> TSCs, which would be double counting.
> 
> So you have to either add the elapsed realtime (1) between
> KVM_GET_CLOCK to kvmclock (which this patch is doing), or to the
> TSCs. If you do both, there is double counting. Am i missing
> something?

Probably one of these two (but it's worth pointing out both of them):

1) the attribute that's introduced here *replaces*
KVM_SET_MSR(MSR_IA32_TSC), so the TSC is not added.

2) the adjustment formula later in the algorithm does not care about how
much time passed between step 1 and step 4.  It just takes two well
known (TSC, kvmclock) pairs, and uses them to ensure the guest TSC is
the same on the destination as if the guest was still running on the
source.  It is irrelevant that one of them is before migration and one
is after, all it matters is that one is on the source and one is on the
destination.

Perhaps we can add to step 6 something like:

> +6. Adjust the guest TSC offsets for every vCPU to account for (1)
> time +   elapsed since recording state and (2) difference in TSCs
> between the +   source and destination machine: + +   new_off_n = t_0
> + off_n + (k_1 - k_0) * freq - t_1 +

"off + t - k * freq" is the guest TSC value corresponding to a time of 0
in kvmclock.  The above formula ensures that it is the same on the
destination as it was on the source.

Also, the names are a bit hard to follow.  Perhaps

	t_0		tsc_src
	t_1		tsc_dest
	k_0		guest_src
	k_1		guest_dest
	r_0		host_src
	off_n		ofs_src[i]
	new_off_n	ofs_dest[i]

Paolo

