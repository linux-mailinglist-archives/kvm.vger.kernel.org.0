Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152B3295F3E
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 15:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899212AbgJVNCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 09:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506896AbgJVNCZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 09:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603371744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Baoti0rGPc8rx4Gu7rHbcn1CKN3zPD/a9Reidmnsr8=;
        b=MY87XrPHJxAeYzIgxFLgpjBbpa88WUH2Vr9H9c0QZtcvnhHVT2lVR+3VU7PNwLWgelMZEy
        E0k9IhfUQcTAb1twYqrYRm8FSwXwSCukF3gMsD/n1uTZC8DoNE17+GZysM6uUUOQ3WjYdT
        b/8J2tVKYvE+q4IT6rBjzpfv4Ue1LFw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-_bwUFLiPMm6K7MWu8WZEHQ-1; Thu, 22 Oct 2020 09:02:22 -0400
X-MC-Unique: _bwUFLiPMm6K7MWu8WZEHQ-1
Received: by mail-wr1-f72.google.com with SMTP id 33so584270wrf.22
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 06:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Baoti0rGPc8rx4Gu7rHbcn1CKN3zPD/a9Reidmnsr8=;
        b=qAP4az3oC9TuKFSN/1fbBWbkD8kHoh1BkE7T4087LSf4MhMx3vGOiaxjm6gjR4dB6u
         4REhIbUu/cnil8+R7sC4ThCeKn83FP4voQYW0z5tmsNkXEBMEZn83s+LpBFjH+D4JmN5
         vtcvY33ZGW5XnNC0NlrghLdsLnWlGKX2mJfAfUYRkBgKk8qEvspAK+/ktbUbdRUp/LeP
         lENymWRdGnYjLAcIdofZikMbwEvyTC3VdPMxadA/5+ttVDppcTJJofP+gjzkkvBF/b3Z
         eUsoLrUaZ/h1ZSbAPspGUEfMtYVEsKLk3eId7QYJFplLgZtnkRhuF0kHb5k8e6C5mTBe
         97Lg==
X-Gm-Message-State: AOAM532X1ZsdxLrWRUpQq2prKu73rPUciqAp4IxgNvrk6Q5sL8y0jZjQ
        SjSYVcszl7LP+TubWjuPRc0K5llpAqhCrbJV1ba6SCrQCV5CdcoUAyTuUEguP5wOwKn7juMngTQ
        0bu6CX1QStJDu
X-Received: by 2002:adf:97cb:: with SMTP id t11mr2834623wrb.292.1603371741248;
        Thu, 22 Oct 2020 06:02:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdR80pHuceIpF8ybnwX11kJxDdRfn6kU7dlv3coiblTzqqD1XBYYiyCglWKy6psAXPxI56Vw==
X-Received: by 2002:adf:97cb:: with SMTP id t11mr2834592wrb.292.1603371741051;
        Thu, 22 Oct 2020 06:02:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l1sm4022890wrb.1.2020.10.22.06.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 06:02:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
Date:   Thu, 22 Oct 2020 15:02:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/20 03:34, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
> 
> This ioctl returns x86 cpuid features which are supported by both the 
> hardware and kvm in its default configuration.
> 
> A well-behaved userspace should not set the bit if it is not supported.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

It's common for userspace to copy all supported CPUID bits to
KVM_SET_CPUID2, I don't think this is the right behavior for
KVM_HINTS_REALTIME.

(But maybe this was discussed already; if so, please point me to the
previous discussion).

Paolo

