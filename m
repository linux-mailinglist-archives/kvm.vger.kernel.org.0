Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7011A6FFB6F
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 22:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbjEKUqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 16:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbjEKUqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 16:46:20 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C983F2705
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 13:46:13 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-559eae63801so138746057b3.2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 13:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683837973; x=1686429973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:from:to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o3IhR8j0I8r27dlVdqBeOblOhv/55O4fJqm1FBFy6Uk=;
        b=dwlrPtacT6G8IUr0BeeCMnWejqo/h/3mr9W6RtMKXd2r52d/+o6Obq1cKA9ampOlze
         tfy25EuABlw2Qui5CH+cfZLcPbIQv7DbB9VsWgB9LGIZ8zxLCtjFT1Gd63Sv2tZZCUjs
         x/JkvDsjLxDecPDcc/++KfbX3HVQ6dHSAkjoXDqI4nQRY1SV+3CeNGs7nJqWn03OZzym
         +kunqilfeOZEu2X60VWdDmyuzu01GtexseJDpO+bNS5ETSyD17gs4JIBlPiE7fN9zF6t
         eLXirZJlBT0+GaSuTsJ+v/bACGBEATy+OVyiU0T4QditQIwpCw29MpkrAGIZFK38PKKB
         n13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683837973; x=1686429973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:from:to:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3IhR8j0I8r27dlVdqBeOblOhv/55O4fJqm1FBFy6Uk=;
        b=kGFXbDUXdEFWh5HmJsdBNiZgMak252vayPa1I1Oyzxej1i0nK1iDLVcqvDk2Sd0/0n
         dgu6L54z98Y8w784EFhfzFuuxMOjx3H8NQCEcGDFuU/T9av2EiclPPSQbqVBhsZFcDUb
         4xc67BsgP89VTuQTukMcJmlex/mFFibMnoIcXJhqh69YKo8sjhp0zpeoS3ZigPRMH6u2
         DL31GbC3/NdDXJm75rFjEIcDc5YJT/dWw8nnOooYgYNoyxbDnDxQuoGi1j0Y8bvpaYwS
         Ga3czuE5oCbyPciTTlU427N4Z0zuK5MrRx9cBxCTlznV57kR0BmK2vTIXVFOM7xD+f8e
         m+5A==
X-Gm-Message-State: AC+VfDxbNuYBeN9mDd2aJJDVSP72oCJDWzRt07jxCkhnUp0kTSvS7J9B
        SuCMOLLkCPMeO/ofhqZK5PlMkw8ATtY=
X-Google-Smtp-Source: ACHHUZ7Z7TfTjuU9gnpUqFfJz0YPhH0pypbdQaOMK8IU0jLXQ3wzyVZY2LqtqOFD62KjPX3/VMUL3g==
X-Received: by 2002:a0d:cc09:0:b0:55a:5870:3d47 with SMTP id o9-20020a0dcc09000000b0055a58703d47mr22755307ywd.26.1683837972752;
        Thu, 11 May 2023 13:46:12 -0700 (PDT)
Received: from Ubuntu (alpha.fresent.com. [64.44.167.152])
        by smtp.gmail.com with ESMTPSA id h123-20020a0df781000000b0055a382ae26fsm4325672ywf.49.2023.05.11.13.46.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 13:46:12 -0700 (PDT)
Date:   Thu, 11 May 2023 20:46:12 +0000
To:     kvm@vger.kernel.org
From:   Karla Lambert <azogmijiga@gmail.com>
Subject: junk referral job?
Message-ID: <mce-1-603035aee28247288f64a529e2f416b4@gmail.com>
Received: 
In-Reply-To: <mce-1-603035aee28247288f64a529e2f416b4@gmail.com>
References: <mce-1-603035aee28247288f64a529e2f416b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        GUARANTEED_100_PERCENT,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi there

I came upon your Florida junk removal business on Google.

I’m contacting you because we’re getting a lot of referral jobs for residential and we currently don’t have a junk removal service in your area to send them to.

14 jobs in 30 days are 100% guaranteed by our brand-new junk removal system, or there is no charge to you.

That can have your schedule booked solid within a week. To get more jobs, more customers, and higher prices!

Reply with a quick "Yes" with your best cell phone number whether you can accept additional removal jobs.

Reply with a quick "No" if you want to be taken off the list.

Thanks,

Karla

 

Sent From My iPhone 

Capital Digital Markup 444 Alaska Avenue Torrance, CA 90503

 

 

 

 

