Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE46AAB25
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 17:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCDQh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 11:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCDQh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 11:37:57 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6492CFD
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 08:37:52 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bi9so7451534lfb.2
        for <kvm@vger.kernel.org>; Sat, 04 Mar 2023 08:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkI2MmqGF5oIUSFRmETEokwPY40pnpPnttUx4Cx3Heo=;
        b=gByic0j7bfMhqP+FT0SX9nPlkZSUUKUuml3HlwAlV/MwC6RV4Yx9vNBI1CFt4r2D9j
         KjHevo1toKrsvSad+sFdJ3uaQbbrSfm4/6LY36aai6N4+ycn/RLs/NkqjsaJVbHrmAla
         N1DB7Q34Ow3dB6gwTEGq7Wk0P5c7KNL49LQrpXNIc6REE08xQqm/Iwj9V6wHVqPyJByW
         ozVHKPyuzvupIL3duWGiy5bGEUqQrGPs8JUF0iJ2XJgBEYIAgt89hgTdjGVHSfs+xh02
         sQVHGDclK72lAyaMftbAioFQTyzH/PDGGf3TPcE/za5DLYVT2SCP+IpQIr/eDTBOBAbY
         aa9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FkI2MmqGF5oIUSFRmETEokwPY40pnpPnttUx4Cx3Heo=;
        b=OWIxr5Ts20w7xUX/S7s1mO3pk/JxadzfFhTCp3tvOzitqo2JowG02ThWj6FI17Cege
         9qUMkkyIepWqmk/Dj79wYVQBDaU/HZcgrBsOiXkaytG3lv8QDMCV4t/wrFoBRzBlwcSG
         RHdA58uh2aD0/91uc+1lRu0ksW8wz0JUqc4cOALnYxCdTVeFCv4y+YBBc8ExYfVJLe4h
         TSJKBXePX8HqjU/nK1uqpK18slFgDV3NJ75ox/F/5ljHkPrar/x9i/pte3UzW3Y3EXmg
         H1icEmZsIlAXUFTbDLJbYZ/MJ8JvLKxDykB8w606aocHJv/NHQU7gHMdPOcHpd5rLDin
         mr/Q==
X-Gm-Message-State: AO0yUKVuSAuZwa/SbPQIBYdjM0vVzXnHbDfg4vYwovQZO+st963ODY5j
        9vD72Ve2Aw4d+ZXr6Vxw4/ogXUFvdI7StPVrEQU=
X-Google-Smtp-Source: AK7set8Q1H4IxsPztEF5M9KOrLWvdnVXr490Qw8LdLJoSlzQPZDf22TbtfIMN93b7D7uXHB5bK3FphQFlX7bJ/0AA2Q=
X-Received: by 2002:a05:6512:3c3:b0:4d8:63cd:bd26 with SMTP id
 w3-20020a05651203c300b004d863cdbd26mr1742218lfp.10.1677947870816; Sat, 04 Mar
 2023 08:37:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:3a5:0:b0:222:3d44:63aa with HTTP; Sat, 4 Mar 2023
 08:37:50 -0800 (PST)
Reply-To: tamimbinhamadalthani00@gmail.com
From:   Tamim bin <nnannaidika2010@gmail.com>
Date:   Sat, 4 Mar 2023 08:37:50 -0800
Message-ID: <CADkarawjx=RypBgARCAxeRnGa+eWjOVaZv09LNZnTeS2DKOpxg@mail.gmail.com>
Subject: RE:Saudi Arabia-Inquiry about your products.!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5033]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:134 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [tamimbinhamadalthani00[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nnannaidika2010[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nnannaidika2010[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,



Can you supply your products to  the government of (Saudi Arabia). We
buy in larger quantity if your company can supply please reply with
your products detail for more information.

Looking forward to hearing from you.

Thanks and Regards

 Mr. Tamim bin Hamad Al Thani

Email:tamimbinhamadalthani00@gmail.com
