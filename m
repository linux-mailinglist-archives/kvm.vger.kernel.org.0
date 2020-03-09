Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8696717E6CF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgCISUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:20:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37802 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgCISUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:20:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id a141so192786wme.2;
        Mon, 09 Mar 2020 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SzCDulvogxwKt7aiMDZq2QO3RMFcK9aQnem/Q86V3aw=;
        b=NEpL5p7Mww5MMTwqj2WaKdEvcPAPyYLssCOkEAYYcZm0ybpz9yNLeWa1E0aMiFPTGc
         E5cwlf2qPGq1SG1lkhgTXntrRhs7PsDPq/5CuDQr6i//wOiNQFKPosVBZFCY1sHTah5T
         BTCb1BMCOPCG08+Qjb8l//NzP9KIySAvUqgqH0rPQtjdePVeAvJIh6DFmjQcH0J2+g/P
         3QhwDFVQWMEqA9E9we3K4/yupllk2nZOlVJzsoYwW6TkWbpY2kNjREpDyuI1abwluoq7
         xHiEbi0tmWinhQfmPl6deIouCofUfPCs093L10yPVYhSgdpkBZ/ZMvUMfrbePZxmg5uc
         dlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SzCDulvogxwKt7aiMDZq2QO3RMFcK9aQnem/Q86V3aw=;
        b=V9pjoXMO76LwBAGBZmpdLyqwf6iDzj7Ec5VQGsI3SjzGONjEerP2u49AjKJ0/qW0xx
         F5etLjtpB220tAaVhDHbWmS/XjnjzBRNrnupCs+6lVQd9xAOtRAphDNE1GIz0STPgkDq
         9AjIy/hoPRcbGK2XhFuw+/Ljzncdg8J5IG4NDNMsoGVbs7vtBHhlSoPINfS40MFcxfzq
         UEHVOgxjADY8s+bTNeB8G/ciwB24SaOlAwOK1et8Fk3a0O0+SQ1DeUa/UjyP4aQ39GuU
         N0+guu6ZYhKks+vmRFbe7scZ1M73wCGDf4z+Oruqm9PXHATV7Yd/k5BbAPDnz68vHulj
         W90w==
X-Gm-Message-State: ANhLgQ14gHkGEZ3xgyWyP4qf+7sTcg4aGMXCCR3K8bdSUP7/mWhmiNzA
        Bogm0qaW55kAaPJ4no8BfDLt7ytiKz4=
X-Google-Smtp-Source: ADFU+vvETPKN726tkV16p7/ZwpuGoXi+/a91mzvJzrYld0P7/ARbZ8SOB/rI5omzHV8Pf4SKPhhL5w==
X-Received: by 2002:a1c:1f14:: with SMTP id f20mr510404wmf.61.1583778028100;
        Mon, 09 Mar 2020 11:20:28 -0700 (PDT)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id t6sm8371828wrr.49.2020.03.09.11.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:20:27 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v4 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Mon,  9 Mar 2020 20:20:13 +0200
Message-Id: <20200309182017.3559534-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309182017.3559534-1-arilou@gmail.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..7acfd6a2569a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -189,6 +189,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
+	__u32 pad;
 	union {
 		struct {
 			__u32 msr;
-- 
2.24.1

