Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2137F633343
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 03:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKVC1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 21:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiKVC02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 21:26:28 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA36DE6756;
        Mon, 21 Nov 2022 18:24:17 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 4so12328911pli.0;
        Mon, 21 Nov 2022 18:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0ENp5DIy0G/UeKHph471u/TMszPxJBDnub0SncXwwYg=;
        b=H3McYj3qLlHCtzwZFO4NBye88PtSBBCazq3Nocqz0MzFRZqech16Ase1O3FBf7DMh7
         RzbmiA/qllDxkmkkh5uO1abzEucVB+IV7WiG63lveAAcoU7c0BjeAPHNbhbRuFejr1ZI
         hMbXEXwt5FBAzz87caBJhU9JTIbHVj3CPfzxlwyPgOu8EM/7bX3TmYwi8ACyFP1oZSvh
         pgqdu96ysyx/Wg8GfTOWIJUp+8ZOnyZD9iBGcnsntV3P9GJlCWs3/m5a32ArLVn1ciXH
         QwA3brdU/ckIQVXoMyAiNDvT7ij1nsBfLX1uPqESfIMPG6w7o9ipKW3PfROpeJGWRVTu
         NLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ENp5DIy0G/UeKHph471u/TMszPxJBDnub0SncXwwYg=;
        b=fLQWM27sDmbA6MTAZKbAIGCzyQ/YFvaZHYwk/ehUKTr5dwrJBf6hZ1C99onvoXPDhg
         KQGT4RxkwPnRLEoOevwB/pkCNg+Tfl7CmDK2mmj/6Ywd5kLr0XlN5P/aT17OHfubM9L4
         v0w5D5UGmwD5uQAuh7gffA18Y0gf92GTDzbsFZ9e3wxhUP+/ELniuJcVBA9fiPOOxfhI
         L6ulQcZ8blZm+2Wv/AvC53KuesI9Z3k47tprCm5iWflSYjFymV4LwtxZvSg25kle674K
         E38Ub//P3yRUADBcTkMkgCgyjzC5kP3tDQfauZ+5Lmek640qtTv0qZG0tzuFcXXw9BFg
         IyGA==
X-Gm-Message-State: ANoB5pnhmczhvv6PstsAgudcGwsfiilZyRgjuXqM3hLcQzcU8lnReS87
        gGYOJCfD6c1yiVGFaFyphQ38OaxnTSXOOzTBuaj9zRX3EVqL4vnM
X-Google-Smtp-Source: AA0mqf7qSUISr4f/aG3acEZueS1cGy5j9jBsiisiRo/uR4+aDqX+8rF6A7IEh9ikEvesIsxIXSwyq+OxRpddqU8kX84=
X-Received: by 2002:a17:90a:8904:b0:218:93e8:800f with SMTP id
 u4-20020a17090a890400b0021893e8800fmr15373966pjn.136.1669083857299; Mon, 21
 Nov 2022 18:24:17 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:6299:b0:46:eb17:10c8 with HTTP; Mon, 21 Nov 2022
 18:24:16 -0800 (PST)
From:   Kavin <kavinvivek07@gmail.com>
Date:   Tue, 22 Nov 2022 07:54:16 +0530
Message-ID: <CABA_fwpDBHFt7_uyu2Bw_+s0yM2UdsK46cpOP4hBVacPvsMsrw@mail.gmail.com>
Subject: Fw: Norah Colly
To:     kowkn <kowkn@asia1.com.sg>, koyama <koyama@kansai-bb.com>,
        kvibert <kvibert@greentopiagroup.com>,
        kvm ia64 <kvm-ia64@vger.kernel.org>,
        kvm ppc <kvm-ppc@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        kvostry <kvostry@etd.ln.skoda.cz>,
        kvrana <kvrana@euronetworldwide.com>,
        kvs <kvs@binarysolutions.dk>, kw lam <kw.lam@i-sprint.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,BODY_SINGLE_URI,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,GB_FAKE_RF_SHORT,
        RCVD_IN_DNSWL_NONE,SHORT_SHORTNER,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_PDS_SHORTFWD_URISHRT_FP,T_TONOM_EQ_TOLOC_SHRT_SHRTNER autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  2.5 SORTED_RECIPS Recipient list is sorted by address
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kavinvivek07[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kavinvivek07[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_PDS_SHORTFWD_URISHRT_FP Apparently a short fwd/re with URI
        *      shortener
        *  1.6 SHORT_SHORTNER Short body with little more than a link to a
        *      shortener
        *  0.0 GB_FAKE_RF_SHORT Fake reply or forward with url shortener
        *  0.0 T_TONOM_EQ_TOLOC_SHRT_SHRTNER Short email with shortener and
        *      To:name eq To:local
        *  0.7 BODY_SINGLE_URI Message body is only a URI
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bit.ly/3hOcFHS
