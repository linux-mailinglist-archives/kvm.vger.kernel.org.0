Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D96655D9B
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 17:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiLYQIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Dec 2022 11:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiLYQIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Dec 2022 11:08:22 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6512DFE
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 08:08:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id z10so8489111wrh.10
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 08:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=FPGMvd6ycy/DVoukakccjqVpVwpmaFpEdiWorn7nG/ecxljNVmYVFoCUxVKoUYCWmh
         LqsfJKIyBB1nGMaEAyPBq+p1/N5qXneDl2fiF5BkMe+t7P8ZuwX3k0wyJi0RFY05xYwL
         1k9UsUvoZsL+GGRDHb/+rPcNi9tfaKFgLONAkRzIzAc+vevndauE/dqne8eoqSWxAmTg
         +iPRApnS9NHVmRzpkj8nOy8Oio4JSYis4LCc9EHOtfmkgSOEiAbGQrVAFkuqH9FQcmk0
         5Rok7W7LuwKbv5BmWfNAA6YY8t9exYcmHcZHdZ0+hwbqF0xnpKFeKU0AYV5S6MK4pUXk
         oMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=DrBt/EQG4gkTIHu4md6ubg4k1Cb2j/HKiWbVVN2r3d2MN95dsQmBYU/E3AnpmIZGRm
         wErIm7HeVJzKWtxeXhD6sQaxCuRq65z3kdoKQo1eBZOmima8YhDSyBsF5OzCy1srKmye
         FLCPfyzclAHWmHDAEaIlaVpVqbuch4N5qTRlpstlnIFm2pa0AbDbym3y2usxIv7aTq/2
         JM0L4ashy576Eq3hf5ZL0WhNHCEZ8VrNyaP7xCOmd7n/KCYxHWPM1rFtdcPw94hJ9w8j
         5DJhFsPgtwgCJvMD9KqZi+VcX4QjnABxZijPbL2BuhPC6WnC2TTonoR/+xa79QDf2qZ5
         gJ6Q==
X-Gm-Message-State: AFqh2krfN22b6IPou4JkE2WW00/FoSy/bzWa7/J7msS4UqwNw27w6FWa
        Fn3In5FIqC2fNufv5F1cb0vKqrCNGJjCQ05rGB8=
X-Google-Smtp-Source: AMrXdXuF3gbk+gWs5BSluoV6iqWDFvC7ULadlRazruLVPp1Y5pz2sj+54mU7/xAOjUBZkywO5USBLOPyUXCbSooPLP4=
X-Received: by 2002:adf:f351:0:b0:241:c595:9f05 with SMTP id
 e17-20020adff351000000b00241c5959f05mr750757wrp.439.1671984499471; Sun, 25
 Dec 2022 08:08:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6020:400d:b0:22f:eab8:86e8 with HTTP; Sun, 25 Dec 2022
 08:08:18 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <milleymilley325@gmail.com>
Date:   Sun, 25 Dec 2022 16:08:18 +0000
Message-ID: <CANf+LmtfC+3a13w22G+2H_-pS+TQWZBxLJP3qEoz4PSkKP=Q9g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Good Day Dearest,

 I am Mrs. Thaj Xoa from Vietnam, I Have an important message I want
to tell you please reply back for more details.

Regards
Mrs. Thaj xoa
