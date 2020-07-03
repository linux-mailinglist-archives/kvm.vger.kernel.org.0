Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65B213D64
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 18:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgGCQQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 12:16:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726108AbgGCQQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 12:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593793003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFQ4g/P1Du9M9ak16zvRNbstwVtVVpspC33Mh5BHA30=;
        b=K8WK6iPdl+hjmqFhT2S8iVrWnob/cP35qstPfV4YeLtcvbhoPYX580KzMR+2YUfI82o7Bk
        GIowqqWhvhE45lBwyHF0JQhLszEoZxJhE/R2WcdQzVL5c4hVGptJU8XxjvYSX0GseUp2Y/
        w2JHzWzNE+mwQunhD8PwjIXMWJCybSA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-bf76B_fjPQ6UdmBNt-Tmdg-1; Fri, 03 Jul 2020 12:16:42 -0400
X-MC-Unique: bf76B_fjPQ6UdmBNt-Tmdg-1
Received: by mail-wr1-f70.google.com with SMTP id g14so32083107wrp.8
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 09:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFQ4g/P1Du9M9ak16zvRNbstwVtVVpspC33Mh5BHA30=;
        b=jTIY+Z77nFK8uIBlMlXaI5xd3OkpZj39kB7toWEjNpgSAWRROGp+BntT4gEw4uw1vg
         3xQ5GgDdJFyJHxFiqs60hogDI6qWjuOFmFlnY1uaTLB5OpohdjTdrNSnkxsFaKaGkQn1
         /rCVMKPVkAVemjGdmrToaLXC5IPtx5cAidgGRMQx7zntBJ1wIviN17FzyMEXtiWoQjDN
         kvoYnrqor9wPHbZ7iWSAWmK970mh4DLyUsUepR0ufmMjpAiWOCMelJX+ZxUcDJ1ijVeq
         ujD5gghEwGi81uTQ2msQQykQ7OiObj0uDlZpBTRB6Ci2MeSP41atxcgWuc0fEp0wnFdT
         5NgQ==
X-Gm-Message-State: AOAM532QqbunuZe6gQJVlmOQXJ7jQFseF7FsmE7qUC8qN3iaCnFE9fYz
        YE5SYExdUVjjreYE3CiXesV7TAEe/axNXoX7B3AY5776BkFtB0GTMNHZChIvOcKDDBWUF3FXVmL
        91pSBGhp1iEnP
X-Received: by 2002:a1c:3bc2:: with SMTP id i185mr38074442wma.33.1593793000999;
        Fri, 03 Jul 2020 09:16:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy13CMAMpLfw5apomXkvwgGF3aDg9j1/6L32NZ7YIZ5bHdkHZp5VQLJwx9OgIRudyksTnzDVw==
X-Received: by 2002:a1c:3bc2:: with SMTP id i185mr38074427wma.33.1593793000808;
        Fri, 03 Jul 2020 09:16:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id u65sm13711095wmg.5.2020.07.03.09.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 09:16:40 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: VMX: CR0/CR4 guest/host masks cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200703040422.31536-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ad927c2-d02e-3739-f37a-2fd75a3ebb97@redhat.com>
Date:   Fri, 3 Jul 2020 18:16:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200703040422.31536-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 06:04, Sean Christopherson wrote:
> Fix a bug where CR4.TSD isn't correctly marked as being possibly owned by
> the guest in the common x86 macro, then clean up the mess that made the
> bug possible by throwing away VMX's mix of duplicate code and open coded
> tweaks.  The lack of a define for the guest-owned CR0 bit has bugged me
> for a long time, but adding another define always seemed ridiculous.
> 
> Sean Christopherson (2):
>   KVM: x86: Mark CR4.TSD as being possibly owned by the guest
>   KVM: VMX: Use KVM_POSSIBLE_CR*_GUEST_BITS to initialize guest/host
>     masks
> 
>  arch/x86/kvm/kvm_cache_regs.h |  2 +-
>  arch/x86/kvm/vmx/nested.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c        | 13 +++++--------
>  3 files changed, 8 insertions(+), 11 deletions(-)
> 

Queued, thanks.

Paolo

