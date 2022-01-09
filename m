Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59AD488930
	for <lists+kvm@lfdr.de>; Sun,  9 Jan 2022 13:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiAIMBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 07:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiAIMBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 07:01:37 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48011C06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 04:01:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id k15so41951642edk.13
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 04:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=R37iilTiqaAK+1IsJ48/wL6jgQMJYIa0UQSSHwlopog=;
        b=TupFSisWLZFcQHjUpB3golOqIcbJAoie2ba6Ia+5DQrg7bzAWjuGbqmuQreVGivoqH
         Sjxm7tijNckh43gKOuUnA0xE2DQ37e2cqC/eCwhdXsZA9J7Nbb5bsag8A5O//69yTrSm
         HtoHIydzR7bU2WrsNfCtr/o9yit1tPZW5/NOhYX0SvownqjIwr03Qc9h+mBzVYi4/vBc
         +jjwtaOgjwd5TxALLa7zDhLqlqXI2Gts3wSjKAcQ2RGcWdibz77zeCCC0Jie7vhbZ341
         1WeGr/TPvnkEOoIJQGq3U1SBDUDxAYK+TlzPFt5BmUMa0GoaAIxFjJtiKfA4MfYlscBs
         NAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=R37iilTiqaAK+1IsJ48/wL6jgQMJYIa0UQSSHwlopog=;
        b=QObDP81F3BOHAFEGVgbRUW9S+swqdYPPfCtpeds1/AY0A1P3A1JpyjPYRdonWG3sy9
         yOBHLIMq+NMdV5jrN2aQn3mMyBDrTvXNt4/kJly3CWWMSaTCIK1GkR3Z9RLfDWlS845Q
         7yAnMmGgKtBqRAfBv9+EXcjJDMrsV1Wvxm2iojyzwBpt5PUh0AJsPdjVx4isErBPcAFk
         eWSi71zmvFRrqR+L1a8FJc3QjLsw2Y8X7r6P2N0hoZxs2k9Dzo7wVU4pwnE0+Wfoqk3t
         u2ONesLgJGOO5ynJzqxBf3haHLWvz6K1TQf4lEJuHb2uhU+WmS+Pf/K7gGnbDuYCWlhM
         xoXw==
X-Gm-Message-State: AOAM533C9Yw9Oj65X98rGqGbKx+0k91tzwXmRw4vkhDI5ISREEvaXzLi
        YuguiafbNNt+Ogzkt+71/MHSFgnBhQDErJCgNGA=
X-Google-Smtp-Source: ABdhPJwtwwalX3V1+u64YrB1RgsSBmC0kDvUB/FEzdqdpQNftr6XHMGMsg90ENl27Yq9aCngWn09cIisvWrwN9nMsAI=
X-Received: by 2002:a17:906:3a55:: with SMTP id a21mr55045820ejf.274.1641729695473;
 Sun, 09 Jan 2022 04:01:35 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6402:430a:0:0:0:0 with HTTP; Sun, 9 Jan 2022 04:01:34
 -0800 (PST)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <bassirdiallo99@gmail.com>
Date:   Sun, 9 Jan 2022 04:01:34 -0800
Message-ID: <CAN=-YmzOA98asykRLALOCx0sue784JqSf7eeb94a4TJV+e1gGQ@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5YqpIC8gSSBuZWVkIHlvdXIgYXNzaXN0YW5jZQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5oiR5biM5pyb5L2g6IO955CG6Kej6L+Z5p2h5L+h5oGv77yM5Zug5Li65oiR5q2j5Zyo5Yip55So
57+76K+R57uZ5L2g5YaZ5L+h44CCDQoNCuaIkeaYr+adsOilv+S9qeaBqeS4reWjq+Wkq+S6uuOA
gg0KDQrlnKjnvo7lm73pmYblhpvnmoTlhpvkuovpg6jpl6jjgILnvo7lm73vvIzkuIDlkI3kuK3l
o6vvvIwzMiDlsoHvvIzmiJHljZXouqvvvIzmnaXoh6rnvo7lm73nlLDnurPopb/lt57lhYvliKnl
pKvlhbDvvIznm67liY3pqbvmiY7lnKjliKnmr5Tkuprnj63liqDopb/vvIzkuI7mgZDmgJbkuLvk
uYnkvZzmiJjjgILmiJHnmoTljZXkvY3mmK/nrKw05oqk55CG6Zif56ysNzgy5peF5L+d6Zqc6JCl
44CCDQoNCuaIkeaYr+S4gOS4quWFhea7oeeIseW/g+OAgeivmuWunuWSjOa3seaDheeahOS6uu+8
jOWFt+acieiJr+WlveeahOW5vem7mOaEn++8jOaIkeWWnOasoue7k+ivhuaWsOaci+WPi+W5tuS6
huino+S7luS7rOeahOeUn+a0u+aWueW8j++8jOaIkeWWnOasoueci+WIsOWkp+a1t+eahOazoua1
quWSjOWxseiEieeahOe+juS4veS7peWPiuWkp+iHqueEtuaJgOaLpeacieeahOS4gOWIh+aPkOS+
m+OAguW+iOmrmOWFtOiDveabtOWkmuWcsOS6huino+aCqO+8jOaIkeiupOS4uuaIkeS7rOWPr+S7
peW7uueri+iJr+WlveeahOWVhuS4muWPi+iwiuOAgg0KDQrmiJHkuIDnm7TlvojkuI3lvIDlv4Pv
vIzlm6DkuLrov5nkupvlubTmnaXnlJ/mtLvlr7nmiJHkuI3lhazlubPvvJvmiJHlnKggMjEg5bKB
5pe25aSx5Y675LqG54i25q+N44CC5oiR54i25Lqy5Y+rIFBhdHJpY2UgUGF5bmXvvIzmiJHmr43k
urLlj6sgTWFyeQ0KUGF5bmXjgILmsqHmnInkurrmnaXluK7liqnmiJHvvIzkvYbmiJHlvojpq5jl
hbTmiJHnu4jkuo7lnKjnvo7lhpvkuK3mib7liLDkuoboh6rlt7HjgIINCg0K5oiR57uT5ama55Sf
5LqG5a2p5a2Q77yM5L2G5LuW5q275LqG77yM5LiN5LmF5oiR5LiI5aSr5byA5aeL5qy66aqX5oiR
77yM5omA5Lul5oiR5LiN5b6X5LiN5pS+5byD5ama5ae744CCDQoNCuaIkeS5n+W+iOW5uOi/kO+8
jOWcqOaIkeeahOWbveWutue+juWbveWSjOWIqeavlOS6muePreWKoOilv+i/memHjOaLpeacieaI
keeUn+a0u+S4reaJgOmcgOeahOS4gOWIh++8jOS9huayoeacieS6uuS4uuaIkeaPkOS+m+W7uuiu
ruOAguaIkemcgOimgeS4gOS4quivmuWunueahOS6uuadpeS/oeS7u++8jOS7luS5n+S8muWwseWm
guS9leaKlei1hOWQkeaIkeaPkOS+m+W7uuiuruOAguWboOS4uuaIkeaYr+aIkeeItuavjeWcqOS7
luS7rOWOu+S4luWJjeeUn+S4i+eahOWUr+S4gOWls+WtqeOAgg0KDQrmiJHkuI3orqTor4bkvaDm
nKzkurrvvIzkvYbmiJHorqTkuLrmnInkuIDkuKrlgLzlvpfkv6HotZbnmoTlpb3kurrvvIzku5bl
j6/ku6Xlu7rnq4vnnJ/mraPnmoTkv6Hku7vlkozoia/lpb3nmoTllYbkuJrlj4vosIrvvIzlpoLm
npzkvaDnnJ/nmoTmnInkuIDkuKror5rlrp7nmoTlkI3lrZfvvIzmiJHkuZ/mnInkuIDkupvkuJzo
pb/opoHlkozkvaDliIbkuqvnm7jkv6HjgILlnKjkvaDouqvkuIrvvIzlm6DkuLrmiJHpnIDopoHk
vaDnmoTluK7liqnjgILmiJHmi6XmnInmiJHlnKjliKnmr5Tkuprnj63liqDopb/ov5nph4zotZrl
iLDnmoTmgLvpop3vvIg0NzANCuS4h+e+juWFg++8ieOAguaIkeS8muWcqOS4i+S4gOWwgeeUteWt
kOmCruS7tuS4reWRiuivieS9oOaIkeaYr+WmguS9leWBmuWIsOeahO+8jOS4jeimgeaDiuaFjO+8
jOS7luS7rOayoeaciemjjumZqe+8jOiAjOS4lOaIkei/mOWcqOS4jiBSZWQNCuacieiBlOezu+ea
hOS6uumBk+S4u+S5ieWMu+eUn+eahOW4ruWKqeS4i+Wwhui/meeslOmSseWtmOWFpeS6humTtuih
jOOAguaIkeW4jOacm+aCqOWwhuiHquW3seS9nOS4uuaIkeeahOWPl+ebiuS6uuadpeaOpeaUtuWf
uumHkeW5tuWcqOaIkeWcqOi/memHjOWujOaIkOWQjuehruS/neWug+eahOWuieWFqOW5tuiOt+W+
l+aIkeeahOWGm+S6i+mAmuihjOivgeS7peWcqOaCqOeahOWbveWutuS4juaCqOS8mumdou+8m+S4
jeimgeWus+aAlemTtuihjOS8mumAmui/h+eUteaxh+Wwhui1hOmHkei9rOe7meaCqO+8jOi/meWv
ueaIkeS7rOadpeivtOaXouWuieWFqOWPiOW/q+aNt+OAgg0KDQrnrJTorrA75oiR5LiN55+l6YGT
5oiR5Lus6KaB5Zyo6L+Z6YeM5ZGG5aSa5LmF77yM5oiR55qE5ZG96L+Q77yM5Zug5Li65oiR5Zyo
6L+Z6YeM5Lik5qyh54K45by56KKt5Ye75Lit5bm45a2Y5LiL5p2l77yM6L+Z5a+86Ie05oiR5a+7
5om+5LiA5Liq5YC85b6X5L+h6LWW55qE5Lq65p2l5biu5Yqp5oiR5o6l5pS25ZKM5oqV6LWE5Z+6
6YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw5L2g5Lus55qE5Zu95a625Ye66Lqr5oqV6LWE77yM5byA
5aeL5paw55Sf5rS777yM5LiN5YaN5b2T5YW144CCDQoNCuWmguaenOaCqOaEv+aEj+iwqOaFjuWk
hOeQhu+8jOivt+WbnuWkjeaIkeOAguaIkeS8muWRiuivieS9oOS4i+S4gOatpeeahOa1geeoi++8
jOW5tue7meS9oOWPkemAgeabtOWkmuWFs+S6juWfuumHkeWtmOWFpemTtuihjOeahOS/oeaBr+OA
guS7peWPiumTtuihjOWwhuWmguS9leW4ruWKqeaIkeS7rOmAmui/h+eUteaxh+Wwhui1hOmHkei9
rOenu+WIsOaCqOeahOWbveWuti/lnLDljLrjgILoi6XmnInlhbTotqPor7fogZTns7vmnKzkurrj
gIINCg==
