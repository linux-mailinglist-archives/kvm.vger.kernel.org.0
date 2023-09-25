Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3877AE198
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 00:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjIYWP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 18:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjIYWP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 18:15:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C178BC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c60d6f2c6bso43739015ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695680121; x=1696284921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RpBN/lTKFs6BPAO87ypgoErQxcXWHucVNZxnISg6WSE=;
        b=U1EVaPPIvNQfFYGzwrAI7YXXXn5e4M9MlddsZTUpLtC9kkvdByEtlHMJlEJP9+n0RQ
         TBewDstsSBLeV7T2c+C7JV4RxSFDjPKItFzh50+q61USFT5GEM6IyRlnRL16yYuokbUX
         zsgxnAQvBn0xIxCfNAib9Q3xm1Q+cOBFeOspSJek4MLXDmikICySp38zIvngF5ZPNm44
         s5aUQid7wQle42TGDreIfQpQk2Ip90G25XqmkV5R7QEqpFsA6geQC0+mQxtct3WfqiOi
         Rgy+D0VhQsdtHckRb8ObrVtDKpK9nFiAFfRi3BdWNj+eFQjbuj7uPfqJD3w/rmd+QPUk
         x1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695680121; x=1696284921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RpBN/lTKFs6BPAO87ypgoErQxcXWHucVNZxnISg6WSE=;
        b=hMKDhpqqh1XIy8TX4UOJhsJtSWCwfR0MBqJ+k6bOGiH5W84lOnVkIU5g1ZjNGSYDpQ
         QY4YmwDuLqsdbfqOti6LkcUjWf0u3kLcEnrUlBA/6+fegNIVBlTDpb/UFTI4SVTLf+ko
         japDBaUnOG+mLwEzcvNuxSEiRL6FZgZt3zaZVxKREFqrsPlqROQH+WSUfq4FsSAfpkjf
         Of3QIGiMK7BSIopnjHoR4mjjnqSwKW+lIU7xg+RtMbCS8G54nAdbEMw1jCpJDi9xaMTT
         l2GnroV0ow1tCkwyftGhvgbHerivRWbcioj2jnVeJkWZsqrpd9UVaCu+p2Fm1pUysBU2
         mC3Q==
X-Gm-Message-State: AOJu0Yx+dp+UcfNbKR961N0cPmmK3TU4+N8wU4euCatAxNR7NehPaaSM
        CLwGb4bJGOe/C/SxlSuyO2XfMeLsaENwhPCx6CWZ+yK8xYWXIDM3NMUkukN8UeqXDwSD7fu6rbS
        VhdnQeajuY2oFAnH1QFxONxvu3uc7+ppkSVdiXABfFsPaUr8oGnQ2hqEI7iyxPmk=
X-Google-Smtp-Source: AGHT+IEnfVct74MyVkck15Fgzy/HS0rgzBzx81X5aI71UM30ZOQY6sV7+FK4z34FwEDkYnlaRE/nY27JigEMnQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:903:2309:b0:1b7:f55e:4ab0 with SMTP
 id d9-20020a170903230900b001b7f55e4ab0mr16810plh.0.1695680119650; Mon, 25 Sep
 2023 15:15:19 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:15:11 -0700
In-Reply-To: <20230925221512.3817538-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230925221512.3817538-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925221512.3817538-3-jmattson@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
set. If it isn't set, they complain:
	[Firmware Bug]: TSC doesn't count with P0 frequency!

Allow userspace to set this bit in the virtual HWCR to eliminate the
above complaint.

Attempts to clear this bit from within the guest are ignored, to match
the behavior of modern AMD processors.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a323cae219c..202972f393b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3695,18 +3695,32 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
-	case MSR_K7_HWCR:
+	case MSR_K7_HWCR: {
+		u64 allowed = BIT_ULL(18);	/* McStatusWrEn */
+
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
-		/* Handle McStatusWrEn */
-		if (data & ~BIT_ULL(18)) {
+		if (!msr_info->host_initiated)
+			data &= ~BIT_ULL(24);	/* ignore TscFreqSel */
+		else
+			allowed |= BIT_ULL(24);	/* TscFreqSel */
+
+		if (data & ~allowed) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+
+		/*
+		 * TscFreqSel is read-only from within the
+		 * guest. Attempts to clear it are ignored.
+		 */
+		if (!msr_info->host_initiated)
+			data |= vcpu->arch.msr_hwcr & BIT_ULL(24);
 		vcpu->arch.msr_hwcr = data;
 		break;
+	}
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
-- 
2.42.0.515.g380fc7ccd1-goog

