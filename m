Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9255172BE
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385915AbiEBPjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbiEBPjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:39:19 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF51305
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 08:35:48 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so25884664lfg.7
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 08:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=RGE824sH5spon15Zyez0gxxiR3dRoc+nor003c4bB6jAoT5PWo749lOB6TUBEtdNS8
         jLcq6Abnd079hgtSSRm9p5MbtdUQCSo3YEKYkMLjCfuV6J67Jc7dAkOA7eHBkZoLSKMg
         5sBa2bFQbtxvknndX9E+LbVd4Rv236ZI68o8k3xt2nVQEzU2ynVP6+5MgsCssYAgkFRT
         naDYhsFXD9tmr5uYMSz2+B/SJvfSnd8kt4w0Bgpug/nKd4DQnA/RDKLgHT97L0YapdzQ
         9DsoN+71r7iMxCCCj6mXNirdSFww9OgFSAY9upIOMbYnZKZVgRMGNi8XZrEKYw/bmilW
         lcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=iOXh3vtxB2EGP4GuhGuovcxyfwRiztSKpW/6foUSUqhbfhMbNXT5SB+WjJcNBMZbH2
         bn/BZ0G3J0k9CsMuYvBKYnkSFah0tYr2Dmd8W0021SBsGeJ/tW1fgjJFUnavyU6SlFdX
         Rt1A9pk9deiAyw9P3XeAX4QzeCbV/Joz8OCGuv/oddHbMCAz/NhaQ7EQCtoTpVdDF8Ib
         YpJDVCT+XWiZ7hCyUtP/gQUxeXtry5jD0CFGL9kj3pqvLP0q2rFvMXh16OYCEw3vRfy5
         Vgc3huT1B/ZpZIf7hYkP+lSZJ92YhvE0FbBld907ncc0BzNKPneaA1s7GUy+FeiGvrIN
         TT6A==
X-Gm-Message-State: AOAM532OAgyS9uz4HTN2i5R9H4l3QTIca6e8k+L/+7aTDqpNpyFd4cYc
        rY5PVipMrNwqKKof4ardO+RAucXvgawBkqAygQ0=
X-Google-Smtp-Source: ABdhPJw92C5cQH0A19SAI8uwwNpYJv9uNpG+w8AlorCk+kZUzCHktucY+1VtsH/Ta2Yxctqzo1Htz/frZ1yZ+T6zkLQ=
X-Received: by 2002:ac2:4e66:0:b0:472:5b54:7349 with SMTP id
 y6-20020ac24e66000000b004725b547349mr6931504lfs.68.1651505746531; Mon, 02 May
 2022 08:35:46 -0700 (PDT)
MIME-Version: 1.0
Sender: arunadogbe@gmail.com
Received: by 2002:a05:6512:22c5:0:0:0:0 with HTTP; Mon, 2 May 2022 08:35:45
 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Mon, 2 May 2022 16:35:45 +0100
X-Google-Sender-Auth: 5D6xVgNTV12GKyuPKZFo9MrtOeU
Message-ID: <CAPsVOGzLZ=bA-DGwHEVqfFH=kMZ_C++jOdBMtpv7a4HU+vco0Q@mail.gmail.com>
Subject: Hi Dear!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hi Dear

My name is Lisa Williams, I am from United States of America, Its my
pleasure to contact you for new and special friendship, I will be glad to
see your reply for us to know each other better

Yours
Lisa
