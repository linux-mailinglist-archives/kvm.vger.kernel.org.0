Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7A54D8CF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 05:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357979AbiFPDMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 23:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348016AbiFPDMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 23:12:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C56BCB4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 20:12:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d129so65754pgc.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 20:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UqCFzAMntkHr9+rIqrAgCzanp9DxHFdEuhL3q7EgAAE=;
        b=gmCbSZOkVRX/vXPhN8P04Wy/cdUUTlHzvlCe4mrQ+DIcc45pPN77/OPXi/+c2ejg2p
         VSgqMXCPAI4ZNuSGqj8iW7+diQQYZ/R+lix0VW65+pXbsVlDBCT5u4+vv35IXRpv6Y0Q
         niwaDBhrli09sA6IqFyr758sCI/3/J+kiGkJ40q7vKzs/4mmsgFVucYxPq6D+MCpfOpV
         3M3us80DKxZMBwQX6TkG+gRXUjJAkVSCaLIrJd11LBPGNY8rtPe6q/l3VTc9/zCvOoHX
         KKJYAxWtpKrGLjbgf5MPOXiqdiKWfWoMmyZ8HJnbEG4sM8PwMh0/dOv3G+s0tFlXUoSr
         CZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UqCFzAMntkHr9+rIqrAgCzanp9DxHFdEuhL3q7EgAAE=;
        b=5oChAcApfVucNZ2kgsbqGJC9dolOgKzsAZxNib5XkjPqbSPanOU5qMXOEiDUnDx5kv
         T5u9CpWSP51QNHdjodOGFcowYsm/42Bks4HkmeuAdUjNkfJdD86N0KapRIjndBLBeJu+
         2QaawhgOQYlu5UcT9RapXraJwxgP+qlgjlZRVYEBYpJwqEfPMt55njvSMZKY7U2Dyjbg
         C3SMwEazv9Sc6Mr3LEStYZaliQaLkiQ6Uwp8FD+5eTFSu4mjSu3LSdGZyTg0TDMQ8pr+
         TBTC1Z18Bono352TirF5PL0IB5hmjMOJZ+s7KGSepiuy4iqQxbVLD3HLsQ5834kXemcM
         iBYQ==
X-Gm-Message-State: AJIora/QCxiCvLS+ndGRE3EhDGFnMM0UD+JUkQstSP5ck9G0oj6EkFrd
        B3JRjUGDfOSm2BsSLksam0BbKL4ZFeuW2Bg98sw=
X-Google-Smtp-Source: AGRyM1thz/zIZnkMjt60nu6UsZJ2904d1gjtADBnaNowlwygrV4JA4hlQeLBiRwRzq+FmWYDXadK0KQF473qWJfEBbk=
X-Received: by 2002:a63:2154:0:b0:3fe:2814:bd74 with SMTP id
 s20-20020a632154000000b003fe2814bd74mr2648613pgm.148.1655349165331; Wed, 15
 Jun 2022 20:12:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:522:8381:b0:447:b986:f785 with HTTP; Wed, 15 Jun 2022
 20:12:44 -0700 (PDT)
From:   "Mr.Anthony mbalam" <mr.anthonymbalam@gmail.com>
Date:   Wed, 15 Jun 2022 20:12:44 -0700
Message-ID: <CAC3o=M0zs=zjx04pKAH9CypTq4ebv2JXdVN_ggDCKO-Cbx3QVQ@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mr.anthonymbalam[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  3.5 ADVANCE_FEE_3_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
Ordering beneficiary,

This is to inform you that your payment file has been included in the
first batch,Consequently, payment approval has been issued by the
International Monitory Fund (IMF) for an initial payment of =E2=82=AC
4,650,000,00 being part of your long-overdue payment.

To facilitate this and avoid further bureaucratic bottlenecks,an
accredited financial institution has been appointed to handle your
payment file as well as others that fall in the same category.

I therefore request to know if you are interested in receiving this
fund within the next seven banking days or would prefer to have it at
a later date within the year. If you are ready to receive the above
mentioned figure as explained,let me know immediately so I can send
you contact details for the appointed financial institution.

Kindly reply through my private email: ( officeauditor28@gmail.com )

Yours In Servive
For;The International Monitory Fund (IMF)
London Ln,Bromley BR1 4HF,UK
Visit our website: www.imf.org
