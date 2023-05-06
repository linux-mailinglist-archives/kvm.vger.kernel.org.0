Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05236F936F
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjEFRub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 13:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEFRua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 13:50:30 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194851816D
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 10:50:29 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-54c96cef24aso1507836eaf.1
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 10:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683395428; x=1685987428;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BXZd/Ira+adnXziXnGW6M5sQnvyHtw9vcvOhDf0qCyY=;
        b=gE7NrRKaE+KheuKviAHx/8Ik6Me+uiDlbsvyPnm/4csW6viWddYXSfGUQy2E5flqmV
         CSa1qcXhaTE/XPz38Y/3b3DAg7vKOj8QME5FEIsZ8nMbkODuhWGzt05+ZZsKjpu6e4tw
         ZhV473D7DHwUD5hsqfrGKjgP+8ipS7Vonro0c5iUnQJIR2NUCAs559DloWz5omp1TdHA
         DpRj4lPzN/Y2NfPe54fjaFFRgN7hovak3dWF/HbU0KcY0z2RxFkemzmo+sPyL8ld0zGl
         FmqiQijv+5ZtFekKXKyzE7wAo04oGpCluWuKYH3ofRDhBCk+1CH0XBx5NnFCxECoOx43
         PCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683395428; x=1685987428;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BXZd/Ira+adnXziXnGW6M5sQnvyHtw9vcvOhDf0qCyY=;
        b=ExeIoU8a1lbtSnFBYuASS7I8z/WGhetx/CdGfr833OnA3U2vVD3TKBLBMUg08kLLoR
         +ZMeS07uvwg/9UwOZ8ayGUGZ5YoKpM0ZCduM2zxbcy+kVIBS8NwIrUU/onIB3+wHPhD7
         AJXQ4ez1y4RWi8/ahwyvNUElCeuctDcRVI6FPn4c9Z9h5nb5zb5HIeft6d9RSxPhWpkx
         yZQIUmg07ZETM2jCebQ8WpcndNNubxQkmfdBon67jeaKl6TvpuBImcaQtgG/MjpUGf3X
         MVBOTKWNIYZPAhfBWSnFJj/iht7Mzf4dv+uJmfucY0JqKo6+5O49BAu3M0mPHVI6MujA
         2VzQ==
X-Gm-Message-State: AC+VfDyArRElm41SpjjfaboMYT5r9DXa6evhG6h4JgaZ5V0PBxxn0KbG
        YKLamZPWqFyfd8mvxScgK/V1RRReP0wGiR4GdTU=
X-Google-Smtp-Source: ACHHUZ7j7zeq6kTfL2Zkq5Asq6LQBatZr44e6Q/BJRFM9d+DAPF/F3svrYjmMdOqSwOs1BwNPSWyym3515TYDiyKaYE=
X-Received: by 2002:a4a:92de:0:b0:54f:49ad:1c91 with SMTP id
 j30-20020a4a92de000000b0054f49ad1c91mr876166ooh.9.1683395428407; Sat, 06 May
 2023 10:50:28 -0700 (PDT)
MIME-Version: 1.0
Sender: issoufd295@gmail.com
Received: by 2002:a8a:54e:0:b0:4d7:2d9c:8f96 with HTTP; Sat, 6 May 2023
 10:50:28 -0700 (PDT)
From:   Miss Reacheal <Reacheal4u@gmail.com>
Date:   Sat, 6 May 2023 17:50:28 +0000
X-Google-Sender-Auth: XAT8La-vIiD8yoY6cUO1gaRzNyM
Message-ID: <CAOzFqiObpz=MfxgfV97P93GECE+5WvUWY6C2NHhu2sCx=HUzrg@mail.gmail.com>
Subject: RE: HELLO DEAR
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hell=C3=B3,

Megkaptad az el=C5=91z=C5=91 =C3=BCzenetem? M=C3=A1r kor=C3=A1bban felvette=
m =C3=96nnel a
kapcsolatot, de az =C3=BCzenet nem siker=C3=BClt visszak=C3=BCldeni, ez=C3=
=A9rt =C3=BAgy
d=C3=B6nt=C3=B6ttem, hogy =C3=BAjra =C3=ADrok. K=C3=A9rem, er=C5=91s=C3=ADt=
se meg, ha megkapja ezt, hogy
folytathassam.

V=C3=A1rok a v=C3=A1laszodra.

=C3=9Cdv=C3=B6zlettel,
Reacheal kisasszony
