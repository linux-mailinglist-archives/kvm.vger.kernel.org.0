Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8525EE6C2
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbiI1UoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiI1UoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:44:10 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EA8CDCD5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:43:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id r18so29527947eja.11
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=aDZS+7YRi2Ak/iXV9DY0qKul/iUV1SHt+O3b6QfU0Is=;
        b=RIG2H2o3WqLOoJ8VnCrf5DNQvgfrTDOeTSEGyL/PDm67oPEIysvDSfIboi5V/makTe
         tGmnOl7qYlvJdYwJ7QeK+2M5DHK6MZhQLSGT7zar4CBlgRTt7UK2syutCeLcaTTDtGfe
         SBlwovCGrFK8Ysmz1kPhgX/XCZh/gGTanPQNzywb6NKlf/QDZzhtvdwH2AkI7pK6Gbzm
         EV0QsN/ZyHWXcDgZPQvXiinYUwHQAgZbKKO7M1moCxe5dCKjHfhSSUj9sNRRHOw+4JIM
         dzm2aCbGHvOOgq4EwJ29uAH4HJo6nlQUYfnmgX7flnFzC0wQFow0rkv9hX/yvOgCjbA0
         jU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=aDZS+7YRi2Ak/iXV9DY0qKul/iUV1SHt+O3b6QfU0Is=;
        b=z6HQwGRH0CR+w2DOY7O/9eATEo98Wmfh368pMEcwrd2DHpIpl0JzEpP3HJetYEZRfF
         SmULQL4bmPj1pf7W5HDGsFtcl79ziBMzLck45g56pyc+vPdx1kjYdyHh8rz0/1XbxHW2
         i9+RFWuYplp7DSQcTCsZeK/GwG2TSlKhORZbImjSTkt892pOz0Pp7zwv5wzYCWnfgk/1
         QZc+C3QJb+CeBGqyQj46CQtlxSAfRcFmov4JTyfYU/aTK+yx3J1ilXy32b1ryTE1cZlu
         lAaXobrxMAolu0HqbIacfmWL+TqmckaLdaAzjuXZX7fq87vq+2LCthRYMSkEKxIl+Glv
         YYHg==
X-Gm-Message-State: ACrzQf0BgB4GZm+26JGHwh8jnO9BUK6S4cfn6VqCurCxfnmFZ96bxj1K
        xm2D4SarwxivDd3Zslooe1yA8xGqGdjo+p6Fh2c=
X-Google-Smtp-Source: AMsMyM4jooOJ63qs+GYcv0MjDE2XGbKBgLyweqi05a3OslXDqAqsQpPQzXbUiETUepo5Jk1t+ddeXXis6LYZKfrL67w=
X-Received: by 2002:a17:907:2c41:b0:779:f8e7:ec32 with SMTP id
 hf1-20020a1709072c4100b00779f8e7ec32mr28691514ejc.392.1664397837008; Wed, 28
 Sep 2022 13:43:57 -0700 (PDT)
MIME-Version: 1.0
Sender: mhseez2025@gmail.com
Received: by 2002:a05:6f02:42c9:b0:24:6232:7b3c with HTTP; Wed, 28 Sep 2022
 13:43:56 -0700 (PDT)
From:   Samira Ahmed <abdsamira696@gmail.com>
Date:   Wed, 28 Sep 2022 21:43:56 +0100
X-Google-Sender-Auth: Kpv4abEsoUyxXKPNI9C8n1r_w5U
Message-ID: <CA+tA-kQeKrps3E2UvosPWH_13g7OjnQi8qoQVe84mDVonAJiSQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

How are you? I am Samira ,can I talk to you.
