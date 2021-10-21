Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715DE43644D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJUOdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:33:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOdx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 10:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634826697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdjbjwKCbzrBggk/e56ABRtQlxhtpBFAla0dU660TYA=;
        b=XDTps6clVfngWREyx7WndDrp9dsFs6fmAsH12pM6AL+q9PVUX59XBCT7GF0qEo5KWVrxg3
        jlSWVE0H+HYJHBaWyL2RSUNe96GHiQfXhUW24stcRZqtVYrw8B/T6dMypdVNFdaX/sCb36
        Pr46UdtzQZC3rQ24zWLKnV8T4Sriezo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-FHD7ClvdNnm9FnwmUg4v4g-1; Thu, 21 Oct 2021 10:31:36 -0400
X-MC-Unique: FHD7ClvdNnm9FnwmUg4v4g-1
Received: by mail-ed1-f70.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so548551edb.8
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KdjbjwKCbzrBggk/e56ABRtQlxhtpBFAla0dU660TYA=;
        b=iz3jorsq8Sxkx98DdQ+lGrEVNeBpow1Ij4h7u8D2SziSpKDxrt1W4Hyxr+Bq0SOc0j
         bS253A5Ixllqn0F4EllzXz29l5h7beZiDU5JjhkGcnO5CNMNsUWR6odqemvFqmCbYu17
         07aDrsH4PjX/XvzehGSWLM5GvLVBv0zQV03tmswP2mXcuXdABnUvw17hNh8HSWSaeZt/
         tY7x3lGGn5Bi2PMaNIro9Q4Uc0z9zOcSgwoHuA8mFfPspfy5HzCfd5DqGdD+aYOb0mDi
         nIbb4IXeCxIzIdCsL0tZLqcKsUuaHNxjk+ZySnhvs1Q9gxDwoCtJ8fMKdHpLVztgR7Nw
         ChbA==
X-Gm-Message-State: AOAM530qkGYnbLBrpFfitUx6/XT7vWBUdR9Ae3Sx23kuZ/8n0bt7U9Qv
        hlN775F5IawpzRDfN3Ry3B7nFDxv+UWrfyKfAvdr98da2FA9Ze4REEBwXqxqSGiCE8yuaUlYHgY
        sxjDR9Pr8UHNv
X-Received: by 2002:a17:906:5f8e:: with SMTP id a14mr7793983eju.155.1634826694814;
        Thu, 21 Oct 2021 07:31:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypxafgdi5hHzCafQVYDig1EUHbFecNSC91E4jIAlto/IaP2B8JgJlSXKB36z3eiGNQY4qw/w==
X-Received: by 2002:a17:906:5f8e:: with SMTP id a14mr7793961eju.155.1634826694602;
        Thu, 21 Oct 2021 07:31:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id k15sm2599031eje.37.2021.10.21.07.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:31:33 -0700 (PDT)
Message-ID: <439c4a77-498d-43c3-4459-46a583a8459a@redhat.com>
Date:   Thu, 21 Oct 2021 16:31:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Addition of a staging subdirectory to virt/ for in-development
 features
Content-Language: en-US
To:     Amy Parker <apark0006@student.cerritos.edu>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <CAPOgqxEuo6VFAUWc5os6N1iPqh-mQrSg6d09Tj5vy82Gw=v-fg@mail.gmail.com>
 <YXCiM2iKZuiwnfjj@google.com>
 <CAPOgqxEj-XEfWZSaY-jxWNWgcWHGKF2qgLXEcs6+y54jfcocQg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAPOgqxEj-XEfWZSaY-jxWNWgcWHGKF2qgLXEcs6+y54jfcocQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Amy,

I don't think any of these justify a different approach than what we are 
doing already.

On 21/10/21 04:24, Amy Parker wrote:
> 1. Supporting new hardware virtualization technologies, which may take
> a while to develop but should still be available to users for testing
> and non-production purposes while being refined, such as on new
> architectures or by new manufacturers. It's entirely possible that
> there will be new competitors in the x86_64 space soon, especially
> with the increasing popularity of the concept of 128-bit computing
> architectures.

The issue here would be, first and foremost, whether the architectures 
would be supported by Linux.  As KVM RISC-V is going to be included in 
Linux 5.16, I'm not sure what other architectures would be supported by 
Linux but only have experimental status in KVM.

In particular, the recent disagreements about including KVM for RISC-V 
in some kind of "staging" code arose only after the architectural 
specification had reached considerable stability, and so had the KVM code.

> 2. Experimental algorithms which optimize current functions; these may > not be immediately production-ready, but should be available to the
> end user in something like the staging folder.

These are also not suitable for a separate staging subtree.  Almost 
always such optimizations require changes to existing code, in such a 
way that the existing code needs to be aware of what the more 
experimental code is doing.

It is okay to include experimental algorithms and optimizations before 
they have reached feature parity with what they're supposed to replace. 
  See for example the "TDP MMU" code that has been contributed over the 
past year and has only reached feature parity in 5.15.

> 3. Other future virtualization technologies, should they ever be
> added, such as cross-binary architecture and syscall compatibility.

This is the same as the previous point: we have some code in Linux that 
is not used widely (KVM for s390 has some microcode testing 
functionality that is only used internally at IBM, and the Xen emulation 
layer is only used by Amazon as far as I know), but it's okay to include 
it if it's maintainable, reasonably mature, and covered by test cases. 
However, contributions to KVM should follow the same quality standards 
as the rest of Linux.

Thanks,

Paolo

