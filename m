Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F1345F4A3
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 19:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241840AbhKZSb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 13:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242947AbhKZS36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 13:29:58 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947BCC061373
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:05:15 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id f7so6465169vkf.10
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=bPBq6esMoTOYDubs7AvTlt6cnYaycdCJ0j5SVwERB7E=;
        b=gCwHECA7vqack5sdUsol+mCBCdT/67Sjir6IIP2uP5ISz3Z+uBz7f2TnUN04aw23KD
         orf9Fd/YuAGcaiqPwsIDSmEEVhj7ZB6o4RKhkI+o7dl8Q/FfvThDINqEnQ8IAbTtCFnc
         nr52nBGduTUBLEvTqLRbCRCc6eZCnxI66+3sNdaXzkyGcPQmeXXZHPO7bA0xCJGLfODM
         B3Qohq9u1VKS39gcIlupNkAhp7URQgAxQr9RHhe3/HhBesq13Ss4mvxLCgR89RDz0FA7
         o/+ovKjs0woao888zUAelx+XyOq1uJqweyoIeTlG8DEuetD+9UfPEwSkBPN1SfooSVKY
         JHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=bPBq6esMoTOYDubs7AvTlt6cnYaycdCJ0j5SVwERB7E=;
        b=y5cdHZlMx5fbRSRFQwbwfchQCx9+Ob/pQpa2qEiFyrw+atNppp35SoO3OJHs2yXLb6
         /19rbDoELOnSH1UIlJ/Eh3aKLCBnuB7kBLdR7EOHK+kUKQPNa3ht0mzXQuHINxFBsiBo
         6DoPLg0B4cLI47GpRXY9FfHJxxAgtq+IiFbf2Xz0PO/pe5MZHSCOXlRzYKnllXaq2p2b
         LnmS0WgWeQy0Zqc5IkeAIiF6r2yI6NOWly4li1cqW/OF+X4u7x/JvNjAb+jCiyAPsdcT
         3kpx+ngVpEVVetk7DqzY0qjfiCWe/K74nIBOZAnbVq03zsZ4oWpPTBJQ5MjOz9ZikIxz
         NxDA==
X-Gm-Message-State: AOAM532IHiBH9/mtrMS9TUoIEMtlHQuFCV5ecy/laEXd69/rhTXWLSPv
        zu4VodSvDXCFlc0YqOPTbLdjgXtKE030IFwu9Tg=
X-Google-Smtp-Source: ABdhPJzaksQ4dfRFFZtCVA/VHk0Z7n8tRav02jVurDhq5wCCLk6/D9U6//SN2F+WV2f3TAi4K0ZK7Cdixqcb6NkV9vg=
X-Received: by 2002:a1f:a4c5:: with SMTP id n188mr15539270vke.35.1637949914485;
 Fri, 26 Nov 2021 10:05:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:3319:0:0:0:0:0 with HTTP; Fri, 26 Nov 2021 10:05:13
 -0800 (PST)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <balla.diop5467@gmail.com>
Date:   Fri, 26 Nov 2021 10:05:13 -0800
Message-ID: <CAEqJ80uLwHLig7rzpgcvixma8fntXLqPgMBSY_-SQpStKd5g6Q@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5YqpIC8gSSBuZWVkIHlvdXIgYXNzaXN0YW5jZQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5oiR5biM5pyb5L2g6IO955CG6Kej6L+Z5p2h5L+h5oGv77yM5Zug5Li65oiR5q2j5Zyo5Yip55So
57+76K+R57uZ5L2g5YaZ5L+h44CCDQoNCuaIkeaYr+adsOilv+S9qeaBqeS4reWjq+Wkq+S6uuOA
gg0K5Zyo576O5Zu96ZmG5Yab55qE5Yab5LqL6YOo6Zeo44CC576O5Zu977yM5LiA5ZCN5Lit5aOr
77yMMzIg5bKB77yM5oiR5Y2V6Lqr77yM5p2l6Ieq576O5Zu955Sw57qz6KW/5bee5YWL5Yip5aSr
5YWw77yM55uu5YmN6am75omO5Zyo5Y+Z5Yip5Lqa77yM5LiO5oGQ5oCW5Li75LmJ5L2c5oiY44CC
5oiR55qE5Y2V5L2N5piv56ysNOaKpOeQhumYn+esrDc4MuaXheS/nemanOiQpeOAgg0KDQrmiJHm
mK/kuIDkuKrlhYXmu6HniLHlv4PjgIHor5rlrp7lkozmt7Hmg4XnmoTkurrvvIzlhbfmnInoia/l
pb3nmoTlub3pu5jmhJ/vvIzmiJHllpzmrKLnu5Por4bmlrDmnIvlj4vlubbkuobop6Pku5bku6zn
moTnlJ/mtLvmlrnlvI/vvIzmiJHllpzmrKLnnIvliLDlpKfmtbfnmoTms6LmtarlkozlsbHohInn
moTnvo7kuL3ku6Xlj4rlpKfoh6rnhLbmiYDmi6XmnInnmoTkuIDliIfmj5DkvpvjgILlvojpq5jl
hbTog73mm7TlpJrlnLDkuobop6PmgqjvvIzmiJHorqTkuLrmiJHku6zlj6/ku6Xlu7rnq4voia/l
pb3nmoTllYbkuJrlj4vosIrjgIINCg0K5oiR5LiA55u05b6I5LiN5byA5b+D77yM5Zug5Li66L+Z
5Lqb5bm05p2l55Sf5rS75a+55oiR5LiN5YWs5bmz77yb5oiR5aSx5Y675LqG54i25q+N77yM6YKj
5bm05oiRIDIxDQrlsoHjgILmiJHniLbkurLlj6vkuZTlsJTCt+S9qeaBqe+8jOavjeS6suWPq+eO
m+S4vcK35L2p5oGp44CC5rKh5pyJ5Lq65biu5Yqp5oiR77yM5L2G5b6I6auY5YW05oiR57uI5LqO
5Zyo576O5Yab5Lit5om+5Yiw5LqG6Ieq5bex44CCDQoNCuaIkee7k+WpmueUn+S6huWtqeWtkO+8
jOS9huS7luatu+S6hu+8jOS4jeS5heaIkeS4iOWkq+W8gOWni+asuumql+aIke+8jOaJgOS7peaI
keS4jeW+l+S4jeaUvuW8g+WpmuWnu+OAgg0KDQrmiJHkuZ/lvojlubjov5DvvIzlnKjmiJHnmoTl
m73lrrbjgIHnvo7lm73lkozlj5nliKnkuprov5nph4zvvIzmi6XmnInmiJHnlJ/mtLvkuK3pnIDo
poHnmoTkuIDliIfvvIzkvYbmsqHmnInkurrnu5nmiJHlu7rorq7jgILmiJHpnIDopoHkuIDkuKro
r5rlrp7nmoTkurrmnaXkv6Hku7vvvIzku5bkuZ/kvJrlsLHlpoLkvZXmipXotYTlkJHmiJHmj5Dk
vpvlu7rorq7jgILlm6DkuLrmiJHmmK/miJHniLbmr43lnKjku5bku6zljrvkuJbliY3nlJ/kuIvn
moTllK/kuIDlpbPlranjgIINCg0K5oiR5LiN6K6k6K+G5L2g5pys5Lq677yM5L2G5oiR6K6k5Li6
5pyJ5LiA5Liq5YC85b6X5L+h6LWW55qE5aW95Lq677yM5LuW5Y+v5Lul5bu656uL55yf5q2j55qE
5L+h5Lu75ZKM6Imv5aW955qE5ZWG5Lia5Y+L6LCK77yM5aaC5p6c5L2g55yf55qE5pyJ5LiA5Liq
6K+a5a6e55qE5ZCN5a2X77yM5oiR5Lmf5pyJ5LiA5Lqb5Lic6KW/6KaB5ZKM5L2g5YiG5Lqr55u4
5L+h44CC5Zyo5L2g6Lqr5LiK77yM5Zug5Li65oiR6ZyA6KaB5L2g55qE5biu5Yqp44CC5oiR5oul
5pyJ5oiR5Zyo5Y+Z5Yip5Lqa6L+Z6YeM6LWa5Yiw55qE5oC76aKd77yINTUwDQrkuIfnvo7lhYPv
vInjgILmiJHkvJrlnKjkuIvkuIDlsIHnlLXlrZDpgq7ku7bkuK3lkYror4nkvaDmiJHmmK/lpoLk
vZXlgZrliLDnmoTvvIzkuI3opoHmg4rmhYzvvIzku5bku6zmmK/ml6Dpo47pmannmoTvvIzmiJHo
v5jlnKjkuI4gUmVkDQrmnInogZTns7vnmoTkurrpgZPkuLvkuYnljLvnlJ/nmoTluK7liqnkuIvl
sIbov5nnrJTpkrHlrZjlhaXkuobpk7booYzjgILmiJHluIzmnJvmgqjlsIboh6rlt7HkvZzkuLrm
iJHnmoTlj5fnm4rkurrmnaXmjqXmlLbln7rph5HlubblnKjmiJHlnKjov5nph4zlrozmiJDlkI7n
oa7kv53lroPnmoTlronlhajlubbojrflvpfmiJHnmoTlhpvkuovpgJrooYzor4Hku6XlnKjmgqjn
moTlm73lrrbkuI7mgqjkvJrpnaLvvJvkuI3opoHlrrPmgJXpk7booYzkvJrlsIbotYTph5HlrZjl
gqjlnKgNCkFUTSBWSVNBIOWNoeS4re+8jOi/meWvueaIkeS7rOadpeivtOaYr+WuieWFqOS4lOW/
q+aNt+eahOOAgg0KDQrnrJTorrA75oiR5LiN55+l6YGT5oiR5Lus6KaB5Zyo6L+Z6YeM5ZGG5aSa
5LmF77yM5oiR55qE5ZG96L+Q77yM5Zug5Li65oiR5Zyo6L+Z6YeM5Lik5qyh54K45by56KKt5Ye7
5Lit5bm45a2Y5LiL5p2l77yM6L+Z5a+86Ie05oiR5a+75om+5LiA5Liq5YC85b6X5L+h6LWW55qE
5Lq65p2l5biu5Yqp5oiR5o6l5pS25ZKM5oqV6LWE5Z+66YeR77yM5Zug5Li65oiR5bCG5p2l5Yiw
5L2g5Lus55qE5Zu95a625Ye66Lqr5oqV6LWE77yM5byA5aeL5paw55Sf5rS777yM5LiN5YaN5b2T
5YW144CCDQoNCuWmguaenOaCqOaEv+aEj+iwqOaFjuWkhOeQhu+8jOivt+WbnuWkjeaIkeOAguaI
keS8muWRiuivieS9oOS4i+S4gOatpeeahOa1geeoi++8jOW5tue7meS9oOWPkemAgeabtOWkmuWF
s+S6juWfuumHkeWtmOWFpemTtuihjOeahOS/oeaBr+OAguS7peWPiumTtuihjOWwhuWmguS9leW4
ruWKqeaIkeS7rOmAmui/hyBBVE0gVklTQQ0KQ0FSRCDlsIbotYTph5Hovaznp7vliLDmgqjnmoTl
m73lrrYv5Zyw5Yy644CC5aaC5p6c5L2g5pyJ5YW06Laj77yM6K+35LiO5oiR6IGU57O744CCDQo=
