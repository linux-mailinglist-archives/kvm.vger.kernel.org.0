Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECF976A241
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjGaUyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjGaUyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:54:13 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044F018C
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:54:12 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 5b1f17b1804b1-3fe1fc8768aso16093945e9.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690836850; x=1691441650;
        h=reply-to:date:to:subject:content-description
         :content-transfer-encoding:mime-version:from:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANXExHiurpsLW1+AnLl79UdLdXb9JEMrjqkSigWkyLQ=;
        b=dl64Sndt+hp7njILlOXfjLF3/tbEGLbRaVVhoySm0YnFFeoWP3wfCX8F7o1RJ2i26W
         5kFyooF+wyWJKX4tdlXDmdoZUye22SQx8zvaaYeepJ085Vi5c/+zKC0ra0LPqsH/UOV8
         X4TgY3uUHAQ548tgNrQkQkySx6rJLNAPqH4lvg3wX5Y+1ofWDEBKxTR45whrxkX5Nknp
         5LsP7gb0QBAG57Z4UDqDR3oAi6N4enkRUaGOYfipzPbz3gMqY61T+3DBhz9/h4rOIKNy
         rmToMhiSz5hkaW4QALWi6EVA9/Gsy00ROLX8sqE5vx/iOWsNtaofR7/ZryZxzg2M5eyp
         DFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690836850; x=1691441650;
        h=reply-to:date:to:subject:content-description
         :content-transfer-encoding:mime-version:from:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ANXExHiurpsLW1+AnLl79UdLdXb9JEMrjqkSigWkyLQ=;
        b=l4ixSaz3GpUGRCl3t4dKOxeY97p8LFfZoE9JQ3IajrtMwP/Wt1hn/+ftV/a09qTWUu
         irE66AzvwCpmMt4ibpem5Tls3ZM7n5EKFYLdWPxpk3UGVbVufc8fS3sZsvWk+H98AU1h
         fIzlT6OeA8K7tRE5yFvLQGiUQffayL6TaqrveYZkz9b4bufHfftEuUYw7vJ1kzkm2SWf
         qAiFvHOIjGIZHyMpp/JkZwUud3S0MZEEBHJqvgegTKytw3ifSORYuVoHL60pv3kMLy6d
         5QM1yLeQDtjvAhoezZ+d92yAJ9V3qeVR/K5dUp2oLYmmnKI7kZqhkMGE0S/BFDh1F6pu
         ezaQ==
X-Gm-Message-State: ABy/qLbCvw9YDsBZL90sL9PM6ic/eh3domkG2tp8tGpAKEU97hWBp95t
        TxTSA6Aw7vCcCs3MCqMAJzRA1A01T5G+/t3v
X-Google-Smtp-Source: APBJJlFTPBbHgGH4f/QyFbGXFpEy4oJAEmd2whn4Jgx9tppQB6vF3bH/knMjX6lcwdQF4QuJtXHtgA==
X-Received: by 2002:a7b:c314:0:b0:3f6:1474:905 with SMTP id k20-20020a7bc314000000b003f614740905mr824685wmj.29.1690836850240;
        Mon, 31 Jul 2023 13:54:10 -0700 (PDT)
Received: from [192.168.1.102] ([91.239.206.92])
        by smtp.gmail.com with ESMTPSA id v18-20020a05600c215200b003fe0bb31a6asm9377853wml.43.2023.07.31.13.54.08
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 31 Jul 2023 13:54:10 -0700 (PDT)
Message-ID: <64c81f72.050a0220.36102.a598@mx.google.com>
From:   World Health Empowerment Organization Group 
        <alexyvonne671@gmail.com>
X-Google-Original-From: World Health Empowerment Organization Group
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: We have a Job opportunity for you in your country;
To:     Recipients <World@vger.kernel.org>
Date:   Tue, 01 Aug 2023 03:53:49 +0700
Reply-To: drjeromewalcott@gmail.com
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,TO_MALFORMED,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings! Sir /Madam.
                   =

We are writing this email to you from (World Health Organization Empowermen=
t Group) to inform you that we have a Job opportunity for you in your count=
ry, if you receive this message, send your CV or your information, Your Ful=
l Name, Your Address, Your Occupation, to (Dr.Jerome) via this email addres=
s: drjeromewalcott@gmail.com  For more information about the Job. The Job c=
annot stop your business or the work you are doing already. =


We know that this Message may come as a surprise to you.

Best Regards
Dr.Jerome =

Office Email:drjeromewalcott@gmail.com
Office  WhatsApp Number: +447405575102. =

Office Contact Number: +1-7712204594
