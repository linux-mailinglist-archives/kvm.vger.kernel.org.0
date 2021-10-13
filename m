Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC31742C545
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhJMPyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhJMPyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:54:02 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B305C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:51:59 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id g2so222178ild.1
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=z6isDkEI3E3ryeoBkNCpwbTEvSUvC3t+kGhcRMWQh/M=;
        b=X73h9M4bLar7XyTTEdSeMV8NhPRVs67EOhsxaIMUEjRkroxZMvf1XcBaJPW8GoKymk
         9LGgi0FXZA33hs2WYgRMbcu9MgBt4Enw+mBPRVulurfb8UZlYRPc+InkWGny/Rn4cnih
         7t4vLdQzSMIQW0swqbqgyJbf2pb4v7Eg70Nqmtq11ec3cO93THYH0/6oZFAtZ7nFn1Ad
         jrDPrZ34VKyk0hWKdxiv1s0TRw0fj54NM10mLPZUwdTfeC/TjHSzUIjLUkc1vyp3/hEC
         2r0rbcpvwC0pMtnctpOodDGhtE3AYHvHys8caWoIC0kgRQLr0HGT6QVZxUkw6h7D/TiU
         xnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=z6isDkEI3E3ryeoBkNCpwbTEvSUvC3t+kGhcRMWQh/M=;
        b=uPFaCtpt5NdxkhrmVxjEE5A/BuUMsW8g+pPn/DI57SBko7M5L9p7QpbuFiqXr1Bup1
         zKvRvHpgbUo2SdA2C19NxxioEnNTXYEHO8C5GUdB9qdwy51tgbxOXKohZwobUSZjNS4k
         dbozjVSio1w1XPhubOM1IztmCm4PAZIP+sgD5oAR0BIAUTLJF9feTEi4H/FwuhxU2lYP
         dP0foCWZflth/wKyOitieAffbZphetL4kQHNrWEISLeViiLkqEgSbhwdxl1DymNxwkxu
         OrKv3g0l3iNLU2Z9Q9i3yhPK/xcy475tCGQsAx3a5kDlnUtLRozgtGolhGG4J1/A9FoA
         glaw==
X-Gm-Message-State: AOAM530Kv+oAAzQWjBzFplrm294wcG7mO5K794TrrQ/cP2PEtYq7JpNt
        y8DBqFUXI5S+q/h53geTLNuWdAOdfdlZwFzNwKlaSw2ehaTvyg==
X-Google-Smtp-Source: ABdhPJwtLddvzt2vQ1iQsyWnNcxSryoRKoyaZQCn2Pt/avANyWbECgaTP7biCkvLunc1HQOtWFB1RTm0IvWjqyj1jFw=
X-Received: by 2002:a92:d2d1:: with SMTP id w17mr247407ilg.166.1634140318509;
 Wed, 13 Oct 2021 08:51:58 -0700 (PDT)
MIME-Version: 1.0
From:   Jan Heylen <heyleke@gmail.com>
Date:   Wed, 13 Oct 2021 17:51:47 +0200
Message-ID: <CAGszK3gTu2hEij9AVXbOySPLmCSYDD=vO-LppPWE2wUfH_2CFQ@mail.gmail.com>
Subject: www.linux-kvm.org
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
