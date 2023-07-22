Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3075DDE9
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGVReM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 13:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGVReL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 13:34:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB3210B
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 10:34:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b890e2b9b7so15931305ad.3
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 10:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690047250; x=1690652050;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XwQ9KTk0AvNg4YEGpLO6Mzd1tQ0NGTk2GH4qBYSzWYc=;
        b=rjWJXCMeXVCDBYgXfSR0aGlnAlR4c+wDePzRZaAS2L32bQ8a44FbL359Bf0riZwOKt
         ko55mJEH2hOO+8ZFWGQuFCcN69FZ0NIbiPKxYwBvGXkJSsZPSxjhO+NFSCk4LzxNeTLy
         /DcP/0sLcjranFlfjYBs8vgKR9TxUfGAgI2CpDPmvMxmDjtItHUv3loWIOGX0tENJPgD
         g8hKuwbfElH97F7DuL5cy3D6PaFEo0wxcMaWxQSP3hIy/w0Z1aU+lVwOg3X1EaARMx1r
         HnCUW7j9U0m7BL9iU7C7IXWv/WbHAfZxj9yEs1xtFUb0GihBABfklsLJAl/WzI/1FePK
         eKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690047250; x=1690652050;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XwQ9KTk0AvNg4YEGpLO6Mzd1tQ0NGTk2GH4qBYSzWYc=;
        b=K2YdJkd5lP7UqMHKv99sK3DCaabYojjOv+c7chU5w47CalDFB/AR1qtMnfJvx8CkGQ
         ay65OtPgtoCvvwoaHSUKAabP6nxBeZGAZpJnJMxNFzZHhiEoI3BbtATYhKqIrduHhb/Q
         bjBEhnjkol23UOu66Nu3aY92DvRVEnVMphFLS/ywPMJ/Ao+g2bbCvhewX0LtC0MN7Bkb
         nJdjILSdiLZ2RvmpBRTQqf350904EtdAd79mxD9vZnWx3n1xJ8qX1bZa9WGm8DPp7Dtp
         UH37Btfm/8c4B2+/cB4yaSyk84wsUtqj4/7IQ5DLkW7+07JnwaQlU849713FzgSMk+8b
         sG4Q==
X-Gm-Message-State: ABy/qLa7IJegXfG2KDj+cz50wYhFAyy09GaAkKrhFS9g4ScArKXZuXxL
        O+KaXZTTZrPQtWjivIfBQ4XygjLHH7KnIgEigZ8=
X-Google-Smtp-Source: APBJJlGYc1ZMAR7l6kygkIEt1KKq9nfEhnn1q0uW0ETdEO7Ymx4MlMQZNDHewYTLms6DIFpyhKxDloC4NgFHFfh54U0=
X-Received: by 2002:a17:903:110c:b0:1b8:525a:f685 with SMTP id
 n12-20020a170903110c00b001b8525af685mr4199214plh.37.1690047249830; Sat, 22
 Jul 2023 10:34:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:556:b0:130:f967:83dc with HTTP; Sat, 22 Jul 2023
 10:34:09 -0700 (PDT)
Reply-To: mrsvl06@gmail.com
From:   Veronica Lee <barr.freemanukoh@gmail.com>
Date:   Sat, 22 Jul 2023 19:34:09 +0200
Message-ID: <CAB6WZPrkvM5fhVDxT_oTtx9LS99nM92S3D2Vk_L1Fh=wt3Ssnw@mail.gmail.com>
Subject: re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

16nXnNeV150g15nXp9eZ16jXmSwg15DXoNeZINek15XXoNeUINeQ15zXmdeaINec157XmdeT16Ig
16nXkdeo16bXldeg15kg15zXl9ec15XXpyDXkNeZ16rXmiDXkNecINeq15TXodehINec15TXqdeZ
15Eg15zXpNeo15jXmdedDQo=
