Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25D24D3DD5
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 01:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiCJAFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 19:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiCJAE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 19:04:58 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBD55BD38
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 16:03:57 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bg10so8591266ejb.4
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 16:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=4SL1/qbkTptdsuZGoXAM80S4DBJva1Vt53CdfbCl4nw=;
        b=ekc9NaLOGjzKr0E4zbVf9pwTNT2F3An1NMtK2n7FA8OuN8r9hZk9kXr3mBUqXQn3jZ
         iAdv6zS1m2bGHg1mCF3/fRFETJP66RX7t+sXSCrWTAx6MLnOjpFUoDBcl8P47JqAHWt+
         C3m08NjMrelpDUXEr6A2uYFRqEKfryumu1JyY002J0QbhyYoi+HBs0dQViPlbkFBNqBw
         PLF5saeA9OrZtB1eU/v7F7GK4tTPZk7Vp/d4v3bLdD8TqU3De5cg8HXt1PkAGpEWCJ1I
         s4RHSO8+vWx/gcCOoXv35DYV+O+RcbCoj/ua6AC5UgwtWen+JaQOxyL0EdKKNascjMhd
         Bevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=4SL1/qbkTptdsuZGoXAM80S4DBJva1Vt53CdfbCl4nw=;
        b=F90ln0m+FJDEzLK/+A0UQMhTncd6tA/YTLsmNnvzpMl0kIglNaem/zwjZ6A5aRAD7w
         1xtj8J9ZC8wu9TI4nls8RSYBrO+b/hL4gnIoBa1gazaMh6xuxP/kUXLnkbW3OD9JfMkU
         mO83eKEnzI1n6i3tJ4HSE5ih6w+s+gCINyQWwGYk2UM7mtqi/slLT0Ka+0N6vrMxeaCD
         mLbNSh+xnKTbMVgdg2in/3/Q8rGU6OMxK0+t//Fg9RkyZANyFza+ES6WLmWazXox1k5P
         isA0YOEoSkIQkKk1WjNTOBT3bwQFCPmvWgWnjsB+cZdVPFNelRWMQprlE8qwkLcIa+s1
         +X/w==
X-Gm-Message-State: AOAM530o6qIdoa0nNsqyfv2dPwpyASYAjI+lM4oMlJcY4blwbESnPWQB
        DKFloIZlusvbJPepFxzV/ygpmxjC5FHN/ARYejY=
X-Google-Smtp-Source: ABdhPJxVjwdrh3t+bXKaAmMeyjE5zNr483nXanPUMp2n/5O2l0UIsU0V7Wq9L9U1I/bzzfBNUgM+CP7tACvKOabvwS4=
X-Received: by 2002:a17:906:3fd4:b0:6db:143a:cf62 with SMTP id
 k20-20020a1709063fd400b006db143acf62mr2006975ejj.454.1646870635883; Wed, 09
 Mar 2022 16:03:55 -0800 (PST)
MIME-Version: 1.0
Sender: julianterry39@gmail.com
Received: by 2002:a54:2346:0:0:0:0:0 with HTTP; Wed, 9 Mar 2022 16:03:55 -0800 (PST)
From:   "Mrs. Latifa Rassim Mohamad" <rassimlatifa400@gmail.com>
Date:   Wed, 9 Mar 2022 16:03:55 -0800
X-Google-Sender-Auth: M5h18z150_hlbrRhYQiv9AmkZ54
Message-ID: <CA+Kqa7f5XEie06WBak4LGQJfD_U-7JuY9SCFoqeYSQP0g22xKg@mail.gmail.com>
Subject: Hello my beloved.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings dears,

Hello my dear Good evening from here this evening, how are you doing
today? My name is Mrs.  Latifa Rassim Mohamad from Saudi Arabia, I
have something very important and serious i will like to discuss with
you privately, so i hope this is your private email?

Mrs. Latifa Rassim Mohamad.
