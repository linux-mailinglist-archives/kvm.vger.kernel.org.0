Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7A3EB3D2
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 12:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbhHMKKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 06:10:00 -0400
Received: from mail.kingsoft.com ([114.255.44.145]:33646 "EHLO
        mail.kingsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbhHMKJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 06:09:59 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 06:09:58 EDT
X-AuditID: 0a580157-219ff7000004b751-85-61164151898d
Received: from mail.kingsoft.com (bogon [10.88.1.79])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.kingsoft.com (SMG-1-NODE-87) with SMTP id 9D.4C.46929.15146116; Fri, 13 Aug 2021 17:54:25 +0800 (HKT)
Received: from alex-virtual-machine (172.16.253.254) by KSBJMAIL4.kingsoft.cn
 (10.88.1.79) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Fri, 13 Aug
 2021 17:54:25 +0800
Date:   Fri, 13 Aug 2021 17:54:20 +0800
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
Subject: KVM: x86: expose HINTS_REALTIME ablility to qemu
Message-ID: <20210813175420.62ab2ac2@alex-virtual-machine>
Organization: kingsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.253.254]
X-ClientProxiedBy: KSbjmail3.kingsoft.cn (10.88.1.78) To KSBJMAIL4.kingsoft.cn
 (10.88.1.79)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LhimD01w10FEs0eL9Zz+Lzhn9sFtM2ilts
        nX6FzaJz9gZ2izlTCy0u75rDZnHpwAImi/3b/rFaHD1/i8li86apzBaTWi8zW+y684TF4seG
        x6wWz1qvsjjweTw5OI/J43trH4vHzll32T0WbCr12LSqk83j3blz7B7v911l82iceo3N4/Mm
        OY8TLV9YA7iiuGxSUnMyy1KL9O0SuDImvtnOXHCLrWLD83a2Bsa9rF2MHBwSAiYSl96wdzFy
        cQgJTGaSuHR9JRuE85pRYuWR7UBFnBwsAqoS209MZQSx2YDsXfdmgcVFBM4ySez5zwzSwCzQ
        zijxeOsWdpCEsIClxIeTK8BsXgEriSWz94M18wuISfRe+c8Esdle4vF6RYgSQYmTM5+wgNjM
        AjoSJ1YdY4aw5SW2v50DZgsJKEocXvILbKSEgJLEke4ZbBB2rMS19dcZJzAKzkIyahaSUbOQ
        jFrAyLyKkaU4N91wEyMkmsJ3MM5r+qh3iJGJg/EQowQHs5IIb7GwWKIQb0piZVVqUX58UWlO
        avEhRmkOFiVx3jR3oUQhgfTEktTs1NSC1CKYLBMHp1QDU/G2srUzJWQWOUlduKl7xku7fo3Z
        /snrz4bIbGjsypLO+/0rWubW89U/7uucDXy7YlquaoTj/U2Pd5QY7Kn9wiXSw3Fv6YMXMu0W
        9i273O+KrH0itH6O25cYy5U38jhm3ufnFH/l/9ja2/v95H0J66cs2i439WmV360D2/NLIkrD
        RLZWvT0gN9c4KrXyUJrpfK0H1aryR0Iq5A7euXn92POYZIPHXX+MwmZf6HTb8uCN8B+j5+wz
        Tu37tMB8Zbvn93cp3IKzuE8WHJiyf97GDxs1y3eU7pZWsK1hPHSs637+/5RZJkwqkYa9/0KX
        7HizoSprtXZpP+PPigPWKtWh3jYipwJy/MOmLTH7fXzTVgslluKMREMt5qLiRADBuEJzFQMA
        AA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I do a test that try to enable hint-dedicated for one VM, but qemu
says "warning: host doesn't support requested feature:
CPUID.40000001H:EDX.kvm-hint-dedicated [bit 0]".

It seems the kernel hasn't expose this ability even when supporting it;
So expose it.

Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..2153014742d7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -917,7 +917,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->ebx = 0;
 		entry->ecx = 0;
-		entry->edx = 0;
+		entry->edx = (1 << KVM_HINTS_REALTIME);
 		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x8000001f);
-- 
2.25.1

