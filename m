Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDEC5715B9
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiGLJaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiGLJaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:30:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8639E442;
        Tue, 12 Jul 2022 02:30:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v7so4944528pfb.0;
        Tue, 12 Jul 2022 02:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LlZwokCCRr1//JcjppZSf7dBePHepe4POxaFRYgWkT0=;
        b=ob3lUCfgB/mcNHXQj7p4ewgx3PXsnSrUnRlo8/SpYNZkG7VWGANbKgQ71iTzhHvrTG
         AD+TtVCsHaBx5iXjEkgzmTyaFh5V9zx1r8mzZRsWLcymvKQLCj5vig9U4NVWgSy02pBE
         Tgs+HG5j+Jg5XNFmBb5gPZpluVKNA2MECu8Umci8h6Myi0OiJH99Q/j21eK5x01WBADj
         og47+6TOW02Y/hRoUzFJ/ofyPdLywRTPm48cKYEJCWFEFdmqHlMgb83WwJps7awFg+VT
         CgSSNRGAnBITgVbET5hp6WWp0oKLWtG4pGbmMZ4vQQaZMigvf3DUj6akMe8TBGB5P1JY
         z2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LlZwokCCRr1//JcjppZSf7dBePHepe4POxaFRYgWkT0=;
        b=DW7mdy2FztFSSl1RKuE8FanhEra5SamRy5N/GsIP/1VmfItFx5K6pnyi9dqsszAm9t
         wuTJzV0qxl/zpqIgWbtZJXr5zcE4On1+wFtA/xTB58zRFEqKtRrnHiyG50U6t53RV0xY
         dIiT3/aZtjGN9l+ucdPN+jZq35lomKs/V/cunvnppxMaB763w4Q+R1S2Qv8xT1mVgnXX
         ExzwKw04dva0JrlZmGdfHQUiJcvNkqALWxZ5EOhNheiFXKVevOfpz+icCrv0RA1BAea8
         BZAOQw7kguvYhKfQfpKsOc+PpZlkCvv/E916uCWwabtwUEuNnbO8S1PvdySpIVd+7aDC
         7JLg==
X-Gm-Message-State: AJIora8jqInxb8eKz1M5aHDKNv3er+zgyJv56pzCQDdeTkRb61I3jTq+
        3eWfF/Nh4wFd6CyTBo1k8QE=
X-Google-Smtp-Source: AGRyM1sWIISpls1J5deVQlnkYWta8ucsGjsLXdTSKCq7iycbn1xeAQ0VrAm6PQJjkMKZUyT4ZYSZRA==
X-Received: by 2002:a65:41ca:0:b0:408:aa25:5026 with SMTP id b10-20020a6541ca000000b00408aa255026mr20603164pgq.96.1657618205823;
        Tue, 12 Jul 2022 02:30:05 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id 77-20020a630650000000b0041299ef533csm5616514pgg.41.2022.07.12.02.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 02:30:04 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 01C16103970; Tue, 12 Jul 2022 16:29:59 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH next 3/3] Documentation: kvm: extend KVM_S390_ZPCI_OP subheading underline
Date:   Tue, 12 Jul 2022 16:29:54 +0700
Message-Id: <20220712092954.142027-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712092954.142027-1-bagasdotme@gmail.com>
References: <20220712092954.142027-1-bagasdotme@gmail.com>
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

Stephen Rothwell reported the htmldocs warning:

Documentation/virt/kvm/api.rst:5959: WARNING: Title underline too short.

4.137 KVM_S390_ZPCI_OP
--------------------

The warning is due to subheading underline on KVM_S390_ZPCI_OP section is
short of 2 dashes.

Extend the underline to fix the warning.

Link: https://lore.kernel.org/linux-next/20220711205557.183c3b14@canb.auug.org.au/
Fixes: a0c4d1109d6cc5 ("KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1ae3508d51c537..e6bd6c6dbd13ec 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5956,7 +5956,7 @@ KVM_PV_DUMP_CPU
   The length of the returned data is provided by uv_info.guest_cpu_stor_len.
 
 4.137 KVM_S390_ZPCI_OP
---------------------
+----------------------
 
 :Capability: KVM_CAP_S390_ZPCI_OP
 :Architectures: s390
-- 
An old man doll... just what I always wanted! - Clara

