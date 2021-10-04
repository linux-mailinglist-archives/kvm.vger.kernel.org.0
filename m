Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DBE420A4C
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 13:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhJDLqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 07:46:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232973AbhJDLq3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 07:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633347880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTIIQiwexuN1RAdzEPgfC+3jBs1EDWZPLEcgd8QeZcU=;
        b=awILPRa3Jpa1laWEo7bRvLJFhDrDfMH68x+NVOpAGrUltPc35yHm7q2XyhsICp8tYdwogP
        QxtNTXeg+jt14KwmEwfq4uYc4AcyXiMoOrO4e2ORaoYHqbaDHMdw3uOsrDuX62E/X9jIwt
        swPzBHrXcMjjObLJzK592qBWWJ01RoQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-yeC3DKY9PGGHIVzhw0Z5ow-1; Mon, 04 Oct 2021 07:44:38 -0400
X-MC-Unique: yeC3DKY9PGGHIVzhw0Z5ow-1
Received: by mail-ed1-f71.google.com with SMTP id z62-20020a509e44000000b003da839b9821so16853425ede.15
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 04:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GTIIQiwexuN1RAdzEPgfC+3jBs1EDWZPLEcgd8QeZcU=;
        b=m2y2Jm0R00HvQ/EVBAyzuiFYxCCwz21hB93JxSayG6To8BA/xzW80U3h76g59ve6jc
         glJCqwg1yR8sNiUthzXto/pY9xaHUaNg+VrS80N5ctrTCDxXGLgH/GFQQw0GMUlmDYu5
         JhFsiYDdz9PJPrjVI4TR0rvvyutYDeSSlmNTPkbGzc8Cy/mTd89WTSjPkYksX7fZfSVL
         lbXn1Nz3Qwfg+8eslr0txJI93RkHh4tCtPEcsN3o61hcWPYRat+TMsmp6PYoWnbjMdPD
         eK2pKD0XzRpldE1qqvnSVX9t07lC5PB5FFI17WDiNHM4L5d5W8SpR58u63xBwd0XtVzE
         YUCA==
X-Gm-Message-State: AOAM532JZYjPi/RPICs6J15VpUHB9B7gGp3XJ/BPdMpg688FqY7sewG0
        K0L05HqgxKjMQG2goXxN2JySCJtcn/ts5YWhzbCiNemTXHYyBqOs/ZeGRFF3pfz2f+Ae6pNHZNC
        YjzDiSZLtQ1Nx
X-Received: by 2002:a17:906:e85:: with SMTP id p5mr16759547ejf.159.1633347877512;
        Mon, 04 Oct 2021 04:44:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDeQKGDooaTNNGCBgf5hxRexDWyP01P+aRkP4Sg07t5/j6jHx/UP99CoVqUE4SEK2W0rQKSg==
X-Received: by 2002:a17:906:e85:: with SMTP id p5mr16759518ejf.159.1633347877279;
        Mon, 04 Oct 2021 04:44:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b5sm7125953edu.13.2021.10.04.04.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 04:44:36 -0700 (PDT)
Message-ID: <89b4ab4e-c443-2b14-e878-8c04d066f5b0@redhat.com>
Date:   Mon, 4 Oct 2021 13:44:35 +0200
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
 <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
 <20211001191117.GA69579@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211001191117.GA69579@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/21 21:11, Marcelo Tosatti wrote:
> That said, the point is: why not advance the_TSC_  values
> (instead of kvmclock nanoseconds), as doing so would reduce
> the "the CLOCK_REALTIME delay which is introduced during migration"
> for both kvmclock users and modern tsc clocksource users.

It already does, that's the cool part.  Take again the formula here:

    guest_off_1 = t_0 + guest_off_0 + (k_1 - k_0) * freq - t_1

and set:

	t_1 = t_0 + host_off_0_1 + (k_1 - k_0) * freq

i.e. t_0 and t_1 are different because 1) the machines were booted at 
different times, which is host_off_0_1 2) t_1 includes the migration 
downtime between k_0 and k_1

Now you have:

    guest_off_1 = t_0 + guest_off_0 + (k_1 - k_0) * freq
	       - t_0 - real_off_n - (k_1 - k_0) * freq

    guest_off_1 = guest_off_0 - host_off_0_1

That is, the TSC is exactly the same as it was on the source, just 
adjusted because the two machines were booted at different times.

The need to have precise (ns, cycle) pairings is exactly because it 
ensures that everything cancels in the formula, and all that is left is 
the differences in the TSC of the two hosts.

Paolo

> So yes, i also like this patchset, but would like it even more
> if it fixed the case above as well (and not sure whether adding
> the migration delta to KVMCLOCK makes it harder to fix TSC case
> later).

