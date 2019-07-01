Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4404121E5
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 20:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfEBSby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 14:31:54 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:52722 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 14:31:54 -0400
Received: by mail-qt1-f202.google.com with SMTP id j49so3241459qtk.19
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=okXbexY+Y2xp9oLAu3+3XZ342ITCS/Geblf+IL5xk/w=;
        b=pbQzwO+d1RQNbfEm2sme1NWRnMDzrPkZZLBIBSuyeZ13oHlQmIpuWS5zYzxRBB2+hz
         ewIRhNo/u0Q6TKWeAPwYCsQ/Nq7hPAdqm58mqE2nh0oAyq1+NaX+ZcSpNgZcmzohp1v0
         8g2htxM7vb3kCrGZFllfc4+yOIP797CMaPbZXFH3XhJxgsjbAGKdWCtIpQxQkHoF4LSD
         leSTN+66l/WlMMgMFjD5c/cE8pl2CZKMCF0R9+H8xDVWtaqKtVL5cXxFlWTkvqg1KcY7
         QTwGOMwMQkQ+NvPwJaay/1v9YYOLJrtyDtGvQJ9oCDt4EV+aYE4ekkx83iIQgSGmQriT
         GvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=okXbexY+Y2xp9oLAu3+3XZ342ITCS/Geblf+IL5xk/w=;
        b=N8rfEA5GPczx2dmT5Ssb8vD7xXqlg4nKe96z+SkMJL4mLfYfzKcn5LhSW2EJ4qFX89
         ahKZlq1IDnOdq0GIqVkqjb3ph4mRvqDM7YCJcWEpooHzC4cvH+Ya6t4J3PYnxyBeFMCE
         CIm0iIddN8jzTJD/2LgKRYjmlcP+e9vIh/buZgMHQvRWRwsCwE/Io/VneZSe49BScwR9
         HIeo2uL8rpO4mhYrzsGkfz5OSpwk+/+YoKTvMPL5ParWR752cLVXoiN1sAAoSxaOEuio
         pO531xh488KuAJxpQ14fWB2Hz/4GUWgYs1sqhIDNRLrEvtJlaCzMzWkeU98gu6A0joSI
         oxGw==
X-Gm-Message-State: APjAAAW0L+kdJeQnLJLzPWLP3S5Hnd9ptQQi8Qrn/63lMfTIU5Z4eqyQ
        3dX46P9yRkzDDmc1IWXL8HXBtD9aAZbhQPkC
X-Google-Smtp-Source: APXvYqx23/6kvvc8+SSWqL8oZ78kLSk6Iz5LjXfooeKMyTyziHhNh12Z8wybYmuoyhguoo60+edzrfR8eXc9HxhO
X-Received: by 2002:ae9:c109:: with SMTP id z9mr4080844qki.309.1556821913561;
 Thu, 02 May 2019 11:31:53 -0700 (PDT)
Date:   Thu,  2 May 2019 11:31:50 -0700
Message-Id: <20190502183150.259633-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH] tests: kvm: Add tests to .gitignore
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2689d1ea6d7a..391a19231618 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -6,4 +6,7 @@
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/state_test
+/x86_64/hyperv_cpuid
+/x86_64/smm_test
+/clear_dirty_log_test
 /dirty_log_test
-- 
2.21.0.593.g511ec345e18-goog

