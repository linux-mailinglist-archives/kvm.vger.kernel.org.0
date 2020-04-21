Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10761B23EE
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 12:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgDUKfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 06:35:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726120AbgDUKfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 06:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587465330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/e5pBhqFJlU00SruznDexk/JW9if8ucTLShJyENQLDs=;
        b=V8dvW1uWV/uKPA4Xsnlu+rzITQeA60phd/22DlbW9lWVbO1n9W1UB3Yti6s69DpjzIGO5P
        rqhHMe5ltxNMAPyNI5aeEJ07FZ+2YqlTHkl6EKnnpBxzGlldDAdLBpdsZMhrzPPJm7Dp55
        9Qf7A/rkLGUA1McSK0HiMVcubC0pDBo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-J9e3ds7aNXuFPhKBdspD6Q-1; Tue, 21 Apr 2020 06:35:23 -0400
X-MC-Unique: J9e3ds7aNXuFPhKBdspD6Q-1
Received: by mail-wm1-f70.google.com with SMTP id v185so1226100wmg.0
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 03:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/e5pBhqFJlU00SruznDexk/JW9if8ucTLShJyENQLDs=;
        b=NeuST6RJAk1vVgyIUUboQ7RBnn2Tzyghog0eT0CQ/h4Sh+QVGZ15yky8hJ2rEVv53F
         34Cq/eBXVHnTsRv9LHS2+yEivPQcMmr6PxmaUG0pfkLUU5nDEMH3RyezlOce/IVk0m5E
         nmbgDSP1Bjr7vtt0xOJ2u0lDcSfWM/sKQu0IpheMQ7kpYGhOn7ZjKijdMkH2G/G88rKn
         ewIVoBBkgV9vA+JlkUNHC0AVdDfpHCPhMoRpo79gocfoXV61LaYbo1UIFNcb6hytf0gy
         DCCQNW8u2YGulpHbkp8IS4b+9oKKFr4yavQAmswvZgdJs3nJFbHpZhfRyk24XtRuKRMY
         8U/Q==
X-Gm-Message-State: AGi0PuY1zTawwzK+cQu7NLVgNfaCsSpTC5haKiRnvkZ2egZNW4OXMn5q
        IyPOafVZmsQj/zyJYEytlGnN83pKmfpQ5FgvdJVX/hUGOoQLeZ2611+/lzXnX+Ta4xK4MmueM8f
        NvHAlLOa4x4GK
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr25349621wrn.390.1587465322371;
        Tue, 21 Apr 2020 03:35:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypIg6w99FQxHmMK6N/nZsEzY4lD4SZnvYWsvTPmU/3cmWx5kpx8qBxytM9t6wOI6pkhY/1yzAA==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr25349596wrn.390.1587465321999;
        Tue, 21 Apr 2020 03:35:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id q8sm2866723wmg.22.2020.04.21.03.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 03:35:21 -0700 (PDT)
Subject: Re: [PATCH v2] docs/virt/kvm: Document running nested guests
To:     Kashyap Chamarthy <kchamart@redhat.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, dgilbert@redhat.com, vkuznets@redhat.com
References: <20200420111755.2926-1-kchamart@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c35b6a07-0e5c-fef7-2a39-b0f498eea36c@redhat.com>
Date:   Tue, 21 Apr 2020 12:35:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420111755.2926-1-kchamart@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mostly looks good except for kernel parameters:

On 20/04/20 13:17, Kashyap Chamarthy wrote:
> +Enabling "nested" (x86)
> +-----------------------
> +
> +From Linux kernel v4.19 onwards, the ``nested`` KVM parameter is enabled
> +by default for Intel x86, but *not* for AMD.  (Though your Linux
> +distribution might override this default.)

It is enabled for AMD as well.

> 
> +
> +If your hardware is sufficiently advanced (Intel Haswell processor or
> +above which has newer hardware virt extensions), you might want to
> +enable additional features: "Shadow VMCS (Virtual Machine Control
> +Structure)", APIC Virtualization on your bare metal host (L0).
> +Parameters for Intel hosts::
> +
> +    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
> +    Y
> +
> +    $ cat /sys/module/kvm_intel/parameters/enable_apicv
> +    N
> +
> +    $ cat /sys/module/kvm_intel/parameters/ept
> +    Y


These are enabled by default if you have them, on all kernel versions.
So you may instead tell people to check them (especially
enable_shadow_vmcs and ept) if their L2 guests run slower.

> 
> +Starting a nested guest (x86)
> +-----------------------------
> +
> +Once your bare metal host (L0) is configured for nesting, you should be
> +able to start an L1 guest with::
> +
> +    $ qemu-kvm -cpu host [...]
> +
> +The above will pass through the host CPU's capabilities as-is to the
> +gues); or for better live migration compatibility, use a named CPU
> +model supported by QEMU. e.g.::
> +
> +    $ qemu-kvm -cpu Haswell-noTSX-IBRS,vmx=on
> +
> +then the guest hypervisor will subsequently be capable of running a
> +nested guest with accelerated KVM.
> +

The latter is only on QEMU 4.2 and newer.  Also, you should group by
architecture and use third-level headings within an architecture.

Paolo

