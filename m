Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9E7443478
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhKBRWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhKBRWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 13:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635873580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05TT9MkJCk0DqV5SpkJmQ07yFhoMwC6RkMiPn+bsf0o=;
        b=F+UWHoYWMTorLlQbUY9TQptAnhdI+DVtmoG6eJBvWqExzX3ApClEgH5wTVEq7ZtzDA4T6g
        wXv8CyqiK3jgDnDlJ7JrWDf46uYgtX1XHYxE+IbcuD0wt+mh5V7aNLx2yGWC/1ZPvY0jmE
        c0JhV2Vhaq8ApH23b+hNQuFw4V2w0gI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-sB19VUgtPYuxudnciczxrw-1; Tue, 02 Nov 2021 13:19:39 -0400
X-MC-Unique: sB19VUgtPYuxudnciczxrw-1
Received: by mail-wm1-f71.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso1118597wms.5
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=05TT9MkJCk0DqV5SpkJmQ07yFhoMwC6RkMiPn+bsf0o=;
        b=30AZCtITWE7qNiFEyuuppwyooKBXYMNFhSFMAKdRT084KBbi9rUZ4thsv7uRXUZpkI
         GYtWdZIwnnChOeVn1tWkh3gesLSXh6gsRwGLrhdoHQnN9s5Cqf6CNBeYBgbjntpbIw2+
         GWYWpfYzZpu3nt1PddsGbwarU3h0CtJZGFfjlQEUZ4gUmQ5rvRco7kl51KuqfC+d6eA8
         ReLiU6C/KX/KI4EuIVwsizfFgP+k87KQo/g4MMlH/U3YXigMZM0tCbTZViWB3+sQSTnC
         wOS5bJQZY3KTvC1Ux4FG5xxNTxJ5JKPCRN8qEE/HIM8FhCpwF9aP1KOBLXA0zrJ5sVpk
         HNwQ==
X-Gm-Message-State: AOAM5319UEHwCP4UWUs/ABJwDvabcpQbuNetTSbPwmIzSlyb/2siQvdE
        5FFzxz4ZgoWM8unxDUVDEL2bpxLr2IfrPBwspZcOjyrtHVEoPL5TY8y+fXUS2wcmwFwDL2fA7WW
        I4Ue8aq9x+lKK
X-Received: by 2002:a1c:7c14:: with SMTP id x20mr8658169wmc.75.1635873577979;
        Tue, 02 Nov 2021 10:19:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXd7OC6c+Krh/aO54+khmn65xJM9TXgfkI6lXdlYIbin+OAbEzqQjf86Hh18QAO8PV6wD6FQ==
X-Received: by 2002:a1c:7c14:: with SMTP id x20mr8658127wmc.75.1635873577690;
        Tue, 02 Nov 2021 10:19:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 6sm3152077wma.48.2021.11.02.10.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 10:19:36 -0700 (PDT)
Message-ID: <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
Date:   Tue, 2 Nov 2021 18:19:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/21 18:11, David Woodhouse wrote:
> On Tue, 2021-11-02 at 18:01 +0100, Paolo Bonzini wrote:
>> On 02/11/21 17:38, David Woodhouse wrote:
>>> This kind of makes a mockery of this
>>> repeated map/unmap dance which I thought was supposed to avoid pinning
>>> the page
>>
>> The map/unmap dance is supposed to catch the moment where you'd look at
>> a stale cache, by giving the non-atomic code a chance to update the
>> gfn->pfn mapping.
>>
> 
> It might have *chance* to do so, but it doesn't actually do it.
> 
> As noted, a GFN→PFN mapping is really a GFN→HVA→PFN mapping. And the
> non-atomic code *does* update the GFN→HVA part of that, correctly
> looking at the memslots generation etc..
> 
> But it pays absolutely no attention to the *second* part, and assumes
> that the HVA→PFN mapping in the userspace page tables will never
> change.
> 
> Which isn't necessarily true, even if the underlying physical page *is*
> pinned to avoid most cases (ksm, swap, etc.) of the *kernel* changing
> it. Userspace still can.

Yes, I agree.  What I am saying is that:

- the map/unmap dance is not (entirely) about whether to pin the page

- the map/unmap API is not a bad API, just an incomplete implementation

And I think the above comment confuses both points above.

>> The unmap is also the moment where you can mark the page as dirty.
> 
> Sure, but it's the wrong page :)

The GFN _also_ has to be marked dirty.

Paolo

