Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9C9799233
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbjIHW35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343662AbjIHW3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F91FCA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7b9eb73dcdso2315814276.0
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212189; x=1694816989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUDCny58mTjAasfc+MarJfyUNBk+L++E3fgqNSlzCZM=;
        b=Tz8Ij39sAhMoqv2md0g7WLo/lHpSHXIh6YizjemCheGXJgwqHBOUzHkyShWJYNnrna
         GEkbVohqV8sG9PscSMn7xMmqyAbosa6E1tqJdiVC/wi+iuCWDxV1zFg9AK3WNlnXOfuc
         XyIRzOC2GAkMfv37DW1q8RXSNgwO4bSNfZl0INOhigQdpgcYku2y/JKb11iqlrGE4NzR
         30FfShtJb9Ns77J0axmbbvBS00GMkQPYCdRe+WiXYLCeT1ozTgkuOsIs4NjR1DaTO5Ot
         +R7vqgdZx/ZEzNLd3Vn7qwPEK1BENYzsLyLVnA4pZJcu3dC1z1sd+z1iRByD/o2cr6/K
         PB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212189; x=1694816989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iUDCny58mTjAasfc+MarJfyUNBk+L++E3fgqNSlzCZM=;
        b=p7xQYMVQV3KdmqEIbMt1EL+8P0IZ3O58Ck77VBZZBXedSVWzZs5Qbmyly2ObLb6ubO
         V/NS33TM0rLRHrqU5eevrhbZBgwnrIDuBPSFhmDK3Fr213eYrwp9VAMmzw1NLYW0OmuD
         xlU/+h23yOGALuyspeKW+9f/3McexYG1+/PKQPVS+5sgZ6DFgFB+y1SQvuoI0EmzyVzN
         odYrapM+NdHWXz+kYHa0mCfjE5Gyvw/RA7WdJi/MwK9oJSDpZXKMPjg01c0/wstwWuwc
         Bx7p1IZyQ6fMnyLkq/Po2XVr5txqs01JnM+n/W357mA5IRA+chqjwbg+3xU48Q+Ave/d
         +l8A==
X-Gm-Message-State: AOJu0YxrihdTsPmtHZf0OkDWOVZ1C0SCVmM2rvU04jzBZCYrBIGOGdW2
        wAW4R9PaM6q7aOBsjyn+C50ei51/u9f5EQ==
X-Google-Smtp-Source: AGHT+IEDvILkGVKALVwPWgXNiW3g6dYyieYFxOwYXxGieU/y+z8cJi+9eCRUi/zrcXi4OV1bNd39rVDx4ol+Xg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:df13:0:b0:d7f:d239:596 with SMTP id
 w19-20020a25df13000000b00d7fd2390596mr82253ybg.0.1694212189354; Fri, 08 Sep
 2023 15:29:49 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:48 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-2-amoorthy@google.com>
Subject: [PATCH v5 01/17] KVM: Clarify documentation of hva_to_pfn()'s
 'atomic' parameter
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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

The current docstring can be read as "atomic -> allowed to sleep," when
in fact the intended statement is "atomic -> NOT allowed to sleep." Make
that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d63cf1c4f5a7..84e90ed3a134 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2669,7 +2669,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.42.0.283.g2d96d420d3-goog

