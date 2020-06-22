Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1B203D5D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgFVRDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:03:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729563AbgFVRDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592845411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c20PFCYQDvm9Eid24U2nkRH13DnKGthrv5RalXWjuFY=;
        b=g1TJWk/BljmMMew+ljRgKvBcZu+XkyxdSpCs77J7IhpFdq9mSDR54l5avYepQW9KyxVsyg
        Bid/i8NHoIFUmn1WpvUtin+OkMZaKRKQEov0dQxpvueEmyGm0kKUcAaOyiHo/vU1FNVE6+
        wucMNJLOVSskJZ7UEKhOiE9oOisTyUE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-9KdCowWuNyi60bvEsp1HYg-1; Mon, 22 Jun 2020 13:03:29 -0400
X-MC-Unique: 9KdCowWuNyi60bvEsp1HYg-1
Received: by mail-wm1-f72.google.com with SMTP id g187so104588wme.0
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c20PFCYQDvm9Eid24U2nkRH13DnKGthrv5RalXWjuFY=;
        b=DuYZ7bFp13EM0kaDKSwJCcM6BM7QIjLD16FpEWItU80k/OLqjkKCBvLcl81oTNhPup
         EkUktnZTq3EIBGph/Y9acoEc5tf0dUXSRqSyK69G98VRCtuIqQi9z8MKdjQT+FQT2zYA
         AsTMKWJn2is4fpx9yPsWLkREp9u8pNor23vPceWiZXuXcgCDnX1R2jJiKFacVkzRr+yc
         gTyxgxZ11QPjiHeFIxnpPQM7e/mo/Q4VQPVVb1ByDPtpChHIJkDs+e2atvRyvs51BR6D
         OnvdhB6kIttRH9cvKlvY9HnrAv+HodoWIC8ZQG2OAOrdL4Nb47pxHIb1Kbfi370Cj1Ft
         lMCw==
X-Gm-Message-State: AOAM530s/M2Sk9J9SHTCMi+J77snPF/EneVNDtpur3OVrfuz6cM24nn4
        C46jaUP78zz/X7g3a7FfSoGSJU59jMVH2wCBQKJuwinDxhWq47E4il4tYz3dOA8krVyK1iZlb3a
        NyZJ2NiR8EDHo
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr19131619wmt.105.1592845408428;
        Mon, 22 Jun 2020 10:03:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwweM4fgoyTFBK/0Q0Al7o+gxdp67dHiQcz5b9iViAs9R8o5AJVNf1yg53OQ6NLPISTypdorw==
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr19131589wmt.105.1592845408155;
        Mon, 22 Jun 2020 10:03:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id y25sm197930wma.19.2020.06.22.10.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:03:27 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
Date:   Mon, 22 Jun 2020 19:03:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 18:33, Tom Lendacky wrote:
> I'm not a big fan of trapping #PF for this. Can't this have a performance
> impact on the guest? If I'm not mistaken, Qemu will default to TCG
> physical address size (40-bits), unless told otherwise, causing #PF to now
> be trapped. Maybe libvirt defaults to matching host/guest CPU MAXPHYADDR?

Yes, this is true.  We should change it similar to how we handle TSC
frequency (and having support for guest MAXPHYADDR < host MAXPHYADDR is
a prerequisite).

> In bare-metal, there's no guarantee a CPU will report all the faults in a
> single PF error code. And because of race conditions, software can never
> rely on that behavior. Whenever the OS thinks it has cured an error, it
> must always be able to handle another #PF for the same access when it
> retries because another processor could have modified the PTE in the
> meantime.

I agree, but I don't understand the relation to this patch.  Can you
explain?

> What's the purpose of reporting RSVD in the error code in the
> guest in regards to live migration?
>
>> - if the page is accessible to the guest according to the permissions in
>> the page table, it will cause a #NPF.  Again, we need to trap it, check
>> the guest physical address and inject a P|RSVD #PF if the guest physical
>> address has any guest-reserved bits.
>>
>> The AMD specific issue happens in the second case.  By the time the NPF
>> vmexit occurs, the accessed and/or dirty bits have been set and this
>> should not have happened before the RSVD page fault that we want to
>> inject.  On Intel processors, instead, EPT violations trigger before
>> accessed and dirty bits are set.  I cannot find an explicit mention of
>> the intended behavior in either the
>> Intel SDM or the AMD APM.
> 
> Section 15.25.6 of the AMD APM volume 2 talks about page faults (nested vs
> guest) and fault ordering. It does talk about setting guest A/D bits
> during the walk, before an #NPF is taken. I don't see any way around that
> given a virtual MAXPHYADDR in the guest being less than the host MAXPHYADDR.

Right you are...  Then this behavior cannot be implemented on AMD.

Paolo

