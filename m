Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B533D63D1CD
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 10:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiK3J1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 04:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiK3J1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 04:27:01 -0500
X-Greylist: delayed 531 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Nov 2022 01:26:58 PST
Received: from mail.dorback.pl (mail.dorback.pl [79.141.165.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B092A32B82
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 01:26:58 -0800 (PST)
Received: by mail.dorback.pl (Postfix, from userid 1001)
        id D363A229E4; Wed, 30 Nov 2022 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorback.pl; s=mail;
        t=1669799884; bh=0iojd1hjjs/2RRG24wn9Sf8HTlwLUFgq/rgRW7IA/ZU=;
        h=Date:From:To:Subject:From;
        b=jvr3K7tzq/t3qicjPbERSj2R2nlmopsjGUxwrNT3D+rWP7qdSzzgIJmyi89izK36k
         l+wLRiCYxpljJXprVoaJnXXmmZiDKzCnrFrdbrLFod2hPaFhsJtPBoe8WmndLzz6AE
         KtwV7OMiktmi2f6h9AdQ+u9jJtLbPTIYLBXc18BLmONHru2R5mp7Gl8qHZm8yYlq3I
         LzoTrZIsvIKLOp13ZqL1Ln5RI5roZt5ckuHYZBVibc4craySnDgP/eVI/JmCqq71sx
         rBRyfWnVhdIi1N0+7kH28n53IdYyMhLOjygUXH0xWRkjzz0XDq9HxD7g6GasUNfBz0
         Hik2zL5Lb4krQ==
Received: by mail.dorback.pl for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 09:16:51 GMT
Message-ID: <20221130091501-0.1.1b.6i7a.0.98phid8qmq@dorback.pl>
Date:   Wed, 30 Nov 2022 09:16:51 GMT
From:   =?UTF-8?Q? "Pawe=C5=82_Jankowski" ?= <pawel.jankowski@dorback.pl>
To:     <kvm@vger.kernel.org>
Subject: Wycena paneli fotowoltaicznych
X-Mailer: mail.dorback.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,URIBL_CSS_A,
        URIBL_DBL_SPAM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_SPAM Contains a spam URL listed in the Spamhaus DBL
        *      blocklist
        *      [URIs: dorback.pl]
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.2592]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [79.141.165.48 listed in zen.spamhaus.org]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [79.141.165.48 listed in bl.score.senderscore.com]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: dorback.pl]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dzie=C5=84 dobry,

dostrzegam mo=C5=BCliwo=C5=9B=C4=87 wsp=C3=B3=C5=82pracy z Pa=C5=84stwa f=
irm=C4=85.

=C5=9Awiadczymy kompleksow=C4=85 obs=C5=82ug=C4=99 inwestycji w fotowolta=
ik=C4=99, kt=C3=B3ra obni=C5=BCa koszty energii elektrycznej nawet o 90%.

Czy s=C4=85 Pa=C5=84stwo zainteresowani weryfikacj=C4=85 wst=C4=99pnych p=
ropozycji?


Pozdrawiam,
Pawe=C5=82 Jankowski
