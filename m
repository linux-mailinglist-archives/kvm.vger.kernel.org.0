Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81CA5299B9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 08:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiEQGrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 02:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiEQGrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 02:47:07 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942733669D
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 23:47:04 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2fefb051547so48982337b3.5
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 23:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=R9qVwZDVZYgr/idFDWYCCs4gn13+kzMPeII1mwEb40ID9CwNMVHHJDtxSlN9gA4rNN
         Jg3KRSrDeaTopIxTwrZpUKvESYUHpu7XssuML7jncRc9myqHIK0RwCZ2YuK/tsixgVQR
         CJlariUNY8Hp/F2bewVvnG+hZbgAFGN9LaxfOYaaWE1gtnSPsUEof6AMuR/x8OWTXpVC
         IQ4hOtC+5/KnwErPJVr/uNBqQ7W1rddcxMjlRdxedh7CjCuol25dFXwMOaIyaB++eieh
         Yq7WvF11pMKTJZHR+QrAN0zRi4chAlGa2bmNo2rE21ohJE/RHZdG/2JIaAJ1sbIwZCGz
         faNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=oWdTK2Ryxw+6v9kLgO22tHth7UzM9woLkjRHGTsfZZfGgqmPQKKqvU7sigeDT7wG8+
         Dy98SQYrERDW/VSHgKlgZaDpMG93QCrE06/PFphgPGQEIWxpUUE7OGjxEGvyF0qf99cx
         ML2XVOex32jxOKVzgz0kawxp63vJno6PoMzXuwV4c8TA1mln7YujbeIBJInivUIhLNTr
         u4IVTYuicWeR6MhsC9B3p2wWGsLj8WwnOh6+GL+YlJEfjWs3JwpRAuszWcEjcXJJoZB1
         hTP6Ur8VPvQR7Kfhhu49JkpbMeu0SGFsZOdme7C+G9hmjq3WzQifl6pl1GMTnRFd+90h
         /S/w==
X-Gm-Message-State: AOAM531dF6BxHi1HSqY3RcvirQXJU4cTm1bUzoVL2/NYwcf5Qu/qSTz7
        VKiVE8xi82/M/Mb6ZU9Ee3pAsn9i94nExbTel/o=
X-Google-Smtp-Source: ABdhPJwGwaIOEHhvcWJ1RqyYzYrzMSYh9fY2k41W46wFVU01ppFRMr69KIDMRBrcd0jbxFjpYETwzeFx76DGz5zDrCY=
X-Received: by 2002:a81:71c2:0:b0:2fe:c534:ddcf with SMTP id
 m185-20020a8171c2000000b002fec534ddcfmr19440085ywc.252.1652770023542; Mon, 16
 May 2022 23:47:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:8191:b0:179:888e:1844 with HTTP; Mon, 16 May 2022
 23:47:03 -0700 (PDT)
Reply-To: mrscecillelettytanm@gmail.com
From:   "Mrs.cecille Letty Tan" <kabiroubagna@gmail.com>
Date:   Mon, 16 May 2022 23:47:03 -0700
Message-ID: <CAP-q6B3YJgMEUzLf66LxSMm3eKs_YpaNEOZK1ed8dF47Ec_9MA@mail.gmail.com>
Subject: Hello
To:     kabiroubagna@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

How are you doing today, I hope you get my message urgently, please.
