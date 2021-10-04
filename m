Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6994207E1
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhJDJKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhJDJK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 05:10:29 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D68EC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 02:08:40 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HNFJ50tk7zQjXt;
        Mon,  4 Oct 2021 11:08:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:message-id:from:from:date:date:received; s=
        mail20150812; t=1633338514; bh=iczBuNeKxMSt9GchG24tfrLadG0Q/+xNf
        DfEbX6n980=; b=cqAxQN0K8afO8vrx1KoypomXNAmecmlCZz5f74/CifebVpgx8
        WH6ibOkH18Giv4Hb6Oa4/e3WGpjLsCf88NgiVQrZP6DcTuJj2ZUXctTmRKZuDR7s
        c5qeCcQvMHpAuRS+EBZ9/boSu3A7MM/XgxkP8q4fAvKVHV6quGiaQwZUQHLts7ne
        CO2WKItUMU06tb7v6kaoOEhT2H4alOR+auWpvykzxyN1SuHUZLkNSCJUqvpa5eak
        3Un8chZIzpfGXh/9LJHKuevaG+rqKPLTOk0e47mHkzpiMJ7RTsa2I/l+yQ7ozDJq
        BozuRDB2ZUeuMwlkfxSLzzOyX/wj27Tf20J5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1633338515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+t7IKBWZmILIRTmMocEZj/h9XzhfaLlZiTzEL88EPGM=;
        b=WDwI3iPyyIWeaMkSL2N/7YBDrkaYWZ73qmZPlXcmuyDewWXtGSjry2WEBX0RZ40LVKlaj6
        RNnLklgjUkMzeK8ub2oH668PxEQmPM93izJvdpLIX/atqfwarBFnPtPx2EauYnf8hgTPdR
        Qc4MCvMpM3vpPjBVxGgYvG9gFuwqdqSr1KM+5HwuvU9sh8ccm/bf5D4p6vNSnFl4DGufFY
        Gex2blTyLCRFpcpFArUfRTO1vFhjtk5uMGDZdheRGk318xQ56yHKflyujjxql6twnwCc9c
        bQUk/8KRquqy0jcHQAfawPhDYq4wJS1/Toj9eRogVmL/QOK5pFwaCvZxcYcpvA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date:   Mon, 4 Oct 2021 11:08:32 +0200 (CEST)
From:   torvic9@mailbox.org
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Message-ID: <1446878298.170497.1633338512925@office.mailbox.org>
Subject: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: 01A0C273
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I encounter the following issue when compiling 5.15-rc4 with clang-14:

In file included from arch/x86/kvm/mmu/mmu.c:27:
arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        return __is_bad_mt_xwr(rsvd_check, spte) |
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                 ||
arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning

(no issue with gcc-11)

Tor
