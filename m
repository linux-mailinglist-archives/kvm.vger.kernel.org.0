Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA91D76AD
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgERLSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 07:18:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgERLS3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 07:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589800707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxiBECMHFAplzz2KB29O/LRSLdFzNsUzEToTKNWFHYs=;
        b=eUW46T93VkiC7R+amKrbtMahqRVngVEEy7NCjcLTwIaFF6hl3o/muVUkrQWm/PWGAE5Rat
        0rntisd6pV10bmYbtUTI2DhJn4M/OGlTg6C7UPFbgOS10N6zHoYxoD4A/UKmaRV0BhJB3E
        IdXMtTdeV/w0239qat405Y+OIXuFA3k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-iO_Xm_14Pb2qaWQebK4sVA-1; Mon, 18 May 2020 07:18:26 -0400
X-MC-Unique: iO_Xm_14Pb2qaWQebK4sVA-1
Received: by mail-wm1-f72.google.com with SMTP id u11so2948143wmc.7
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 04:18:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dxiBECMHFAplzz2KB29O/LRSLdFzNsUzEToTKNWFHYs=;
        b=Xx4D3JB+wcljjmwzBdBDi6yxTb/1+boKtnRZZHz6M8Qld5V1QhdcKz7d3rENGIKWlO
         WDiCM6lv6pBWjIw3XBe6urdvPktJK/2hJnv8Dnc2gTRO070X/lqTVIH4KSHst6QFs/f0
         cRRT4EcKrsi+UxkSiFb0wd6K1ghGCMx6MwRMLQrDDkuV46DKPw+7+AOo1bzbrGcvad6z
         jaKPHGqjrPogd6eSSgJL2M9YyRSvIiRDakPJpBcaax+awqKumu7CA4aow41NIeWdw4p/
         CusiSSjDvBtdBGGy7dUO1GMofAxKcWhzgPkYxp8XxZjAmCoUzwC/tKeB7Ls6mUxo/uQ/
         sGng==
X-Gm-Message-State: AOAM533qQNoPCz8Xpp3qOvtS4Vme/hokuTKkWhBaDdbwV0wRH3bsdYus
        4BImYgJUFCglOtm9fPnZz4SOZ9uZ1iPATyP4Qabb+UbY38hSpSU9Lqab5QUlsRmUVLsE9CSHM4U
        KqoD9JrfA9f+s
X-Received: by 2002:adf:f786:: with SMTP id q6mr19058393wrp.120.1589800705061;
        Mon, 18 May 2020 04:18:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNLwMrbe3B5c0qaCQ/YjHTYYnwcj/Jnv2tH5S7lfJMD5adLyh8g16sr+0JKvnyuDSUcvQdGA==
X-Received: by 2002:adf:f786:: with SMTP id q6mr19058368wrp.120.1589800704864;
        Mon, 18 May 2020 04:18:24 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id r2sm16417514wrg.84.2020.05.18.04.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 04:18:24 -0700 (PDT)
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
To:     Anastassios Nanos <ananos@nubificus.co.uk>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
Date:   Mon, 18 May 2020 13:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 10:45, Anastassios Nanos wrote:
> Being in the kernel saves us from doing unneccessary mode switches.
> Of course there are optimizations for handling I/O on QEMU/KVM VMs
> (virtio/vhost), but essentially what happens is removing mode-switches (and
> exits) for I/O operations -- is there a good reason not to address that
> directly? a guest running in the kernel exits because of an I/O request,
> which gets processed and forwarded directly to the relevant subsystem *in*
> the kernel (net/block etc.).

In high-performance configurations, most of the time virtio devices are
processed in another thread that polls on the virtio rings.  In this
setup, the rings are configured to not cause a vmexit at all; this has
much smaller latency than even a lightweight (kernel-only) vmexit,
basically corresponding to writing an L1 cache line back to L2.

Paolo

