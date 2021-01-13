Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D5E2F5451
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 21:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbhAMUuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 15:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbhAMUun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 15:50:43 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3374C061575
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 12:50:03 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i5so2272579pgo.1
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 12:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yrtd6TLEvu+g1E4rNp60CS8fDKJGNUH8hQppm9rl21Y=;
        b=wBB4c+w3wWJPP0bX5blGyGBLoz6cI0r9TY/iEBBHgWaWEhKcrLSOUqlxU5MFf3m7M9
         fL+O2RhJddC2LUs9HfTx9b3edlj9p1zTjDQgFYkjMsAUOz7ZmN24ETMhsTqlFa+1pjqI
         6sQ291SpCOdiJQ/QfUVYYrthVUEqnoQTZZETmNwJpe+EAAFN1zdaMizmxag7CCyjG2r8
         JVxIbd8AHDjB5RGBtSLY8uLWAfpxgFWT1SDlpSJvt4hnVWjq3UqFfnVZOYA6qUCn89oF
         fgPlVH9JmOrz68c2yZfTevuZDFQXfGPwlm1tsie5q0QJeVLt0rRLNBDFHylsp5XNYtzb
         /UjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yrtd6TLEvu+g1E4rNp60CS8fDKJGNUH8hQppm9rl21Y=;
        b=TOHcDok3SjdcGRoUWqvGno5oHs6zejZRULcIVUWXmvrd7BcvOSk/vwvancdD5JWICF
         cZZ8v0bPx4azkRMKgJfBoL97UmzC18dwZAMG3s3YJXWOGmlBuNjDCyK/Zs4e0NCqtZ8p
         V4mt4w5znFEEbUOf56nlBYEWhFqFdV8wK9tiMRkpYyRH0IdVXgooPEz8Flay44ekSukN
         7b1gLz0dVFAxh6FvpS3j3Esuw/g/ryTYvpV3wgbHbXFxgch7T8I2DuINnlYdU/LollFp
         0VRGA9AO1Y+6gpugcWGlyN8TzLq9enlupUeiCdEBdk9Ujq8yg4JBtQVVrjrfZYc0eREP
         hRtQ==
X-Gm-Message-State: AOAM530zTojXyiyqIOmxUhzbYuD4Jx/NARF7mYqtwmhvTkblbXhMuSrC
        EIpaERLa1tJpTLxNLOtKo0eIhw==
X-Google-Smtp-Source: ABdhPJxtPukIQ5OL8oGLq9C1Ydc/Psn3l3J+oxoxt8NGRNJE7dwjJvqZO2BDW3mcinRO7tGnA6HYgw==
X-Received: by 2002:a63:d18:: with SMTP id c24mr3777539pgl.442.1610571003057;
        Wed, 13 Jan 2021 12:50:03 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z2sm3244698pgl.49.2021.01.13.12.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 12:50:02 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:49:56 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 6/7] KVM: x86: hyper-v: Make Hyper-V emulation enablement
 conditional
Message-ID: <X/9c9PuAd4XJM4IR@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-7-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113143721.328594-7-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
> Hyper-V emulation is enabled in KVM unconditionally. This is bad at least
> from security standpoint as it is an extra attack surface. Ideally, there
> should be a per-VM capability explicitly enabled by VMM but currently it

Would adding a module param buy us anything (other than complexity)?

> is not the case and we can't mandate one without breaking backwards
> compatibility. We can, however, check guest visible CPUIDs and only enable
> Hyper-V emulation when "Hv#1" interface was exposed in
> HYPERV_CPUID_INTERFACE.
