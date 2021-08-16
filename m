Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF953ECE74
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 08:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhHPGKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 02:10:52 -0400
Received: from mail.kingsoft.com ([114.255.44.145]:34924 "EHLO
        mail.kingsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhHPGKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 02:10:50 -0400
X-AuditID: 0a580155-983ff7000002fcd1-2a-611a01488ceb
Received: from mail.kingsoft.com (bogon [10.88.1.79])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.kingsoft.com (SMG-2-NODE-85) with SMTP id 1C.C7.64721.8410A116; Mon, 16 Aug 2021 14:10:16 +0800 (HKT)
Received: from alex-virtual-machine (172.16.253.254) by KSBJMAIL4.kingsoft.cn
 (10.88.1.79) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Mon, 16 Aug
 2021 14:10:16 +0800
Date:   Mon, 16 Aug 2021 14:10:15 +0800
From:   Aili Yao <yaoaili@kingsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     <yaoaili126@gmail.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: KVM: x86: expose HINTS_REALTIME ablility to qemu
Message-ID: <20210816141015.31e329e3@alex-virtual-machine>
In-Reply-To: <20210813175420.62ab2ac2@alex-virtual-machine>
References: <20210813175420.62ab2ac2@alex-virtual-machine>
Organization: kingsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.253.254]
X-ClientProxiedBy: KSbjmail3.kingsoft.cn (10.88.1.78) To KSBJMAIL4.kingsoft.cn
 (10.88.1.79)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsXCFcHor+vBKJVo0P1P1eLzhn9sFtM2ilts
        nX6FzaJz9gZ2izlTCy0u75rDZnHpwAImi/3b/rFaHD1/i8li86apzBaTWi8zW+y684TF4seG
        x6wWz1qvsjjweTw5OI/J43trH4vHzll32T0WbCr12LSqk83j3blz7B7v911l82iceo3N4/Mm
        OY8TLV9YA7iiuGxSUnMyy1KL9O0SuDJeNW9iK9jMVvHg1DaWBsb/LF2MnBwSAiYS33+vZ+xi
        5OIQEpjMJHHxRg8LhPOaUWLp7sdsIFUsAqoSm+c1gdlsQPaue7NYQWwRgbNMEnv+M4M0MAu0
        M0o83rqFHSQhLGArseHPQWYQm1fASmLnjLNgDZwC1hKzly4FiwsBxedvuwB2Br+AmETvlf9M
        XYwcQCfZSzxerwjRKihxcuYTsBJmAR2JE6uOMUPY8hLb386BGqMocXjJL3aIb5QkjnTPYIOw
        YyWurb/OOIFReBaSUbOQjJqFZNQCRuZVjCzFuelGmxgh8Re6g3FG00e9Q4xMHIyHGCU4mJVE
        eIuFxRKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ82q7CSUKCaQnlqRmp6YWpBbBZJk4OKUamBSi
        VwnfFNqt0rC8V0v9dE9hUn1s6dNA98yJDY1MS/ft/a+wwleFlUHvXcCVvqiwNz27755mmBfl
        XTbx+ZrfqqduFE4rsHv173CZb5GsjZn6kdt7W19P+FXxzjjo8MG7lvfXaMydqX5i6wNJwZv1
        nBdaD3s438icZuWuXfmac86fJ2tP3J4yc5VfbCin6hulex0F3iIy01dMSF2a/oD//j/jKpmy
        hZKnOgT6ghWquj+zFPgs9flZLP5DwZ5zY+WFZy+v38jY5Vj84fyuvjsVid1RWz+W8s3L3lHu
        XVlf3LxZQ/qa6OyTKdw/JUwWqK/5OUtdsV2sf5XNbg8z9oS3Zw6xiMxb2ffYy3Grr7CXgxJL
        cUaioRZzUXEiAPrdudMuAwAA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 17:54:20 +0800
Aili Yao <yaoaili@kingsoft.com> wrote:

> When I do a test that try to enable hint-dedicated for one VM, but qemu
> says "warning: host doesn't support requested feature:
> CPUID.40000001H:EDX.kvm-hint-dedicated [bit 0]".
> 
> It seems the kernel hasn't expose this ability even when supporting it;
> So expose it.

Sorry, I check it again:
Ihe issue I met is because of my qemu's mis-backport,

In qemu, kvm_arch_get_supported_cpuid() will set the feature bit:
    if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
        ret |= KVM_HINTS_DEDICATED;
        found = 1;
    }
But I have mis-ported the KVM_HINTS_DEDICATED and KVM_HINTS_REALTIME macro; And it lead to
the error I met;

And it's right that kernel don't expose this ability!

Sorry again!

