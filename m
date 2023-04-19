Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8B6E7AB4
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjDSN2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjDSN1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C333859DF
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so1450175wmb.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910867; x=1684502867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whKVeNhm2/WfA3zu2frln50fm/eIKX+KatcyC647UUQ=;
        b=DV/fNHDX0ZMlhe4V4S5gfOnqyYYsYVFwSPyIBZVKNMFXb78AOvqDmPD4SsHQNHwDV+
         GFPB1R5WhbUm/37KiE+MwWjj2AcoVbJRCMzx6mgcE3UOhK4F4LRq+iuOkhGQXaq8kMI5
         E0gnYC6mXM2dGfFkkgXLbP1+M13hlY1imYsCHXubjVzt+Zl1SUfJF6CIo8I3+tYSHa3V
         aKYS8nM8yOQNrldXV2PAF3pvOwLF/KSkIo0wciPBnlF0PKIsdvYbGc3sKPzFkkKY3Gej
         uiNZShtpbyT9oerFX2LW19kOsAKD+xtZMlNMNwzV3JZvCmOcn2dmHD7X2GeuV5hXLpwn
         qvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910867; x=1684502867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=whKVeNhm2/WfA3zu2frln50fm/eIKX+KatcyC647UUQ=;
        b=aQkqqvGAfZDgmgAzGuCCqUI+ris8R321ZFd9e3vkH2PshbCcPpoEAu5FL39APy5qOw
         e9cQeQbNrI7TDCQVEXRTl9uc93HQKqmITWtV3WyS80X8LhmJLhU/1AlsgYEOvg7HFshX
         vmE3J2Y0DG+LeEN22kPFH7brWCruGyDl+oaD7j6gF/iM7iq4yhN2IK7YyHwmCDpqxS0/
         GZ6+Zq5z0nGKvQleiipDHxZIF2ZCOj8+oA+ISRvp3/SRjPhqzc+z3ZliZt9jaJkrOws2
         d6fkV0PNtVNozHtkHpEqN7ZeCecT7eD7fPi2sGRpNCGuHf6Kxm+2/k70mvULWmxKb+d7
         I0Jg==
X-Gm-Message-State: AAQBX9eOJ6mQwdDA4osjVYXXBOakUcX3MwAYYVHVQHpbFOE2LyQe04TU
        2xtC2WPYnGt4rb5PoR6uW6tfGKAp2uFuytdxb+8=
X-Google-Smtp-Source: AKy350bWGN+fAZqwUsNHozqjs4Ra8wtNhThRPf1OYPNFXFd8wBF5WS867krnsy01o+qnODSXTnj7+g==
X-Received: by 2002:a05:600c:2103:b0:3f1:6474:c144 with SMTP id u3-20020a05600c210300b003f16474c144mr12061764wml.24.1681910867394;
        Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 08/16] virtio/scsi: Initialize max_target
Date:   Wed, 19 Apr 2023 14:21:12 +0100
Message-Id: <20230419132119.124457-9-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux guest does not find any target when 'max_target' is 0.
Initialize it to the maximum defined by virtio, "5.6.4 Device
configuration layout":

	max_target SHOULD be less than or equal to 255.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index f059fc37..fc1c2ad9 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -76,6 +76,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	conf->sense_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_SENSE_SIZE);
 	conf->cdb_size = virtio_host_to_guest_u32(vdev, VIRTIO_SCSI_CDB_SIZE);
 	conf->max_lun = virtio_host_to_guest_u32(vdev, 16383);
+	conf->max_target = virtio_host_to_guest_u32(vdev, 255);
 	conf->event_info_size = virtio_host_to_guest_u32(vdev, sizeof(struct virtio_scsi_event));
 }
 
-- 
2.40.0

