Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B963F897
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLATw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiLATwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:52:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B293723F
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:52:52 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 145-20020a621497000000b00574fab7294dso2838256pfu.13
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T3Xw60Pix1cG4UBEcwKBNt+iW5FV3zwEkrNY5DVdltY=;
        b=pXAlBzxEzjMopTL9MJOEkkxRstjTgv5E2youV/Zwc0kLGJw4Ipt1Ii1GklMXcyLezz
         OmPzGhZ0xMjoR1gWmKbIfnXxcQYlF3kwZaxAJ3M4FBE6WeQqfDWQK9f3VQJVarGYwKBv
         EouCQVMfmDtGoEBcLRJMD7N8fqRoQ57MO5U+MCyQvTfFy0MFGBxIE4TDgzuH+bAOP55i
         zDKnzj5jSyQPlSLcCiGPhTq1xLZbUketh83WVjpenXNHLnaAT9oKgVFzJI5sGzhD+vCP
         NLi8PeUO84WatdcnxJEK6ZYC36sfZYGvttpo+WVnxkXFgd6iwkAv168rBFJqec1IEp/K
         Q7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T3Xw60Pix1cG4UBEcwKBNt+iW5FV3zwEkrNY5DVdltY=;
        b=CioNjEq2q17iEJnTqTpVA9yNWGNYJuTgV5bdA02bFMdOJ+U0SPCQawH+27UEHff9ha
         aPHoHfA6OtKFpoN+fnuSs3BK3Z9eekdonwztfybHLKSsDXRRMTuU4jgVplPWJHYb9nm6
         HqWT9ryBhYr8h8hdeT4rrFKGID+9BXeLr7s0AWObP8ihfxWgTv0XEP7kUMWvzhRL5Tfh
         V6TUorKOZYs3UD8vBr6YfFTFi03U+p3R3f7I2iUNoGOKBHKrWtQTmBnKoehy8KVkliCG
         5qKCTVdf3H45tLICKBIH9OUZJCMTtKI9w0KRZ4e2dhyE4E3Y05yaUwuE/FI9wY/8tgiJ
         Yohg==
X-Gm-Message-State: ANoB5pnkSkhXlaT9hMc1p3AIfj3qv7cIoXVpYl5thmkwZPUsoDpMYKp6
        WZEbGPb8PWrDFH15id47hAP3MiXaiP11Wg==
X-Google-Smtp-Source: AA0mqf5TxiZHFd6U4P6ZxINuqKr+rka5dcq5bdnEU/u8FPh5Z+9rOqdoCSs04fdwwy1prTsw4G68743LF0u5lg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:f04:b0:218:8ec2:a4e2 with SMTP id
 br4-20020a17090b0f0400b002188ec2a4e2mr64538756pjb.174.1669924372229; Thu, 01
 Dec 2022 11:52:52 -0800 (PST)
Date:   Thu,  1 Dec 2022 11:52:47 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201195249.3369720-1-dmatlack@google.com>
Subject: [PATCH 0/2] KVM: Halt-polling documentation cleanups
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
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

This series makes some small cleanups to the existing halt-polling
documentation. Patch 1 moves halt-polling.rst out of the x86-specific
directory, and patch 2 clarifies the interaction between
KVM_CAP_HALT_POLL and kvm.halt_poll_ns, which was recently broken and a
source of confusion [1].

[1] https://lore.kernel.org/kvm/03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com/

Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>

David Matlack (2):
  KVM: Move halt-polling documentation into common directory
  KVM: Document the interaction between KVM_CAP_HALT_POLL and
    halt_poll_ns

 Documentation/virt/kvm/api.rst                    | 15 +++++++--------
 Documentation/virt/kvm/{x86 => }/halt-polling.rst | 13 +++++++++++++
 Documentation/virt/kvm/index.rst                  |  1 +
 Documentation/virt/kvm/x86/index.rst              |  1 -
 4 files changed, 21 insertions(+), 9 deletions(-)
 rename Documentation/virt/kvm/{x86 => }/halt-polling.rst (92%)


base-commit: 7e3bba93f42e9d9abe81344bdba5ddc635b7c449
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

