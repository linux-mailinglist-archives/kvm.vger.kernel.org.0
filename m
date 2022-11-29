Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2FE63C648
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiK2RRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 12:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiK2RRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 12:17:53 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D185A1D307
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:17:51 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w15so9994093wrl.9
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZKN9Q+eq0uc2V72eeYpmTHIZGYsEOhCOCy20hkaLTtc=;
        b=TOnYs1ecs7ME6pLERhlGGIwNLRLNc5HzSwU1yMLg31p5hI+YtZrFqz5J7fDroQsrvT
         +N0DGMtT+sJu9pV+t8DBDOZw5R7v1ruMbqI0lG9K0DhF+4IeTzKfGSy3dqxWWxwW0+gJ
         LSCMhbVm9woQ+M0lShcVR1z7jvZyZeX7rcmpjYk9kACBBKj6dasIL6ICbUUtdkLkmlRA
         5TCS1NumrfbQFwyeNPbWp4m3jXaEOAh19q3P/MV/09ocPsC4xvw+1+2/qHbT+xjLdon/
         YLJnJL10aYs2nudxaC1VOyqUMp/WM8DHNNMwKLJIs1xMTdREcVi06yx3W1sd9O7tQrY9
         +MXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKN9Q+eq0uc2V72eeYpmTHIZGYsEOhCOCy20hkaLTtc=;
        b=ZdxiIN/kjUgaJ9Pgh+DPVvFXOOOkfm4irWdoX9sxF38bXkFpMfjr8s21dY5mmRtIT6
         sOIkfxgGG+uYyLWbJIjG/lSNPnbkZu4acGXl+ONNaTWmMUryN2o909bMmkuYaUbU4jKt
         JVkZukSb0mgp6aKf1KSM+C1FTY/9JxkbMvmIxMkTFmkMynvhXFeFQ8Sh3kkL46jOKnac
         ReNpozY4P+QQedXI/op21QWryGC7Uev+7sBdIU4M1Tqp+IFuTxiL0F1Pzx0XUGd9/w4z
         41ZClyn6ukLcQuVzE86Tyip4lGFu861m716u5eg7zTNZZmTsJTn8j217nG0URzQ5vt9W
         CRTA==
X-Gm-Message-State: ANoB5pn5ZQxgmsx240vkpS0lUqzhDrl76tPDnxtdnHQOC0a0o179m6uB
        gI89Isg01SUF4liR8vh+4Ou9tFxu0FKGSOI9vf0=
X-Google-Smtp-Source: AA0mqf6vBo5wiObH76uTvIylbPUCl9CVgT10F6x+9KcRy+P0gXOk1DRqm8BRxuKJZ0GcGscr8rmLgA9gh1e034d2+Po=
X-Received: by 2002:a5d:6243:0:b0:236:6b05:a8be with SMTP id
 m3-20020a5d6243000000b002366b05a8bemr34343493wrv.346.1669742270339; Tue, 29
 Nov 2022 09:17:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:600c:384c:0:0:0:0 with HTTP; Tue, 29 Nov 2022 09:17:49
 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <banglebea@gmail.com>
Date:   Tue, 29 Nov 2022 17:17:49 +0000
Message-ID: <CADTJrWO1Fw6rJ-CaE7GsX7uDzdXvagZ1ds+x3cGtz8uW04SRJg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Dear Friend,

I have an important message for you.

Sincerely,

Mrs thaj xoa
