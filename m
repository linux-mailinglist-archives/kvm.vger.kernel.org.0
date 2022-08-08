Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54458CE3D
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244165AbiHHTDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 15:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHHTDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 15:03:49 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901019022
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 12:03:48 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r6so5348869ilc.12
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 12:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=syAtPX/fEfY/Znj5vIFhc6XP8gBHOtdfC9U66uE+0pg=;
        b=PinGFxYR+g6qD+2+1uClXpDIeha9HqBTjdj78StBVEeLhFTubqtiFpLXdAfzJQsnIB
         N/MrX8QQinIl1NXg0uIFgSy+pzaDOur/RGU9txFVKv8TIuFtAszffnMyt1h/mMeSu9bv
         c10YPiJpVMd3y0+ns4MfWt0kkhWpeO6n6iwpXg3eFUwTmn7FkDdRCD2kidAjQuigBNhX
         Ixx13wqu5MyktG3tnvQ/5y1P+7rO5xKE2WPPawWBOYLq+iUSh7Q9HsDP4bRBKdNrPB8O
         7M403iCvz/LeaZfwjpV/6dTg2e5ImH4hWYiWkvz7LgJ3S+sQ0HEWNB1dCk5p8Gslf/SG
         jSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=syAtPX/fEfY/Znj5vIFhc6XP8gBHOtdfC9U66uE+0pg=;
        b=InMmm4cAelXZtT18edCQDqox9zSJmjQlP5FuKT8TOrl0RwQrB1wVgjflBeOXNlvf2e
         DORai71AjmOx5HDvUaniaxn4Cryuf9yq+nTOtp6PfFenqtfS7ioH5TSt0//jeaMW39QZ
         5GkLmb4hDBAk76CUg+xkCDQofyXkuBFErsajuk9Mum6CY+fhtPkgy5oPeG6/RonOqCkq
         aHflfW1/RSGnT4YD8+vrQyCLfGCfqBQrpHPjguVyI/mSToZ38K1siXaDZy/ReWqrKeFd
         K+B9ffIhzAotTdNE64JvThVh9WdhDybT3bmjYE8Qww76uWgG+DI2NIICD7dgAGKXAzm4
         4Njg==
X-Gm-Message-State: ACgBeo2iQwPleSJFstErM9ORxHkngf0QJig478LZ6zdBaysQ8UglxNlR
        QMWxCV/bHxIDP0dJFyfMegLB/Q==
X-Google-Smtp-Source: AA6agR7c1UwS8w8jUikUvEkKhIpyqDOzMB9e62cctTro+gFeq58kURPib4bcwlSqgRjrBUEKVsO6fw==
X-Received: by 2002:a05:6e02:1ca5:b0:2df:3283:b4a8 with SMTP id x5-20020a056e021ca500b002df3283b4a8mr9468668ill.131.1659985428040;
        Mon, 08 Aug 2022 12:03:48 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id c11-20020a02a60b000000b0032b3a781754sm5541725jam.24.2022.08.08.12.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:03:47 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     dietschc@csp.edu, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v3 0/2] KVM: x86/xen: Prevent Xen timer init when running
Date:   Mon,  8 Aug 2022 14:02:10 -0500
Message-Id: <20220808190211.323827-1-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following issue was discovered by syzbot:
WARNING: ODEBUG bug in kvm_xen_vcpu_set_attr.

When running the syzbot reproducer code, the following crash dump occurs:

ODEBUG: init active (active state 0)
object type: hrtimer hint: xen_timer_callbac0
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Call Trace:
__debug_object_init
debug_hrtimer_init
debug_init
hrtimer_init
kvm_xen_init_timer
kvm_xen_vcpu_set_attr
kvm_arch_vcpu_ioctl
kvm_vcpu_ioctl
vfs_ioctl

The ODEBUG bug crash appears to be happening when vcpu->arch.xen.timer is
already set and kvm_xen_init_timer() is called, which appears to be the
result of two separate issues.

The first issue is that kvm_xen_init_timer() is run "every"
KVM_XEN_VCPU_ATTR_TYPE_TIMER. This is addressed in patch 1.

The second issue is that the stop xen timer code should be run before
changing the IRQ vector. This is addressed in patch 2 with some cleanup.

version 3 changes
-removed ambiguous comment
-updated another comment to be more descriptive
-continue cleaning up changelogs

version 2 changes (mostly feedback from Sean Christopherson)
-split patch into 2 patches
-fix changelogs to be more descriptive
-fix formatting issues
-add check for existing xen timer before trying to initialize another one
-removed conditional for kvm_xen_stop_timer() so that it always runs
-ensure that xen timer is stopped before changing IRQ vector
-streamlined switch case KVM_XEN_VCPU_ATTR_TYPE_TIMER a bit

Coleman Dietsch (2):
  KVM: x86/xen: Initialize Xen timer only once
  KVM: x86/xen: Stop Xen timer before changing IRQ

 arch/x86/kvm/xen.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

-- 
2.34.1

