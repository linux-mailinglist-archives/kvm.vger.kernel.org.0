Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FD942BF39
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 13:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhJMLvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 07:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMLvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 07:51:49 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1275C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 04:49:45 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id d11so2372717ilc.8
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 04:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=z6isDkEI3E3ryeoBkNCpwbTEvSUvC3t+kGhcRMWQh/M=;
        b=EeI59T3YprrX2AJbErMvXSUtcoS6xyc3gwVaC4fdr+3JJ1SHoMQY3HpeRBajfDE9h8
         OvuunxlAaiA5y/4WChdRoy1IXtBLN/QN5O+ABcq8nFxK/KFGKW7oBC6nrpuEbjahwUNV
         yva9S8DlSKA7CO+7inQmvJVJ+w6qqMq7oUBVj/4u4tkM6+Orw62nhyOPF7sHhsFGvwZ4
         Mt0vetW4LmiU+X3f0Gyn2gkXTkN3QYeIcQoHKB20mVxSFBewe2tDBIGskx62xpPQfRzj
         s0aQ5g4fKIej5EuWi+uTxOPaesQOZm/MNwnCEbnZ+opOiuijUfgIvILNSv2YY2a90pIP
         QTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=z6isDkEI3E3ryeoBkNCpwbTEvSUvC3t+kGhcRMWQh/M=;
        b=CutBncaVCJUge4nR18Ck4UX5KbIyXurBM/vBOmmnjOnIeWvTiKK9TEximTBey1fjoo
         F9tVGiUgh2YQkFTtgZdDIDmXHWB6eSIXVk91P+iER2YRExJZHmVzlrKTX8VgRjz+zjec
         YcXGEnp2qA6D9MK8qEsOCJIgCCS0jecxYzMK0ilwUzNqE/F99/7kxqsm9oog6bOheXB1
         DpQALx3ccmsSGGyk99FScFrlnJRfU1fhxOLPRwyYBMI5iAqt9TwKrJJSec/GLY76SIn8
         /6DfljN94FzDf9OPCrUD/HaX3Hx6ar4bUteRVqzcYD+oapHJoUg4vzfjOuMHn1ILTQ4Z
         tCGw==
X-Gm-Message-State: AOAM530V13kU3YqMUTQhn0JyJU4/YKtjehZAGhtp2qTn+luKfF4vhG1g
        hC5XcOgrXhxRVsFl007Z+iaB1dbwBmVeDY/W0rS1e4FgMTpIcg==
X-Google-Smtp-Source: ABdhPJwrY1l3jWghUrKisdCmTSJSkcrHRA6ljFpMf1NL2NCG/iG7n+qNpXmN66pAB2eNnjLVQ57NM1UziG4MSPNZ3u4=
X-Received: by 2002:a05:6e02:15ca:: with SMTP id q10mr27588352ilu.262.1634125784939;
 Wed, 13 Oct 2021 04:49:44 -0700 (PDT)
MIME-Version: 1.0
From:   Jan Heylen <heyleke@gmail.com>
Date:   Wed, 13 Oct 2021 13:49:34 +0200
Message-ID: <CAGszK3h6DcG_gefyFgGcbYuvNUV=Ss4=1-mg0hDwJLgYc4wtBg@mail.gmail.com>
Subject: https://www.linux-kvm.org
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

to do an edit on https://www.linux-kvm.org/page/Nested_Guests, I've
created an account on the wiki. However, I believe the email
verification is broken, giving following error:

"KVM could not send your confirmation mail. Please check your email
address for invalid characters.

Mailer returned: authentication failure [SMTP: Invalid response code
received from server (code: 535, response: 5.7.8 Username and Password
not accepted. Learn more at 5.7.8
https://support.google.com/mail/?p=BadCredentials u20sm7282588qke.66 -
gsmtp)]"

As there is no 'contact' information on the wiki itself, I think this
mailing list might be the second best option to report this?

kind regards,

Jan Heylen
