Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBE64D889
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 10:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiLOJ0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 04:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiLOJ0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 04:26:48 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F62926FA
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 01:26:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a9so6221387pld.7
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 01:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHvqhKfwkSYWgIBUppKUElAVHImwDcI/W0up7OF2SsA=;
        b=mUk56sM9kwSU+ViZr+jON+iHdhoCezdb5Fw2l3HTI57ZeRfviaY12b0CetT767J1U4
         7bdCCfFVV23jcWuyhqAD/IJszJEdgsO4p9XKA3jnP/R+lJBf/Ulw1o9mrC50ARQHjlLm
         s1IawtDwx1K1CXPhp0buNvLPz+7XILpxcbVseKyX8MS7gfeubjw+MBHBV/RFdNNpAtFc
         InQYqSOAZboXRXHZVbp0jndQesRxGsOlOFUyIRP0M7ldbtWUJdb1OyfWV7pfAFwnXDmn
         8CXS0G5MHpn5kPb0KI9CMENcxWtT9mtGbxq5GlxZvH3ZrZ09eEYcVhIINjzy6llFwkmh
         loOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kHvqhKfwkSYWgIBUppKUElAVHImwDcI/W0up7OF2SsA=;
        b=TKRRWP97pgiQVxmF04Q/kPOpZmub8F/qlHhgauVUouaR6m+ENiBE+eMNrTFGVVuKti
         YY98e9uRtrLOKKwT19M+3+0Z2SPtJJJkSStWCMoqxs9+NHKkUYjAdxMCVfahir3o6FYQ
         GBzoASCmOCtjFoGTvk0swLdtxx/3koj+ImjjsRwv734oGY7cqSQGFmFUNWgsjhVzVmxK
         w3mVsV87UKHSMiSt4GOzXp8UcsvTf5/JwQflWMDC4aTOsVLLj15AgInwUpHfGv3cJ1QH
         41Usy6eenq5c3dL0kegaAiezDYexVzjLt4jxnTn1hjrFLUxuzRODV8LQH9RnvDSumHnU
         Lnuw==
X-Gm-Message-State: ANoB5plIzyNnGJZ8CO4iKsrFuV8JwZfp17yHa0sooh3NY0rcF5yqv962
        ADh5dIGJOllxAwjyj01BCBSoZHes1CwSDRN7CXQ=
X-Google-Smtp-Source: AA0mqf4QIimy2exiV7eQ2VnNeRKOQpYIxYh9kCiOY6EiZQIgONGJGl+Bjv/CtwLC3LBPxGLt51OCsaUkPhKEhsMnZgM=
X-Received: by 2002:a17:902:d585:b0:189:9fb2:2541 with SMTP id
 k5-20020a170902d58500b001899fb22541mr44777364plh.60.1671096406654; Thu, 15
 Dec 2022 01:26:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:bc10:b0:89:6a96:4e04 with HTTP; Thu, 15 Dec 2022
 01:26:46 -0800 (PST)
Reply-To: peterwhite202101@gmail.com
From:   Peter White <bossskelle@gmail.com>
Date:   Thu, 15 Dec 2022 09:26:46 +0000
Message-ID: <CAN5zVhvCKbTviWbNLeXDnBQwFcS60=dYAuc+tkQWpJ0-FOXO1g@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8691]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bossskelle[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [peterwhite202101[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings from here.

I want to know if this email address is still valid to write to you.
There is something important I would like to discuss with you.

Thank you

Mr. Peter White
