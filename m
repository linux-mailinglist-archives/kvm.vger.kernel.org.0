Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0A33DC691
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhGaPRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Jul 2021 11:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhGaPR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Jul 2021 11:17:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29304C0613CF
        for <kvm@vger.kernel.org>; Sat, 31 Jul 2021 08:17:21 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g13so24368837lfj.12
        for <kvm@vger.kernel.org>; Sat, 31 Jul 2021 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dXRdtW1lcGIz4mb1f5rvJE4s9eiQBxS0z9E/AXqkQ+c=;
        b=QgJzk41BDum9PZwJlz7KN8H2x8imPTFr/s7M9fx4UiUv4H23xBfIBHjk57TnWLbHPW
         nAyA98s9jMWAMBY5dm5/fEjoTX+UhkeUSO+i9rs1mZWq0QILk0HwDTdRtJ6fxJr0mJBh
         cKvjy0cVWArJI2FICt2V+8Y2KAyjOdeffLTaDjDT6dc/4Vr/Gwaw4VFvQfZM0vku6mW+
         v2B6BjPyb7AgsW73qXmAamHL7skDndkumbsCp35LwVdVxLJAYS9Uk/JQ+E7pQ/6VcVlH
         KmdHsJzzPMLeDg3v3BRfdD6LfUw/H3o2vl9lq9VX0KnNFlIr4V9pnjD8I71dq/ks6XS0
         s4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=dXRdtW1lcGIz4mb1f5rvJE4s9eiQBxS0z9E/AXqkQ+c=;
        b=N8fyQr7RxXeHrGseaH+pqAvweH45Edv4141IbdcaajAdTBCSl0hYOzWsedEZLTkhqF
         EJ1ptdoFNDwPRaFMjLSkT2M5DykWAm8dwWSJuaow008h31GinohM+zNelX38iccIuskg
         DOHQPZoNlbgEIXyGX9uLzki3i9y8OXwoA1YaGG7R5EAg6/jI+8grZPfKTyZ2NOhN7njB
         CyYmXWDSq8O9vCaX31T0DKGU9bYxzkb/O9c+/IDqvD7SbpMYnwk97hYaoBbrEEZJ69Z3
         1y5JlsE9GJ19KqHbF82I8eIQJawuQrTHLvKFsyQV4LKij77H97MXlnXxIGBhEFs7Rb8z
         x5hA==
X-Gm-Message-State: AOAM533rGciVUK5pUrF/H0CHH2j42ZWLpMBcMMJWufGSw02nQ83qmdur
        /Yju2qQ4G2pV3qhszmEJ0Y6yhXU179iBYSOoDEs=
X-Google-Smtp-Source: ABdhPJzdcFWGxqcZ7QCkSy56IYMhTgmFz43QXkpHFtUbaqqgC11OpCqUQaLIsY9WLNr8gLRTW9tMG/605CMFLuStNvA=
X-Received: by 2002:a05:6512:951:: with SMTP id u17mr5874095lft.392.1627744639401;
 Sat, 31 Jul 2021 08:17:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9a:79c2:0:b029:116:2bc5:9adc with HTTP; Sat, 31 Jul 2021
 08:17:19 -0700 (PDT)
Reply-To: jesspayne72@gmail.com
From:   Jess Payne <haansbro46@gmail.com>
Date:   Sat, 31 Jul 2021 08:17:19 -0700
Message-ID: <CAA8X_PZxqBpVMMZ-Eor=PwuJNbNouwg3w+7yUZo8gfRkP-+rKw@mail.gmail.com>
Subject: =?UTF-8?B?5oiR6ZyA6KaB5L2g55qE5biu5YqpIC8gSSBuZWVkIHlvdXIgYXNzaXN0YW5jZQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5oiR5piv5p2w6KW/5L2p5oGp5Lit5aOr5aSr5Lq644CCDQoNCuWcqOe+juWbvemZhuWGm+eahOWG
m+S6i+mDqOmXqOOAgue+juWbve+8jOS4gOWQjeS4reWjq++8jDMyIOWyge+8jOaIkeWNlei6q++8
jOadpeiHque+juWbveeUsOe6s+ilv+W3nuWFi+WIqeWkq+WFsO+8jOebruWJjempu+aJjuWcqOWI
qeavlOS6muePreWKoOilv++8jOS4juaBkOaAluS4u+S5ieS9nOaImOOAguaIkeeahOWNleS9jeaY
r+esrDTmiqTnkIbpmJ/nrKw3ODLml4XmlK/mj7TokKXjgIINCg0K5oiR5piv5LiA5Liq5YWF5ruh
54ix5b+D44CB6K+a5a6e5ZKM5rex5oOF55qE5Lq677yM5YW35pyJ6Imv5aW955qE5bm96buY5oSf
77yM5oiR5Zac5qyi57uT6K+G5paw5pyL5Y+L5bm25LqG6Kej5LuW5Lus55qE55Sf5rS75pa55byP
77yM5oiR5Zac5qyi55yL5Yiw5aSn5rW355qE5rOi5rWq5ZKM5bGx6ISJ55qE576O5Li95Lul5Y+K
5aSn6Ieq54S25omA5oul5pyJ55qE5LiA5YiH5o+Q5L6b44CC5b6I6auY5YW06IO95pu05aSa5Zyw
5LqG6Kej5oKo77yM5oiR6K6k5Li65oiR5Lus5Y+v5Lul5bu656uL6Imv5aW955qE5ZWG5Lia5Y+L
6LCK44CCDQoNCuaIkeS4gOebtOW+iOS4jeW8gOW/g++8jOWboOS4uui/meS6m+W5tOadpeeUn+a0
u+WvueaIkeS4jeWFrOW5s++8m+aIkeWkseWOu+S6hueItuavje+8jOmCo+W5tOaIkSAyMQ0K5bKB
44CC5oiR54i25Lqy55qE5ZCN5a2X5piv5biV54m56YeM5pav5L2p5oGp77yM5oiR55qE5q+N5Lqy
5piv546b5Li95L2p5oGp44CC5rKh5pyJ5Lq65biu5Yqp5oiR77yM5L2G5b6I6auY5YW05oiR57uI
5LqO5Zyo576O5Yab5Lit5om+5Yiw5LqG6Ieq5bex44CCDQoNCuaIkee7k+WpmueUn+S6huWtqeWt
kO+8jOS9huS7luatu+S6hu+8jOS4jeS5heaIkeS4iOWkq+W8gOWni+asuumql+aIke+8jOaJgOS7
peaIkeS4jeW+l+S4jeaUvuW8g+WpmuWnu+OAgg0KDQrmiJHkuZ/lvojlubjov5DvvIzlnKjmiJHn
moTlm73lrrbnvo7lm73lkozliKnmr5Tkuprnj63liqDopb/ov5nph4zmi6XmnInmiJHnlJ/mtLvk
uK3miYDpnIDnmoTkuIDliIfvvIzkvYbmsqHmnInkurrkuLrmiJHmj5Dkvpvlu7rorq7jgILmiJHp
nIDopoHkuIDkuKror5rlrp7nmoTkurrmnaXkv6Hku7vvvIzku5bkuZ/kvJrlsLHlpoLkvZXmipXo
tYTmiJHnmoTpkrHmj5Dkvpvlu7rorq7jgILlm6DkuLrmiJHmmK/miJHniLbmr43lnKjku5bku6zl
jrvkuJbliY3nlJ/kuIvnmoTllK/kuIDkuIDkuKrlpbPlranjgIINCg0K5oiR5LiN6K6k6K+G5L2g
5pys5Lq677yM5L2G5oiR6K6k5Li65pyJ5LiA5Liq5YC85b6X5L+h6LWW55qE5aW95Lq677yM5LuW
5Y+v5Lul5bu656uL55yf5q2j55qE5L+h5Lu75ZKM6Imv5aW955qE5ZWG5Lia5Y+L6LCK77yM5aaC
5p6c5L2g55yf55qE5pyJ5LiA5Liq6K+a5a6e55qE5ZCN5a2X77yM5oiR5Lmf5pyJ5LiA5Lqb5Lic
6KW/6KaB5ZKM5L2g5YiG5Lqr55u45L+h44CC5Zyo5L2g6Lqr5LiK77yM5Zug5Li65oiR6ZyA6KaB
5L2g55qE5biu5Yqp44CC5oiR5oul5pyJ5Zyo5Yip5q+U5Lqa54+t5Yqg6KW/6L+Z6YeM6LWa5Yiw
55qEDQoyNTAg5LiH576O5YWD44CC5oiR5Lya5Zyo5LiL5LiA5bCB55S15a2Q6YKu5Lu25Lit5ZGK
6K+J5L2g5oiR5piv5aaC5L2V5YGa5Yiw55qE77yM5LiN6KaB5oOK5oWM77yM5LuW5Lus5rKh5pyJ
6aOO6Zmp77yM6ICM5LiU5oiR6L+Y5Zyo5LiOIFJlZA0K5pyJ6IGU57O755qE5Lq66YGT5Li75LmJ
5Yy755Sf55qE5biu5Yqp5LiL5bCG6L+Z56yU6ZKx5a2Y5YWl5LqG6ZO26KGM44CC5oiR5biM5pyb
5oKo5bCG6Ieq5bex5L2c5Li65oiR55qE5Y+X55uK5Lq65p2l5o6l5pS25Z+66YeR5bm25Zyo5oiR
5Zyo6L+Z6YeM5a6M5oiQ5ZCO56Gu5L+d5a6D55qE5a6J5YWo5bm26I635b6X5oiR55qE5Yab5LqL
6YCa6KGM6K+B5Lul5Zyo5oKo55qE5Zu95a625LiO5oKo5Lya6Z2i77yb5LiN6KaB5a6z5oCV6ZO2
6KGM5Lya5bCG6LWE6YeR5a2Y5YKo5ZyoDQpBVE0gVklTQSDljaHkuK3vvIzov5nlr7nmiJHku6zm
naXor7TmmK/lronlhajkuJTlv6vmjbfnmoTjgIINCg0K56yU6K6wO+aIkeS4jeefpemBk+aIkeS7
rOimgeWcqOi/memHjOWRhuWkmuS5he+8jOaIkeeahOWRvei/kO+8jOWboOS4uuaIkeWcqOi/memH
jOS4pOasoeeCuOW8ueiireWHu+S4reW5uOWtmOS4i+adpe+8jOi/meS/g+S9v+aIkeWvu+aJvuS4
gOS4quWAvOW+l+S/oei1lueahOS6uuadpeW4ruWKqeaIkeaOpeaUtuWSjOaKlei1hOWfuumHke+8
jOWboOS4uuaIkeWwhuadpeWIsOS9oOS7rOeahOWbveWutuWHuui6q+aKlei1hO+8jOW8gOWni+aW
sOeUn+a0u++8jOS4jeWGjeW9k+WFteOAgg0KDQrlpoLmnpzmgqjmhL/mhI/osKjmhY7lpITnkIbv
vIzor7flm57lpI3miJHjgILmiJHkvJrlkYror4nkvaDkuIvkuIDmraXnmoTmtYHnqIvvvIzlubbn
u5nkvaDlj5HpgIHmm7TlpJrlhbPkuo7ln7rph5HlrZjlhaXpk7booYznmoTkv6Hmga/jgILku6Xl
j4rpk7booYzlsIblpoLkvZXluK7liqnmiJHku6zpgJrov4cgQVRNIFZJU0ENCkNBUkQg5bCG6LWE
6YeR6L2s56e75Yiw5oKo55qE5Zu95a62L+WcsOWMuuOAguiLpeacieWFtOi2o+ivt+iBlOezu+ac
rOS6uuOAgg0K
