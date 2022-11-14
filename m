Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39ABB627949
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiKNJo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiKNJoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:44:55 -0500
X-Greylist: delayed 432 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 01:44:55 PST
Received: from relay.mgdcloud.pe (relay.mgdcloud.pe [201.234.116.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498BE192B9
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 01:44:55 -0800 (PST)
Received: from relay.mgdcloud.pe (localhost.localdomain [127.0.0.1])
        by relay.mgdcloud.pe (Proxmox) with ESMTP id 128D2229817;
        Mon, 14 Nov 2022 04:36:33 -0500 (-05)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cgracephoto.com;
         h=cc:content-description:content-transfer-encoding:content-type
        :content-type:date:from:from:message-id:mime-version:reply-to
        :reply-to:subject:subject:to:to; s=Relay; bh=POmmLhbs6/14Mhmcbsw
        HpX0H+MIlo+W0e6cG8XDkBG8=; b=kVGemHP2Ezq2C1j2GPEqAS9hLjvLaaFyuUx
        twbprDAfDDMwoBbSe6uAoJHoYvwJ/xFVpACDKYmYszFZV9oModvACCmHQHLZfKGF
        EdJreSY6oCZA72Tumf8pUsz2r1o0zmqxiNs61auvAKTwMOjKkwmc8sSWJqmY6Vvq
        J6aoZK/oBtzHNwt5T4F5qaeCmD9hdd1XI95OOvH4Q2swbvFd+aaUcBgUBHfFoTv0
        jklcFM8eqvGbA6kT6yZfBHJUlmXfNw5C8RIjlsHxZ2IkIAdkKnauRNv6xJjomklR
        qacR6rPyBQ/XCL/wgpjiaMj8kdVTpGlX07L8MF6KfDTTslubDVA==
Received: from portal.mgd.pe (portal.mgd.pe [107.1.2.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by relay.mgdcloud.pe (Proxmox) with ESMTPS id EDD6022980F;
        Mon, 14 Nov 2022 04:36:32 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id CD00120187D81;
        Mon, 14 Nov 2022 04:36:32 -0500 (-05)
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5YqyzD5cKZDK; Mon, 14 Nov 2022 04:36:32 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by portal.mgd.pe (Postfix) with ESMTP id 819C620187D83;
        Mon, 14 Nov 2022 04:36:32 -0500 (-05)
X-Virus-Scanned: amavisd-new at mgd.pe
Received: from portal.mgd.pe ([127.0.0.1])
        by localhost (portal.mgd.pe [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kSCWoesmlOxX; Mon, 14 Nov 2022 04:36:32 -0500 (-05)
Received: from [103.125.190.179] (unknown [103.125.190.179])
        by portal.mgd.pe (Postfix) with ESMTPSA id 3EB2D20187D81;
        Mon, 14 Nov 2022 04:36:25 -0500 (-05)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Strategic plan
To:     Recipients <cindy@cgracephoto.com>
From:   "Mr.IgorS. Lvovich" <cindy@cgracephoto.com>
Date:   Mon, 14 Nov 2022 01:36:25 -0800
Reply-To: richad.tang@yahoo.com.hk
Message-Id: <20221114093626.3EB2D20187D81@portal.mgd.pe>
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,HK_NAME_MR_MRS,RCVD_IN_SBL,
        SPF_FAIL,SPF_HELO_PASS,TO_EQ_FM_DOM_SPF_FAIL,TO_EQ_FM_SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello
I will like to use the liberty of this medium to inform you as a consultant=
,that my principal is interested in investing his bond/funds as a silent bu=
siness partner in your company.Taking into proper
consideration the Return on Investment(ROI) based on a ten (10) year strate=
gic plan.
I shall give you details when you reply.

Regards,

