Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F105748C0
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiGNJ0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237604AbiGNJZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB9B5BDE
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAfRoyLsPfv15JpoNJzCUez3RnyFpKTG8pry8dsjYgY=;
        b=fN3n15NIM/uEJc3f1Ic07kE1nRlUICAbn6Boe4o6FOlm/7Ogi46ab35bF0LUu0Yq+V/crL
        5H9GBuahADgt/WJLj/1j8Q71MasSCcQD6m2qQ8lCpumP1u2UTyXjR3TULsa4qjbaOeBm6E
        YDASVxjta1Mx5licVpO/XKSteuI9K0A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-5OORkWKbMbu9A52Z7fxdQA-1; Thu, 14 Jul 2022 05:24:23 -0400
X-MC-Unique: 5OORkWKbMbu9A52Z7fxdQA-1
Received: by mail-wm1-f70.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so510408wmb.1
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AAfRoyLsPfv15JpoNJzCUez3RnyFpKTG8pry8dsjYgY=;
        b=iwjLVbwh5BS97hlc0nSHKHOoUgZM7ZpxnBgiUfY4pLOzEIGgOPZJvGjl5gIcH7Qssh
         LZ9Xo1l906IXfHRODZ/dl3zoyPkeNB0l96FNFiLMMKBEDxxRFLQhgvvk3AP0FU7OA+Mj
         ApBWaz7S4S2pFf66G9oiDfd1HrKiKeVSGzzYSqVghqn/qiH0O5m7c8M9pYFAFUIiDpHv
         FZGGPwquWT68y3zLWVOTi+LXyBO8upLUt4JBDGm1igNXAKAwwL2s3cwCeJn8msk2G3Iq
         mMd3s57EPrxg4J0Y3WQU6TXw38TveAVF1IYPQhc3I4Xd0iPN2m2HKxxcNxSLv9swZREm
         rfIQ==
X-Gm-Message-State: AJIora9OcbkizG7TT68KImCd0kgZ3HYJGOA5uzLlG+lJkHclsiDZCQiH
        K96uHKFTHweymM/oaYngpglGS6QrXfGSKLvhfq3Xl2q6wmYlSYSHCQ8RILpofZVxvgbU0oNKZne
        36o2Kqe48GVyK
X-Received: by 2002:a05:600c:1f16:b0:3a1:9cd3:856f with SMTP id bd22-20020a05600c1f1600b003a19cd3856fmr7774689wmb.55.1657790662264;
        Thu, 14 Jul 2022 02:24:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tZitMXzBSYaX1KnlvXZvZRjClLz1V3XvaqomxfS7Lm++YzJhsy0XaLdXT7Zua/NXXMP4lRlQ==
X-Received: by 2002:a05:600c:1f16:b0:3a1:9cd3:856f with SMTP id bd22-20020a05600c1f1600b003a19cd3856fmr7774673wmb.55.1657790662058;
        Thu, 14 Jul 2022 02:24:22 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id e9-20020a05600c4e4900b0039c811077d3sm1298363wmq.22.2022.07.14.02.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:24:21 -0700 (PDT)
Message-ID: <00c0442718a4f07c2f0ad9524cc5b13e59693c68.camel@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: Hyper-V invariant TSC control feature
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:24:19 +0300
In-Reply-To: <20220713150532.1012466-1-vkuznets@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-13 at 17:05 +0200, Vitaly Kuznetsov wrote:
> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the 
> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.

If I understood the feature correctly from the code, it allows the HyperV, or in this
case KVM acting as HyperV, to avoid unconditionally exposing the invltsc bit
in CPUID, but rather let the guest know that it can opt-in into this,
by giving the guest another CPUID bit to indicate this ability
and a MSR which the guest uses to opt-in.

Are there known use cases of this, are there guests which won't opt-in?

> 
> Note: strictly speaking, KVM doesn't have to have the feature as exposing
> raw invariant TSC bit (CPUID.80000007H:EDX[8]) also seems to work for
> modern Windows versions. The feature is, however, tiny and straitforward
> and gives additional flexibility so why not.

This means that KVM can also just unconditionally expose the invtsc bit
to the guest, and the guest still uses it.


Nitpick: It might be worth it to document it a bit better somewhere,
as I tried to do in this mail.


Best regards,
	Maxim Levitsky

> 
> Vitaly Kuznetsov (3):
>   KVM: x86: Hyper-V invariant TSC control
>   KVM: selftests: Fix wrmsr_safe()
>   KVM: selftests: Test Hyper-V invariant TSC control
> 
>  arch/x86/include/asm/kvm_host.h               |  1 +
>  arch/x86/kvm/cpuid.c                          |  7 ++
>  arch/x86/kvm/hyperv.c                         | 19 +++++
>  arch/x86/kvm/hyperv.h                         | 15 ++++
>  arch/x86/kvm/x86.c                            |  4 +-
>  .../selftests/kvm/include/x86_64/processor.h  |  2 +-
>  .../selftests/kvm/x86_64/hyperv_features.c    | 73 ++++++++++++++++++-
>  7 files changed, 115 insertions(+), 6 deletions(-)
> 


