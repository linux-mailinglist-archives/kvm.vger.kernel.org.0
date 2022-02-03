Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8874A7C3E
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348271AbiBCAEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348277AbiBCAE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:04:27 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E881DC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:04:26 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id q186so1435741oih.8
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s0MQi3bpow1zyJ4zQWYbYlBk70M4EVdFwB8Xuxg5W+E=;
        b=eF2Loap49G0SBNV+JcSbp0vpFefM7+IqRii6/cXOYPlqVhA90khj/k5qEcBCMu2nYN
         l2QRlKY2LtyOLBrbggm3xZ2PGWBjVvK8nxCid2bk+iWqI8jkRX6pjVDonJOjJqZ35A2T
         Fpy0ghghfQjoAEEjpN2Sr1mKqqzDrf3i6gC1mNCjVtcfAC6gFoFIZw6AiRg/sUJPHa3i
         2+H/SEL1ytf1nRVHI79dtJvT+xCeWTX6Y1+IYeNuZK4FQBjYdZ0qgT8P1wezDP3iXCoD
         AR6j2YcJFdAdyOESNiNnX6Zw93GHev613QI90DEwHum3qqIa7og6ZSdLM20vy4wEG5Hm
         uHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s0MQi3bpow1zyJ4zQWYbYlBk70M4EVdFwB8Xuxg5W+E=;
        b=IRgevCip7IBSrUcSPodWRAOAxcE+b6FpNAS+Mz1akG8G+RQNW560hn/HlenwGg6j1X
         HW8S/KZLGkI5S3w4IbNFLeS7ISd5jqa8ARAkI48QA7807j9mmqNAWqjf1iXGIlBCtEXv
         0HIWvWICypIlC539xxKB49E9AHjmydqP512nhAJOKbbbskmOX1VH3wvKwEX/1b4TT4cP
         uhKmebP7IpIDcrQFxlDdP32c/iojY8hQUoNlrZPBvr4XIqFK+bnIOgnCDedyx/k0vSVk
         yx9P4vr3DClVsl4G+56V21AC8gSg0rRWWlBYqH7BIhjezm9IwO5Zpc7MTvoZzTZp1zhg
         MRFg==
X-Gm-Message-State: AOAM531tmxr43Ov5WJbxw2BJqe18H/TawXmRlhVEUVp/F7Ar2tj/cHru
        R11fSog2dGBkZBzk+4r2b03ZbC3tHjX5oZ3lOd5qVw==
X-Google-Smtp-Source: ABdhPJzC/GU6T83A1TLbeWX6/i4FcK7pCOXIES/lHfWZOAhUAzNxqx1uKn60wzrgT/RsX/tpDPdU1iUrMyYgQca8KhQ=
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr6616062oib.339.1643846665849;
 Wed, 02 Feb 2022 16:04:25 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com>
In-Reply-To: <20220202230433.2468479-1-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Feb 2022 16:04:14 -0800
Message-ID: <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
>
> Ultimately, it is the responsibility of userspace to configure an
> appropriate MSR value for the CPUID it provides its guest. However,
> there are a few bits in VMX capability MSRs where KVM intervenes. The
> "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> are updated every time userspace sets the guest's CPUID. In so doing,
> there is an imposed ordering between ioctls, that userspace must set MSR
> values *after* setting the guest's CPUID.

 Do you mean *before*?
