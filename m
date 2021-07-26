Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726E53D5A81
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhGZNAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:00:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234161AbhGZNAp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 09:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627306873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwb+gJ5kZupdhuNB/HcDQBwyIfUYDI68vwzalsg6VHw=;
        b=U4X4iDQOSh2zIFRsXKCqbVwmVGSiZxCzDTGoSrqkEa4Y0PysciG6fWM8tdjuxhmzPL0W4/
        3b6TsFbgwaW2UcE/RI54Y3A88HodkoSjXNklDt3UD2dFPtfU7aOc0sPr2iQOMqmIub6nvH
        j2v/Q6d31mtZP0/IpkGA8xENz5CZCxI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-mi8YT51_N0msMnZh4tfRdw-1; Mon, 26 Jul 2021 09:41:12 -0400
X-MC-Unique: mi8YT51_N0msMnZh4tfRdw-1
Received: by mail-ej1-f71.google.com with SMTP id g21-20020a1709061e15b029052292d7c3b4so2090097ejj.9
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 06:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iwb+gJ5kZupdhuNB/HcDQBwyIfUYDI68vwzalsg6VHw=;
        b=qESX/uEwyxx4Y0jIDy/2LKElrfxQTRWq4JA1qCVVe1GYdnTTYDs4DQE3dS+BojQvyE
         /UeKDmflf1qpGM/3IKkE94ScwNSdA3gAobhsKJ2mo8CNaXmZ3BxA09dahrg1rOC5hqnD
         XhXqA2qxj7TJLw3AbOkoQ3pf3696kY+rJ0ZtG1y23Ad+xo7V5ijBEqY1UCmZfreuYs7Y
         FkR5snhQ4eoLFFCRpOj+twQ1KQ+mwDdmFfkWyud12MBnsBST7Yw0/yok6D0QYWdGHpD4
         0zCZDjZaoyczjyjU79T4D55o0bNfFXc+lGSaOgkfAnnaFPpLbqZ6nbC2P0RsPVBP6a7E
         fVPA==
X-Gm-Message-State: AOAM530dsmy4Jxwo2GPL5YEKIkGv4/DInMcB9lI2VbnKYPImN7I0ofn0
        Txg/r70W9vhJerA8opDfISi3ZJNlg71RxRRh9ETYyD5I1iyIZg5a5mxjhMb6SYZn9E2kJTNBSXT
        HwDhxfGOdwAHC
X-Received: by 2002:a17:907:62a7:: with SMTP id nd39mr17088023ejc.502.1627306871203;
        Mon, 26 Jul 2021 06:41:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT0bYvy/TK8+n6Y6c+hBewPc87dvCIB4DeEysL1icefAhm31DZ7CDgxzd8DglLWWJepno96g==
X-Received: by 2002:a17:907:62a7:: with SMTP id nd39mr17088011ejc.502.1627306871006;
        Mon, 26 Jul 2021 06:41:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c15sm12639677edu.78.2021.07.26.06.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:41:10 -0700 (PDT)
Subject: Re: [PATCH 0/6] x86/kvm: add boot parameters for max vcpu configs
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20210701154105.23215-1-jgross@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b05371ad-05e3-9d99-702e-d8296be492f0@redhat.com>
Date:   Mon, 26 Jul 2021 15:41:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/21 17:40, Juergen Gross wrote:
> In order to be able to have a single kernel for supporting even huge
> numbers of vcpus per guest some arrays should be sized dynamically.
> 
> The easiest way to do that is to add boot parameters for the maximum
> number of vcpus and the highest supported vcpu-id overwriting the
> normal default.
> 
> This patch series is doing that for x86. The same scheme can be easily
> adapted to other architectures, but I don't want to do that in the
> first iteration.
> 
> In the long term I'd suggest to have a per-guest setting of the two
> parameters allowing to spare some memory for smaller guests. OTOH this
> would require new ioctl()s and respective qemu modifications, so I let
> those away for now.
> 
> I've tested the series not to break normal guest operation and the new
> parameters to be effective on x86. For Arm64 I did a compile test only.
> 
> Juergen Gross (6):
>    x86/kvm: fix vcpu-id indexed array sizes
>    x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
>    x86/kvm: add boot parameter for maximum vcpu-id
>    x86/kvm: introduce per cpu vcpu masks
>    kvm: allocate vcpu pointer array separately
>    x86/kvm: add boot parameter for setting max number of vcpus per guest
> 
>   .../admin-guide/kernel-parameters.txt         | 18 +++++++
>   arch/arm64/kvm/arm.c                          | 28 +++++++++--
>   arch/x86/include/asm/kvm_host.h               | 22 ++++++---
>   arch/x86/kvm/hyperv.c                         | 25 +++++++---
>   arch/x86/kvm/ioapic.c                         | 14 +++++-
>   arch/x86/kvm/ioapic.h                         |  8 +--
>   arch/x86/kvm/irq_comm.c                       |  9 +++-
>   arch/x86/kvm/x86.c                            | 49 ++++++++++++++++++-
>   include/linux/kvm_host.h                      | 17 ++++++-
>   9 files changed, 160 insertions(+), 30 deletions(-)
> 

Queued patches 1-2, thanks (1 for stable too).

Paolo

