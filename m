Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E227B258A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjI1Svh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjI1Svf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:51:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C4C195
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f7d109926so164262667b3.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695927093; x=1696531893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qxiUgymJbSqYVSjVnDwaQ0NwklGc/ZL8ErYIOq5iH8=;
        b=SmIZSyeYGAdCkV21yFjn53gTfGqeKnbBZCX3QeRmHagPbJZMr5pUbF0CiiM8WhOojr
         1rXqW+aU735WXTwlpvMm+/qvJVp+EG1xQKAcFIepOCkJPfOUziyazpb6xrt83iGypvim
         aEnD79hufxmzMYA0/8Q3uadm/UHXLz9lUBoT5FTky18PB1M7qFSLBTgkP3zlDlLdlt4b
         B+RdMwrPEczZcoTXwUZPF8iu37Brr0KY+p90KS1AxSklNChE60Z7OXEtr4KLbEnXX1xC
         U61GoGNANIeTERcodtml0CaShOPLkk9xxb90wkkTvPGX2stFA1FvHwg2wcb7uJLRAuo4
         z4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695927093; x=1696531893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4qxiUgymJbSqYVSjVnDwaQ0NwklGc/ZL8ErYIOq5iH8=;
        b=wBENbK/NHWdepttFfW2OUL7PeoFCa5UudqWudIegLZCVcofwfhhWxLWpYwNfVLExF8
         Yq3IQ5+cF7ew00/W1UJWwplMwioBOBWUGUfn4dlQsQMGRXgq/nPB+4eMw+Z9bZY5MwTO
         CTTLxaiRSCeMCSqH+8vQL8ePzZbNvYUlOP91uHL0qmhpZW0zG0A2OHsbNq1HgZ8mygkP
         dmLETwqv2/fevq/7RhGyXHqUaOegKW855qemwT80n4QGWGnq47ZJXryJWrsfo6iBpu5O
         Yej4KWElYAQkeFvlh+YwMqE6NRmjlCXfu98yfYP0HlLp77SFlvr1MkSUv+vM1gYsKFu3
         sP7w==
X-Gm-Message-State: AOJu0YxSLHcrmG9fgqeAAnCvttCWg4yS2jsXguUQ62fG4pRNhq4wqPX5
        DE7BZFptFrDNw+w3oqid7n3EwZ4PiJ658twEcIosiuDRwA6tEbSCxqtgck6n2XoC4OgHHPVift+
        DdWZzF1dVJHV8l/yuOnVt9y1dARu6o94OTw5kZDTOZ4HKCi3k5giHsYTEe8IX/Z4=
X-Google-Smtp-Source: AGHT+IF2n8wzxI2hpTSlpYaqd4kpzGOC9eFDCc64RknT5wkNCWUMOzSiq1DsxTrN3eNUaXOFMPTWCpZoBE7Kjw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:ad64:0:b0:583:5471:1717 with SMTP id
 l36-20020a81ad64000000b0058354711717mr30570ywk.10.1695927093241; Thu, 28 Sep
 2023 11:51:33 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:51:26 -0700
In-Reply-To: <20230928185128.824140-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230928185128.824140-2-jmattson@google.com>
Subject: [PATCH v3 1/3] KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When HWCR is set to 0, store 0 in vcpu->arch.msr_hwcr.

Fixes: 191c8137a939 ("x86/kvm: Implement HWCR support")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..1a323cae219c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,12 +3701,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
 		/* Handle McStatusWrEn */
-		if (data == BIT_ULL(18)) {
-			vcpu->arch.msr_hwcr = data;
-		} else if (data != 0) {
+		if (data & ~BIT_ULL(18)) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
-- 
2.42.0.582.g8ccd20d70d-goog

