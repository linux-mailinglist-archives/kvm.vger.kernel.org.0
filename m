Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D534751DA9
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjGMJqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjGMJq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:46:28 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4DC2115
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 02:46:24 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-403b6b7c0f7so4732691cf.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 02:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689241583; x=1691833583;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NdiupA6cBTfp2T4wmKkTrqOertN7BIFSXZbmCnqIkpY=;
        b=S2LtXCIV5BW7xDFKUplusFd5wrofECnDwZkNeBDWnqGYwNquHj3uOmZh/Mih0+h4pH
         gPmBsyFuKUys1LHnff0BfwPF/Y98dr1yrjrfyyNGhcY9NCAxYmcb1vR9FtVx0ToJYcfB
         jdwm4BeZfLK2Fb5hInyoHOVz5gFnDs33WZ2YyHbb/3zPaIleN8ikftY44dRXaUSuQIUc
         c6xVrg9TcitxAPPB9KGTZocyTidkahAXi/ZABc1eRb0Qn0lxtEX5rMBzpzdwFJxIjUnB
         Wohynt7G06qG00XcPwNsqKws+38tgxWK7J0ZXreAbVGrmG+8HLuW5W9jLi+D2rrsN5WF
         SOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689241583; x=1691833583;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdiupA6cBTfp2T4wmKkTrqOertN7BIFSXZbmCnqIkpY=;
        b=P0zq8sln3dIsO/+6lwMCUvIruxMIGUiAdh4F8zv1IXDU1z/1RoHzyWqAwdQwUjdZz4
         kqDyFeOAf4zFv9EwQFCIlmhlRLWFqeBt4YZOZGJYr5T26oyYRBuVmTb8EB019Fdfliuw
         tHNdQ3poeUfgxr5nt0yj1z94UzpvmfS9d5qgA7tQcboYSGxTrM9yegUSDVq+8smlwo1g
         dE5QoWWAb3VGFUghaHCee6RA0FWkFpMFWSSv0XoTsdTAsk0Ky6spk4DrfvDWI2mmOcM7
         Pjhb0RtjLlekAmkXdquNv1IiiL3gAACfKyhICieel8zW7j3SoDghrFyKXvpraQIoPnFX
         j5fQ==
X-Gm-Message-State: ABy/qLZYC8iaZFBhvPc7Fcm5PdlPbRM36wti1g4t6RBk4CVOeoI2O2jF
        B22wrQ/f7oHDoXiEoh+BvKH6H414Htlf32f3Am0=
X-Google-Smtp-Source: APBJJlHol7iUKSpS/65EejhJjtIzEbCKtSgkZ2PDr4h0uHXSrg/7L/EGVztNafLiWGfE1+QpXQ5Wb+/JJBPQCZoP/UI=
X-Received: by 2002:ac8:5f85:0:b0:403:788f:5d0e with SMTP id
 j5-20020ac85f85000000b00403788f5d0emr1490104qta.60.1689241583448; Thu, 13 Jul
 2023 02:46:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:1353:b0:403:c5ae:5a29 with HTTP; Thu, 13 Jul 2023
 02:46:22 -0700 (PDT)
Reply-To: mariaelisabethschaeffler.de@gmail.com
From:   Frau Maria Elisabeth Schaeffler <abbatunkara2019@gmail.com>
Date:   Thu, 13 Jul 2023 10:46:22 +0100
Message-ID: <CAPw=j36SsXyye5LUhLAhtsK-zT6ajWy0n6y-_dksRNrXX80+kQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
Sie haben eine Spende f=C3=BCr humanit=C3=A4re Arbeit erhalten. E-Mail f=C3=
=BCr
 Informationen: mariaelisabethschaeffler.de@gmail.com
