Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D125402A3
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbiFGPlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiFGPlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:41:13 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9971C8BF3
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:41:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y32so28941820lfa.6
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=PyInHAnePUrsCxyRN1yOwviYIqmmuD9NRK8P3yQO+gY=;
        b=i0cuCz1EwZX74hgzgGSpudaN625aWEw7hvYzRzN7kBGECAxOAYVPPGUf4I8oXurMIJ
         v4XKc/ZNXkeSqpLorSFuU4pjyKhdNR+dLja0Xg8O3xL+eTTo9xyzGSnVfcR+9/Z7nnyo
         Up6C4Kr1LkBcXArBSIaSSsPDGzYRRpGA/K+XIwx06Zi4zb7lk6rz8GbOs+XeX34O62S0
         4abSdW5u5/caJn3kq47QPf9TqLTr3G/RME7GQV1Nh9GkwGIjG8S9VBJ9Xhx/t9LEE1B2
         mvp2UaqZlBPrkHeuBGvFXy62dWBa6u9mqR73uJhH2B5DnK363jbBn1ndGHn5Fm4Qonmo
         yMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=PyInHAnePUrsCxyRN1yOwviYIqmmuD9NRK8P3yQO+gY=;
        b=RgNgXHR9mxzP+1aE76MmiV8oPn6RJTBvL/y+rxnXZ6T7XF5qhWRC0mXBpbVYcaNDT5
         aG3HxzxS7tOoDO2ZZsNf2Lc8+H8KYmXOX9lOb8Scy/vdUvzWHManxgHTIcEJj1urrC1l
         ETC27dXUvT1hawkBf/SaHXABqhRfM2pA6DU2mleRSugkLBP0IMMZLIyfHM3AESMNMKHM
         lxHRIoBZPdYwCGxky8uNLoKh5cXBnZpYht0dxM5TxO8E9ct+C0v4+ki3bOGWM7IpIh7w
         CmIc5hZZhy0MpbRZLJLJQocrb5a9CPzoH0XbvSwkUq9fWQI+81wD7ORIlDjml+7Av7Es
         nz5Q==
X-Gm-Message-State: AOAM532KDtmDc4PRxRnyoDPxJE03ljMLCKwUigk5aDNOlALlRFgKmuZJ
        qNDYNcsC9k8glqDjlfdOHX2srTmguGMPwHcB3vs=
X-Google-Smtp-Source: ABdhPJzHFEXYz4E5v0tMn+FCJz/wdo6U5goK/KQpLvjUHtCdwybLAJVaZlFkjcckU1kkfLjl7//ausXGWlvn4VxLEpw=
X-Received: by 2002:a05:6512:3d94:b0:479:560e:ce5c with SMTP id
 k20-20020a0565123d9400b00479560ece5cmr5017203lfv.506.1654616470090; Tue, 07
 Jun 2022 08:41:10 -0700 (PDT)
MIME-Version: 1.0
Sender: ericnony02@gmail.com
Received: by 2002:a05:6504:40d5:0:0:0:0 with HTTP; Tue, 7 Jun 2022 08:41:08
 -0700 (PDT)
From:   "Mrs. Rachael Bednar" <rachaelbednar.55@gmail.com>
Date:   Tue, 7 Jun 2022 08:41:08 -0700
X-Google-Sender-Auth: 4Sr3sTp6aIuBaYuvENf78WbLB24
Message-ID: <CAGscK4G2stz0hX-ARdN-dHyeUGjau9wVwtUg1p0sOfO5BKVy=w@mail.gmail.com>
Subject: PLEASE INDICATE YOUR INTEREST FOR MORE DETAILS TO PROCEED.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings my beloved,

My name is Mrs. Rachael Bednar, am 67 years old from the Czech
Republic, I am a widow suffering from long-time Cancer and Annual
Pustular sickness. I have some funds I inherited from my late husband,
the sum of (5.2 Million Euro) Five Million Two Hundred Thousand Euro,
and I needed a very honest and God-fearing person who will use this
money for charity work. I mean to help the poor and less privileged
people in society. So please do respond for more information.

God bless you,
Mrs. Rachael Bednar.
