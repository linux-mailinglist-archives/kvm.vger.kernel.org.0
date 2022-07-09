Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2161756C953
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 14:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGIMHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 08:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIMHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 08:07:23 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF17371BF
        for <kvm@vger.kernel.org>; Sat,  9 Jul 2022 05:07:22 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id d187so924185vsd.10
        for <kvm@vger.kernel.org>; Sat, 09 Jul 2022 05:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=jxNGQ1VJJ8xK6WwefPrA3m5Fd0FF5gJlzU9B8KV6EkM=;
        b=nIGy0G9CTDVnTCJtBUTkriUbTuiENt3OJU03gAO5TXYNB6AlPTeYBwtiNQIaOH8KUU
         cefPgxbcxjTLNURWBxsRFLoCbyGhtVmm34vw47wdd8S6fYJbc9pQo365uziZ8BkglCKV
         qBWRfTew2YsEQVAVTLNiOFyOpRkoQpHACEt1AK+POJXyd1GhzmJD14WxkjrBOixHNYLu
         qvTyzxk2LT1BDE+6lWI76XQHqDItxccIUB/V/wSLoHqf+KYMpfFy4d5GbBg873g0IPWB
         pqROAga3HJsLTVm3EhBWyzTNWQ+uaCBDcL8QGGHUWMV1fCV4l80UyX/KLPSMu9K0hdRQ
         DL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=jxNGQ1VJJ8xK6WwefPrA3m5Fd0FF5gJlzU9B8KV6EkM=;
        b=Qylb5vWkBkmZDBzi4DSL7WEXtdEnietlVRFIn1mOXYQRI3rS1ubhDP3Hh9jxtvmcCH
         3Q9vYV8VqSWc7cM4L47tu7ndJiGkJBNcAPpEeLwG0JtK55JyQ7KBJHbi9+P9GoaniUlc
         OUA/VQ4kUwX5nvaQkT+jpqdpo6W2s8OmJkEofd8EFATLyB30Px3ctqm0DfJYU2B61NCN
         W5MESDBqEzbOkoHA6CXKGcDIAwPfkvsRXygE8U7WdqJdXUaoFP4FmBlD3y3al/3DS04f
         6GWBFPBeBFaArQ77GkAPLhouxGjtGTmJq4TMlx8Xo3m/qohio7VtZwwRaUYsftagJ16p
         fVLQ==
X-Gm-Message-State: AJIora/KRs1hTLBbkgnAczZDcGrQfZYPMePj3Up+ORGMtaR8gM6rNhIv
        y657qlc5N22oSwZu2iDlNCGTZ0OZZ2S8mjlvfQ==
X-Google-Smtp-Source: AGRyM1taTP1im2PQbroUsraZ2N8oQbSt1hRa6kPktX1L57dFx7qIvV4ydtWu8Vh5MYAZ9lSFiQg3Zp0cPqO3VHYKGNQ=
X-Received: by 2002:a67:c21a:0:b0:354:37d7:aaf8 with SMTP id
 i26-20020a67c21a000000b0035437d7aaf8mr3351424vsj.30.1657368442076; Sat, 09
 Jul 2022 05:07:22 -0700 (PDT)
MIME-Version: 1.0
Sender: varonjames145@gmail.com
Received: by 2002:a59:a38f:0:b0:2d2:5e81:a10d with HTTP; Sat, 9 Jul 2022
 05:07:19 -0700 (PDT)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Sat, 9 Jul 2022 05:07:19 -0700
X-Google-Sender-Auth: SB9hnpiRLJZTmrBh_AfCZCmHC6Y
Message-ID: <CANr=4hvcadFgJ0_NAO_a9oXYp_uR6hW9+suJih-YXAR4HrVCHQ@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MAIL FOR MORE INFORMATION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good morning from here this morning my dear, how are you doing today?
My name is Mrs. Rabi Affason Marcus; Please I want to confirm if you
get my previous mail concerning the Humanitarian Gesture Project that
I need your assistance to execute? Please I wait for your candid
response.
