Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D03DAA7A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhG2Rpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:45:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhG2Rpe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 13:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627580731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rT316eGUa2+7b7jjZkTlKN4mfhqRrOL4B5+LcpVHIKo=;
        b=aW6A940p92WMQyoWCwqZksEJL3ubYIpEpzMjDJaSUcBxVLL/cPYTPs+qkL271P5j6ymnwG
        jVU5K13p5dlMUy+sZSX5vQq78Hx7SiiSxf0b2yCoPTok09TyzGJUebD0PdEG470vkoYvrU
        70DVApQVFbTHHo93//AyF+fJepwku1c=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-wsQdb_W5OSCfvxr1C_vHuQ-1; Thu, 29 Jul 2021 13:45:29 -0400
X-MC-Unique: wsQdb_W5OSCfvxr1C_vHuQ-1
Received: by mail-il1-f198.google.com with SMTP id h27-20020a056e021d9bb02902021736bb95so3636335ila.5
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rT316eGUa2+7b7jjZkTlKN4mfhqRrOL4B5+LcpVHIKo=;
        b=MFo25R8tj+jRaV1jFMZm/vZVK6dztbRwAOsud2mHzs3THgW1YoL2FdhJirHAySv6C3
         xaQhw0yctK5XXCb5aFuAfoseWODoiyUDJH+t4MYaNzmtxd+DbGEXrKoasPRdDZFNHDOy
         klVTuTnYA7JCoJdLKb90mvLyyPTLtHQqgNyZqYFHrBcsemY7u+WnI7kccO9+Cfp1I6ir
         FaBtWViiYuRsmbSHSr3yAWIycMXyJeidCOT5tu248FlnFvQ97vy6p+gRvwTpzIFf/ySf
         4Da+bEK4ujnBC2rjwzRsP09x0f4IPSsIYHrUHALbGWJ5zPfvECdfOScU1p4lwDoB+YNX
         MeOg==
X-Gm-Message-State: AOAM532l1LTqr1cLIGgYp/B23vQqxjY88xtRhB0MsPyBxJXDS48gN/i8
        z4Oa/TTwlymThcWqkpC2ao2isAvUBsmKM7I9PPu79UOq2Kes5g3PdLbUcBb4/qCPEbXlK9Rp1Nv
        Sve+t2wOW6q+B
X-Received: by 2002:a05:6638:3a12:: with SMTP id j18mr5555705jaj.75.1627580729307;
        Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf77LhlT9YvfAjMD/rhjDi5lGqSzYugzzvfmOLDdrWVhTSAaNJZlRA4FN/MoqzmCofE6vzAQ==
X-Received: by 2002:a05:6638:3a12:: with SMTP id j18mr5555679jaj.75.1627580729171;
        Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id j18sm2589446ioa.53.2021.07.29.10.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:45:28 -0700 (PDT)
Date:   Thu, 29 Jul 2021 19:45:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 13/13] selftests: KVM: Add counter emulation benchmark
Message-ID: <20210729174516.nje54y7c5iy5qyn4@gator>
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-14-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729173300.181775-14-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 05:33:00PM +0000, Oliver Upton wrote:
> Add a test case for counter emulation on arm64. A side effect of how KVM
> handles physical counter offsetting on non-ECV systems is that the
> virtual counter will always hit hardware and the physical could be
> emulated. Force emulation by writing a nonzero offset to the physical
> counter and compare the elapsed cycles to a direct read of the hardware
> register.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++++
>  3 files changed, 209 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

