Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDF873FA8F
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 12:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjF0Ky1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 06:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjF0KyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 06:54:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB3B1BE4
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 03:54:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-51452556acdso2041087a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 03:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687863261; x=1690455261;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MFG1KNlvf1Axxy9iiCRuF2Wv9mzsHvQM12J2RA1vN6Q=;
        b=osobjKykc3MMvkR4iPr738bnJhvcoV8YcwSBqNo/6DXIZKoqGsgeBod0ceDxg9ybZR
         NwYwnuVbv2cHVlf4pzVOmG/wV49WmJ3L1btXdVpvYYGREfR5womuS5IAv2HHWB86g226
         kmO1ggFycl9uL1doA594q+5Co6cNFl4aCQNobWTu0xnRN4XcNhzI2HV7kuIhf1Uy9btS
         vzIcKOB1ssuKeztzUEhLoU8bVgiQr/CuaPjdyjlQA3rDMAf6kpbpqdOi+/cgFVpyKs8H
         FwMbvTC2jnGl81Jgjdv1TG7khMpN8XYx2FKNz6X1L5WbpUITJcqdRa02y7oNwWhjDwVy
         vRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687863261; x=1690455261;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MFG1KNlvf1Axxy9iiCRuF2Wv9mzsHvQM12J2RA1vN6Q=;
        b=fZkgN9zZOJ9c+wNfBq/weae5UEhNYS6k6wl8Z2IoLzKCKiIclxD6ZMeXdHy+LqLWrE
         tMLl3RN1UugPOY6bv+WIJX2vClz22gu5+jyUd1paySOzq2+5pX6gUs4KFe5f+qG7MbIg
         nug65riYESaYbbtCVyKKTruv+Ho99/itQP26a01dw6x7yKJhL+TGO5Cbb2KFXGRkypfO
         yPkAA0c0tQqk8dleZFl98mxV6K7C95/OkOcL+OTZSGJmUFzdCrJRRC2l5i95zQwbohAI
         wdyeXQzfaOFdYGDcMbs4xbbHE/GR15SE3SF3tjpazkovvYdponnrSR4pu+g7cPq0TRxv
         5okA==
X-Gm-Message-State: AC+VfDyFgjuE+WmOkmduuFu86VT2A+Ja03gXM1BQ/IAgnf57ltRf/YiU
        F1ZgeGJVwMYeAwg2NSZfzuAJLeoTDI8hUPR8fuE=
X-Google-Smtp-Source: ACHHUZ7X3GWLo0L0oRykPDDb+SdqK789wDSC9aZIc2evKVqCNedEf1oZkdv+lAKjXAH3dgcAPySJWUnrc8YPTMDuiyY=
X-Received: by 2002:a17:90a:c301:b0:262:c8dc:5ab0 with SMTP id
 g1-20020a17090ac30100b00262c8dc5ab0mr4998710pjt.39.1687863260627; Tue, 27 Jun
 2023 03:54:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7301:7e06:b0:d7:4209:df15 with HTTP; Tue, 27 Jun 2023
 03:54:20 -0700 (PDT)
Reply-To: lschantal86@gmail.com
From:   "L.S Chantal" <moris9974@gmail.com>
Date:   Tue, 27 Jun 2023 10:54:20 +0000
Message-ID: <CAKjm6rZpS9WbqaYeh59S4s+3q+3f++ceAgY4rcRAK=4wvxxT3Q@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5084]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lschantal86[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [moris9974[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [moris9974[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.
Your compensation fund of =E2=82=AC5.1 million is ready for payment
contact me for more details.

Thanks
