Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EBA53D984
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 05:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbiFEDs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jun 2022 23:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346204AbiFEDs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jun 2022 23:48:56 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637714D27D
        for <kvm@vger.kernel.org>; Sat,  4 Jun 2022 20:48:54 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w16so5623201oie.5
        for <kvm@vger.kernel.org>; Sat, 04 Jun 2022 20:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3x72/ah7oVy1n7hZQ2TRq4JYjiu8oyFxE5Jon1kCtcA=;
        b=PiTY5yB2n3wz+NleA3DAHREjMxYRrMTbztfZk8tUBpdruIyaK/1b6l1xdx7wzLiwxb
         wD0U+i2nDD/AzgJd5twWK8rBdqb50I2XkbvANlx6oRJjcGviao53HaZIpDYadhRoNdD0
         xTKulwAZ19CWDWJa97SAAEhHYIlUUeDl2hBCHiwT0stfh/4MFWaSxZ86Ou0kojJfvTtj
         iA2Qob9ukNXKBYvO4+zX07r1DXGwg+mfikcTY8lEHisQnlINcneDwpwMGR3tb6k2+jJy
         MPXv9hFEZ1e+vVUHd6siD4HGf6IDB8VqWrKgefK4u7iOTAeBzKRwimpFOng3am+9HH33
         nBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=3x72/ah7oVy1n7hZQ2TRq4JYjiu8oyFxE5Jon1kCtcA=;
        b=7/pqdyfwva68MM2CoqIv2PZ1k7kcJgp8iWeJNDbGy7LAtZub8XeqE56v3qNC9rPxg4
         5i6KkcNprRw1ydzRMqLZyv0a/GXFM+AJ8ViuS9sjIzU5zay1lynyEdeufsDZE2KtFJQx
         PKV96QaaLjQz9fOQp3bnAoQUyFXQCn8NC7MEkq4CBZvK3D9OFbQyUbYd7r9M3X3PunXp
         SL5VBQi+173/cdrkllG+TaU3bznLjkgpSY42ZXzCG5R4lf6UtFJIeu0eaG4u/yjI+VSy
         9GopODQbCakh6fNcqs9eMCntexS5l9IhewJq9GyEGbDNsOqVlVd9rMbgbLLpC9Gxf59y
         mEEA==
X-Gm-Message-State: AOAM5310GHkpLmRe02ait15hbpECzSKH8eYf664XXovljEBwaN3466Tw
        Jk/xCvBuhxvmekH3rfAZYkfl3Su1RYA85QDYlO4=
X-Google-Smtp-Source: ABdhPJxPYOjFv7RMEF7YHNd6GUG/39v0jv78jNbQhcCoIqc/xWdVhSM8iW0PTLDZwuKRtn7gcIyHXCa309K2sJ8/afo=
X-Received: by 2002:a05:6808:2196:b0:32b:274e:fcbc with SMTP id
 be22-20020a056808219600b0032b274efcbcmr27144265oib.266.1654400933650; Sat, 04
 Jun 2022 20:48:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:71dc:0:0:0:0:0 with HTTP; Sat, 4 Jun 2022 20:48:53 -0700 (PDT)
Reply-To: mrstheresaheidi8@gmail.com
From:   Ms Theresa Heidi <christiantotin310@gmail.com>
Date:   Sat, 4 Jun 2022 20:48:53 -0700
Message-ID: <CAAmZm9Lf3PrqyeeX5k=fagfsgiH73JkrVYE85RXxmRwTVsZskQ@mail.gmail.com>
Subject: =?UTF-8?B?5oCl5LqL5rGC5Yqp77yB?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:242 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrstheresaheidi8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [christiantotin310[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [christiantotin310[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5oWI5ZaE5o2Q5qy+77yBDQoNCuivt+S7lOe7humYheivu++8jOaIkeefpemBk+i/meWwgeS/oeeh
ruWunuWPr+iDveS8mue7meS9oOS4gOS4quaDiuWWnOOAgiDmiJHlnKjpnIDopoHkvaDluK7liqnn
moTml7blgJnpgJrov4fnp4HkurrmkJzntKLpgYfliLDkuobkvaDnmoTnlLXlrZDpgq7ku7bogZTn
s7vjgIINCuaIkeaAgOedgOayiemHjeeahOaCsuS8pOWGmei/meWwgemCruS7tue7meS9oO+8jOaI
kemAieaLqemAmui/h+S6kuiBlOe9keS4juS9oOiBlOezu++8jOWboOS4uuWug+S7jeeEtuaYr+ac
gOW/q+eahOayn+mAmuWqkuS7i+OAgg0KDQrmiJHmmK82MuWygeeahOeJueiVvuiOjirmtbfokoLl
pKvkurrvvIznm67liY3lm6DogrrnmYzlnKjku6XoibLliJfnmoTkuIDlrrbnp4Hnq4vljLvpmaLk
vY/pmaLmsrvnlpfjgIINCjTlubTliY3vvIzmiJHnmoTkuIjlpKvljrvkuJblkI7vvIzmiJHnq4vl
jbPooqvor4rmlq3lh7rmgqPmnInogrrnmYzvvIzku5bmiorku5bmiYDmnInnmoTkuIDliIfpg73n
lZnnu5nkuobmiJHjgIIg5oiR5bim552A5oiR55qE56yU6K6w5pys55S16ISR5Zyo5LiA5a625Yy7
6Zmi6YeM77yM5oiR5LiA55u05Zyo5o6l5Y+X6IK66YOo55mM55eH55qE5rK755aX44CCDQoNCuaI
keS7juaIkeW3suaVheeahOS4iOWkq+mCo+mHjOe7p+aJv+S6huS4gOeslOi1hOmHke+8jOWPquac
iTI1MOS4h+e+juWFg++8iDI1MOS4h+e+juWFg++8ieOAgueOsOWcqOW+iOaYjuaYvu+8jOaIkeat
o+WcqOaOpei/keeUn+WRveeahOacgOWQjuWHoOWkqe+8jOaIkeiupOS4uuaIkeS4jeWGjemcgOim
gei/meeslOmSseS6huOAgg0K5oiR55qE5Yy755Sf6K6p5oiR5piO55m977yM55Sx5LqO6IK655mM
55qE6Zeu6aKY77yM5oiR5LiN5Lya5oyB57ut5LiA5bm044CCDQoNCui/meeslOmSsei/mOWcqOWb
veWklumTtuihjO+8jOeuoeeQhuWxguS7peecn+ato+eahOS4u+S6uueahOi6q+S7veWGmeS/oee7
meaIke+8jOimgeaxguaIkeWHuumdouaUtumSse+8jOaIluiAheetvuWPkeaOiOadg+S5pu+8jOiu
qeWIq+S6uuS7o+aIkeaUtumSse+8jOWboOS4uuaIkeeUn+eXheS4jeiDvei/h+adpeOAgg0K5aaC
5p6c5LiN6YeH5Y+W6KGM5Yqo77yM6ZO26KGM5Y+v6IO95Lya5Zug5Li65L+d5oyB6L+Z5LmI6ZW/
5pe26Ze06ICM6KKr5rKh5pS26LWE6YeR44CCDQoNCuaIkeWGs+WumuS4juaCqOiBlOezu++8jOWm
guaenOaCqOaEv+aEj+W5tuacieWFtOi2o+W4ruWKqeaIkeS7juWkluWbvemTtuihjOaPkOWPlui/
meeslOmSse+8jOeEtuWQjuWwhui1hOmHkeeUqOS6juaFiOWWhOS6i+S4mu+8jOW4ruWKqeW8seWK
v+e+pOS9k+OAgg0K5oiR6KaB5L2g5Zyo5oiR5Ye65LqL5LmL5YmN55yf6K+a5Zyw5aSE55CG6L+Z
5Lqb5L+h5omY5Z+66YeR44CCIOi/meS4jeaYr+S4gOeslOiiq+ebl+eahOmSse+8jOS5n+ayoeac
iea2ieWPiueahOWNsemZqeaYrzEwMCXnmoTpo47pmanlhY3otLnkuI7lhYXliIbnmoTms5Xlvovo
r4HmmI7jgIINCg0K5oiR6KaB5L2g5ou/NDUl55qE6ZKx57uZ5L2g5Liq5Lq65L2/55So77yM6ICM
NTUl55qE6ZKx5bCG55So5LqO5oWI5ZaE5bel5L2c44CCDQrmiJHlsIbmhJ/osKLmgqjlnKjov5nk
u7bkuovkuIrmnIDlpKfnmoTkv6Hku7vlkozkv53lr4bvvIzku6Xlrp7njrDmiJHnmoTlhoXlv4Pm
hL/mnJvvvIzlm6DkuLrmiJHkuI3mg7PopoHku7vkvZXkvJrljbHlj4rmiJHmnIDlkI7nmoTmhL/m
nJvnmoTkuJzopb/jgIINCuaIkeW+iOaKseatie+8jOWmguaenOaCqOaUtuWIsOi/meWwgeS/oeWc
qOaCqOeahOWeg+WcvumCruS7tu+8jOaYr+eUseS6juacgOi/keeahOi/nuaOpemUmeivr+WcqOi/
memHjOeahOWbveWutuOAgg0KDQrkvaDkurLniLHnmoTlprnlprnjgIINCueJueiVvuiOjirmtbfo
koLlpKvkuroNCg==
