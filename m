Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0064EC9B
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 15:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLPOGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 09:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPOGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 09:06:31 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19A72F00E
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 06:06:30 -0800 (PST)
Date:   Fri, 16 Dec 2022 14:06:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1671199586; x=1671458786;
        bh=s/0Ra5jxrtkgKgr4zLSCB6wuhzWPy9Vh16v5rOO0pkU=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=ifUuVWPJThxBCWF7LudWJ7TV8aZCugRvfYSC43Y4/TZ6N9NXfV9H4bKOLTT3twnut
         BHrgxemIcNAA4wqzOdHZPZJHa3vIQ/m1eq/seHddstcPjvTk3viC5iOaBUWD/9zbOQ
         qaY7awG8gFPjED2sINpCbcKRUSmgYA0wJG+OcnMNrQG31k4zdnRejfXeI+3l2V462f
         KdIj5xKl0z8gsWHqrNjvy6Jeg4+GzxO7EEMwMTxuTvaSDoFk99DGUIvAU4YYpzSs5i
         UR9u5EXbtVYWtL906aqpRgR+0UgGMfAvZ0p+VHZNwYxg5v3MpWT0cjyfsDlOovqXv0
         cCHhLtVBsDRjA==
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   davtur19 <davtur19@protonmail.com>
Subject: Minor security issue on website
Message-ID: <Yj4GiIz1tJgEYeX2GyfKsVlvDjNfLsXMuddb1yXG6mLdCeheYvx48RNkUna2ab6F74xONAx-bpVTyGNDMsrOCWv2ew-0gfmctO3Q4K4v3XY=@protonmail.com>
Feedback-ID: 9199020:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good morning, it was my concern to report a possible security problem on yo=
ur site that may give access from outside to confidential information.=
=C2=A0
I attach below the direct link:

https://www.linux-kvm.org/.git/indexhttps://www.linux-kvm.org/acme.sh/https=
://www.linux-kvm.org/api.php5https://www.linux-kvm.org/composer.jsonhttps:/=
/www.linux-kvm.org/pear/

To check which paths have been leaked:
curl https://www.linux-kvm.org/.git/index | strings
/maintenance/ looks like an important folder and rightly is blocked by apac=
he.


From what I can see, there don't seem to be any major leaks but only a few =
minor configurations.
I would also recommend disabling apache directory browsing.

For more info on the problem and how to fix it:
https://en.internetwache.org/dont-publicly-expose-git-or-how-we-downloaded-=
your-websites-sourcecode-an-analysis-of-alexas-1m-28-07-2015/


Waiting for your feedback I wish you a good day.
