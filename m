Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6DF4074DB
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 05:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhIKDmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 23:42:13 -0400
Received: from terminus.zytor.com ([198.137.202.136]:59889 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhIKDmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 23:42:11 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2021 23:42:11 EDT
Received: from [IPv6:::1] ([IPv6:2601:646:8600:3c71:7167:9908:f516:fd1e])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 18B3X7IF606345
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 10 Sep 2021 20:33:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 18B3X7IF606345
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021083001; t=1631331189;
        bh=pdG5k43GvDzLKaCCViG8ja7JUnRV8sFeNGROkrEoC1A=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=ESofSvHpJC4jgq28qaFW8Ax9x+zFVvbQrTMPXRHlZlMZVtivH9YoZ4pPnkiZg7IYi
         msMg9V3ro7FB9t1QFkBF24jqV2n9Mhch+HnJxShweF9bTVmGOwy94B6t14J948N6F1
         4kl98nkxyCjlV8tIpPqMwxsVaE1NeTFamuLDGr8JTewvQgCcbfVnyghaemCZv53vm9
         bpUJyx0HJm5H8KXhN4Og7ahEOu7EmfSaD4TXElg3e27W8/2ZAKsKYeZ27uThd8fzuR
         nGwgxspghHXSX1ZO800ZgfUFCYhPwttOIJJlBnXeyn1/qJiJTZO2HkFK3P8YjDjBBD
         awxwjn8hUW4Vw==
Date:   Fri, 10 Sep 2021 20:32:59 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     18341265598@163.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
CC:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhaoge Zhang <18341265598@163.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_kvm=3A_x86=3A_i8259=3A_Converts?= =?US-ASCII?Q?_mask_values_to_logical_binary_values=2E?=
User-Agent: K-9 Mail for Android
In-Reply-To: <1631330841-3507-1-git-send-email-18341265598@163.com>
References: <1631330841-3507-1-git-send-email-18341265598@163.com>
Message-ID: <7CE1178D-729E-400A-A8D5-C8A9CD1BEE26@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

! is already booleanizing=2E There is no need to use !!!=2E

On September 10, 2021 8:27:21 PM PDT, 18341265598@163=2Ecom wrote:
>From: Zhaoge Zhang <18341265598@163=2Ecom>
>
>Signed-off-by: Zhaoge Zhang <18341265598@163=2Ecom>
>---
> arch/x86/kvm/i8259=2Ec | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/i8259=2Ec b/arch/x86/kvm/i8259=2Ec
>index 0b80263=2E=2Ea8f1d60 100644
>--- a/arch/x86/kvm/i8259=2Ec
>+++ b/arch/x86/kvm/i8259=2Ec
>@@ -92,7 +92,7 @@ static inline int pic_set_irq1(struct kvm_kpic_state *s=
, int irq, int level)
> 	mask =3D 1 << irq;
> 	if (s->elcr & mask)	/* level triggered */
> 		if (level) {
>-			ret =3D !(s->irr & mask);
>+			ret =3D !!!(s->irr & mask);
> 			s->irr |=3D mask;
> 			s->last_irr |=3D mask;
> 		} else {
>@@ -102,7 +102,7 @@ static inline int pic_set_irq1(struct kvm_kpic_state =
*s, int irq, int level)
> 	else	/* edge triggered */
> 		if (level) {
> 			if ((s->last_irr & mask) =3D=3D 0) {
>-				ret =3D !(s->irr & mask);
>+				ret =3D !!!(s->irr & mask);
> 				s->irr |=3D mask;
> 			}
> 			s->last_irr |=3D mask;

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
