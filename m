Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FCF4CA12D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 10:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbiCBJsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 04:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbiCBJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 04:48:17 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9EB2AC40
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 01:47:30 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id j5so1024869qvs.13
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 01:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oVymzacBmHlfSEBN0NUcViscc1BlJREjJA6+b6RGOmg=;
        b=QWdde23KNX46k7WkqryQHz1i3nNKX3hJ6bUw0DjcHiOt75WWu7w5auh04nLkT/xnOJ
         R0VQHYTpPb3pK1dC5Q61RFQMwi4trskiEVa2TQn04UuisHYWibAazS7ATmu54TIBxXdA
         5lK9Ys3nLH2M+OL5YbUWmBjXKkfNKuHDhT335FY7373hVh3ljtDU7hufDm+HoFdxRSC5
         irTZ1zsjvdJCrCgb+ck2wdaojqCCFwevHlYpXu0UnAPPXOqgUXh+Q4uM4deQ12SqSBxO
         anQ3SzaZnzqNuLNM3DIBa/tSUB0jwrQxi9OOPrEA2SXa6sqI0YSXgXVQjBwH2TaK1Eg7
         1gOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oVymzacBmHlfSEBN0NUcViscc1BlJREjJA6+b6RGOmg=;
        b=3+mZiIgNdWYFkPOlfFwsECP/E2qiyfgIMcZMrGc5/LRoAaHul0ysJ7+VQFtfM1VSno
         39B046CBuXjYxpKqVfJvC5tPtKlCQQ7CZv0szOgIb5k89XKGzAjYaI7F7sREw6bay0gx
         fa2efsxu+8Af8Fc43TuDC7iNPPONdyO97Sjinr8JQTWG64wMhKqqTDKF4zImaDLd07ji
         Jf1JspD0TASWrRwlNwiF2sPkDWwAm42w7ctU9f47zXkqEmFq4+xaUxt866BHuIjrDPRv
         kWJVxdMjCmFfUGirDLofsS9sPznMnDNclBXeURlXCucw2brTiyDfTWrSSshhlW3p7LuO
         J6Bw==
X-Gm-Message-State: AOAM532EesPFKaSov+ywlDxLJF1CKK2wCK6a8EMdDJb9ZhL7CVCFGA9e
        S/bY3XNRqPWfiamL8tgHRK5JJy3x8Rtpuk2Gzmk=
X-Google-Smtp-Source: ABdhPJwbpxn+o5lpNUFUhQmBWdx4hvUvkX98PANWZ50On8S1tPm3b2kQMdzMgrFsQtUtHu3RHExhB4D+i2WeoxrhN7I=
X-Received: by 2002:a05:6214:f2d:b0:432:dc5f:ea15 with SMTP id
 iw13-20020a0562140f2d00b00432dc5fea15mr14989081qvb.81.1646214448456; Wed, 02
 Mar 2022 01:47:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:5443:0:0:0:0:0 with HTTP; Wed, 2 Mar 2022 01:47:27 -0800 (PST)
From:   Anna Zakharchenko <fpar.org@gmail.com>
Date:   Wed, 2 Mar 2022 10:47:27 +0100
Message-ID: <CALr0R0oEzU-WF+OhADUDAnG2qytOv4T7_0dX6YBZoqPbR=3=NA@mail.gmail.com>
Subject: Re: Help me in Ukraine
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,


I am a Russian widow trapped in Ukraine's Donbass region amid Vladimir
Putin's senseless conflict. During the 2014 battle in the Donbass, I
lost my husband, a prominent Ukrainian businessman, who died without
having children with me. I am currently in an underground bunker in
Donetsk Oblast, a separatist war zone recognized by Russian President
Vladimir Putin. I urgently request your assistance in moving my family
trust fund worth =C2=A33,500,000.00 from the UK to your country to prevent
European Union sanctions from seizing my money because I am a Russian
citizen.

Please help me save and protect this money. You will receive 30% of
the total money as a reward for your efforts, while you must keep 70%
for me until the conflict is over. For more information, you can
contact me directly at (anna@sc2000.net).


Cordially
Anna Zakharchenko
My email address is: anna@sc2000.net
