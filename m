Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC5294F4B
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 16:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443800AbgJUO5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 10:57:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2442007AbgJUO5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 10:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603292234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oX62o2mMq6ThW10U7zRzLFt7DVdzbnn+m+BE1+ZSDAU=;
        b=da/QQcAGVcl2+89v97Ar4Wi/bnwfyClV3osUN3Eh1PzcFZs9vzsQKcwPK41SdkscDtTTNh
        4L0FlALZ2adsWl08oaB7MoYZcB5aB76PJxQBTt/bW6IhUh2gH56e5s5f5WZApIwjAa/GHk
        WxZXY8OUafH7QFDuhs+m9Qq2sWjYZbM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-QOZjkxCjOp2quOIIvxufEQ-1; Wed, 21 Oct 2020 10:57:10 -0400
X-MC-Unique: QOZjkxCjOp2quOIIvxufEQ-1
Received: by mail-wr1-f71.google.com with SMTP id t17so2831129wrm.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 07:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oX62o2mMq6ThW10U7zRzLFt7DVdzbnn+m+BE1+ZSDAU=;
        b=g56dij6Z1tlLBhIzl3sYiqo1QlXmN6miYOn8cnI2WtU6aoIRn4F5+DP6VSbURPXyul
         jsBxsltOppdIBXHgFKuPcJS8Otuc0WjpgO2yOVHW2Rwup+MIAzFnnqhRiGj/dIyGGCRb
         aTfGnWYeIQ+0SKvjvVeYpgduuPFcZFcEw3KdOsPwuT59k3r1kkExoTnlae4emudgz0Sk
         5kXXP0zrEnIL2RIdLVC4QmWeqEeKO73jVu0Nl5SJOgxI19PqaXKLYXv0mjWwg5iPxmr7
         2T6HUBWhSYXIgNgOVAOwLXK55twqjdantBn0NDVlb0ZXkIwHmHCRD5+PYf9uaviwDmc9
         otJA==
X-Gm-Message-State: AOAM5316Vy4NO3l90R4SZpbmXBV9nHhpFFNPnZ0eTnDmCL+wFNDQnfTv
        sz8YMMeX1mHT2VL+jYXJ/JQlIhreTDXn63wFJAswXSjoOHOVmMeg/RWhfuUvm4B/CRoPEHbHwSq
        nqiYvNG1nc5ef
X-Received: by 2002:adf:f289:: with SMTP id k9mr5544631wro.0.1603292229413;
        Wed, 21 Oct 2020 07:57:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+/o3/Z0mXdoBm/K7QJ01h/g/QC0bYf8ik3JXDVn5K6PFW7zTCRXPkfzGItxTIY+5phv92Ew==
X-Received: by 2002:adf:f289:: with SMTP id k9mr5544618wro.0.1603292229263;
        Wed, 21 Oct 2020 07:57:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x10sm4395846wrp.62.2020.10.21.07.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 07:57:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>
Subject: Re: CPUID.40000001H:EDX.KVM_HINTS_REALTIME[bit 0]
In-Reply-To: <CANRm+Cy4Ho7KF0Ay99mY+VuZPo8dkkh7kKRqjgY_QzPcVy5MCw@mail.gmail.com>
References: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com> <CANRm+Cy4Ho7KF0Ay99mY+VuZPo8dkkh7kKRqjgY_QzPcVy5MCw@mail.gmail.com>
Date:   Wed, 21 Oct 2020 16:57:07 +0200
Message-ID: <87blgv4ofw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Wed, 21 Oct 2020 at 14:47, Jim Mattson <jmattson@google.com> wrote:
>>
>> Per the KVM_GET_SUPPORTED_CPUID ioctl, the KVM_HINTS_REALTIME CPUID
>> bit is never supported.
>>
>> Is this just an oversight?
>
> It is a performance hint, not a PV feature and doesn't depend on KVM.
>

True, but personally I'd prefer it to be reported in
KVM_GET_SUPPORTED_CPUID too, that would mean that userspace is in its
right to set it, just like any other PV 'thingy', even if just for
consistency.

-- 
Vitaly

