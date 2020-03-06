Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0717C31A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCFQjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:39:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33705 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFQjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:39:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id x7so3139610wrr.0;
        Fri, 06 Mar 2020 08:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqBaz7Pqcjvqd8BzE+nwXVxffgaDXzbn0ymPrZ8bx5I=;
        b=ZNWeuQFwBIvTe8w5V1YJ7K5Z6Uu46S0ZxGEZAY4hVwRfR305Iu/gbeKfetnAfBNPgI
         8DzwxVoXrZUQ2NFGEq7plXlQHolqW+qSNR4ehqjlUNm3bdhyFOSeuMVVHh+U/PduMNlT
         n75b04c8DeJbXpcl18LinJ07xHBbS0Rhx1cuOSvwnxYK7r6Op4Aub+IAkwSQRC8oqs5/
         tx6OeVom0IetxxCro0quRNTy+T3ypiGa26ogoaJsPjnKm9ZWc67GqVPf1IDz777fSQwm
         85TPnF34t+l25w63hgf6ek3xBpPXp08T7mHZiqz/wD8c+1ca5TASle1ytUTGZV7afNIq
         9Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqBaz7Pqcjvqd8BzE+nwXVxffgaDXzbn0ymPrZ8bx5I=;
        b=N24onkn78bekmvRkr+j0aTAkL6M85MIJhjeg2aRK6zbm60/++gNR1S9iof2EloA40L
         Zo6Lk1h2d4SloiHLZrJvnplg8oUg3NWDbqwKvAhFbAeyRmQvWKb95h1wIrQcASKGIcGP
         yKuU43Jlt4q1uohruKrbI5wi17l4iDhSZ0u77R+VmbXqbd0AHv3AMwv3qQ0NIls0swUi
         6EyuLEoJ69UtUp0kkThoFfzHvanN6tx3ZXU9kIFAxqqMm9orwg/5cRL7Re0qMVEw/E8W
         1hL8M7zo9TEozU+bnB+Qe/HwN7JwQs2XHv0fJ6IoQvrB1QC9LPjMyZjpIrdeFV4Tax/S
         xEQw==
X-Gm-Message-State: ANhLgQ0klXP/Q6RZHoUeSRDM7r8uFsX3Xn5USXyV0yypCPoz/G9ukaFl
        HAykQCDQ6OzMnPjS1bb8OdOYG5s9
X-Google-Smtp-Source: ADFU+vu8PM8BfB/3tnpmAnl4QkKt8nOdKP/pQ6jqE9wlHwfOK4XvbbLSVru+j194LDNaN8YJVuc/lQ==
X-Received: by 2002:a5d:410a:: with SMTP id l10mr4491955wrp.380.1583512750017;
        Fri, 06 Mar 2020 08:39:10 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id n24sm8812760wra.61.2020.03.06.08.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:39:09 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v3 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri,  6 Mar 2020 18:39:05 +0200
Message-Id: <20200306163909.1020369-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306163909.1020369-1-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com>
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
index 4b95f9a31a2f..24b7c48ccc6f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -197,6 +197,7 @@ struct kvm_hyperv_exit {
 			__u64 msg_page;
 		} synic;
 		struct {
+			__u32 pad;
 			__u64 input;
 			__u64 result;
 			__u64 params[2];
-- 
2.24.1

