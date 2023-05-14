Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB79E701DD5
	for <lists+kvm@lfdr.de>; Sun, 14 May 2023 16:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjENOYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 May 2023 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjENOYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 May 2023 10:24:14 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B29A1BF6
        for <kvm@vger.kernel.org>; Sun, 14 May 2023 07:24:13 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-192c2569c72so5082834fac.2
        for <kvm@vger.kernel.org>; Sun, 14 May 2023 07:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684074252; x=1686666252;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=YcEqgBdnJmhjqCHcSKdCEvDG5SRVhZ3+XuguTE7+CLZs9xlg39jT4sfe6qFtSMOvAC
         RJl28rFzMgwGR2gW2yvkm6570F3i2+aOZy00RvlQEkigmpqd82MxY3iyzTqQiVOC4Ny9
         5jHq+R9cjG84KiTjxVVq1u+qIIpHbOys8rgM9lcqg0arfkNFJSjK2fO2Esm1xZTfdrzQ
         WVJJVM+r2b9fWdbXHuIyb9hQbNjLVv9k0mdeOmxa+tA9Ysq6oztHSVzVc2vL6vTkWEbd
         u1MtPOGoLOTh0plUXiUOehKyk3+36Y4LKz6lq51vO+cPB8E4abxpNbsf2MriXGYfEU3N
         nPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684074252; x=1686666252;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=QUoQLcJ6JKPzaqToLXkLSFNsR8DwpP5i6+NApk8g5Pv20mM8UZFHsvZLaBofKAQ1gH
         x5SgHXdJHFAljfSrRWW9PL+tXw2EwQ9zIMHznKQLwPQzCePTee0WV2PMH8xKmBTZsAhg
         HgbibAvKouKUXwkA+DBZ120JNcJ++82HtjOxZn2uCWce1mtd5QQiMxT/3Xie5asg7S85
         HuL/Bpz7PU0gKNTdHh7DJO/jIjynFUSPKo6s1/amhehKUAxqLXEzxFGWFgK83VjvFkP7
         zW8uuaCdDBj62e8ocugdRulDpw3mgGg0OuT4GWUiNAvFuidQfcGwVGfQgE7C/cAukKOW
         AASg==
X-Gm-Message-State: AC+VfDxw2vHVjaFv/TnrFT+lTm0cU7MJE+wkheXN6RI2hMpdnEdUZVzC
        99G9CiQkgPXBqRNtP4fr5V7QoqfG6wW65OwIxVs=
X-Google-Smtp-Source: ACHHUZ4+o6/zRWRepQ6pjG1iK8tfNaGdj6GW1V20Qyn5mUPGKUxuZ8HTlaEZOZQUSE5pdRFVpQ9rAao0HAC2guft70I=
X-Received: by 2002:a05:6808:408a:b0:38b:b27b:325e with SMTP id
 db10-20020a056808408a00b0038bb27b325emr8406743oib.30.1684074252246; Sun, 14
 May 2023 07:24:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6850:4f88:b0:499:fe92:c588 with HTTP; Sun, 14 May 2023
 07:24:11 -0700 (PDT)
Reply-To: pmichae7707@gmail.com
From:   paul michael <paulmichael2466@gmail.com>
Date:   Sun, 14 May 2023 15:24:11 +0100
Message-ID: <CACzWseovuA2dH1PJrNoZ13usHc-076L2Os8EjAQfNDJ6ige4iA@mail.gmail.com>
Subject: Hello good
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

Every time I retest your email, it tells me to check with my ISP or
Log onto incoming mail server (POP3): Your e-mail server rejected .
Kindly verify if your email is still valid for us to talk.
