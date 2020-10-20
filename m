Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EF293A43
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393826AbgJTLti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 07:49:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393623AbgJTLth (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 07:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603194576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HJOHi7hCCCjte1IjtmuV53qRpJLxyma9mr6NzsxivYY=;
        b=Nz/PG1fPfuxxjp1tnWvdrn1E6wUZE9gFfrXeF7LVsTPfHqypQxYHX+KtQ7XA0WiNZ5d3ki
        JUBizNe7AzYJjizeiRcwC9i2JOZfzn2R/06pmaC6h8gAV0cBt47GFSxFfXVyg3wqDxwPJG
        Eo9Gprz9dJ/DgXkCSXCVlEsmS3IQuys=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-HRLsH-31OFurgGxKFO_CvQ-1; Tue, 20 Oct 2020 07:49:34 -0400
X-MC-Unique: HRLsH-31OFurgGxKFO_CvQ-1
Received: by mail-wr1-f72.google.com with SMTP id m20so704028wrb.21
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 04:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJOHi7hCCCjte1IjtmuV53qRpJLxyma9mr6NzsxivYY=;
        b=l1SgiHeM6QoeNFtcWMBrsuTN1rUIq4bQYtqWgFn18AdVzprPBellB7S6cIJcKCL3wv
         TigHR7bc0sKKTD2sSSSHsD6kqUqM9cfHPuRRsghUn9mi3y8BnzPrvRrrLEgnH9Szkxc/
         Lo0+BoVTYtOVkS+2GYx3uBHXWDXTOiT4TWKBns1q7LpMOVCi21ys5pavQhGl2jVhjRBi
         Umw08VZLF1oD07mRdR9J8YbWoOdIG/Qsz/LiAeT0xh2j6EojRsmoXSxupvezgu4Ptv8X
         Hu6Chfs/jRSZRg44+LUzobQa8k0TuGP8ntneDFPMaIMRfbaBjAFR5CHsvfEaG3Ho6gVr
         KX5Q==
X-Gm-Message-State: AOAM5334CptF7hYrmJjcw3pKW6Mzz3VCFd7zF8CVOZc2RGZ9nwqjan3O
        W+btEypIkIjlnepshXYidaGDUo7qp6bEatTozVpFjBt5dLnLP3h3oqyACe/LyW9SPWW5mMXLwyl
        v4Vc8ClNHmz7a
X-Received: by 2002:a1c:32c6:: with SMTP id y189mr2644619wmy.51.1603194573146;
        Tue, 20 Oct 2020 04:49:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSAcDTZqsLEt3bb+95AsHI8IRoDgAog7DIIwwjTsqb14PwgPsSXiaZNkhonOMQ+nf1v3nhHQ==
X-Received: by 2002:a1c:32c6:: with SMTP id y189mr2644591wmy.51.1603194572890;
        Tue, 20 Oct 2020 04:49:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b15sm2631962wrm.65.2020.10.20.04.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 04:49:32 -0700 (PDT)
To:     Alexander Graf <graf@amazon.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
 <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
 <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
 <bce2aee1-bfac-0640-066b-068fa5f12cf8@amazon.de>
 <6edd5e08-92c2-40ff-57be-37b92d1ca2bc@redhat.com>
 <47eb1a4a-d015-b573-d773-e34e578ad753@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Message-ID: <ac2be818-04c8-6027-870c-184148e511ef@redhat.com>
Date:   Tue, 20 Oct 2020 13:49:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <47eb1a4a-d015-b573-d773-e34e578ad753@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/20 12:52, Alexander Graf wrote:
>>
>> Yes, but the idea is that x2apic registers are always allowed, even
>> overriding default_allow, and therefore it makes no sense to have them
>> in a range.  The patch is only making things fail early for userspace,
>> the policy is defined by Sean's patch.
> 
> I don't think we should fail on the following:
> 
> {
>     default_allow: false,
>     ranges: [
>         {
>             flags: KVM_MSR_FILTER_READ,
>             nmsrs: 4096,
>             base: 0,
>             bitmap: { 1, 1, 1, 1, [...] },
>         },
>         {
>             flags: KVM_MSR_FILTER_READ,
>             nmsrs: 4096,
>             base: 0xc0000000,
>             bitmap: { 1, 1, 1, 1, [...] },
>         },
>     ],
> }
> 
> as a way to say "everything in normal ranges is allowed, the rest please
> deflect". Or even just to set default policies with less ranges.
> 
> Or to say it differently: Why can't we just check explicitly after
> setting up all filter lists whether x2apic MSRs are *denied*? If so,
> clear the filter and return -EINVAL.

Hmm, if you start looking at the bitmaps setting up default-deny
policies correctly is almost impossible :/ because you'd have to ensure
that you have at least one range covering the x2apic MSRs.  I'll just
document that x2APIC MSRs ignore the filter.

Paolo

