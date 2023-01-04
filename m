Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1A65D32D
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjADMxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjADMxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:53:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530B613EA3
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 04:53:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fy8so18296105ejc.13
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 04:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=bOIR45fbCvRM6xmCqdxgTD0YNERiAosR9Nux+oftxfGxy9W8UXuBGs4l8ySMAgH+Rl
         V22SE9QF/86Jd/6Cr5AICkMH/KSknaSbCM2/LSQZVf/LL+szWas6pn3RqNzjKrjiozXU
         WC6TsC2T72Bci4cN14/bkc6tNAp+DMFsivpXW0A4LHfKYyFngbFUzepXB1r0KE/jjnP8
         31EEFZVDTAmKBGuUncgYMIkrrci245KQelmDrKYn3Hxy1TD1+h5nlRsyR+7tdUsl6OYB
         agExaRlYwuUZtL0e5j/Xqv3F/TGjP5FEjPNrtfoLa5KrgSOGABP88Y7kuifuANyJhXs6
         r3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=V48Gs8o7PHYT0CMCFqp7pMNN3FQTSg3c03GhcipQCTozu5VjX9CF2CheRatEM4+a3S
         DyMSfzhJy8ANljO0ewma5XTppO37Me3mmGpZX0qEqGzj6HUrm7kMgMSzXWnyW2iIA0c1
         p13CdB6RzBdjnKxwRS10tX7KFIV5g38mk68EM9wmmXgBNLrtCdTZhrs1By7pPRYt+K7T
         PeQw/Y3k+zq8RWFbaL4zrKuMSpOSjFKd1D79fWYF1I0orJZ96pKADfWNqoCWlEoZ/xmD
         XSJUQqu2tzTeIiOtck2jgIeVzQMPmBinXyox8+vZrrG7P+OgMvSIMsLRso2pjGnO9XjU
         L4Xw==
X-Gm-Message-State: AFqh2krPKs/L6XDwpH49NBZDm5fMCWUueQBqlmEkbn7heMsbpqltW/XU
        xF3RWepY0SQYk9tqqTt40qbzIaIyKmGNqMBbf0A=
X-Google-Smtp-Source: AMrXdXvOZ3EcIzCNsBt//wDYYIECxlBvMbeC52hRLCIduAQZTY/sFnrmGiVKWAH21oyf1vipgWVsTzLjhoE6GdJqQtg=
X-Received: by 2002:a17:906:5a8c:b0:7c1:27b:d597 with SMTP id
 l12-20020a1709065a8c00b007c1027bd597mr3298785ejq.249.1672836812647; Wed, 04
 Jan 2023 04:53:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:b852:0:0:0:0 with HTTP; Wed, 4 Jan 2023 04:53:31
 -0800 (PST)
Reply-To: Gregdenzell9@gmail.com
From:   Greg Denzell <jsong630@gmail.com>
Date:   Wed, 4 Jan 2023 12:53:31 +0000
Message-ID: <CADbAY5k58P6mUVFvqFF8Sj3SWSzb6SpWk793FwDzXgZmZ9QMcw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seasons Greetings!

This will remind you again that I have not yet received your reply to
my last message to you.
