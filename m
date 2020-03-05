Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338EB17A24E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCEJgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:36:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46596 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCEJgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:36:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id n15so763240wrw.13
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 01:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Ye/O37MCIbzXLxyjF3VkWBXDADKZKKWQnOm/v94m10I=;
        b=EubDSzL7mn/zJ0WD35PgLt3hWlGyysVIFovIGNtRa0NkQiEMpGCCTRxAqSd2g6XtXy
         SEjVTFUbo+l5y4NAhf2406E7SFt0+QH5efMpDQZIstAKo2+lAVXSWw+8l8hSly9LwT7C
         ArLCWZpE8fUUlNAofOG0n6RZOJ6oZ/CcRx0vFS/z3uJR2esUNVGW0TCVBiihFTgUX5Q6
         bh0z/zym6Icrkvl7s6rmrUK0LqcVnslZb1HqMYMLV+uDDOR1bxVfgOPcJJuQnNmIRSMs
         bCE+cmRkc3/2B8AMULzDbKu9Moij8Lqsn8kf2noPgBOHJqCkLWrFxXeHq1QoH9nucOtV
         IKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Ye/O37MCIbzXLxyjF3VkWBXDADKZKKWQnOm/v94m10I=;
        b=pay1k0tjhacTX/2cD5Dl+hi31TTKkyGkThQHxrhEa8r20d3CGqqEZFTXSsjLhzKlCp
         d7axmb2zTTSwV+Qgc4P2GqwLgnIpKEXc0uc5QyoJzAWo78yvJBnmo7obQm+E3B11yYGs
         Q8NJcokadOhD7J8PXY3J42f+8/7kODmEPDnfX4luTlzGesWO7R2HbOnOdygGlCBm8zPY
         Zka9oFX4eAuzbspOhO3HTY2XfjrtpcL2bhq+IIoUE9+4HHboIQzgPGxQGp0hZadqo9Nn
         +iYMDTnAyUCWTXc8u3qFfPfjz49i+kzWfh/fySqSj+hQukBXvDp5GETx3BNJR6VSrJUA
         I+QA==
X-Gm-Message-State: ANhLgQ1IMDJZ66ASJsn1cCbhArYKKg3mXerTOWuVHjCI8tUlSasTXnT2
        kOyNonNTKhXeHTJMNFvM28pJ04SM
X-Google-Smtp-Source: ADFU+vvdQcT0HDnZ4IPn91n6VXteyRqke954CMMxgUoJbDnANUmD4AOsiqSm98Ew6ZNgpLKULkZu+Q==
X-Received: by 2002:adf:a2d9:: with SMTP id t25mr9012925wra.84.1583401008693;
        Thu, 05 Mar 2020 01:36:48 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w1sm8188563wmc.11.2020.03.05.01.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 01:36:48 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 0/2] svm: more interrupt injection tests
Date:   Thu,  5 Mar 2020 10:36:44 +0100
Message-Id: <1583401006-57136-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is just a cleanup.  Patch 2 adds more coverage of interrupt
injection, including running HLT in L2 when L1 does not intercept it.

Paolo

Cathy Avery (1):
  svm: Add test cases around interrupt injection and halting

Paolo Bonzini (1):
  svm: rename and comment the pending_event_vmask test

 x86/svm.c | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 157 insertions(+), 9 deletions(-)

-- 
1.8.3.1

