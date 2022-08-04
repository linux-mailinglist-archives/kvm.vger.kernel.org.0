Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC52E58A3DB
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiHDXVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiHDXVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:21:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE329140A4
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:21:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso1198906pjl.4
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=nMuewFVWvHhGnwWrGe4vWiaOphm8t46P57ZIL5OdlFcz+LrWzGOM8uHGMI1ithmC9f
         wVe6wsxild4yh25CtDOQFQ8OdluJJbOfoozO0e/LmgLKGeWdbb9CWnWP13rqmmBd4CVw
         E71ZGwqFTN0I8LQFtXrB8napPsa7/Be9GPPQAYpWvFsvMfaK8oCryY9U8zbURhnbUlUz
         KRTNhn4WA2fDgW1mM3+HLmqfi6Op/b1lkpHqctKBISkH2Q1SjAP+RSDzqng0X+g8Ka/d
         8CNTPNt3OEu8KghYF9/J1/Dkb0z+n6GCNd+lejUp/L92/aaEbNzOURndWi7eg+GFrr6Z
         h9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=xyK7zMbPBUFmbIp8u7mxaTlz4LFQOI7VyG3dHJeqLbHF+L7o5F+RSnLpNufXaw7DhU
         L5rJIYRenSrjbTyp4U2ZaxAo5vKkDd2L/yoYeqCDv6Kp0P4xXUg6atlf5eMxk15Mc6S/
         1i6iNnQxVdple5czmRgIus62IC+LOX9fZ7TX5MllFydTPtRqprhqT/QfdoCLoBldPW54
         wEtkzA4jSorI+LnSKaBenwGgZ+0Qwgz7gBPe3fJUQJLTNyWxXW0jafRtX79OQFkVMOvx
         A1WWP21v/6jwjeyOLy8PoP58fnekDZEt3/Hnn0+ek+EVAe/7VBQpqL6IrUr4QL8b9YcQ
         PDoQ==
X-Gm-Message-State: ACgBeo0l+WSgtc12FZj9IOtIQsw+3Ub/Nww2t9btwuYZq5tDfKNRz8RE
        dEOlJ0RzzMemt7MAvR+78eTHadb+O81AHvtLKBU=
X-Google-Smtp-Source: AA6agR5ZHYRwro222oIq9x66FFkqQtV+zN52tgo5U7RKcaLTXNxkuidYmbP7L9BWrt0AhOTzXCPvWh/zORqg5UiJRMo=
X-Received: by 2002:a17:902:7c88:b0:16c:5301:8a52 with SMTP id
 y8-20020a1709027c8800b0016c53018a52mr3924117pll.95.1659655303985; Thu, 04 Aug
 2022 16:21:43 -0700 (PDT)
MIME-Version: 1.0
Sender: savadogos996@gmail.com
Received: by 2002:a05:7300:6d1e:b0:6d:5ced:c8ce with HTTP; Thu, 4 Aug 2022
 16:21:43 -0700 (PDT)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Fri, 5 Aug 2022 00:21:43 +0100
X-Google-Sender-Auth: lMNSJmHS9zqJZXnC-D-ot8SqnCw
Message-ID: <CAMmySebk0Fzxj2MSyjJC6ygusiBzyDrW2fQP58daBePgsttGiA@mail.gmail.com>
Subject: My name is Dr Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
