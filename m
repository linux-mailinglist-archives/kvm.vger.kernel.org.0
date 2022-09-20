Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191885BE463
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 13:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiITL2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 07:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiITL2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 07:28:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491276BD71
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 04:28:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b35so3442908edf.0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 04:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=8ecYicVNlqCwpTD7keug9XpsIRW3LWPQcbFkS4Vo5hc=;
        b=dHNY5aXfpe7Q0DX7URtd9X8hxta6/o66JygT4zp5kGCIxvhBIy5iJnf0ca3SFidoeh
         8dufNOljW9odysNRYSCNeLWl/JC+FztMC9+fojwTUY2spcssbYAQCnQvSPw/AuGOrIjk
         dKe16aDcNOImTahA0Aec0b3zTJj5TP58MxyLLqj/z92BjrYsNP9NRIXi/zd1hRj1Ltke
         R/MH/yUqMNPBIqVF7wpEVJW7v28mBXJgar7mWI/bJgmJtVheSXxoynNKq0+kzW6RHeAB
         HNJzqdBtzlALBgwR9JPy33FXs+HCEmJ+HM6GciNad3KfoNqmb5ozlVXEYCWJxTmQVsll
         LFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8ecYicVNlqCwpTD7keug9XpsIRW3LWPQcbFkS4Vo5hc=;
        b=6Ae4H+Wsx6ksZiG5wj6LSogrv57ImAdwnu+WFFnWDubzzX6HqJDK7sZvt3PIfLu0QQ
         /rGYO/DBDt4izlRocD/XvvDvTp8NFg88F9NrqvH7jz+1HWHFbgWioZlV0I3PEGZfSyHa
         CQnszn2R09hsHXIYidFwG5Qt6rVURfeE2pFptgiXpaS1zbAPN1XHqlqhK3Z3d3QAoxT3
         78A0TRSiykQhXRS5dEo3cSIiY/FK9PRNVlqt1e3z3uJbrBg7V6DHl4AEr8l3PoZZEAH/
         zSQ+4QvKrd9EHL4jAPSOtTJZ5WfC8SJzrz6Ch7WaKnavIacQaB2daOhW6IWuS/oEeRDC
         ChmQ==
X-Gm-Message-State: ACrzQf2A7OTmYdZkINipYlmBEP/ZuRJ1XY7n4gAAvAw2RDclYO2+DJ3A
        5hVzw+TrozrR9hHorJ7h/6vKLUI4wcGqP81xH7o=
X-Google-Smtp-Source: AMsMyM5etGSGkkYi/bAmDbWEs74UXmQYnRvmMynvakYLtWHXS4/elBtbeXrgxVL728DLUldjW1eQCqb6H1mx4oruzZI=
X-Received: by 2002:a05:6402:50ca:b0:451:a711:1389 with SMTP id
 h10-20020a05640250ca00b00451a7111389mr19116377edb.239.1663673289711; Tue, 20
 Sep 2022 04:28:09 -0700 (PDT)
MIME-Version: 1.0
Sender: nwaonugoodnessozioma@gmail.com
Received: by 2002:a50:1001:0:b0:1d1:7b93:ad5a with HTTP; Tue, 20 Sep 2022
 04:28:09 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Tue, 20 Sep 2022 04:28:09 -0700
X-Google-Sender-Auth: i64Ysk08woNXdVST13qBVcw9iYg
Message-ID: <CABNfLOzMw_PdjWtKP7wP8moFuU7f+Ffx+kCHf9ujKX2gDZwysA@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS
        autolearn=ham autolearn_force=no version=3.4.6
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
