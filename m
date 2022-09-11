Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223475B5170
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIKWGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Sep 2022 18:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIKWGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Sep 2022 18:06:40 -0400
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2830924975
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 15:06:39 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-333a4a5d495so79678527b3.10
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 15:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=6VzaTuMkSaoKWgUM6Q1+SMdSDfZtUEniQTBorD4F7ME=;
        b=T4fsj9Pubjc5xrioOQu8gNeZFJAo9w5HZnYyBzVK5HniCTO6sV0y/Jqusu3eH+thgn
         3dagOtNYXvs/YSn09wQugf8qOJ10g4KZZJaiLU+v1nK5ijNZzWROSgMZJ1J0IjfozG2h
         hbglyFergIusqJLupXOtbwvM1f4hUll5iObMooGSc5Wzm8dsRPmNDTBOGptROa48WHGN
         +6omjm6K2VuPGRD3S3kaASi9ZCmYShdJKHJJP528gHklJavySoD+yKJtIQfOGKqcQ4ZI
         isxE7iCQz7+xCkdT4Tml5c8p+zBulXL0J6Em4MrzKW8oR1Cy8Syu207dWSQfH1mKVrsx
         orGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6VzaTuMkSaoKWgUM6Q1+SMdSDfZtUEniQTBorD4F7ME=;
        b=hg2bqqW12i3x8v3H8DzjnRqNSlSPOnIckRSklKS6LoHR9l0Su2mLqKLG644A0DHlN5
         E0U/g05kof64SmQalSNbwdFcMqIPTr+S1VM/Xoixm4Q9hn8aQrtd4/pf2t93FOfns6bI
         scqSoTb094RDyqDLH7VpUAmXX2+cFn70Ua5q/CndQXjbhKgTywA61ZesmK85uet27voI
         Nbgk7nPC3grEECvyBYNA0US5q5nv3PQQOZPaPD85x0HYoV6ULf723PtSAIFcmGg+d+gl
         WvvambMbR55tFK/uClwEO4Xyi1qfA4Bq+kPvBSpcvqlOFEUrkHrD+0Y2MD34N0rE0lek
         BZIA==
X-Gm-Message-State: ACgBeo1EOaXfg9/YnjtndwsEqBPxyqJOKRZm65ZcG3VN7lUc4fEoio9T
        9eItc+4gMzALP09zYP3o1T/ATgcCiwZ+/3SbAJQ=
X-Google-Smtp-Source: AA6agR4qpC71SZU6A965xIYNYi4XyD59icyBoBVa5efzEt5Cih9NqGCIjlEBCHFbeaVMd0pqrnEJJat0vnTpnigJgYo=
X-Received: by 2002:a81:cd3:0:b0:345:477f:be8f with SMTP id
 202-20020a810cd3000000b00345477fbe8fmr19177013ywm.41.1662933998400; Sun, 11
 Sep 2022 15:06:38 -0700 (PDT)
MIME-Version: 1.0
Sender: innocentyakububawa@gmail.com
Received: by 2002:a05:7108:2e10:0:0:0:0 with HTTP; Sun, 11 Sep 2022 15:06:38
 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Sun, 11 Sep 2022 15:06:38 -0700
X-Google-Sender-Auth: BL4PVEXAVbvsESdG_ImG7tXu4oM
Message-ID: <CAO=JbK1YrmYuZ1BbNiAuMu+MMutYX3haik7XSwj1r8tw7R-XAA@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Margaret
