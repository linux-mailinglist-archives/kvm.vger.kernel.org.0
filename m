Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D186E8D1C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 10:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbjDTIsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 04:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbjDTIrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 04:47:49 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1677E5264
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:47:39 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B85403F5DC
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 08:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681980454;
        bh=gjfn8mwGbqoBuiWtH29ZnnRbCynlsiRY6IrJ4wrGO7c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Hjt/ac5qtyCXdza8JsQKC7mWQCRhT5v0T/70JtEawrND0Moayl0onRNHyX6iVptvl
         1n84EPcSRfGtmlAtgSzt4JC88cNLvVGeK6Ei/juOPSpEkEHY5y42E6D3PmVpHYymmU
         axuypoMRzJBVXwbu2U3GB/i39QCu003Jh7vmYyB4QFAVka0AzyV744HSQk3a8HdnvX
         pWosKLahCoKgU2QPrD+gtMx1WfhVkj+gRdC63Q8qPIkQ7axmZ1+viDsWuLviUHgEkc
         wMM61MVW5BT61Zr9MqRNQXTa5D94YZqEct6rbwJPgv4RYdhTATqfgaRhhG4v5GkabF
         czTlJx4kBvZ0Q==
Received: by mail-ej1-f72.google.com with SMTP id jj28-20020a170907985c00b0094f5d1baecbso966908ejc.4
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980454; x=1684572454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjfn8mwGbqoBuiWtH29ZnnRbCynlsiRY6IrJ4wrGO7c=;
        b=ATSwnO3K1O+Gn00ZdTSOZZW6q/vEY+Qm7GZPCT578tt1gAzdL3MwEFnSscFL6I/Bno
         GeKVc366W2Ac1nmvGt8AQjXPHct66V8svK3Fcv5dPEeC3/nzOPSXTR4ypGFA/C4PEVFV
         nYj7WdCXolW9gEfz4T+5zBB4X2G4CA9LLio1mNw7YUWCipT1cZO6KAYaljvO8q+cgZFJ
         cjqJNVcykyAajfRNwDkwfTGlmrUSQp3hzCe1QwVOyWWEezUEFvZcHU78COJvkLGppTsa
         ieoCd8FjtnsIYxXFh4AWBsahdxwe5Tjvti/12yC51Vf0NIyrhln/ui/Sx0MVMtsvorq5
         LOiA==
X-Gm-Message-State: AAQBX9dy/kLC9i3OXiKRvYzOCcVH09HO14VTvAFUal9a4oiFdrK6cce8
        vmZJwVSsDDV+XYhXwMRcfdEmU6WnICytOeRjOQtQCWBYGJ0N80aaBVNv5hUrKZFbR+UtVQyBloJ
        JQG5apr1/iF3L2u0YKuY7Lb/hMpTUpA==
X-Received: by 2002:a17:906:40d7:b0:94f:17b7:5db3 with SMTP id a23-20020a17090640d700b0094f17b75db3mr894460ejk.20.1681980454455;
        Thu, 20 Apr 2023 01:47:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350b5Z9/yLBuIQsMUw1scAoKcGPRWOUNbfxBMO5tsQXXSsPuENSDfm8ucPo1lb6kpxNuXVk/2Rg==
X-Received: by 2002:a17:906:40d7:b0:94f:17b7:5db3 with SMTP id a23-20020a17090640d700b0094f17b75db3mr894444ejk.20.1681980454165;
        Thu, 20 Apr 2023 01:47:34 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bd076.dynamic.kabel-deutschland.de. [95.91.208.118])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7c39a000000b005068053b53dsm500964edq.73.2023.04.20.01.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:47:33 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RESEND 0/2] KVM: SVM: small tweaks for sev_hardware_setup
Date:   Thu, 20 Apr 2023 10:47:15 +0200
Message-Id: <20230420084717.111024-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: SVM: add some info prints to SEV init
    
Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
enabling a little bit handier for users. Right now it's too hard
to guess why SEV/SEV-ES are failing to enable.

There are a few reasons.
SEV:
- NPT is disabled (module parameter)
- CPU lacks some features (sev, decodeassists)
- Maximum SEV ASID is 0

SEV-ES:
- mmio_caching is disabled (module parameter)
- CPU lacks sev_es feature
- Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)

==
   
KVM: SVM: free sev_*asid_bitmap init if SEV init fails

If misc_cg_set_capacity() fails for some reason then we have
a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
not a case right now, because misc_cg_set_capacity() just can't
fail and check inside it is always successful.

But let's fix that for code consistency.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

Alexander Mikhalitsyn (2):
  KVM: SVM: free sev_*asid_bitmap init if SEV init fails
  KVM: SVM: add some info prints to SEV init

 arch/x86/kvm/svm/sev.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

-- 
2.34.1

