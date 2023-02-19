Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D910D69C1AE
	for <lists+kvm@lfdr.de>; Sun, 19 Feb 2023 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjBSRZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Feb 2023 12:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjBSRZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Feb 2023 12:25:17 -0500
X-Greylist: delayed 32510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Feb 2023 09:25:13 PST
Received: from mailgate64.posindonesia.co.id (mailgate64.posindonesia.co.id [103.146.135.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721F412F38
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 09:25:13 -0800 (PST)
Received: from mailgate64.posindonesia.co.id (localhost [127.0.0.1])
        by mailgate64.posindonesia.co.id (Proxmox) with ESMTP id B06AE3A4E99
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 23:47:04 +0700 (WIB)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        posindonesia.co.id; h=cc:content-description
        :content-transfer-encoding:content-type:content-type:date:from
        :from:message-id:mime-version:reply-to:reply-to:subject:subject
        :to:to; s=posindonesia-mailgate64; bh=649KiAmEK3EsGtBHbs/5MjwXT8
        2WL00ODocS4Zkoqks=; b=WASVhP7gbCjxb5pcMJI61VLCZZe5GxDz64y/Ngcq6C
        cFRFVA+50jpdNferPovPikmJdgxHJQUXuhqSlotHynLho+/SjWlZPEySaGjUVKyl
        Xg4mnaxxk943SGkWpoQfdsKPAvPSGj6Kshb4uWTq6Zxd3v+UEBeJa1jIOAOPbQLM
        bykoMqPdBLXG/WlMCebYZVOpzTzwdALhD2A/1xwHNf/IZtAfMuHwKjFXfJ8m8ksK
        JkIERvdEDTG6g00ORyCVZT6QhQUaIdDf8QYZsIolhS4JYhd+Kk31MgnGrsBG6tRH
        JL/VeD5kFnZCV+O/1/fRVF/dDq7VhAmULSLTNbialo1w==
Received: from zmmtacloud.posindonesia.co.id (unknown [10.28.8.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailgate64.posindonesia.co.id (Proxmox) with ESMTPS id 98C0E3A4CE6
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 23:46:40 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by zmmtacloud.posindonesia.co.id (Postfix) with ESMTP id 344D31B6706
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 22:21:25 +0700 (WIB)
Received: from zmmtacloud.posindonesia.co.id ([127.0.0.1])
        by localhost (zmmtacloud.posindonesia.co.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 17ZKbZfOA-4f for <kvm@vger.kernel.org>;
        Sun, 19 Feb 2023 22:21:25 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by zmmtacloud.posindonesia.co.id (Postfix) with ESMTP id 65B411B870D
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 22:20:39 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 zmmtacloud.posindonesia.co.id 65B411B870D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posindonesia.co.id;
        s=E6824E3C-11D5-11EC-B3CA-F7EF1304C619; t=1676820039;
        bh=649KiAmEK3EsGtBHbs/5MjwXT82WL00ODocS4Zkoqks=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=fLKt3y+iaWcXWmaDLUaTL7nWugVzhiazFDEwofxksd5Pp9rI374dpVo1IFuWu6vcu
         /HHw+Hv5+6GLwtwfghK/nhfL63PYnfWyi+59TYjIZzqfjK02Yyk69hOgB+6luMhdxg
         Z+GyESFm02H6hssaEtVBq7xJhXyJ4UJk1uQLuyCmtxIUAL8ukLk7yo+nxwPeNXDKIo
         Al05IPoXVJHISuybh70hoZWSbT3FMJESnp2LWVz0necqV9H7CNYCnsa4UOg/rMY1Ii
         sZKAzKJSf1p1ZaSM7r/ln1s93dR5Jvdhp2VVP7LQUduGQur3eKpT8p039I8dKfqjG/
         VZ/sB1RhQDdhw==
X-Virus-Scanned: amavisd-new at 
Received: from zmmtacloud.posindonesia.co.id ([127.0.0.1])
        by localhost (zmmtacloud.posindonesia.co.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 62EsFQ9sYoS8 for <kvm@vger.kernel.org>;
        Sun, 19 Feb 2023 22:20:39 +0700 (WIB)
Received: from DESKTOP-IM7P72B.lan (unknown [102.132.157.225])
        by zmmtacloud.posindonesia.co.id (Postfix) with ESMTPSA id B44111B7964
        for <kvm@vger.kernel.org>; Sun, 19 Feb 2023 22:19:44 +0700 (WIB)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Is kvm@vger.kernel.org valid??
To:     kvm@vger.kernel.org
From:   "Hansjorg-Wyss" <900493628@posindonesia.co.id>
Date:   Sun, 19 Feb 2023 17:19:40 +0200
Reply-To: info.wfsrvs@gmail.com
X-Antivirus: Avast (VPS 230219-2, 2/19/2023), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20230219151945.B44111B7964@zmmtacloud.posindonesia.co.id>
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_BL_SPAMCOP_NET,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?103.146.135.223>]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
You have a Donation of $1,5 Mil from Wyss-Foundation. Reply for more inform=
ation.

Thank You
Hanjorg Wyss

-- 
This email has been checked for viruses by Avast antivirus software.
www.avast.com

