Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1990A4ED5F4
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiCaInb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 04:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiCaIn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 04:43:29 -0400
X-Greylist: delayed 980 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 01:41:42 PDT
Received: from mail.jywrepuestos.com (mail.jywrepuestos.com [190.119.242.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640101F6868;
        Thu, 31 Mar 2022 01:41:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.jywrepuestos.com (Postfix) with ESMTP id 53474AE1934;
        Thu, 31 Mar 2022 02:49:29 -0500 (-05)
Received: from mail.jywrepuestos.com ([127.0.0.1])
        by localhost (mail.jywrepuestos.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Cxwqpz-KOnjs; Thu, 31 Mar 2022 02:49:28 -0500 (-05)
Received: from localhost (localhost [127.0.0.1])
        by mail.jywrepuestos.com (Postfix) with ESMTP id C8E7CAE18E5;
        Thu, 31 Mar 2022 02:49:28 -0500 (-05)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.jywrepuestos.com C8E7CAE18E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jywrepuestos.com;
        s=F71C435A-5232-11EB-AA07-242A54BEB359; t=1648712968;
        bh=NvV5XMylaq+D0M/CACFcLwdTxmMEUpgGFxTLj2be8kI=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=HPKS97OTdxvMn/6dpfrxff+F8dunXdDlPrqC89eI2XeIo05UftTHEXqHBmcCmcIyg
         dtwtApK3tdaa7FpsaB/hmYoMMDOH2LceTfmIvUPlnik4PqoiFeLQhmkeP7+dtuOs8v
         SCkwZ/F6I6Wj350AijUgsnOwtMXVn9TxZ+68UGwQyf1fHPUSz+imYZLDsYOcjbgZds
         tA+49MRpu8+hVyIIuPYvy9zjzLwuucgXJAh5zNCWwE64lw3xEndLcUDWzaVPxMfTto
         QDZ7lhoQ0WOYVq1sTUa2RcSI84yFY1LbmdAaNIJwaLOuQmXa3x9fsv4NdTqy37vAhR
         Sc2w/Iw/LGmVQ==
X-Virus-Scanned: amavisd-new at jywrepuestos.com
Received: from mail.jywrepuestos.com ([127.0.0.1])
        by localhost (mail.jywrepuestos.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id G5oreR9PEnlc; Thu, 31 Mar 2022 02:49:28 -0500 (-05)
Received: from uk.pffbmbdadveenn2130a1ch5mpd.zx.internal.cloudapp.net (unknown [51.145.89.122])
        by mail.jywrepuestos.com (Postfix) with ESMTPSA id 001E5AE192F;
        Thu, 31 Mar 2022 02:49:24 -0500 (-05)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hello Friend
To:     Recipients <wilson@jywrepuestos.com>
From:   wilson@jywrepuestos.com
Date:   Thu, 31 Mar 2022 08:15:09 +0000
Reply-To: reemalhashimy309@gmail.com
Message-Id: <20220331074925.001E5AE192F@mail.jywrepuestos.com>
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_99,BAYES_999,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,SPF_FAIL,SPF_HELO_NONE,TO_EQ_FM_DOM_SPF_FAIL,
        TO_EQ_FM_SPF_FAIL,T_SCC_BODY_TEXT_LINE,T_US_DOLLARS_3,XFER_LOTSA_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_FAIL SPF: sender does not match SPF record (fail)
        *      [SPF failed: Please see http://www.openspf.org/Why?s=mfrom;id=wilson%40jywrepuestos.com;ip=190.119.242.179;r=lindbergh.monkeyblade.net]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [reemalhashimy309[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 T_US_DOLLARS_3 BODY: Mentions millions of $ ($NN,NNN,NNN.NN)
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.2 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  0.0 TO_EQ_FM_DOM_SPF_FAIL To domain == From domain and external SPF
        *       failed
        *  0.0 TO_EQ_FM_SPF_FAIL To == From and external SPF failed
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  0.0 ADVANCE_FEE_4_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My name is Reem Hashimy, the Emirates Minister of State and Managing Direct=
or of the United Arab Emirates (Dubai) World Expo 2020 Committee which was =
postponed to October 2021 to March 2022 because of the Covid-19 pandemic.

I am writing to you to manage the funds I received as financial gratificati=
on from various foreign companies I assisted to participate in the event th=
at is taking place as we speak. The amount is $24,762,906.00 United States =
dollars. But I can not personally manage the fund in my country because of =
the sensitive nature of my office and the certain restriction on married Mu=
slim women.

For this reason, an agreement was reached with a consulting firm to direct =
the various financial gifts to an account with a financial institution wher=
e it will be possible for me to instruct the transfer of the fund to a thir=
d party for investment purpose; which is the reason I am contacting you to =
receive the fund and manage it as my investment partner. Note that the fund=
 is NOT connected to any criminal or terrorist activity.

On your indication of interest with your information; I will instruct the c=
onsulting firm to process the fund to your country for investment purposes.

Regards.
Reem Hashimy.
