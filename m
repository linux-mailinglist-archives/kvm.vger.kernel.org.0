Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4932F642D7D
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 17:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiLEQsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 11:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiLEQsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 11:48:12 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27BB20356
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 08:47:01 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id s186so13571840oia.5
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 08:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=J5DJvgysfq/WlLQF3BoPI6GU8BE+Tje5Djd0ir//TP5dNFsuqupVPBXOQ0O4gxg8V8
         SYH07Kqm2rbS0R535m+xMvQdDPoI2iz21ph8KVbcCAR56tT1DaMotA+nzqGR8THr9ZqC
         5CyYNVPUukJE5EF/4t63fMOp/dPa08cuBVuWWNmlDRtyd49pcbNHhgGg11NmhgdQKreV
         BCbyMVewa+AHUS92g+52aLbxMR3vCKN/53z5OMkkS6JSOWnApubUssR/uLU9CYHMbiKx
         ZPYjglxlC7t6EAeh2PhYWW0b0Rx654L058Zga+k0Bae6/A53tpFBa+0sZelLFhbdpfgf
         fLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=XA6MmmtE+Gnj42H1uIpRncWjRoWUnzW8JeHK+5zsSWhBUvCZGJVZRBRIixzUiSrdKN
         ivWdNHW/KC7qS46BcEM1wdRRX03ff3KvAGQ4d/eb6Xr+iJbybrh7IR34oS+0aXt8VLOf
         szZdxpDfTJVAITTeGgZUkNfgmZihsSjzTIK+HqkIp/2IsRh7jinZb5hcQA7ocgDYAS9m
         GunuL0Fte91oI9WJd8gL4ZeI4Y9xsKlKqx/ec4+/ANt3egBUVZpn8zjiDIRQnLO252eA
         46tOALqwisLaAFXkmv2h0d4fwqV5qO/h3MRXgCeUUbuU0zKGzhG0KXYTgacQ7pvHREtH
         P5yQ==
X-Gm-Message-State: ANoB5pk+z+m325zbxbATHLEMH1gvyieci/DLtgmOugwkkvALfAAbs9Yj
        nsgkcG/MkyAC0iffZ3tUt40Hstu5VX1Qw0ipOzI=
X-Google-Smtp-Source: AA0mqf7kTSpMVR9jCy4aZ8ePpj1QTaD8qP0Tj1+ttQRVMsUz39gkLYxqJnLqdcCvIAqzcoxdNWN3uh8WKZUW+30qhOE=
X-Received: by 2002:aca:1301:0:b0:35a:4210:6402 with SMTP id
 e1-20020aca1301000000b0035a42106402mr39976828oii.15.1670258820961; Mon, 05
 Dec 2022 08:47:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:7211:b0:dd:1fa2:ef73 with HTTP; Mon, 5 Dec 2022
 08:47:00 -0800 (PST)
Reply-To: plml47@hotmail.com
From:   Philip Manul <lometogo1999@gmail.com>
Date:   Mon, 5 Dec 2022 08:47:00 -0800
Message-ID: <CAFtqZGFLTAxU4U5uJyeL+UcEj45e74TU_yHaERA3KZ-EmHZ43Q@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.
