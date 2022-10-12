Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9787B5FC802
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 17:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJLPNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 11:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJLPNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 11:13:33 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC4212ADE
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:13:32 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a67so15531818edf.12
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNOw2J+qzBTDgKZCNn/XBsZzDEJMNhUQSPu7DrJAglE=;
        b=Mger2Jorqf6AknYFQ7I7IjoyVvi0o0+06qbN1WbSKqEf2RgPCDVchWKvx9oAvLSCHX
         4lHW/wt3YwqFBQlBmM7pnJ1zvIeKhQOtEQLEPtbvYZFPhf8iW96EIbPIfpEwBXavs7pp
         xwmdjnT4scVmxgWlzsjRG7gfcv50F6NGwp4m3mYk6U7C4Auwpn19WqR+bAvjD11qkFM4
         pBslyHT8YYjwgnWFakgFyzZ0SHL7hgiLc8QwaCQXrVGsnN8naj310FfysgSt7VnsATq2
         eqVX0MFsy3fDwHEQCf/x7uFPzzG/nw2TZsoYtcPJO0YIsiaow0y6dtnSEZ8bEGxniEUX
         XAZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNOw2J+qzBTDgKZCNn/XBsZzDEJMNhUQSPu7DrJAglE=;
        b=h+vhhIKf1GCskZsHPlSawrYYMDt+XAp8gHQdO30k3EgTtjqjaD1+C8gJHDsL3KPAou
         mk7nFC1vHUac2kxTbuTCh249ItF3NrC4QiCjgpHa+f34ynrLFy5l9e+ye3nRMQ42VeaU
         TMI2LviMBwMKymYwEBW75w3AosjEYhntS32g4FZ0251cviGHcQaKYehY5bJ8JwFRphx3
         FqE8/o70isp1mEU3vtaSsasQvHFEyrE95CGQyNDwXP8qnpZnQWNgrbJ+RjhAZkqoTSJc
         grzgL7obTsCaBIRW03VMndGam/UcCj5u5K7sbKmZmuQgzzePLAyyWoz8PjuYPZpzAci1
         dumw==
X-Gm-Message-State: ACrzQf1yNm1RINeeXPKbwrGkNBbtiTZ+OxFV0Ih1NirNZGOvL/rzcm2N
        BL/O/Do6iSgcJVfxsH+dbfgQBpGkQn042EkouPw=
X-Google-Smtp-Source: AMsMyM48+4b9JoqU1cWlI5mvJ9Pq+QhEt779adNqG8zm3F6s1Ksh+12IWK1p7k0QWLZcst1gpdvP/6dQXMGtSST7tss=
X-Received: by 2002:aa7:cb43:0:b0:458:b6ac:fb7 with SMTP id
 w3-20020aa7cb43000000b00458b6ac0fb7mr27510010edt.43.1665587611349; Wed, 12
 Oct 2022 08:13:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:309:b0:5b:a485:7ceb with HTTP; Wed, 12 Oct 2022
 08:13:30 -0700 (PDT)
Reply-To: financialdepartment9811@gmail.com
From:   "Financial Department U.S" <dupontaugustin8@gmail.com>
Date:   Wed, 12 Oct 2022 16:13:30 +0100
Message-ID: <CAMU++eeddzJNjDrcYBVwygSOwYgJyMWa1dvJNbtHa4vgTZTU-w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5017]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dupontaugustin8[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [financialdepartment9811[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dupontaugustin8[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Dear friend,

I have an important message just get back for more details .

Sincerely,

Mr Jones Moore

Deputy department of the treasury

United States.
