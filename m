Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0AA4D7225
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 02:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiCMB6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Mar 2022 20:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiCMB6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Mar 2022 20:58:15 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E0A125CAB
        for <kvm@vger.kernel.org>; Sat, 12 Mar 2022 17:57:08 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id h11so17192946ljb.2
        for <kvm@vger.kernel.org>; Sat, 12 Mar 2022 17:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=OdXzchTXF5ygcxgCw1q2CvumG2BDBOdg7E2I4M2s/KM=;
        b=Y1hxrlCocXzoO0KNMJcvttQ5Pe198Ohag4iyhA8MVqqfrSAc/JlMIMzfAxjG0kimm3
         6dH/kzN2Gbq6NesYIv19t1bO7+Dp9/rjypkLZaKoRKQoha6x7QJfGdjW9nULlSA6VdeX
         E4L2sY4VN4hGA7ifa6Sh//iHNTXmVaQ7VG4T4fV85fwlD9XJaOJv0NVPpCeApMCDtZQF
         /34AkoC8wD5IsFqj+9xnOYLGjkelyYgxVTs9XAnMKIqiscLdNGj1Plkh7CcHyp9oxKk8
         sdIq4D9jKw4b6JOvlVbp2BwDvOCp4qwHAiIy1iTseI5X2ZA40Rz1H+1IsJN1daU1+K79
         g1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=OdXzchTXF5ygcxgCw1q2CvumG2BDBOdg7E2I4M2s/KM=;
        b=ZrQzrWJ07Fw/7JN/CYc0lOnHyLWb4gqbsfUbYH+FYMOX+X2Rr2Jbisvfr8VYh8+8Hl
         /3Btqr/iwvVkfL55vY/Zci83aZVVHYAp7KnfkPrWoxlnepLltwHJ5GXhW41zrzVAVzV1
         FUGPf4wTna0+TjRgTr8PXdjBXJ4dZKS7HjQ/V8Bqrx4FB6pgm9CNywscrVv9hbybO9Vp
         5tKLf8n2R9DeV64Pv3CQQZhID+XHkLhbgB9su4GyPKIAcDcac/427Sc2piQSbIzYt/ZG
         zx2pvZJm2hB01tPKG/gJzGHHbRLHMDX0Gb6oRnbMuBGMzlzgHi8bPKI33xujUPlump4C
         46ww==
X-Gm-Message-State: AOAM533xT4nXEoUjbLH39zkVHczEF4WJ8XJPmbVESnTro01dX4kIlko0
        A0aLBkgYBzLAuJzArB6RRbOiZVQF30eQIGjf9XI=
X-Google-Smtp-Source: ABdhPJyZG1npkTX8l98Va1IsKb9Ac8etjl/fK8s2KQXzJN361Y6bhDiBkELhiFRGsc7U7wp1sNFhXNKE6fOFYyRJqvY=
X-Received: by 2002:a2e:b989:0:b0:248:5a5:cb64 with SMTP id
 p9-20020a2eb989000000b0024805a5cb64mr9876432ljp.183.1647136626517; Sat, 12
 Mar 2022 17:57:06 -0800 (PST)
MIME-Version: 1.0
Sender: lukadaboatsem@gmail.com
Received: by 2002:a05:6512:308d:0:0:0:0 with HTTP; Sat, 12 Mar 2022 17:57:05
 -0800 (PST)
From:   "Mrs. Bintou Ouedraogo" <rajackabdoul77@gmail.com>
Date:   Sat, 12 Mar 2022 17:57:05 -0800
X-Google-Sender-Auth: SoqN2FwwwJOtzL-aw_bVoLVmbwY
Message-ID: <CAJP-65FeHzT49HmubC0Xm6j__m8-3y1i8sducQiWZ1G1y1gkBg@mail.gmail.com>
Subject: Dear Assignee
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORM_FRAUD_5,FREEMAIL_FROM,
        HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,MILLION_HUNDRED,MILLION_USD,
        MONEY_ATM_CARD,MONEY_FORM_SHORT,MONEY_FRAUD_5,NA_DOLLARS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
This is to officially inform you that we have had series of meeting
with the IMF during the past two months at the meeting, we discussed
the issues regarding Victims of fraud, this compensation exercise is
also extended to victims of the war also displaced some retired
government workers and you are among those that have been listed
around the world and will benefit of these indemnities which have been
concluded.

Therefore, I am writing to inform you that the United Nations and the
IMF has agreed to compensate you with the sum of 1.7 million US
dollars (One Million Seven Hundred Thousand United States Dollars) we
arranged your payment of One Million Seven Hundred Thousand USD  by
ATM card, the ATM card
with security PIN numbers must be delivered to you via {DHL or FedEx
courier service}

Contact our representative Dr. Abdoul  Rajack, and transmit the
following details to him:
1. Your full name:=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6..
2. Mobile number:=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6=E2=80=A6.
3. Address to which you want us to send your credit card:=E2=80=A6..

Contact Dr Abdoul  Rajack, with the email below and transfer your
details to him Email: (rajackabdoul77@gmail.com)

Thank you


Mrs. Bintou Ouedraogo
United Nations Officials (UN)
