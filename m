Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0333CCAD
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 05:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhCPEpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 00:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhCPEot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 00:44:49 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C571C06174A;
        Mon, 15 Mar 2021 21:44:49 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h7so4027120qtx.3;
        Mon, 15 Mar 2021 21:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ln6IROcL0oqmiyWgZVylBCyeTAvDQnVtqaLoFG3jsSA=;
        b=Lkh6Qx6Q7o3RBAorjTjSkvKFkltnLwjRXu/3fiMeGJEQEMoLLu59QV6qN7aDvOo/21
         JnVdfWhhzEjz9Ytx66L0CDdqcIHYlV/H5cITChcr+ZvL/TtNtc3W79q807BHlHZNnB3A
         a1H+tR//ncYKigcDknno3igITuo7a55hTEivqGv77MnSjrx+3oOCng49rOD5UTt52NpY
         J4nVZjCyz5m+xCvT1cKOlffLFgHjUNPSpbOpOXY0bD+eBA+OxthhUL5jo+pTrpqEOEy7
         oXMKOVEiRdUfXS+GJHjbyIivWCQPgpTXXIuYLx+eyBsqxl3fACNx3MXb776Tm/7XB7xS
         LPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ln6IROcL0oqmiyWgZVylBCyeTAvDQnVtqaLoFG3jsSA=;
        b=h4nXQipthQ5VHsq9RetQ0CY+R0JS346n1d5KIA6a1D18Eqh+GHyrfCbT26O0qds/if
         ZVgxCiijjVdu3bQZW+2GVnx9G0hDdyN36emS/ya3Lhe1mRe8XB73lFQSbxCIaXt85Fhw
         OkEl9I0ol5IV7aPYEijjmFRmj2pywzJHd9VMWL/n9dFLIbqMjWnaell29hUa0J1VlrBU
         n3SSSzUS959wDyfHnNl8e8VfZ5Z6LVdF5PPJR0O1IOk1iFylAXBzcfLb2GGFKqtTYLv3
         U7RougDanxLXyMCZuUGYRiF4Z6YbKOD+EqZmXqXxzyZvbrwCNaWyJZzARu9rpRKzC11A
         Z33w==
X-Gm-Message-State: AOAM532PDROGGMuqLgfZ2zhcFephPn5nmAJlCd3aLRGUSZa0Wm1zI/9r
        wxKakbdmLhJMTzAeYV2Koyw=
X-Google-Smtp-Source: ABdhPJxRoDEvfZK3pGTpLK8ocuHyLorhAGB8PQ4JCJWBaKlabF+nz/DW1jipdHChWgkcJtt8glqz5Q==
X-Received: by 2002:ac8:6b8a:: with SMTP id z10mr6231616qts.243.1615869888471;
        Mon, 15 Mar 2021 21:44:48 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.45])
        by smtp.gmail.com with ESMTPSA id g14sm14306322qkm.98.2021.03.15.21.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 21:44:47 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] docs: virt: kvm: Trivial typo fix in the file timekeeping.rst
Date:   Tue, 16 Mar 2021 10:14:24 +0530
Message-Id: <20210316044424.3068802-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/extremal/external/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 But...Paolo,is it also "extreme"? I am in a catch-22?

 Documentation/virt/kvm/timekeeping.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/timekeeping.rst b/Documentation/virt/kvm/timekeeping.rst
index 21ae7efa29ba..932d7f7d1ece 100644
--- a/Documentation/virt/kvm/timekeeping.rst
+++ b/Documentation/virt/kvm/timekeeping.rst
@@ -299,7 +299,7 @@ device.

 The HPET spec is rather loose and vague, requiring at least 3 hardware timers,
 but allowing implementation freedom to support many more.  It also imposes no
-fixed rate on the timer frequency, but does impose some extremal values on
+fixed rate on the timer frequency, but does impose some external values on
 frequency, error and slew.

 In general, the HPET is recommended as a high precision (compared to PIT /RTC)
--
2.30.2

