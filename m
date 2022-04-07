Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26EC4F7F1F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 14:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbiDGMfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 08:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiDGMfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 08:35:50 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BE615EDE5;
        Thu,  7 Apr 2022 05:33:49 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q19so4821160pgm.6;
        Thu, 07 Apr 2022 05:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oHuMdd+Tso54IS24zoaKEo7ZF3a1oq8FNtueInQMuKg=;
        b=TP5m84milVRvG/vEdfXwdoGsaBa4DtHBo313pRzo5ALpNwKykawRcbsU4JHBwG928X
         n5jRakad5YjG9eFkh+7QyNsQRSSkBceUG9GxSLvPM9ydqymcYFGa8t+cT16wAFVYtn5E
         Tm0FxsfLb3ONv418/WLIsSgHsnwWPtYG1P7XhsyJBo1/YupRo+2Y1caU5ReQn2FTD9KR
         oEfNV/qbGhraydqt6xDfrmotxOVI99RtQARty2IARenhNTZHIJ1pa2l7r4GamI/2KkDq
         BmlszCrdY1v32v0rEq223xFv4QRc6SK6IN5w3cwfPHdg+hY2B1LoYIdhmzMBJnKAfFdl
         yM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oHuMdd+Tso54IS24zoaKEo7ZF3a1oq8FNtueInQMuKg=;
        b=bIccdu6pTAJ5HDDEqQ7+/rgLHh3QnrqdfxiO3Y/N/NK1QJ5b2gkqozESyw2MmV9tiA
         g9THaHKl5unMj4+v4WW81AZNcJwTVIl7rHbnvaZpJuz7sahTGKXkLIPRD69En4dQaTjf
         KeSKFOtU8mwEj29VszgrV14iVsuuFVoMFJBHj22AcSSNygzAgCZuZ7bephPsquCmO60s
         0wZ+7D6FAVF+/odjKrYo44/K9u8hbvpJIr1dA1QIVHZ37/vCdmEC7i8P+XPPprgPAt2g
         bvnTDVpSBaTrYijDqLtKsplifmKGFKBGuED8xukbEME/UQ5L2Y584AQGAs+kyUtuhGtm
         DQhg==
X-Gm-Message-State: AOAM533NZjxdT+lpEvz7+Ad5PcFqEXLzjZgQTBwKy3Su03twOtJHJfa/
        y+qRsIOe/4QRi3I/ynQuj6WyIkeqzGzY7vIj
X-Google-Smtp-Source: ABdhPJxaB7S5JM7L1Nse63e3q13TrwKZX/zgN6E55DEv72DlYwSESD8Cwg7AsnUwV84IfHCk/CWwgQ==
X-Received: by 2002:a63:7f50:0:b0:386:2b5c:9d16 with SMTP id p16-20020a637f50000000b003862b5c9d16mr11244153pgn.153.1649334829156;
        Thu, 07 Apr 2022 05:33:49 -0700 (PDT)
Received: from ubuntu.mate (subs03-180-214-233-65.three.co.id. [180.214.233.65])
        by smtp.gmail.com with ESMTPSA id nv11-20020a17090b1b4b00b001c71b0bf18bsm9484966pjb.11.2022.04.07.05.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:33:48 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH v2] Documentation: kvm: Add missing line break in api.rst
Date:   Thu,  7 Apr 2022 19:33:27 +0700
Message-Id: <20220407123327.159079-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add missing line break separator between literal block and description
of KVM_EXIT_RISCV_SBI.

This fixes:
</path/to/linux>/Documentation/virt/kvm/api.rst:6118: WARNING: Literal block ends without a blank line; unexpected unindent.

Fixes: da40d85805937d ("RISC-V: KVM: Document RISC-V specific parts of KVM API")
Cc: Anup Patel <anup.patel@wdc.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Changes since v1 [1]:
   - Rebased on v5.18-rc1
   - Address Fixes tag problems reported by Stephen Rothwell [2] by
     removing date and quote the original commit

 [1]: https://lore.kernel.org/linux-doc/20220403065735.23859-1-bagasdotme@gmail.com/
 [2]: https://lore.kernel.org/linux-next/20220407074844.110f9285@canb.auug.org.au/

 Documentation/virt/kvm/api.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa66004672c..85c7abc51af521 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6190,6 +6190,7 @@ Valid values for 'type' are:
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+
 If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
 done a SBI call which is not handled by KVM RISC-V kernel module. The details
 of the SBI call are available in 'riscv_sbi' member of kvm_run structure. The

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
An old man doll... just what I always wanted! - Clara

