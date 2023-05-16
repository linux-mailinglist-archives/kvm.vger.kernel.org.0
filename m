Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8E77050D8
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 16:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjEPOd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 10:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbjEPOd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 10:33:27 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B935BBC
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:33:25 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6abeffced6fso4163536a34.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684247605; x=1686839605;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mhMTEtmnAgofUvsT7JdDd7CuFjDTNwQ0IePtBe84tf4=;
        b=a/f427kBRa7CpC89r2cX5iAEiwXVu9vDKKF1rIRkm8bbqJySfL26geA6ASTGiTC9fy
         v9R5r0z5aKV0VL8jy8jv0alXCb1lIo6L+ct7R/9vGficF9uz+evQ5gJ8idxnMX+ZjQMs
         Ij0FZ0dpIm1rG7Oz2APA4DKfnHlkOqeTZxkOQvFXFK4yDh9udNZS16DtW1Dd6gCvTTHr
         uX4EPyHsdpEEnmGTo8CaMbszS1Wj+lJImqLiEW7TZax2cPjGhx+Sy6dNSZpxrG3tYrZE
         fFg3jaRQnV/S1J8DQw5yD+spKpzyHAsbGCh8EnHFUzMklxJhupeGM4YVv1v0v1bGrm40
         4Hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247605; x=1686839605;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mhMTEtmnAgofUvsT7JdDd7CuFjDTNwQ0IePtBe84tf4=;
        b=gSE6EDfKlHVi+ozfS+ADqx767vv78iBZYNqGZkUPeLNiqXN+yJDN4dVtSyPHmEW8CU
         IqGkeE6Q/eDGzzCsreqG2bNxzvTjDqU4vmqlJfiNhhbI2vh+O1vAV0tcXdSKoSudBW4G
         2ix0tAbKdODLqDrfhu4uuLleGpGHqx4jSvgB3KXMPBdrlubUnLpagAAszJ2MR6NrMMF3
         4Ux4YmJXvl49z/vOaegjf5f4wfltK+XORFBVY1CdlWBICFn5NKQ8N/sYx1qvqhAakHJO
         sIlbERZUOCd7T0qcEPQkU3lGRlXsiznwfoDpLZvOcpm6XAMXlEGdBQYNZYrSBfSs4jRW
         hWhw==
X-Gm-Message-State: AC+VfDziBM7ZznQwEOQJ3GGGxbkvBE0GLl8ri5/qnHJZwQ/Evk9L67N3
        wPkDQS2AHjqYvLlKNflgNsltaIiQMj/cFBkFytQ=
X-Google-Smtp-Source: ACHHUZ7g1NpgNDFBDCawHGKriuswXHVc3lBkZXG8q0YbivVTpt1Jcp89eTLnudOKTIyFYxE9AIrCzMRk6WuAlftpfLY=
X-Received: by 2002:a05:6808:482:b0:38b:8acb:3245 with SMTP id
 z2-20020a056808048200b0038b8acb3245mr13276496oid.13.1684247604886; Tue, 16
 May 2023 07:33:24 -0700 (PDT)
MIME-Version: 1.0
Sender: martines.rose01@gmail.com
Received: by 2002:a05:6358:d097:b0:104:8167:97a8 with HTTP; Tue, 16 May 2023
 07:33:24 -0700 (PDT)
From:   Sandrina Omaru <sandrina.omaru2022@gmail.com>
Date:   Tue, 16 May 2023 16:33:24 +0200
X-Google-Sender-Auth: qi8BMhm_XgJo8HWsgko20hpV9eY
Message-ID: <CAKHiPNRs=_Ab5fV05PzH2JjeXRN6C2ggw48yuZbVJ4F4OkLFSQ@mail.gmail.com>
Subject: KOMPLIMENT DNEVA
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KOMPLIMENT DNEVA

Z globokim spo=C5=A1tovanjem in poni=C5=BEnim priznanjem vas prosim, da nav=
edem
naslednjih nekaj vrstic v va=C5=A1o prijaznost. Upam, da boste prihranili
nekaj svojih dragocenih minut in s so=C4=8Dutjem prebrali ta poziv.
Priznati moram, da vam pi=C5=A1em to e-po=C5=A1tno sporo=C4=8Dilo z velikim=
 upanjem,
veseljem in navdu=C5=A1enjem, za katerega vem in z vero verjamem, da vas
mora zagotovo najti v dobrem zdravstvenem stanju.

Moje ime je Sandrina Omaru; Sem edini otrok mojih pokojnih star=C5=A1ev
Chief. G. Williams Omaru. Moj o=C4=8De je bil zelo ugleden poslovni magnet,
ki je v svojih dneh deloval v glavnem mestu Slonoko=C5=A1=C4=8Dene obale.

=C5=BDalostno je, da povem, da je skrivnostno umrl v Franciji med enim od
svojih poslovnih potovanj v tujino, =C4=8Deprav je njegovo nenadno smrt
povezoval ali bolje re=C4=8Deno domneval, da jo je na=C4=8Drtoval moj stric=
, ki
je takrat potoval z njim. Toda Bog pozna resnico! Moja mama je umrla,
ko sem bil star komaj 6 let, in od takrat me je o=C4=8De vzel tako
posebnega.

Pred smrtjo mojega o=C4=8Deta me je poklical in me obvestil, da ima vsoto
tri milijone =C5=A1eststo tiso=C4=8D evrov. (3.600.000,00 =E2=82=AC), ki ji=
h je
deponiral v zasebni banki tukaj v Abid=C5=BEanu, Slonoko=C5=A1=C4=8Dena oba=
la. Rekel
mi je, da je polo=C5=BEil denar na moje ime in mi dal tudi vse potrebne
pravne dokumente v zvezi s tem depozitom pri banki,

Star sem komaj 22 let in sem univerzitetni diplomant in res ne vem,
kaj naj naredim. Zdaj =C5=BEelim po=C5=A1tenega in BOGA boje=C4=8Dega partn=
erja v
tujini, ki mu lahko naka=C5=BEe ta denar z njegovo pomo=C4=8Djo, in po
transakciji bom pri=C5=A1el in stalno prebival v va=C5=A1i dr=C5=BEavi do t=
renutka,
ko bo primerno, da se vrnem domov, =C4=8De tako =C5=BEelja. To je zato, ker=
 sem
zaradi nenehne politi=C4=8Dne krize tukaj na Slonoko=C5=A1=C4=8Deni obali u=
trpel
veliko =C5=A1kode.

Smrt mojega o=C4=8Deta je pravzaprav prinesla =C5=BEalost v moje =C5=BEivlj=
enje. Prav
tako =C5=BEelim vlo=C5=BEiti sklad pod va=C5=A1im nadzorom, ker se ne spozn=
am na
poslovni svet. Iskreno si =C5=BEelim va=C5=A1e poni=C5=BEne pomo=C4=8Di v z=
vezi s tem.
Va=C5=A1e predloge in ideje bomo zelo cenili.

Prosim, upo=C5=A1tevajte to in se =C4=8Dim prej oglasite pri meni. Takoj po=
trdim
va=C5=A1o pripravljenost, poslal vam bom svojo sliko in vas obvestil o ve=
=C4=8D
podrobnostih v zvezi s to zadevo.

Prijazni pozdravi,

Sandrina Omaru.
