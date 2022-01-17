Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9BA491129
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 21:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243119AbiAQU6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 15:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiAQU6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 15:58:05 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22623C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 12:58:05 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id t4-20020a05683022e400b00591aaf48277so21458818otc.13
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 12:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KF7UfJyg273nq+7UPuXBXJZx5tYDxZRdcCSC95qVL0Y=;
        b=Me/jkXhjfEinzPrTuJrRemZtW2y0GidUhmBwl+k2nHW5gnM/5jrM1FHmFW0IwdnqXg
         ubCgP2ClHaIOv8ddkn3IiSwE2qDCnvkmfZnC66RchZJGdQKNi1g8QsJ4r/3hsewt3R3X
         kUjnsAzkZ4fcKBCVnhNh3qBT8UjtbVjgx7EEAXAuK95zkddyYDyOYobPBLAj+dLJnP26
         P+BssiTu0IN/l2CXypSLZpfo0KiynS+13JXRCDioJ5HPDyrDtkZAgYFooaVatkJnUxyr
         uaNwAYegUujiMgyYpFaS1oB34SUsbDvVMmPbfkhEGJwQVjiBGp5LaRq69ug2bSRlqbm/
         n50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KF7UfJyg273nq+7UPuXBXJZx5tYDxZRdcCSC95qVL0Y=;
        b=YZoNEUoSLO85UuzyKQRdFjGrWoxAF8MW7V3dxETwtF/H0Vq8owNkfXIUDtr7p+78b9
         etbgo3xhwvfYUeTtrHxobmy2NXfbtDcsLVw3yN2ukbz6/SaIYeZ6j59s67eUf2i0Bhds
         Q85PANtNX+8Y13xtslkZgmIskV9tPt6KZKCsn10wBPyDDRD1PxCH97UVKzYLhEKmKqsH
         5gQCxSPBauL5Fwv6oJilkaxSW33jH1FPXZxnTGQj3gfhKCsOnNyewO3CCHVZ7+eIbodg
         N1rn18LWLWHz2so2wJ/pItLv/TbybJsXxcQOFWrH1NunUfINdglCY47QRDOCJQEbslES
         brjQ==
X-Gm-Message-State: AOAM530vGPFuuV+7mcGzFZfaSzCSDwAyH5HGBxj7GdPEwAUCtFkgEdpM
        c8fWvh5SerxePkxdDgJ9B7wrrQDwnaZ3m2v9F6lNmQ==
X-Google-Smtp-Source: ABdhPJx7KSIOGMBto4HP5L7hv2jxsoQwkdcb8n4cTd2YDgj3wvrnJ1wx3y7Eg7f5Xky9jvLaf2R/CK7hRa3swTQ83G0=
X-Received: by 2002:a05:6830:441f:: with SMTP id q31mr18449252otv.14.1642453084021;
 Mon, 17 Jan 2022 12:58:04 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
In-Reply-To: <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 17 Jan 2022 12:57:53 -0800
Message-ID: <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
Subject: Re: PMU virtualization and AMD erratum 1292
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 16, 2022 at 8:26 PM Like Xu <like.xu.linux@gmail.com> wrote:
...
> It's easy for KVM to clear the reserved bit PERF_CTL2[43]
> for only (AMD Family 19h Models 00h-0Fh) guests.

KVM is currently *way* too aggressive about synthesizing #GP for
"reserved" bits on AMD hardware. Note that "reserved" generally has a
much weaker definition in AMD documentation than in Intel
documentation. When Intel says that an MSR bit is "reserved," it means
that an attempt to set the bit will raise #GP. When AMD says that an
MSR bit is "reserved," it does not necessarily mean the same thing.
(Usually, AMD will write MBZ to indicate that the bit must be zero.)

On my Zen3 CPU, I can write 0xffffffffffffffff to MSR 0xc0010204,
without getting a #GP. Hence, KVM should not synthesize a #GP for any
writes to this MSR.

Note that the value I get back from rdmsr is 0x30fffdfffff, so there
appears to be no storage behind bit 43. If KVM allows this bit to be
set, it should ensure that reads of this bit always return 0, as they
do on hardware.
