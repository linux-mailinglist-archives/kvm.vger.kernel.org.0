Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F8790B8A
	for <lists+kvm@lfdr.de>; Sun,  3 Sep 2023 13:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbjICLJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 07:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbjICLJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 07:09:45 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07455127
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 04:09:42 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99c1d03e124so74769066b.2
        for <kvm@vger.kernel.org>; Sun, 03 Sep 2023 04:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693739380; x=1694344180; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btDICSS3U/0vq+m5JCOU9lxhxHmOA0DRG3PsdFIiFQc=;
        b=HcVFdbKF7x5TzoZZYa9VWk1bvTSBzd3pc2tYsin5cB+bmjTOWv/C7k4m1vMjH8HiR/
         ZSiiHe3US3goOTO8xkp3C2HHh4sBBnHyQE7sYXB2eQNKqcuvV1tjcABcCfXrI7YA+65v
         65508OCVpxeKzolHobcLUUCmBeffRcsfLZxZ55zVzz+U+eK71FNuVFZ5BlzBpzmHqLMd
         5AVpR1xtbuGY/2SAi1yhH5c8KsWL8g06/EEhIPnUusr17ORR208EftBsDfpXRy8iGa5x
         S5/GDYhaj64Ok3d9DmD162KOIIEKkm6HI9YGzliOMDVkHMmJuzVXw2OhJaCw1yKUhHsi
         W2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693739380; x=1694344180;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btDICSS3U/0vq+m5JCOU9lxhxHmOA0DRG3PsdFIiFQc=;
        b=iS5VC9fP9B02WdLuRwmllaZsL56kLvZyA70S8p+n0nEGaRprzLb/9jSVRX19PfbcVq
         /dQcJkEAAULmeFMgBeso8fvSgNNF4Hvhpwk9yiVu820NHRa8QqZmakirhkbXH3lKys8P
         y8TB5ufxqC8IUtspkMUNxYMl+4jeUauvpfOi35O3v+1Gzeke36WP9u8bJaJBFjsYzgkD
         5SCIuz/IaTwlK693Cm8lFfw+c44d/59tvzKzbtMXZZs8x355Qu5oIXFRXGauqSMY5Zd0
         E2i82kgcdr0BZymg+w21gIa8zGf2N4CELqhwuJp01APZuYXD2RIIlRMkC7NkpnQ/mI+L
         7UGw==
X-Gm-Message-State: AOJu0YxBpLjbboM00bXuypwRSLso49MM5N77NHP4IWV9bjOktPVuGmsd
        umc8vpnIb7c7y07o18IlJ8I7vRa5Oy5kVw0zFoM=
X-Google-Smtp-Source: AGHT+IG/SMM1eMabAvI9o2PF7/LW5nwJVOoyBEJMV9ykRLfeKXHAo24d6J8pp3BAeM57JRxzEh4lwD5UdjjkEYxZdqY=
X-Received: by 2002:a17:907:2be8:b0:9a1:b144:30eb with SMTP id
 gv40-20020a1709072be800b009a1b14430ebmr5228146ejc.54.1693739379917; Sun, 03
 Sep 2023 04:09:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:612:b0:e0:f51f:da7a with HTTP; Sun, 3 Sep 2023
 04:09:39 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Dr. Bright Phillip" <prdr6h7j9g5@gmail.com>
Date:   Sun, 3 Sep 2023 04:09:39 -0700
Message-ID: <CAJtQnu+8iBkW7XTbmWsSQdysUkfe_58g05vyYFkAc4YoTMY9ew@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

-- 
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Dr. Bright Phillip
