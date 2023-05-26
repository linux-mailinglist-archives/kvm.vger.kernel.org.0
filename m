Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7023712BD3
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 19:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjEZReh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 13:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjEZRef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 13:34:35 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A9A19A
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 10:34:34 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 2adb3069b0e04-4f4b256a0c9so1059812e87.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 10:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685122472; x=1687714472;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GWfAX3wP0d/3WFj3wkMH7vLqftqTMpkK6w5fJ1VRa64=;
        b=aNd7EsdDrKylJemxKCZDfK8K5iqs0nroylopQWBzxXHEHz61Z2P9pt9fit1bQNtE0/
         vB78puA6Ia2WeqF1yG7YasZJyzgN22aQiTtlkugMox9mHjXis85ElaJ5j8ZrBbn+LO2o
         DQ5DPxrsy9ycTudKqEnzSiOuqYBggGUh4aLBK2+dpuTTI1TiuGxMWOCWrxnqb2MKSma2
         hk46R3fa9wigw0DFSjEA8gtkVvUfDSu4hYPUfh8y2arKo0VZDH1MFebwTvdWGdRbsF8z
         Xcsmn71iktY5774mh5ucKf5UNXPIZA0m+b/3RIMlSEdIdGyfKgTsJI5Aj+5h8QOLb+HC
         Cj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122472; x=1687714472;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWfAX3wP0d/3WFj3wkMH7vLqftqTMpkK6w5fJ1VRa64=;
        b=UMwkBYs89zFPmXD2Zp9651R46YYNlaLigzM5WLBFoVBItwonCzkmh6eIogAplrZtes
         b+UvKvzVVWCpJ3DaWPbYngbVlTComKsglJNZ5vVUKrNLu8Gi6jNbqZUL/oWUGHxMGNxw
         t/HccOBFwmMpV1WpNs0YtB+FcgNsghMvw7KjCwZ0cNmcwPm/FUYJn0b2Sl058hKduJA2
         Jl/sR9zKnbOSQRD3qWJmAu+mh5aUVParAgHA0h+ZW87XbVeko6vWcLelSMC8fo8SYYT2
         IDA2Icp9a+FP04T3hZgQol2OH94Ju/vehbo8nYiAMmTsmEXYqNOId4dLPm1+nE1EaW/l
         bkDg==
X-Gm-Message-State: AC+VfDwdsKaiCPwq+1FeguYAebcynki2gKTIuJ8TS+9b+tFhOtPH+jB3
        /UIb6PxfGk+X7eAJMdQue00bqQj2yvH8KgMJ6/c=
X-Google-Smtp-Source: ACHHUZ4JMAbKM+SFEY/McR3oxKUhMYiOvNHosWPxjkosKobg7LAyLciKPjxJcBdKqgiJdCJg2a/OTlsrpJ+kyyPaThc=
X-Received: by 2002:a2e:9c06:0:b0:2aa:474f:16e with SMTP id
 s6-20020a2e9c06000000b002aa474f016emr878748lji.30.1685122471763; Fri, 26 May
 2023 10:34:31 -0700 (PDT)
MIME-Version: 1.0
Sender: lruby0209@gmail.com
Received: by 2002:ab3:7939:0:b0:230:8afe:766d with HTTP; Fri, 26 May 2023
 10:34:28 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Fri, 26 May 2023 19:34:28 +0200
X-Google-Sender-Auth: zXWki37FadPQVwXwyNFQP8RwLB4
Message-ID: <CAEPObtOnAPKZv8ee4Kk_QL11w5-mXZPxWRxaCm2o2+YYXPWtpA@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please forgive me for stressing you with my predicaments as I directly
believe that you will be honest to fulfill my final wish before i die.

I am Mrs.Sophia Erick, and i was Diagnosed with Cancer about 2 years
ago, before i go for a surgery i have to do this by helping the
Orphanages home, Motherless babies home, less privileged and disable
citizens and widows around the world,

So If you are interested to fulfill my final wish by using the sum of
$ 11,000,000.00, to help them as I mentioned, kindly get back to me
for more information on how the fund will be transferred to your
account.

Sincerely Mrs. Sophia Erick.
