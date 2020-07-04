Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B2214227
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 02:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGDAA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 20:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGDAA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 20:00:59 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258CC061794
        for <kvm@vger.kernel.org>; Fri,  3 Jul 2020 17:00:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p1so3866989pls.4
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 17:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=hx4Ii7Mu34eeKhr8zMFLfVanR1HBL8D7oPXDf/oi9fs=;
        b=cDWoh7IdXg5opxu3KRKfFQdEPPfQ7TbhB7VHzU91h59yo8IaeIOTXjO4NMqqsvQnZO
         Oiddbs4Fwzb9n+fM0h7ZRE/XQHI1GGO5ZRI7pSqNJEhRajMPBEl5lABEevhmSmeZq23Z
         8s1Z9TIWmDL5sM8WpZkQXfDkSqmVdE/nuKH737fpMCkEnFuhVO/EDywiQJnVt9LNfk+7
         UJriHmMr/CHOsKSa3tNXvPO6TA8YlmM+6ilFU8e5R0F/ynr/I8aNl1COdIBQTYQivigR
         NGjAPuU1DRBJHrh43Qh7PWRQEbVSPWrxElhIk99iE2GQa20IALx6+0okFGvwSVcdLzAy
         WkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=hx4Ii7Mu34eeKhr8zMFLfVanR1HBL8D7oPXDf/oi9fs=;
        b=ay50dl3hL1kOmIIHYM8YZKJHcbBmZQ+5NEwpDvvzW95VD8btnrGGAuCbCvGYxNNHR0
         pZzknnJ5DdDwqU3ANrHLoQqq4KyGt9gDR266KrtW/5IJ8v6Goutoiyp5PkhGOV9NTtzG
         DX5zFFfqNZcoGP69BOE/N1kLwfFLz7KPt2SdlCJHzmj6ouJVhUWTH+fR089SGcMoYhN9
         7TV/R2hin/Qgy7dj6ZwIZh8vV/L9+rTK0VCKEQH7MNBWlBCL5EDkBM2MOeZWU+lvTmXA
         UVKf5p+U8DbrXTqAq5wMVNzFxncM6/nTDQIC4FnUAItFiJoB2a+5C094klbROqhABf+o
         1uuQ==
X-Gm-Message-State: AOAM532OkIUanudvNGJNlzujWq7LpGaQw3eHo1yLTs7POnfUOg7EeWTK
        1YDbbmUmXbVDYyjXgg1OB7jwNfX8pUQ=
X-Google-Smtp-Source: ABdhPJw6viaj2yVH1WjGKFHDhQRGqusV/1cgtivQQJNRYJ2NrEad7ss5FPDb1OddoYIUqlGV1AnmSQ==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr14610897pjb.181.1593820858160;
        Fri, 03 Jul 2020 17:00:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:3d48:aafa:723f:edfd? ([2601:647:4700:9b2:3d48:aafa:723f:edfd])
        by smtp.gmail.com with ESMTPSA id 191sm12629874pfw.150.2020.07.03.17.00.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 17:00:57 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Question regarding nested_svm_inject_npf_exit()
Message-Id: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
Date:   Fri, 3 Jul 2020 17:00:56 -0700
Cc:     kvm <kvm@vger.kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

I encountered an issue while running some svm tests. Apparently, the =
tests
=E2=80=9Cnpt_rw_pfwalk=E2=80=9D and =E2=80=9Cnpt_rsv_pfwalk=E2=80=9D =
expect the present bit to be clear.

KVM indeed clears this bit in nested_svm_inject_npf_exit():

       /*
        * The present bit is always zero for page structure faults on =
real
        * hardware.
        */
       if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
               svm->vmcb->control.exit_info_1 &=3D ~1;


I could not find documentation of this behavior. Unfortunately, I do not
have a bare-metal AMD machine to test the behavior (and some enabling of
kvm-unit-tests/svm is required, e.g. this test does not run with more =
than
4GB of memory).

Are you sure that this is the way AMD machines behave?

Thanks,
Nadav=
