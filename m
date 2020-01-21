Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF1143EA0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAUNvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:51:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727817AbgAUNvv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579614710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+thaj6fraaz5u5SaFmzmpY7g+fCANo2RPX6WMKeeTI=;
        b=ZMPp1uqtgTQth73vjAEIqAHmizbUZ+LewsWKm5rR+WSoiohLmj/GRK/Q9cbz2+pJub7DAO
        mVyROobwefLAuYdjRsNGL9T+nZh7iLotL0B0Lb+Qd4slXHQZEstVow7AjnCiYL9DzuORzS
        O6nIdRGnD5P1obmPUQkhKrlg+CtYNG0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-EY9bbQBAPPWDkH4wBITmoQ-1; Tue, 21 Jan 2020 08:51:49 -0500
X-MC-Unique: EY9bbQBAPPWDkH4wBITmoQ-1
Received: by mail-wm1-f69.google.com with SMTP id t16so640237wmt.4
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 05:51:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+thaj6fraaz5u5SaFmzmpY7g+fCANo2RPX6WMKeeTI=;
        b=mOliY8yd23BXFXVWhfpXUJJdMFAJD2ae4qTWBpIeAt8UluJEgRQN0lNKndE/fdpFoj
         yIquqekqzVc5kjmdoGqkIAOBvwvkEntlLhPpPw5n4o9wSm+Yb6yS/FiQHepYWVg734DI
         a4Yx7doyalpHqqa66dCygQOrefw6V9RIDF33aA+/VDPDhhRr6lvQCK6PlwNiiY1XetqS
         sKoXG3DZ62GtHCy/9tC/+YE64QNI4O4h5OQqCkZXT41iRvPak0VKptewEYf+8LXGKoBa
         Wnz6Qm4e7D2tgxUMn3/KPNQu5V4r+6t9DzEy38Yoovg8ZlmQ2zZHJKLUIgmN3JEgkj5W
         GpVw==
X-Gm-Message-State: APjAAAXSxZRNZcGgKwOfK3PUfuQ7l6F45SbGEi3YmXhmnoJLlShnJQRP
        KcqJepob69q8pwnEIPkDvHOiZrH0B9z1qBucB32jlzbkY6JftZO1qcf0NG3nZ01OtpBCrMb2bpd
        sT4LAbLhKSEEz
X-Received: by 2002:a1c:9602:: with SMTP id y2mr4430224wmd.23.1579614708122;
        Tue, 21 Jan 2020 05:51:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUB73EGquW6vCktv8qGYr2Nk6qQyraAwTN0+HO2LIZ8PeFcJM3D2gQr9or8mDGO1aiJknCuw==
X-Received: by 2002:a1c:9602:: with SMTP id y2mr4430206wmd.23.1579614707814;
        Tue, 21 Jan 2020 05:51:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id q3sm53733831wrn.33.2020.01.21.05.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 05:51:47 -0800 (PST)
Subject: Re: [PATCH 0/3] KVM: Clean up guest/host cache read/write code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Barret Rhoden <brho@google.com>
References: <20200109235620.6536-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50f1d58a-5ac8-be1f-9c31-a49e699f362b@redhat.com>
Date:   Tue, 21 Jan 2020 14:51:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109235620.6536-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/20 00:56, Sean Christopherson wrote:
> Minor cleanup to fix the underlying crustiness that led to an uninitialized
> variable warning reported by Barret.
> 
> The first two patches are tagged with Fixes:, but I don't know that they're
> actually worth backporting to stable.  Functionally, everthing works, it's
> just a bit weird and AFAICT not what is intended.  It might be preferable
> to take Barret's patch[*] first and only mark that for stable, as it fixes
> the immediate issue without revamping __kvm_gfn_to_hva_cache_init().
> 
> [*] https://lkml.kernel.org/r/20200109195855.17353-1-brho@google.com
> 
> Sean Christopherson (3):
>   KVM: Check for a bad hva before dropping into the ghc slow path
>   KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
>   KVM: Return immediately if __kvm_gfn_to_hva_cache_init() fails
> 
>  virt/kvm/kvm_main.c | 45 ++++++++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 19 deletions(-)
> 

Queued, thanks.

Paolo

