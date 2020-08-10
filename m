Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C36240660
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgHJNGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:36 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47958 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgHJNGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7647C4C896
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1597064793; x=
        1598879194; bh=sWuddOVPDvXfJUjGYXEIMMJQ2ajk7Sl7THo/L3AauQs=; b=p
        5/cAd4/QMDcvC1neBKCFYM31J1HqdHZQ+5AV6F5u3KJQoOd2rFdMYrv6kYjqW+fO
        RSKlCwUWZ+OupDpipyX0+F+4fvAZE3ni9FccuhWahuB+VAAOcP/e9xgx2AVSeB3f
        Q56Df8cvBFi3tFQw/hnxwQnANKhRXsvtE1VxIImk9Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JSl9qkysC0J3 for <kvm@vger.kernel.org>;
        Mon, 10 Aug 2020 16:06:33 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4D9464C667
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 16:06:33 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:33 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH 0/7] Add support for generic ELF cross-compiler
Date:   Mon, 10 Aug 2020 16:06:11 +0300
Message-ID: <20200810130618.16066-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series introduces a way to build the tests with generic i686-pc-elf
and x86_64-pc-elf GCC target. It also fixes build on macOS and
introduces a way to specify enhanced getopt. Build instructions for macOS
have been updated to reflect the changes.

Roman Bolshakov (7):
  x86: Makefile: Allow division on x86_64-elf binutils
  x86: Replace instruction prefixes with spaces
  x86: Makefile: Fix linkage of realmode on x86_64-elf binutils
  lib: Bundle debugreg.h from the kernel
  lib: x86: Use portable format macros for uint32_t
  configure: Add an option to specify getopt
  README: Update build instructions for macOS

 README.macOS.md        | 71 +++++++++++++++++++++++++-----------
 configure              | 13 +++++++
 lib/pci.c              |  2 +-
 lib/x86/asm/debugreg.h | 81 ++++++++++++++++++++++++++++++++++++++++++
 run_tests.sh           |  2 +-
 x86/Makefile           |  2 ++
 x86/Makefile.common    |  3 +-
 x86/asyncpf.c          |  2 +-
 x86/cstart.S           |  4 +--
 x86/cstart64.S         |  4 +--
 x86/emulator.c         | 38 ++++++++++----------
 x86/msr.c              |  3 +-
 x86/s3.c               |  2 +-
 13 files changed, 178 insertions(+), 49 deletions(-)
 create mode 100644 lib/x86/asm/debugreg.h

-- 
2.26.1

