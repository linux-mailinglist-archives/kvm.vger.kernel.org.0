Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDDE3CC491
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhGQQug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jul 2021 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhGQQuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jul 2021 12:50:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62085C06175F
        for <kvm@vger.kernel.org>; Sat, 17 Jul 2021 09:47:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so9184531pju.1
        for <kvm@vger.kernel.org>; Sat, 17 Jul 2021 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XAXtFfFWf5f+/PXzysLaTvO6Dw1X1ZBXX13BrclTvo4=;
        b=fiYGCl/m5s3fBV5bsqvB+5v/3lbRBgvUOrMCqXvv4hiYFrqxTsVxeWJoczf3iBr3y+
         Q6TZq5tqclKxtxygY4plVTPOSL9VesVG55oMb1GEnet3f6pAUe7aMWNr38Yqt8FXHwio
         pftygZjyEYQeKwISzVm5EOE3cFlaVd5qGyfxrjbFSq37P9f80+8z42TMRrLUM19xUhsT
         U5zNossQ3ZBiannaoIofW5lrjs0WNrIfmegTeq9DysqPgO5JYuVlT/GlBafmzCN/cSUR
         +TGRYX4Sx3pQRZUc7A/SNc7WcFzW1vlwS9OoOfqHkwqhVB0tLicy/QPFdKqd4MH0xyOA
         6EDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XAXtFfFWf5f+/PXzysLaTvO6Dw1X1ZBXX13BrclTvo4=;
        b=iGKXz5VDhEiiW920Ag6fgEpZ9Bv24kRdboCh6/vGaHhNCUi0Lt7606tdttyDDmEXxI
         HWg2L1QxVW9TwhROf50vTtb1WI1vXavQ6w+5uybnvIVOlRkQiHoK6NODqnpHCuIsP2vO
         Cy9rovmoeK1BfXOjk1HOs6+s2vL2bV0pRrd1pLN65xqGZRNWd8J9JKzgGXxVQJheaJJl
         j2uyKxBObStbxrRbD5n+OrCgDWpqbbBTOPq0moKYbHCgC5ll8Ej45QhWKyMcdEfSMHfe
         s/SuCzZ4ZNAkWFd8S616GUy010f1zyosA4+YJhjqrngbR2XKFjSf6D/vLQnMEyhpkY9L
         bDdA==
X-Gm-Message-State: AOAM5311FqE9A1No/DGBqISxIC7F2mU3bdcsjHIDU6Xbe0Rrj7BaCNF6
        o+BQuCAM1SKgxiTPDSQlfkcW7rHA4tIP/nrjML3zi6KNTi4=
X-Google-Smtp-Source: ABdhPJysIlE21gThAIJOuN295c3PTQmipPA3Lq5y41zJFdAsrBsS0u+uYf5VDkfGAyRUgzu85CKFpiobS2PLall6DjE=
X-Received: by 2002:a17:90a:fa1:: with SMTP id 30mr1737459pjz.42.1626540457770;
 Sat, 17 Jul 2021 09:47:37 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel Martin <consume.noise@gmail.com>
Date:   Sat, 17 Jul 2021 18:47:26 +0200
Message-ID: <CADscph1andcLtCbx4ot3FX5xdQYjkTaQ1q5L0BHLJyjFaE6L_w@mail.gmail.com>
Subject: wiki: Mistake at page/Memory
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

https://www.linux-kvm.org/page/Memory states: "A single access to a
guest page can take up to 25 memory accesses to complete, which gets
very costly. See this paper: ..."

First, the paper url changed to:
http://developer.amd.com/wordpress/media/2012/10/NPT-WP-1%201-final-TM.pdf

Second, I can't find any "25" in the paper. Though a "24" in section
4.2.2: "... In such a case a TLB miss cost can increase from 4 memory
references in non-nested paging to 24 in nested paging unless caching
is done. ..."

Anyone would like to fix that? I can't, as I don't get the
confirmation mail, see below.

Cheers,
    Daniel

-----8<-----
KVM could not send your confirmation mail. Please check your email
address for invalid characters.

Mailer returned: authentication failure [SMTP: Invalid response code
received from server (code: 535, response: 5.7.8 Username and Password
not accepted. Learn more at 5.7.8
https://support.google.com/mail/?p=BadCredentials f11sm4498579qtp.85 -
gsmtp)]
----->8-----
