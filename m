Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5549B14E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiAYKE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238537AbiAYJ7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:50 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553EBC061760;
        Tue, 25 Jan 2022 01:59:49 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id u130so14981644pfc.2;
        Tue, 25 Jan 2022 01:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oOTkb+Q9/amZvPIG5yANfVQOPdgSqbGAc2I9WSO6Uo0=;
        b=LBKx/2P/Nl1mXqyOzGdfy6es73hzU5cLrnMBc/8D16QS4gzweCSUg053vZdQQHEoJk
         smcJuXwuzajr4jO4qDb5Ww/Uiol3edThXD4KBPUAztqdEPweLxBQy3R0STBvQqqz/58Z
         Nuaf7ehMAXc55act5ScYkDhjxSL2DePwQbmTv7M+f9vef6Hjyf9TTlrYlEyrcvNfP0wx
         brm0XIu+xUWSIr4gdqplgchY/MgX/E+ibf//YmXtkHV9kgnj1GBTqD3ZVSXv55hcAdn0
         BXwhZxM7h+pTt1a/wO5YE6xTNgUrdyl/IIvp6LuqgNQpQQct73eRP2hY5TNGopp5kos9
         2BRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oOTkb+Q9/amZvPIG5yANfVQOPdgSqbGAc2I9WSO6Uo0=;
        b=hrxvrEb9EzISCE7OOzHPt+RcUKKZRWuunVWwwXh0T2kfTCJHMlJgzp9fw+todTVzhT
         d4cXOaswGuvYW5xxDpBiJNwTGplbxN0ThOJWHBCNYLebu/SoIkSkb9aJVsJZcvCayzLR
         glAyy5XhjgEBivvnj1K/dfIj/daUAKpy1i+GP+by6xFEInZ3LPaMYEthQcRa8Xu/ipg7
         RAiB2frk4+IExJZFRt162aSoUfCXUflVnIW23Smr3VyeI0HAqM5nlrqKrnHSKQq/PwIU
         SgXv/6DVQAWsUFBCMUbdqXsFtREjjfRFJKAVNKqEDNwLNOZ21P+WMLBHU3q4qEdSwlzH
         LWgw==
X-Gm-Message-State: AOAM530bx9el1CNdK3d9wtn5AlcRPxYyfSoaUaCKjJoKyLszSXZ0xKLK
        oHrvt6+F60tjq4ptH/a/TWQP9yvfxSmMvA==
X-Google-Smtp-Source: ABdhPJxA+sRmuOjK5WwrchT84Iisf5iF/g6SB9x+mzdxo7GQSXv+7UqPZOxad0NFRp/xYRJPZ6Nl/w==
X-Received: by 2002:a05:6a00:10d0:b0:4c9:1d31:c596 with SMTP id d16-20020a056a0010d000b004c91d31c596mr8357350pfu.73.1643104788970;
        Tue, 25 Jan 2022 01:59:48 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:48 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] KVM: x86/ioapic: Remove unused "addr" and "length" of ioapic_read_indirect()
Date:   Tue, 25 Jan 2022 17:59:03 +0800
Message-Id: <20220125095909.38122-14-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "unsigned long addr" and "unsigned long length" parameter of
ioapic_read_indirect() is not used, so remove it.

No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/ioapic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index decfa36b7891..765943d7cfa5 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -54,9 +54,7 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 				      int trigger_mode,
 				      int pin);
 
-static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
-					  unsigned long addr,
-					  unsigned long length)
+static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic)
 {
 	unsigned long result = 0;
 
@@ -593,7 +591,7 @@ static int ioapic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 		break;
 
 	case IOAPIC_REG_WINDOW:
-		result = ioapic_read_indirect(ioapic, addr, len);
+		result = ioapic_read_indirect(ioapic);
 		break;
 
 	default:
-- 
2.33.1

