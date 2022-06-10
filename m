Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074E8546994
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbiFJPj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345481AbiFJPjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 11:39:21 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D324128DC09
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 08:39:19 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 19so6322050iou.12
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ustad4Oit1LbdSHBANPMFYdxqbyRopb/4kSjojaTPVc=;
        b=OQzSd9NThiAkyWfOJU99r2XLdSeMO9RN1xDK7cJcv+NuGepTE4T4PPm+aqd+IEmuWG
         s2MyKfJa++z9sEi391aqlt4WG9aK+qdyMCqMKMdzKMiXluLJE5GRLsRVZkmiq347HCuo
         ahbcogUcvCFVnm16lEKfB7AL/pWunUZK/J4nJdFPqLMT22qD2R/H5rvx+R7LINQeGAem
         I83yEAs/bfvaAYWvXw0DmTkQe2UxCRsGX5Dn/hziTfKEKVNcs9XaS5y0ZK24Atc3c14K
         NNABVibT+ha+2DxoTnw9KHgAvUJIS+/Sn8fN2UYHddccM4vwjDUW6TiQbT8jRtttmsv+
         Hhog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ustad4Oit1LbdSHBANPMFYdxqbyRopb/4kSjojaTPVc=;
        b=S7Y+vsZV0amFgcxKDFRF84Y0kQXI970S9zvw51dNZ5z8a+K/hdSbnQkLsMKbzcIxzf
         RckfyfYOV0aJJPV//IhCRp8e8kz6R0+qtfhqCfiKDVOnhZP84UMFR9yowWbPFRYvKlBf
         emOAXvbjN87XmWz8pcaWXeNjk7XYVc8wJcTpZB6JzU+tfrywzwUaREIcG1HIahyiP1xE
         c1hr318S24gaRmAlMjh5uXsPXIDmhjH4lhGaSimJts6k8ECNX8Nz4034UFztEX8gZ5MB
         mMHZjBV0O+XpPaVUfg1YYPqYFQTH05WDVsaHubUApInOJXgGffzxl061fZobP7veN88C
         lg4A==
X-Gm-Message-State: AOAM533kBRCYTwU+YtkCnijeKPGBQzu7ONTmTfZCdWUnHELCt53JubkH
        NnmfyE+QiFj0lwqllQ/sCSWMByr05oPnb1C3dH0=
X-Google-Smtp-Source: ABdhPJxyBMJb1QSW9qjWcVjKXsbenK35sbZ/xCLTgDd7snXihGp70BD6AykdITG627PgrDtvqH+GFdcylPAVYZtF1sQ=
X-Received: by 2002:a05:6638:438c:b0:331:adac:a274 with SMTP id
 bo12-20020a056638438c00b00331adaca274mr15799962jab.192.1654875558497; Fri, 10
 Jun 2022 08:39:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:a709:0:0:0:0:0 with HTTP; Fri, 10 Jun 2022 08:39:17
 -0700 (PDT)
Reply-To: rl715537@gmail.com
From:   Rebecca Lawrence <angel.corrin2015@gmail.com>
Date:   Fri, 10 Jun 2022 15:39:17 +0000
Message-ID: <CANUTHViXoswJ37BN9eK2CYiwPzj0u87gCPpo72EtHCAL1iK==Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

Hello Dear,
My name is Rebecca, I am a United States and a military woman who has
never married with no kids yet. I came across your profile, and I
personally took interest in being your friend. For confidential
matters, please contact me back through my private email
rl715537@gmail.com to enable me to send you my pictures and give you
more details about me. I Hope to hear from you soon.
Regards
Rebecca.
