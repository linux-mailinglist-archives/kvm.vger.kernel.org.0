Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101BB21BEA3
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgGJUiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:38:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726828AbgGJUiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 16:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594413489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5MP2qIakLEXVBEBbF3t/qrh+tptAJKb2qp2yBgy7/Q=;
        b=Z8TaoTs/CxwwsWdt/25tL66BmC2yO6LHuKzngDGL9DsTN65VUpZZqDVH9tCW8J+4Wtrjd5
        BSw0cfSxty0a95EIjkcq64h+GfxyGIOhfb/UQF2093MnWtFQlnuFuQzHhlHixMGhpYpzlH
        DPT299+IpNyF2rZS6C59OmIlvDK4geo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-WGg_oIurMLSOtRzrSqLg_w-1; Fri, 10 Jul 2020 16:38:08 -0400
X-MC-Unique: WGg_oIurMLSOtRzrSqLg_w-1
Received: by mail-wm1-f71.google.com with SMTP id c124so7936868wme.0
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5MP2qIakLEXVBEBbF3t/qrh+tptAJKb2qp2yBgy7/Q=;
        b=bpxiHuiufW6ZzldQvw4V08I5uKOF3TEolGg3qPbadwe5yE6ve+ZapJ0kTi9HOL+rmp
         GXZNHZwqQttJu8v/Gud+5BfphsrQOhI6j5A7lm0Zw81T8+5vKNttCgL+sZcUmw7ehM5N
         z0Tutwb9TuoXidWofy0KdIy1xm/98CLuaV/XNb6pimO1DIRrY9DNnK32pGT4hpCze2i0
         xIOk1GSqEsjghcYsk8F5XdpeWyVff4nLbdWU9X57mmbdN5L7aeslYPvio5AUKnslmS0Z
         4XYIvkmYYRBl/e24dYK393IkhSkwX2ebw4mgm1CTPbkQv9cpvhEaRWpxLIzUpaU5NhzS
         8NFA==
X-Gm-Message-State: AOAM530117H68jt+r+VaWzKglvHSXxLvkjrdUQ5w3jHCfZbi+1BphZQL
        0pymgigzK20r3wbuPRV1XwndSqv1yFBIxAhT6JGEAd2O2/yXDzi5Ks2rhy2ZGY6hGMMnz194aFr
        SdCBTRJkS5xki
X-Received: by 2002:a1c:6706:: with SMTP id b6mr6429119wmc.167.1594413487289;
        Fri, 10 Jul 2020 13:38:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydtg+FdlAZoDpEdeVob9aemCtktsvH5dvPWq9RqZ93RNjWBRTR7eTBucDRUxpt4F+0S181kw==
X-Received: by 2002:a1c:6706:: with SMTP id b6mr6429104wmc.167.1594413487035;
        Fri, 10 Jul 2020 13:38:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id h5sm13013468wrc.97.2020.07.10.13.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 13:38:06 -0700 (PDT)
Subject: Re: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200710200743.3992127-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
Date:   Fri, 10 Jul 2020 22:38:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710200743.3992127-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 22:07, Oliver Upton wrote:
> From: Peter Hornyack <peterhornyack@google.com>
> 
> The KVM_SET_MSR vcpu ioctl has some temporal and value-based heuristics
> for determining when userspace is attempting to synchronize TSCs.
> Instead of guessing at userspace's intentions in the kernel, directly
> expose control of the TSC offset field to userspace such that userspace
> may deliberately synchronize the guest TSCs.
> 
> Note that TSC offset support is mandatory for KVM on both SVM and VMX.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Peter Hornyack <peterhornyack@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c             | 28 ++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       |  5 +++++
>  3 files changed, 60 insertions(+)

Needless to say, a patch that comes with tests starts on the fast lane.
 But I have a fundamental question that isn't answered by either the
test or the documentation: how should KVM_SET_TSC_OFFSET be used _in
practice_ by a VMM?

Thanks,

Paolo

