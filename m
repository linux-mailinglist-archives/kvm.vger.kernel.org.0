Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD22E58F32E
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiHJTbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiHJTbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:31:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF47792C7
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l11-20020a170902f68b00b0016ee1c2c0deso10176150plg.2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=4ClZUMx8TnkVPiWPppNyKCT9yBDdrvfugyfW4aVoXbY=;
        b=eth5rcymjcTo6VYe4CYLR2cfYrhUHSgDwphDXVe5M9W77uVjamZK3zEQPkOaz8MeS4
         v18WcYItKk9ZR7udLSpcf89ncUrsRl8E52JO0GZ6cpgSHrfsX2fYCvuid4bHHF8HPf6M
         VsybieO28xH93+w4aUORM8rnRRWfPK8qg4uhN+vSJcDmX/KTUojSyVAaty4iu025crUn
         vhfdnOeVpgVQ0zQfeT5i0V29ivvaM60SPNcLfBkYjlU1gOQKl/2a8hwlEyB9SnHFD9wY
         ljJ/GYwGbhbF9yHI2U65mevgovogtg33yQx8TLgb2O2HkI/g6wZ4HGrZlviH543LdqlE
         x1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=4ClZUMx8TnkVPiWPppNyKCT9yBDdrvfugyfW4aVoXbY=;
        b=nx2RbAoB1TLwsd+ck+fHjDikyt4pottPRhsYr5MZ3yWXhONWhbwXqeQR0fvIr9gcOb
         q0ENNG6iQ9QlKAJ5RqUXIW+odFY79lMlXyXI9kXwLrmwBkK3EXo+PWPYk8MNlZiHFQag
         3PPDgJn+xXUKLwIufHmkxM17/PjyL5NRMf5ICcbKEAkTubr/6+FNOBcMMfcxfb+iLgOt
         gAa4jOFtflEIPRy0PlpB8pMeNCbgU4Ylwl06HQ0KtIyH2lOchQ5m53liFr8luAjcXmwR
         OA26yVDh82kCi0Hi2wsXUGLJJ45F5GN561Eo8fipuNfzgQrIDTez8qqBymF4+EEaSfqp
         I+dQ==
X-Gm-Message-State: ACgBeo2PDHsDGPxI5V9yLFLugs1vkSwWIvOvdNzBtV0L/4puztt8I5HE
        ybGdS3Csx9qMOCMmMqvYUylNWpk=
X-Google-Smtp-Source: AA6agR5ruBssTN91JyZyYKhtoX72CT7taSbOJaMPbA/aSzLBfq1S0116heTn2cGcPhGw5MM6Pcu1B5w=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a17:90a:fe10:b0:1f3:1de7:fe1b with SMTP id
 ck16-20020a17090afe1000b001f31de7fe1bmr5057895pjb.189.1660159855775; Wed, 10
 Aug 2022 12:30:55 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:33 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-8-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 7/7] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9788b19f9ff7..30e0c35828ef 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7486,8 +7486,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.37.1.559.g78731f0fdb-goog

