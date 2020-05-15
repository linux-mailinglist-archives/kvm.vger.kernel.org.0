Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53EE1D59D5
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 21:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgEOTSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 15:18:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52413 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbgEOTSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 15:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589570293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CWVjSQ7npbEVbxrWhifmRkThSg5q50pTnOsQ0WvJuZg=;
        b=aGCuqSjRd3925o1q/27SAT+BLxZd+/oW/UXwsaKszlrNpKOS0dR9LHgXa0mZlzSeT9x93b
        goepiqZ+mlaoQM+532DW77D9MbFUhYZctdU3wEK1uCYF6eCvPJANddMi8Mob4JiSZ7Dx1J
        o7aaiX4RJUDTlKdT0F0z6puj7FN6jr8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-kTRGIYD8OUaHLB1CNhQiYg-1; Fri, 15 May 2020 15:18:11 -0400
X-MC-Unique: kTRGIYD8OUaHLB1CNhQiYg-1
Received: by mail-wr1-f69.google.com with SMTP id p2so1623848wrm.6
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 12:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWVjSQ7npbEVbxrWhifmRkThSg5q50pTnOsQ0WvJuZg=;
        b=N0PjGJfp0YjrPJiHzX0AiwgEjz9iQmXTV6lEXVTvea7iKQafAjICQRUfgN73OaoWtZ
         UnoJILI3+O/c7iUmraEb7qVS/VkfP0x2B5vesp+kSKHOohDX077spBJL5xNccfIvbB9s
         wdCefJ5j74SSMd6xsmhtayQWVO58lt0TM3tAjBLTZbi9Ivoh73tFKVQydHL6yCN0YEgu
         ALpu6KDDHQgVQPuUCei+6Pa3UkvVsCA78V/jT8gt0RtAa0UJ++f9k5LmFTb2LBlrkwmw
         Td6jKnorT3bbetAd7xClNeLQkN0mu7QCjY6m1YFECl9D5I5FYFIoD0SoGwJlvEqr5t2v
         1QHg==
X-Gm-Message-State: AOAM531DgVdspzM6K0HYwJgSInuoIaG96woe6PG+oEZg/fkaW2MzHfFX
        KPkmnBteyKT8GC1ooi0cM5yHVDfBVIaQnogga6Gbovzo2rVBygfXP+Db7tKBqPt9tS5yBbd4Vmw
        KmGgCFhxTpTFR
X-Received: by 2002:adf:db4c:: with SMTP id f12mr5581904wrj.387.1589570290510;
        Fri, 15 May 2020 12:18:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDDW2yoWcBeIK7+KjGy8ibUQKD9q7am7akLIVsiO47SDzmrEmzMIHAPe+jdokSH0wcXJItYw==
X-Received: by 2002:adf:db4c:: with SMTP id f12mr5581873wrj.387.1589570290122;
        Fri, 15 May 2020 12:18:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7012:d690:7f40:fd4e? ([2001:b07:6468:f312:7012:d690:7f40:fd4e])
        by smtp.gmail.com with ESMTPSA id 77sm5244034wrc.6.2020.05.15.12.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 12:18:09 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com> <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com> <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
Date:   Fri, 15 May 2020 21:18:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515184646.GD17572@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/20 20:46, Sean Christopherson wrote:
>> The new one using #VE is not coming very soon (we need to emulate it for
>> <Broadwell and AMD processors, so it's not entirely trivial) so we are
>> going to keep "page not ready" delivery using #PF for some time or even
>> forever.  However, page ready notification as #PF is going away for good.
> 
> And isn't hardware based EPT Violation #VE going to require a completely
> different protocol than what is implemented today?  For hardware based #VE,
> KVM won't intercept the fault, i.e. the guest will need to make an explicit
> hypercall to request the page.

Yes, but it's a fairly simple hypercall to implement.

>> That said, type1/type2 is quite bad. :)  Let's change that to page not
>> present / page ready.
> 
> Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
> only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
> can (ab)use the error code to indicate an async #PF by setting it to an
> impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
> is even enforced by the SDM, which states:

Possibly, but it's water under the bridge now.  And the #PF mechanism
also has the problem with NMIs that happen before the error code is read
and page faults happening in the handler (you may connect some dots now).

For #VE, the virtualization exception data area is enough to hold all
the data that is needed.

Paolo

