Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0558CFB3
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 23:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244465AbiHHVcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 17:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243597AbiHHVcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 17:32:10 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007AD1B790
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 14:32:09 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-32269d60830so94569447b3.2
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 14:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=BP7N97YjVM4PMUACuppi4PcUKAj1aoOhRa9DbafFqaA=;
        b=itmWef8vKkHf38GDJ9MnHqnN4C9GTZDbwi1jcP4nt/J3J0XTQzvEMol6G2FeuSpv8H
         P9QtvZBQgFUBAFbm7e0UEJljvqyAPTJm7tnsE5153Ry/4ByePSFmE7EQsyRQhD9CfBFc
         AfdylAp/Uoq1My/HSE/7DZDx9oNDeOlcGv2HVySppN356X5GngZSP2T4ZOtrb7csoUdq
         urs8F3jsd8H9F6T9jqrV47SYoDqD08raplRv1emhuzMrrtn4P/KyI++s08Fe/PzgZbDb
         X9kcFB9g7gSIpFjZ8/Av8/Wvci7p22F/otB+7zL5Cmm6RQcfEc9ztWAAqYu1UmWgNZsy
         /gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=BP7N97YjVM4PMUACuppi4PcUKAj1aoOhRa9DbafFqaA=;
        b=DWYc7hxYXjRz3DywpxVCpSTbod6iOGK9Mb7g4V6uGCwB9cev5GWe8g1WbKB2WCmOac
         vIf8QbnXIElzbHlrZ3yyC1u0Qe/8vLHgVDh1kQxfjsIqmm13g1gMV/F7CQu1AqzHzAPa
         zMgG8a5SHrhbk3pPUNAHYN6Tt3R0zHGU1tkbsHR7UwqRGLQWHZ4TmSvpU8Ua+v0XHmbD
         t9h/HYv0JhwiwGikXZjAOel+ErrjpjcaTG1sAnHdDur/0lRJ2PyEnx/VYLXCSGULtjZl
         MlJoibg8q5AiMynSH2Rk6aMYrG7rv/EDH2uJT1DvMEwH/6AmhbqxG/bWQd3how8tfD6w
         Wz7g==
X-Gm-Message-State: ACgBeo2OPQz64VU8Jn6rGRyXV4Z8Fxh6otqG/j7IOY2VUXaG/oH8g/Tl
        xaLA7z0kTGOl1wuR+Ftpu1MYeja4uhngFA5awSE=
X-Google-Smtp-Source: AA6agR4sCwrj4M3qR+MTLP7x/KFmNGgVuNupzAn33EkZywGSfQggQOIA9lo1YDloo8yV6sSe5NxYfLQKXJyArX0gzOk=
X-Received: by 2002:a0d:ccc4:0:b0:328:30e0:957d with SMTP id
 o187-20020a0dccc4000000b0032830e0957dmr20644033ywd.53.1659994329132; Mon, 08
 Aug 2022 14:32:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:a20e:b0:18d:db0c:83a7 with HTTP; Mon, 8 Aug 2022
 14:32:08 -0700 (PDT)
Reply-To: keenjr73@gmail.com
From:   "Keen J. Richardson" <angelamarina137@gmail.com>
Date:   Mon, 8 Aug 2022 21:32:08 +0000
Message-ID: <CAB4TZU=LmN9E49Bu4=L4SQE3gFhjAQATrEMFFk75hPvkO7R7=g@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [keenjr73[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [angelamarina137[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [angelamarina137[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Keen J. Richardson.
