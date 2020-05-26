Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D161AE4DA
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgDQSfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgDQSfE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 14:35:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1092C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t3so2728151pfd.5
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=10I06/r4iTnXuchMXI1U1SbADc47sHPNKITtLRQr7RA=;
        b=saLskT3+VVd25bTiJd4nN31vp+/BCCchUNT6BXsEaSltmwOLaytJWTUvOexw6uds1i
         KZ7796FcfscXYt7WOGeVlEyg+4siioMRbDMvZzsCCFBzV/aNyX7lEY1YUulz3ve/OMe6
         2fHBzCPOvybv3DP8Yy9rGXLvzb6XMFH2Nquf9GX58+PSFRIZvOeiXXiGkBjChYyXMXdf
         16p37jv4JFYe6+WStBLwKh4r66rQ4SldTXQ1SCGRSwdo5fXDEzHhAIZhEC5zeqg5nTrK
         vcERhtaaPlZ602Ah0r5qYRjQC8FP1TXstZUMjLtavd+fJz3tZrsOSACjggDbcX71wc1X
         06/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=10I06/r4iTnXuchMXI1U1SbADc47sHPNKITtLRQr7RA=;
        b=Cnpu4BB5cmraAfua85soHxbO2/uyRR8YInAy9atqhMM9llcN19uBUCLfWL6DesOLqV
         wdBjUm6WaRC1o/K22oaGzyfrDCCMfCT9GM/9SyFdTQJ1SzD4EafXdMg2bHGQbnkqVRy9
         17nZmmNGZFmEDP+/tMTkG77MH4/hQgN7Z/n25Frmwl2Pmz7cSLVzdoJaszi4t5N3/Lc8
         ZNpbbHRaboBXbLIpwAuwqXA/3PjGdhqySpDhSv7TV6t/PIo6f26zA17Z42EGPzTMmbyo
         hEvZSQUw6J4WjNmz1ih7hyFyHxwk1sQ3Nj7HS97Xv3F2G7Fgcx6svzqCuVaAjopZrkMe
         HyCQ==
X-Gm-Message-State: AGi0Pua68rPhHEQwmJXlV5OgBYmTPgmch/srWvr3Jqkg16r6DlQLHIvI
        MK/0uwAuNZtNHqlrUc3nwJJjCjM9M/zpIp8WaDHy9HGSocxlX96uGclU65a4I8aiKiPpNPEV5SK
        IS0HQFAiRO/GY++mU5GtcMh3R//SFPxOuD8jrITok6N+sXTmx5FT3qIdNXbYhk2gBXnK0GRdutF
        hR43s=
X-Google-Smtp-Source: APiQypK+ejrOVqpVq6jHDAWtC597DDwBUuk7xHj60xEd6jyuBeP78cAPpr3y+uUSldVXnesTc56rIh9btjg0Y/llD8U1LQ==
X-Received: by 2002:a17:90b:2388:: with SMTP id mr8mr5502296pjb.97.1587148504158;
 Fri, 17 Apr 2020 11:35:04 -0700 (PDT)
Date:   Fri, 17 Apr 2020 11:34:50 -0700
Message-Id: <20200417183452.115762-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [kvm PATCH 0/2] *** Enable VMX preemption timer migration ***
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

*** BLURB HERE ***

Makarand Sonare (1):
  KVM: nVMX: Don't clobber preemption timer in the VMCS12 before L2 ran

Peter Shier (1):
  KVM: nVMX - enable VMX preemption timer migration

 Documentation/virt/kvm/api.rst        |  4 ++
 arch/x86/include/uapi/asm/kvm.h       |  2 +
 arch/x86/kvm/vmx/nested.c             | 64 +++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h                |  1 +
 arch/x86/kvm/x86.c                    |  1 +
 include/uapi/linux/kvm.h              |  1 +
 tools/arch/x86/include/uapi/asm/kvm.h |  2 +
 7 files changed, 67 insertions(+), 8 deletions(-)

--
2.26.1.301.g55bc3eb7cb9-goog

