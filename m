Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470B038C265
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhEUJAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhEUJAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCDEC061574;
        Fri, 21 May 2021 01:59:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 69so10621788plc.5;
        Fri, 21 May 2021 01:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3yVIvqG1JyVADZbEfVpibeclSnVPEq1FjsSnqb72wTc=;
        b=caBpAi/U0Iw0NsZBGSpnZsUmuBjorpbNtdbB2BbnqIWsMc/AtMZOiQL7iWZ0JipP0a
         tiOHopCpQ5nlzMNHuTzbFrT2HmQpo6K6JCoV1/FBEWNVIrFDD1Z8ZQjVCtNt7xy8SYLN
         swknq+6kJOrd1jz6/AbBcSeFvsDPRTCMLvCeiCv1rVb2+lUOKt21TgUZVUNPKW9yK5xn
         xP5q1+DU2ksBhFts+K8XsQKCPgp3L+YybMQYyJE15ISaXSH2xgKYM5JSvjelfqztMwrc
         cQY97GJby/SdpBcPGfoSM0i8KUyFcAzND8MkcRU/BmYVLKnPybY1kDiQIpkShrac1nZm
         fYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3yVIvqG1JyVADZbEfVpibeclSnVPEq1FjsSnqb72wTc=;
        b=nLFpCJN23lMtMegMLrOdfhAAA6Hh0CWRkSfGxbziK6XZF3ls1sauDozbQmCvmh97zX
         ytoP1yuQWMe3A/ai+HDmGCPsfUvgvpbxs24FD/4J3w6cHT8HyXYSkykXBMnmBMa9zrjA
         UuxTqQNfWdcVR2pz3OoHoIWmaUIvs0i9LE0RnB79SpStxLNxorw04O/0kHZpAsjUAqaP
         2dVMY+ZLlT1TDYuLap5Rxcc4D8ZO6bX4jQOWx/qQxOtQljI7LtgUYiyV+4waIUR2kzS5
         oNY/Egv4fFAqEbhVZR1NDBTYF1yP29l4fsS5ISjiG3MO1dK8AcxZBIRYTWc6g1iJPusU
         VN9A==
X-Gm-Message-State: AOAM5300ZCRVsSsDzP+kD3ZFDlZiKXN5x98wPP/tz9bFQbOdgMFGgJ0T
        UIJN4f+ISIBVed/Fxw50S54=
X-Google-Smtp-Source: ABdhPJxPN1UZLO0PXhLTlf5qR//s8n68GRwyK+x/ityD7Qg25LhfVT+kgYl0HAV2wRFoergfO/9U1Q==
X-Received: by 2002:a17:90a:5309:: with SMTP id x9mr20007pjh.111.1621587555532;
        Fri, 21 May 2021 01:59:15 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:15 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 0/7] Don't use BIT() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:41 -0700
Message-Id: <20210521085849.37676-1-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

The BIT(n) macro is used in the kernel as an alias for (1 << n).
However, it is not defined in the UAPI headers, they should instead use
the _BITUL(n) macro. This patch chages all existing usages in UAPI
headers and updates ./scripts/checkpatch.pl to properly reccomend the
correct macro depending on context.

Running the below commands shows no more incorrect macro usages:
    rg "BIT\(" **/uapi/**
    rg "BIT_ULL\(" **/uapi/**

Tested by building a basic kernel. Changes are trivial.

I encountered this issue when compiling the following program:
    #include <sys/auxv.h>
    #include <asm/hwcap2.h>
    // Detect if FSGSBASE instructions are enabled
    int main() {
        unsigned long val = getauxval(AT_HWCAP2);
        return !(val & HWCAP2_FSGSBASE);
    }

Resulting in the following likner error:
    /usr/bin/ld: /tmp/cceFpAdR.o: in function `main':
    gs.c:(.text+0x21): undefined reference to `BIT'

Changes from V1 to V2:
  - Use _BITUL() macro instead of open-coding
  - Fixup HWCAP2_RING3MWAIT as well
  - Shorten commits and added "Fixes" per reviewer comments
  - checkpatch: Broaden UAPI regex
  - checkpatch: Reccomend _BITULL()/_BITUL() for UAPI headers

Joe Richey (7):
  x86/elf: Use _BITUL() macro in UAPI headers
  KVM: X86: Use _BITUL() macro in UAPI headers
  drivers: firmware: psci:  Use _BITUL() macro in UAPI headers
  uacce: Use _BITUL() macro in UAPI headers
  media: vicodec: Use _BITUL() macro in UAPI headers
  tools headers UAPI: Sync pkt_sched.h with the kernel sources
  checkpatch: suggest _BITULL() and _BITUL() for UAPI headers

 arch/x86/include/uapi/asm/hwcap2.h   |   6 +-
 include/uapi/linux/kvm.h             |   5 +-
 include/uapi/linux/psci.h            |   4 +-
 include/uapi/linux/v4l2-controls.h   |  23 ++---
 include/uapi/misc/uacce/uacce.h      |   3 +-
 scripts/checkpatch.pl                |  16 ++--
 tools/include/uapi/linux/kvm.h       |   5 +-
 tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
 8 files changed, 148 insertions(+), 36 deletions(-)

-- 
2.31.1

