Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062D4CDCDE
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 19:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiCDSpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 13:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiCDSpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 13:45:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 675A01D06E3
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 10:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646419456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EmjO2s/UE4WN1n8czSG/KMxEFj+XCRHlp7UtBZB8uLs=;
        b=Mvu2Yw0y+q78fkJ0x2LupHoU17b4OsPUiY/wQmPccvwzs3tTQeoM+8H1t9sGIudifYeZD8
        eP4QHV+RTV8MoyAdGXoaKjCsdppZJv7zGKTJ8M5euJrR2qwOZQvtuAu8/ZiVV8KrrWxtUO
        6oz9tSUHwau4pN/S6lKvI7wqbsXePw4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-ZQ9o41lmMeKmncF4FhI7hQ-1; Fri, 04 Mar 2022 13:44:15 -0500
X-MC-Unique: ZQ9o41lmMeKmncF4FhI7hQ-1
Received: by mail-qk1-f197.google.com with SMTP id k23-20020a05620a139700b0062cda5c6cecso6211886qki.6
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 10:44:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EmjO2s/UE4WN1n8czSG/KMxEFj+XCRHlp7UtBZB8uLs=;
        b=voM5SZ70XGZhZ4aePR7iLjFN0BMtIaHZJygEX1FCC46sk/VyJzDlG3NlKhFPKFnTDi
         Cq2bLz61gRXEzUPHVNGTC2a3XzXMB4NKanufghgbmvouYdvjrqgalXmC5AVYBvnm2EBD
         QrGsZ7PORCiWNZyJgw2bhiWIOVUzposgjOgnPfIog3GDLSVifzhWKH64f1C0Ayox/dUU
         O1tc12gV73kjlx2tgVfJpwZ8R2JOqbNYUqxt/4Djhpope2rar0F81KnmnOeNXqi+911T
         atg5Q0gj6HIqQu2qe4x4fUuM7cRG8trtS02LvX7vAAruTh3v6b2tPmOZEHFvLUeDOjiJ
         KoYw==
X-Gm-Message-State: AOAM532HUosXFUTabNSwE7iwECDYKXNIoEEf+wmhRl2rRP/+lOyCBJXM
        tcJHGT4sIxTruv7w+Tok8Sava6Am+htMsx8ki04cbHOgKBTNKWfSbqDRlqzprtFxBJzhVdyNi2+
        763abZkBZVWQ1
X-Received: by 2002:ae9:ed06:0:b0:662:f250:195a with SMTP id c6-20020ae9ed06000000b00662f250195amr3494287qkg.471.1646419454715;
        Fri, 04 Mar 2022 10:44:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlOh0MWWmR63bDrwguqRku4B7//dRqe5Ce4quEFaf6bml5LdfhTnSK3EUd5JVZsWccUdctww==
X-Received: by 2002:ae9:ed06:0:b0:662:f250:195a with SMTP id c6-20020ae9ed06000000b00662f250195amr3494278qkg.471.1646419454514;
        Fri, 04 Mar 2022 10:44:14 -0800 (PST)
Received: from fedora.redhat.com (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id f14-20020a05620a12ee00b00508b2c61482sm2725837qkl.25.2022.03.04.10.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 10:44:13 -0800 (PST)
From:   Tyler Fanelli <tfanelli@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        Tyler Fanelli <tfanelli@redhat.com>
Subject: [PATCH] i386/sev: Ensure attestation report length is valid before retrieving
Date:   Fri,  4 Mar 2022 13:39:32 -0500
Message-Id: <20220304183930.502777-1-tfanelli@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The length of the attestation report buffer is never checked to be
valid before allocation is made. If the length of the report is returned
to be 0, the buffer to retrieve the attestation report is allocated with
length 0 and passed to the kernel to fill with contents of the attestation
report. Leaving this unchecked is dangerous and could lead to undefined
behavior.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
---
 target/i386/sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 025ff7a6f8..215acd7c6b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -616,6 +616,8 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
         return NULL;
     }
 
+    input.len = 0;
+
     /* Query the report length */
     ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
@@ -626,6 +628,11 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
                        ret, err, fw_error_to_str(err));
             return NULL;
         }
+    } else if (input.len <= 0) {
+        error_setg(errp, "SEV: Failed to query attestation report:"
+                         " length returned=%d",
+                   input.len);
+        return NULL;
     }
 
     data = g_malloc(input.len);
-- 
2.31.1

