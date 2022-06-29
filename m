Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7300155FE08
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 13:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiF2LBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 07:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF2LBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 07:01:33 -0400
Received: from mail-oa1-x42.google.com (mail-oa1-x42.google.com [IPv6:2001:4860:4864:20::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A633E5CC
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 04:01:32 -0700 (PDT)
Received: by mail-oa1-x42.google.com with SMTP id 586e51a60fabf-101b4f9e825so20925146fac.5
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 04:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=zwr+gvqINn5s/ZV6IyRPgfhaWD9WdQkp9Eb4Seu1lr8=;
        b=Fmbieh3/8VeUGvEdm1aH71SDkAyhGBwd+5CuXo+xasvHKyuTZu4Ll3p+pgSqsW6J8g
         z8S1ACsNmkhz/tAVnL8mVJ+knoysVQ5UR1SPg8ZY+Ad1+94ImNaLGaWMNNdn1EYHygvB
         vDOejuvPjWo1vhHFq4H6olckLkzAui7qaVuodDP68GmJ+mKpoPk5gLyhgaXiThGmuggT
         dCDRNUbtm0vfBFhvBjbDiMrd28NO3rvKE1AdzT+b/u1TI3cThmRmy2bXeXwP8id3T7Vk
         uII13TAjHZ5eWoM170J+8+4xfVWtLgx5ewAY5ukskssNlSiwKoCUyICwpSWIiQymBrnA
         9Ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=zwr+gvqINn5s/ZV6IyRPgfhaWD9WdQkp9Eb4Seu1lr8=;
        b=oq18hNAiua8x7ww/4b5+Aqz0b2bjxm3UfWIqEfIQTBUVd4qYJDTN4pvga/IXAMM1Tm
         yl5R5R4ZFEqIU91VrV1q4xM0F/QsdQWuBlna/hW/GrnblnzbtB78FLj9B9Z4jwDdSzXC
         gBO1HAvcrCcXjOC2BJEkkqq7eo0XM51Oua1maLDlH28j68V+IdzIpi7IBXUW8N/P5W70
         CfO4LSRHu20khgVYBVqwBkj1YqClC2+hsTJvGvbD+4TG12FSMalX0/uuyidQeloQfM1O
         vJirzZdg5uIwcdoFISwxX2TV1DkLVu4EcccgHYsXtn7tzlPobrtbNSszli6tZFVs1mnr
         SKZA==
X-Gm-Message-State: AJIora94nzsWCN6Uu2p2vVAhCkfH8sQWllaZJitNolPM4I/Vvdp3W8Op
        ms21fUh6dFDazCnao9AWIItsNhuRNzVw955NyHY=
X-Google-Smtp-Source: AGRyM1tRHy6qAdRcOWPJm7Hclq8PLoYBPeFnpt3w99aL6hB8FkvHXCqcptVsUx70VdLZoAubXzrEOCVVZFfBuk7KB78=
X-Received: by 2002:a05:6870:5ba6:b0:f1:5840:f3a5 with SMTP id
 em38-20020a0568705ba600b000f15840f3a5mr1578547oab.254.1656500492152; Wed, 29
 Jun 2022 04:01:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:1e0a:0:0:0:0 with HTTP; Wed, 29 Jun 2022 04:01:29
 -0700 (PDT)
Reply-To: dravasmit09@yahoo.com
From:   Dr Ava Smith <misslidko01@gmail.com>
Date:   Wed, 29 Jun 2022 11:01:29 +0000
Message-ID: <CADmtpX=QjMyoOah+szERMY7AogWS_K2Z=_2QOF3yq+rDZKPvPw@mail.gmail.com>
Subject: Hello Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
