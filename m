Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96AE1BF41B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD3J1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 05:27:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgD3J1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 05:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588238829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+vie47UJ1oW/NhA/rX/zyO/BjzssU/nJjeCxNVmVx9Q=;
        b=Es4hjRxjN7pcJRXt6K5q4/3qX11RAL9y0v+UQUWp9cdENkTiysGHmQ2LnCz/pbHKjI57cx
        9Y8ikPPygT31FLQZtxHPI8I8SqDPjXGWU6DQtvTQH5L5NCoLi01pJE35wWMTvtMGrI4uqS
        XumwrmvoxtCd6yrsnEjB4OxV56qksXw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-iBqhz8aeOuuN8DzbxNR6vQ-1; Thu, 30 Apr 2020 05:27:06 -0400
X-MC-Unique: iBqhz8aeOuuN8DzbxNR6vQ-1
Received: by mail-wr1-f71.google.com with SMTP id r14so747367wrn.8
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 02:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+vie47UJ1oW/NhA/rX/zyO/BjzssU/nJjeCxNVmVx9Q=;
        b=XbvUAikivKAWxJYoLGiWdJuEVN9hjydF9yc3SZG7wQCVFFjTocIKt8aqPWck3VBCsQ
         /RdzOylahOsCJhUWEACJxBnBSZBwStCYyLz5RKfv15Fs4FX/DkgVpQhl/HZbZ7WGRi0J
         8hDgIkq/6FW29UgfBFdNOjbcr2WUWEfjTvx85L3UWujvNkeIE/27IkDokGqPMGw9IUsp
         9LsZRDTFniK8NK/5AHA+tsfQUjjXxrYZie6nQp+iLP/+KoyT0Bh5GH4X1BhUgFHjQ94j
         p0YnApu+/oGwMvxLMYKoNx993T0fC+IwCzaWqufIyHB1CneDklSEV81eTuvx3gXm1tLk
         iwxw==
X-Gm-Message-State: AGi0PubbdKT0OfWcVfxPQMvjc0fzxxSkgG5cHcHDJ9qpQJZttIwr71LB
        ptuQCIrMEttMmL+6zYxMra7j8Wsuhd76j9D6iivUJtGeFJ2QJzmVEsC0K+n7pQgLtIl6+NDzBfW
        2HLQIVpTtz6hM
X-Received: by 2002:a7b:c456:: with SMTP id l22mr1910015wmi.148.1588238825864;
        Thu, 30 Apr 2020 02:27:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypIidEgYyupOkF7nL6eGUnI+MnsnTzTsxHxlSJH5y9TKoVaupD0CtacA6MBnjUdJnCD7NKs2TQ==
X-Received: by 2002:a7b:c456:: with SMTP id l22mr1909983wmi.148.1588238825624;
        Thu, 30 Apr 2020 02:27:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id o6sm3109407wrw.63.2020.04.30.02.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 02:27:05 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <b1297936-cf69-227b-d758-c3f3ca09ae5d@redhat.com>
 <87sgglfjt9.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18b66e2e-9256-0ef0-4783-f89211eeda88@redhat.com>
Date:   Thu, 30 Apr 2020 11:27:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87sgglfjt9.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 10:40, Vitaly Kuznetsov wrote:
>>  I think in that case
>> kvm_check_async_pf_completion will refuse to make progress.
>> You need to make this bit stateful (e.g. 1 = async PF in progress, 0 =
>> not in progress), and check that for page ready notifications instead of
>> EFLAGS.IF.  
>> This probably means that;
>>
>> - it might be simpler to move it to the vector MSR
> I didn't want to merge 'ACK' with the vector MSR as it forces the guest
> to remember the setting. It doesn't matter at all for Linux as we
> hardcode the interrupt number but I can imaging an OS assigning IRQ
> numbers dynamically, it'll need to keep record to avoid doing rdmsr.

I would expect that it needs to keep it in a global variable anyway, but
yes this is a good point.  You can also keep the ACK MSR and store the
pending bit in the other MSR, kind of like you have separate ISR and EOI
registers in the LAPIC.

>> - it's definitely much simpler to remove the #PF-based mechanism for
>> injecting page ready notifications.
> Yea, the logic in kvm_can_do_async_pf()/kvm_can_deliver_async_pf()
> becomes cumbersome. If we are to drop #PF-based mechanism I'd split it
> completely from the remaining synchronious #PF for page-not-present:
> basically, we only need to check that the slot (which we agreed becomes
> completely separate) is empty, interrupt/pending expception/... state
> becomes irrelevant.

Yes, that's a good point.

Paolo

