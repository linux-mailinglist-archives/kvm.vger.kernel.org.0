Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C883453C978
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiFCLeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 07:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244064AbiFCLeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 07:34:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F093C71B
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 04:34:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q7so10044005wrg.5
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PaEzrm9U0WjJMxkE+zbw8yGRv0uhjcRl9sFl9vmbKpk=;
        b=b8PcN/ccGkJ0/ZtydlJUDDo2g+lpmectIjukuRMfQW4HME26sHrEMEldrBwTeDxIUK
         M/HpWJF562WK9qVdrpCBJhBn3EH8JWTSNWEIvGzo81rv8mzXBv0u7x9hSMCYZPhqnInj
         yYoQilE9IET90q3m2/BKMNkec21Uox4Wvfbx4j/8ohtmIBprKbq4+f0GAVtPB9ki0n6U
         f9dFCgaQJ/2EcaP6arBEpWRWSEvozhvL0MNvjekjeOhoTJZLh8scSBPq0JvdMiyAdrE5
         3VNpg3kxdlwQrTTOzxnX6nFDfHdqkRjj1389X5/QI/uYDrcAYBccqWSXafc3BEd+4tq0
         g1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PaEzrm9U0WjJMxkE+zbw8yGRv0uhjcRl9sFl9vmbKpk=;
        b=sqRHSVgaUBqxahr94gTHby/tusIwbiNUsGjNkv0Z1X0aoX52yqRryDPqcl/PdXuO0L
         jTS4UbWg6C3V26TBDst49jRQv0Y9mv4DUf8I1DkKgsX49/ydVeUb6Ucsmv1tCwhm2LJy
         hoJMOkUFVmoJrK0EsRxpkNaDFTnGvsHtuNgTrnvK3CtqsaBrNLmzTFb9+PQNT6gnKJzH
         zkW8goN+wlMdN06mXABG2dEO04R49ALPuQLfdNDtZKxfo8E3IcoUebfAQWDPDLEqbQ37
         Kp1mTyv9kes5B0TqFe6rE5MHgRlRySEAsr8to369Y+Ex71ytCx2q8VOGF5FlagUd7AZd
         cXHA==
X-Gm-Message-State: AOAM5336/ztZj36DcHaclPgF17ieyk+Rh/PE7dDtBKvMfVe/4ftaZsUI
        q1WRlyv58ijXqiNKgdXdko4wI0KN2RhLblRLK2s=
X-Google-Smtp-Source: ABdhPJwmTXTua7i0Y2LyV9FIbaOq5RZxyPLulK59izB6wsCMXx4ntZI5kVTjHTquDpHG7BXlxWK+ocKjKWDAzXVWp4E=
X-Received: by 2002:adf:d1e9:0:b0:211:7ef1:5ace with SMTP id
 g9-20020adfd1e9000000b002117ef15acemr8151369wrd.282.1654256050572; Fri, 03
 Jun 2022 04:34:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64ed:0:0:0:0:0 with HTTP; Fri, 3 Jun 2022 04:34:10 -0700 (PDT)
Reply-To: markwillima00@gmail.com
From:   Mark <mariamabdul888@gmail.com>
Date:   Fri, 3 Jun 2022 04:34:10 -0700
Message-ID: <CAP9xyD3H3sQKBUvb981jmegURGpPGFk+yaCkjZWvgJxJVKcBMg@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Good day,

The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
