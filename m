Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196947335E7
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345397AbjFPQWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345393AbjFPQVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 12:21:47 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D3644A0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 09:20:49 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 3f1490d57ef6-bc4651e3838so816824276.2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686932448; x=1689524448;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qrmcRDZqwi31YkwdnR1i4dWD3broD3YXrZDrzvOyNI=;
        b=AJiTYxcOi3HnFa4C8DVP65E8Q24ygy5CXkF7avce0qI4gf6VBgMEpDYxv8yVFi/3Is
         rFz3six0vLpHdp/j3gfEiVLH3uyJ6Ky8TDunfGcphoO2ecJ3CxHAZOXX/FdHGS7iPRf8
         WRx1BF4Pdua4wTvbu8bDxU6CHA2tLL0FG+IP3Y0YohSLiS/xJvsYC/aqPIQEOB5ss1zc
         qvbwx4+YbXgE4twwc01kQI+FQND6FPcbb0t8+kRKJmuDyuGxagI9+4bTnm2717X392Ek
         YnhJ2CfkTMP/m+MXh7qGCaC5ohAYrG3ZDRQhQ0GzBr3YuXIlnILh/o2GXd0a2Ot1vTY8
         a4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686932448; x=1689524448;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qrmcRDZqwi31YkwdnR1i4dWD3broD3YXrZDrzvOyNI=;
        b=cb8Vqy2olRqKsYTgtHS/rkIx5XbMdJ0+QFEWa5IGYRZ4eSjAy4HwDqyKReksiGKDx8
         pVDgMrPAy85+dlGhWydkJ0rlcMxP87ksh8fCY3Jcq5fWnSSC86vro6eM7BHRRsD8B0oj
         TaGCJOt3ilkvQ1Wm02c/2dG7C8YFzpnxlEJ3/5x7+l8nLBy8aUhZuVEAT2nOD+zeY4av
         IAheZOGs3YfM0+JognCaDMPODbzkeHpSUwq3sOllsQthCT6h9aZD9NARPhL/WpQtj6ai
         Qnh6metjtyRHHoUo+7AV1bgpz4r/HSawKm0hDcR+bKLVqiJDPr/lE9PKR/EdqC5bgA9I
         Ps7w==
X-Gm-Message-State: AC+VfDx5V0mfgHUi5bcdjze3urEBhyyIMK+9Gz5GVOYvbSitvv1njUCD
        eTDnX6iJglgLI8fSX0z4f+F226yDuNP5u4+7YBs=
X-Google-Smtp-Source: ACHHUZ5sEg6QNSCE/x/5bUgBNjaYCQ83uivc/NtEensWy1eU23bKZ1J2VdHq2pV8lkvIImXwW/OfnGWSF1+4NMFuFcU=
X-Received: by 2002:a81:4e4c:0:b0:56d:4906:5248 with SMTP id
 c73-20020a814e4c000000b0056d49065248mr2039468ywb.15.1686932448210; Fri, 16
 Jun 2023 09:20:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6918:d329:b0:183:8f17:44c1 with HTTP; Fri, 16 Jun 2023
 09:20:48 -0700 (PDT)
Reply-To: markwillins999@gmail.com
From:   Mark willins <mosaabibrahim888@gmail.com>
Date:   Fri, 16 Jun 2023 09:20:48 -0700
Message-ID: <CACF9fyzV3FkA9EensTA1AzZmUEKqS2ZtAhL4UqmMv-Gd9NUJDA@mail.gmail.com>
Subject: Re: Greetings!
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

Hello,


The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
