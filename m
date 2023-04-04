Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A1B6D6058
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbjDDM2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbjDDM17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:27:59 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217134218
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:27:36 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 627F33F237
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680611224;
        bh=RdaT2Pf0VFYL4LUkKTTIwRSg1FtfHR7MN47zcz2wKyA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=XEDIRnVlogxBpPN6AZMLCcUu9/CZvGLbslUSShmEZLsiAjyL4bOEipQc+wWZ/l0dT
         DsEwDTgo7AD8HL+HWAv5BjitrgAAsA4wFA6vz47jTKBycP1ZYRRm/m8X5qWAohUHWP
         IpD+4DkXNAlLmUDG2cf4h48bPza06ydvvVciNT747eU/Zh6To3bTRTBGscBXoyH2ej
         tCDFKytAY+CtHwCeFk2a2BYDbnWm21pKKC/TqCK8Uzf7pFO9pbBtK4H9WA6ME5F/jj
         CfbF3OGgHEtK9LISnDEOcW9hPDYmNDPzO0B2blbvGftg8HbYpVRLeMyp5OyX+i7DA0
         u0ZLOo++NcoBw==
Received: by mail-ed1-f71.google.com with SMTP id i42-20020a0564020f2a00b004fd23c238beso45723037eda.0
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 05:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdaT2Pf0VFYL4LUkKTTIwRSg1FtfHR7MN47zcz2wKyA=;
        b=5yUz+KQwEocsCzUz7IM4ZPRoq90nxxtKPQzxxQG0g+5KHLAvuLmJUoxRxT/jIVhBnH
         ZRIJB2o59W4AKu/C4j/LgsbJ2QeAAtpofbz5Bivj804yfkwPnS5HJ/SUneKI6LJobVjg
         lRvjiPvEAa83pSTTFetAn//tXqnytPjt3tsYECfqgXNgjhydtUM1+qeMAh5c52ywaYRw
         L+7Nh8WCROezs9T7ycwPKco9KuZnKbhN4nmfC1yCFC8aSkkfvMPwhiAZd8oVdorm9xN4
         d0J/NR8LZdM7QtzFSA4v2nCAcPeDTmQTUPTOrWgGw5cyNFaBNVe1cxEqXlTdxhcsM8Mx
         7+/A==
X-Gm-Message-State: AAQBX9ckkfn0xiFrbRd5j/X3FdsuEdEHeBh30KcUzBGK6rN7qC4lpRfJ
        GshoZq8qgkDH2iXW8OMP91psEuTCRlc/POxS0PnqdSrNMpape8PSl9ZeY8RvdWsZsGdPuzGXDi1
        lEo9oQ/1VGJ218TGsr4gN25PztPuIIwuqEJiF1w==
X-Received: by 2002:a17:906:2c5a:b0:92f:d1ec:a7d7 with SMTP id f26-20020a1709062c5a00b0092fd1eca7d7mr2173267ejh.15.1680611218108;
        Tue, 04 Apr 2023 05:26:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y/ujbddqp3HjUAj9CzGSOJ7QQpVL596N3u1nc4MRlbgPCjte+OsmmKjlb86wYj09uLMnAtfA==
X-Received: by 2002:a17:906:2c5a:b0:92f:d1ec:a7d7 with SMTP id f26-20020a1709062c5a00b0092fd1eca7d7mr2173252ejh.15.1680611217810;
        Tue, 04 Apr 2023 05:26:57 -0700 (PDT)
Received: from amikhalitsyn.. ([95.91.208.118])
        by smtp.gmail.com with ESMTPSA id p18-20020a170906229200b00930ba362216sm6033056eja.176.2023.04.04.05.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:26:57 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init fails
Date:   Tue,  4 Apr 2023 14:26:51 +0200
Message-Id: <20230404122652.275005-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/x86/kvm/svm/sev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd9..a42536a0681a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2213,8 +2213,13 @@ void __init sev_hardware_setup(void)
 	}
 
 	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
+		bitmap_free(sev_reclaim_asid_bitmap);
+		sev_reclaim_asid_bitmap = NULL;
+		bitmap_free(sev_asid_bitmap);
+		sev_asid_bitmap = NULL;
 		goto out;
+	}
 
 	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
-- 
2.34.1

