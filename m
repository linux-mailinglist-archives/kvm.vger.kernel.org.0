Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9569053504A
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 15:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346526AbiEZN7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 09:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiEZN7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 09:59:31 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A56C0FA
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 06:59:30 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id y141so2968212ybe.13
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=sKSXgk/nk/WSkPpE0LnWU5w6MMzn9hzZMkx/hz1110g=;
        b=M3c9+kRn84mwhYAsCWctIT1IDSmYMwZmK3zeoIHPUCtjr51Pp1h94Rs0hX6EIMzSIO
         K9AGkvjOhfjDgvwFunkRLGpfgtaeBPhSzfV93d0HSl2a8uFxWy3ql3Elfo04C1rMF1Z0
         u399JQgS56srDhqL9IUYZytWY7u1C05G+A/b82r5XunDwWSPe274HIMtQ5IN5c/NHSNT
         NFRuBN2clB8OK4VxFRB6oYoiXr4XtIQE67/By8etgwri52PsFQYracC/AkM2JvBfjw5c
         APsBo9Vn5JPLLnYQfPhu3RMFCRnEVvmO+ZcHpt3Xu8YHxOhuxPrxmlI56/oeqVK6RsqI
         oe+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=sKSXgk/nk/WSkPpE0LnWU5w6MMzn9hzZMkx/hz1110g=;
        b=dU8pAorY6+2Mf8iPmYly+hJD0TVegTMuh2TT1iirJyINv46YTzsmE2wFutCVApKnfQ
         FA0wJrdBhbAeqdZlZUVPKiyliKGvJ0cxx6O2tsNVwdp6WiWA0eYVAfhZFIUPDbCXtLLz
         Dl++jjR6geEyobmnZVNC0aWZ1AL7gBS1rBYKK0LwSH+6R6to3IOxkLD/4tqT9kt6eXgG
         XI+xHY/uEhL0uy+Y7WS6pZCw90gWRD7O38qpi/GwsxxzUdFIv8uD6xTLkk7E6agGz5rL
         lOuvdaHKVLjzOn0YG4blOBoFjjwM/AK1qpvL/VjMmk69995HCcZLJycGNDu6IwUOFOOC
         5ZaQ==
X-Gm-Message-State: AOAM532xmu70Dc7j+B6zoWfgtwcOmxEnT7TSX56Z3foMepKX7Ypz5HV/
        KNG+aW1rSeVQmem/BnYZqL0Bq24GHczOgZrkwyw=
X-Google-Smtp-Source: ABdhPJykDwYykH1r34a482bpllF9aoIQM+YBDMDPLtrZBYW9aGnPPhX1bzjKd1ZPMWlRQfcVJhin9HSEKF7CbhIOnWc=
X-Received: by 2002:a05:6902:102a:b0:64f:4132:9be with SMTP id
 x10-20020a056902102a00b0064f413209bemr33838335ybt.288.1653573569271; Thu, 26
 May 2022 06:59:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:2590:b0:2d2:296a:7286 with HTTP; Thu, 26 May 2022
 06:59:28 -0700 (PDT)
Reply-To: illuminatihome999world@gmail.com
From:   Vic Naluzzi <naluzzivic49@gmail.com>
Date:   Thu, 26 May 2022 06:59:28 -0700
Message-ID: <CA+bhdZ37ExgDCfDSCsnuvHTt=ocKTP-c0VGeRFjocLL_6W9DTg@mail.gmail.com>
Subject: ILLUMINATI
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5025]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [naluzzivic49[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [naluzzivic49[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
WELCOME TO ILLUMINATI, The Club of the Rich and Famous; is the world
oldest and largest fraternity made up of 5 Millions Members.We are one
Family under one father who is the Supreme Being. In ILLUMINATI we
believe that we were born in paradise and no member should struggle in
this world. Hence all our new members are given Money Rewards once
they join in order to upgrade their lifestyle.; interested members
should contact us via Email: illuminatihome999world@gmail.com
