Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6C121BA94
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgGJQPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgGJQPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:15:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A9DC08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:15:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so6560053iow.8
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jy29C0jNBJlzPOntslbWG5zVMkbK/yCb3aOwp+ZNwYQ=;
        b=VMGo3Bn8jtrCU+jVB8BPfXtWepk5wI4UguXdxtGp2vCwmkxmxlCWOLXYgkD4/HeoGp
         hx8nINnh2BamY0kE6CXrytvTzUpOfx4QD4f7FMQDXJKJKhieUAuCghzenALmHYBx7SvV
         zEAY9CIpiNItp9oosFkXO5UGq6T9p0aywHfzHIT2oN+mSij6BlkQ4dPop6stX+sgY5ZQ
         JQxB/9wkf/pes7TBL18mq4uepSSntWvSuS7KcjLSJ7BHGVLkCUYVaPT4Ir0Oe/+AZlYK
         quhIm+JVra13JhtSc5g8MHQDxebmlfi/Ft9rm+PGclPYBbbss7UQoEypVCPhLRqQpFx1
         QoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jy29C0jNBJlzPOntslbWG5zVMkbK/yCb3aOwp+ZNwYQ=;
        b=qaZ1RqnwZhihTnz/hGpw7kx9fM6air3AtxtTFrd+4g1Rvmux00dByS6cXA3wT74Yx1
         wHQCTgZWbzzm6MIJaWanWj2gg5LWlzI9TuJdyWQEOhSsZ/XkPSAltGrqkSfYJS8xTcsF
         Ozk9uNoBKpPDBW4y0aVXt3ymhUkmKYxDkW+1vrP+cVb/9g3vFWpg5JtoXeFf5alIbhsf
         JodNJeyXfmExlu1D4NCnEYtIWoqnFf9ny/0Ny7IHDoKiIB3e7vVXQOQ/rJGwU4UDHmw3
         Gz7804V51trNhjhZTh7dx0j7TtwNCyjb7Pu5bS9Gc42YlWjjn2ZzDMUXRlLEW9xGFso4
         33FA==
X-Gm-Message-State: AOAM531AybB74NlXQrWK85hGSuJEAG59FUEqW24/S+q6Vi5CzTGXJSb3
        1DICmt6AdO/sYJRi2c0PcYq44p1GgsUb2QQvRn5G6A==
X-Google-Smtp-Source: ABdhPJxQKn3C8Viy7cFZE/IciSW+3FlyvnpS95Jsc7xj299u1lHgLuAwhOWErmRh70KTECwiY6wtsPiTkjoRQuOMLDA=
X-Received: by 2002:a05:6602:2e0e:: with SMTP id o14mr47771057iow.164.1594397713805;
 Fri, 10 Jul 2020 09:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-5-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-5-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Jul 2020 09:15:02 -0700
Message-ID: <CALMp9eS7MmS7G0YfXA7Wxwwxbx67LVWZ57z_ZCbpJv4euiNnAw@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] KVM: x86: rename update_bp_intercept to update_exception_bitmap
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 8:48 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> From: Paolo Bonzini <pbonzini@redhat.com>
>
> We would like to introduce a callback to update the #PF intercept
> when CPUID changes.  Just reuse update_bp_intercept since VMX is
> already using update_exception_bitmap instead of a bespoke function.
>
> While at it, remove an unnecessary assignment in the SVM version,
> which is already done in the caller (kvm_arch_vcpu_ioctl_set_guest_debug)
> and has nothing to do with the exception bitmap.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
