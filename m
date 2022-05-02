Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D95451690A
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379465AbiEBAdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiEBAde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 20:33:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A0D1BE98
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 17:30:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g6so25142956ejw.1
        for <kvm@vger.kernel.org>; Sun, 01 May 2022 17:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version;
        bh=M6nKG3cKtupztyRDu8OMgiSKZWowCWG57xCOVH1mlSM=;
        b=h+QaolxAy20t4aTk9DSBNW76OK6uLZTLQu5+nwks3uAqGgcl1xyKMFH11FcX5KyyWP
         NAp36i7SgqEme/sNM7H4UNlg6UUcYdTlFAxMfuidhR3fr9247LIY6GvebuybttLVjaI7
         LFGjvz2ILs3xoD7lh8pxHmcz1SUnrw+rAwrE6kIXg/kUhrbmPdOWYDFDWIq5AC45yHLE
         Rd7aewP263nq3Eym2D8u8S//ivKDXua6qABAHWJg9Y9j/F3SDdf9FYRW1HWjmEYkZaxt
         wpZx1l9x3OrdK51D0qPuI288OS3Zs3IVrV3UAGOWAIPWdWqGfibaApNIn22KfMjOzGOP
         b1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version;
        bh=M6nKG3cKtupztyRDu8OMgiSKZWowCWG57xCOVH1mlSM=;
        b=bCjoGabrtSNDrlBviiJfX5cFi5X5iyZjCTk8Ixmyuv6h0wphhUPCLSHoP75KS6p1WW
         eYas2G2voY9Z9RC9S7egyQszcVVBAFnejOAKhnwbP1SzuuD+s5vbFW0+24gk0LW+JZ/h
         BGUDBcrOJYpVe4UbYTRKFI+ELTKnBGmx3k9CkqyRLpbkXY8YVBWfVPBQpEij45hckDks
         gsUvatjTi2UXHDre6SA9z5uyYrl20k63W16T8wfB/Kw+ZFM79UOxKDsQb81FQjlsQW5I
         ok/9QHkj5+O67EvD+CQLVVrZzgKTajTwEYpHnC6xHTCmH6/hPZXaWvZ7wvDQmfnE0w1+
         7b+g==
X-Gm-Message-State: AOAM5327jj/EkperC8HCpaEm+vkrb2qRfM/Oyn+wqNpdNcLS9gk+UWBI
        NP/osDPt7ZQrhZZ90CL5w+jRsSI1ASb8Sw==
X-Google-Smtp-Source: ABdhPJx4nNfnNn4xb/wCpCuxii9jRCGOnrX0bv+8J3ulASZ63RdqxnxOVIWy7yJlwIfuFkL62K8k/w==
X-Received: by 2002:a17:907:62a6:b0:6ef:8118:d3e2 with SMTP id nd38-20020a17090762a600b006ef8118d3e2mr9121269ejc.605.1651451405562;
        Sun, 01 May 2022 17:30:05 -0700 (PDT)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id el8-20020a170907284800b006f3ef214e12sm3055993ejc.120.2022.05.01.17.30.04
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 17:30:04 -0700 (PDT)
Date:   Mon, 2 May 2022 02:29:59 +0200
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     kvm@vger.kernel.org
Subject: Core2 and v5.18-rc5 troubles
Message-ID: <20220502022959.18aafe13.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/vjyoNcZelUZFaZ5Qe1f4qLU"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--MP_/vjyoNcZelUZFaZ5Qe1f4qLU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, when I noticed fix for pre-EPYC and older Intel hardware I checked
v5.18-rc5 on my old Core2 machine and something else fails here.

When I kill -9 the first qemu attempt (see dmesg-1), then next
attempt is OK, after successful VM shutdown another attempt fails again
(see dmesg-2). After that it takes some time and machine needs reset
(see dmesg-3).

HTH, Z.

--MP_/vjyoNcZelUZFaZ5Qe1f4qLU
Content-Type: application/x-xz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=core2-dmesg.tar.xz

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
Wg==

--MP_/vjyoNcZelUZFaZ5Qe1f4qLU--
