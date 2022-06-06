Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2310053E87A
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiFFJsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 05:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiFFJsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 05:48:40 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D926FB438
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 02:48:38 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso534116fac.4
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 02:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=DCTOHlnn9bgmau2O5B11dgpXKkwCcv7DNwv92J7STCs=;
        b=Zci2T29tpQddMU1sXXYczf+wTYogXwBhsuQpZZXjZmKYuBApqrBZV4dVT3oxiiHFHd
         gCpZYfVyvoMA97096YUXQ3IsBnOfVsNsY+9WRSTWl0cIRnj5URx+e2sHwqCzP2GwzanG
         fxbTRFQP3d/OvYKPWB2tfyYOKakspAc0tzZ/iHdaLq5///zSVUBLkhBHXUku0pk6a76V
         AjAqtOkTgb5wWXPhb4d4Yznoh9CIGXErPacZj84Q9/HjqqLg6SweVa6lFoFcSCtIl1sB
         sk3jq1rOWOxkhwjGEp+4neo8/EtKi5hUhfFFOpQC7Y3IHIz6De5MWjunXxC87j049PV4
         HPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=DCTOHlnn9bgmau2O5B11dgpXKkwCcv7DNwv92J7STCs=;
        b=jZGCySGMoNsFNmXyLw7RIZ4uAe5lUlxTaTbhLXd4kWjAyinph6j0mf4t1PVNLS8y7e
         Aunht6IzZgknEAmwJK2G7dgyScCWgmc2yvOe5lSw/qM41etPXqGNOgHpmeEYfjrSBMbb
         9d07LWEvQ7Uh7X6VrZH6tqmIbF0oRzvpY7WvHl9ZHR3LOILYBjAembccHQRX73FDFIsJ
         6iRBV78FUJO/QJFpblD6UNyEX934qo5m/ewPVyU0p8ZH1jXc6sX74Wq/6BJfeMLfmF7V
         w+5m7iYdFa7QFN7BU7x0hvttU5XX8F7bkD2hJ03mvsSCZ/FUHKH5b1V3G1vv2ALJEbaS
         X8nw==
X-Gm-Message-State: AOAM530v6w/0jSS3iXGjYCiVwgAqSRkTEjYC4R5HqMWBBpr8mIzev9zQ
        sBKrkQM8Q6UNUem4+pMXOZ/92WrCzGu6S7PWPm8=
X-Google-Smtp-Source: ABdhPJy7SQLoQNE2sfY0vXYWdnc1ZYzh1a/RXzoL48RtiujZSe5GdIeGSZrmfUo6/6rX3wW7uBUf77cd7sM5UVnVJtE=
X-Received: by 2002:a05:6870:c092:b0:f1:efd3:ef9e with SMTP id
 c18-20020a056870c09200b000f1efd3ef9emr28940342oad.92.1654508917867; Mon, 06
 Jun 2022 02:48:37 -0700 (PDT)
MIME-Version: 1.0
Sender: avriharry612@gmail.com
Received: by 2002:a05:6830:249a:0:0:0:0 with HTTP; Mon, 6 Jun 2022 02:48:37
 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Mon, 6 Jun 2022 09:48:37 +0000
X-Google-Sender-Auth: gJPRzt7rckG-BHlehY6FLrzxQqU
Message-ID: <CALnSw1M2r6W+tD7Am84CaZu6GGcYYbwjFe5Lb7ams9tsFwRNBQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, how have you been? I'm yet to receive a reply from you in regards
to my two previous emails, please check and get back to me.
