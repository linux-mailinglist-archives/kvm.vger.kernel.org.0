Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0C4573B5E
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 18:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiGMQi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 12:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiGMQi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 12:38:26 -0400
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D4CDFF6
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 09:38:23 -0700 (PDT)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-10bd4812c29so14661361fac.11
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 09:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=+u/i1bRRTmx7GoF+ebXcml8ddYCvtftnnKtg3nFuG0E=;
        b=dRQ8GNB301GgBsEUB/jzpiMY6Zy5kBswjd6ee1Eg2RpTRLzLgoyGMeMMEBzvCnFl9g
         Xkm3S3zG6EdXGuQv9tTC4esYZrsD4w3b72P7t9/dveuebFUrycJOrAZwwm53OjcGM1if
         mhFdwDmWdSyMCg3tTyRvaZXdgP7jC5qaH9rg+jseiDchq2+RETQ8JrJBF+8bb9H3udoz
         +YLjE9PN+ejTrr1RrSdFBIHkGO5JRGTwy/mj8MUMWTONM3MKDY3KYosYtxS63/I87Gpg
         +wQs7DJxj9bTL3hzs1aWV3cIhQz9ai0/EG0GYj72AyrjP6TLzo/SlaNScam7uEoN721b
         qRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=+u/i1bRRTmx7GoF+ebXcml8ddYCvtftnnKtg3nFuG0E=;
        b=dEpulqsfTHKNq9BthwM8lRRxJTawF9OtAe7i+gW7TMk48TWIwSZ0AJjLifqr0y+mZy
         p6x45Ce+H6Ig3bcLnXAIB//Nh4zJzuAnwhp090PD+32Q3Nx7I8J0MhAIEP1+vv3/T7Ta
         J0ZYuXce8EfaJogR8VNi44JIkb6Rxu5GslawbtpFKgAqJN1U427wsGdx4nIA0qQpaKzh
         FslyrnuIChLLN6fVCRrAn04v0PT0VSuS8ynOG9bHK7v8BQt4DhYBSopFncDt+YyRBYnW
         wz1kUvuNLzMXIdjqg2R7oklXnGtUoaT9iWWiy5LexdhZoP6q6yT+Z9BWfOZO/DxfWUvO
         dMzA==
X-Gm-Message-State: AJIora/LnZdEgavnFgyc7vXyaqATWy9mgR8NZXYQsPmuYK7sJGWKllUo
        +X3RGbt/zcMp8QMPyxu0zGnIvbtGeNa5W5awUw==
X-Google-Smtp-Source: AGRyM1uHwiAEjLhuAURtk8EFuZscOR7a1nVYr9p34cS7MlUN5fmZvBOXoJquwXCH82NZ1QZAWfF5Wbk0AmRHta1/BRs=
X-Received: by 2002:a05:6870:5b81:b0:101:b256:b7d with SMTP id
 em1-20020a0568705b8100b00101b2560b7dmr5083124oab.198.1657730302738; Wed, 13
 Jul 2022 09:38:22 -0700 (PDT)
MIME-Version: 1.0
Sender: edwardjasmine52@gmail.com
Received: by 2002:a05:6808:3020:0:0:0:0 with HTTP; Wed, 13 Jul 2022 09:38:22
 -0700 (PDT)
From:   "Mrs. Rabi Affason Macus" <affasonrabi@gmail.com>
Date:   Wed, 13 Jul 2022 16:38:22 +0000
X-Google-Sender-Auth: RX_AHw0bdNAveuIsV81qhJj6Dho
Message-ID: <CAN9eyjBV7Rr+BuvoiFqFSQpnSb-6z2MM9FjByfaeca3rJF6s8g@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MY FOR MORE DETAILS.
To:     egcoj@yahoo.fr
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good morning from here this morning my dear, how are you doing today?
My name is Mrs. Rabi Affason Marcus; Please I want to confirm if you
get my previous mail concerning the Humanitarian Gesture Project that
I need your assistance to execute? Please I wait for your candid
response.

Mrs. Rabi Affason Marcus.
