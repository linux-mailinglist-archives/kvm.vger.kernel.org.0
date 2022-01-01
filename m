Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16586482730
	for <lists+kvm@lfdr.de>; Sat,  1 Jan 2022 11:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiAAK3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jan 2022 05:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiAAK3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jan 2022 05:29:05 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3B9C061574
        for <kvm@vger.kernel.org>; Sat,  1 Jan 2022 02:29:05 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so32753054pjo.5
        for <kvm@vger.kernel.org>; Sat, 01 Jan 2022 02:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=dhFaFNGf9P/hgzfpigNOAcNefTeR7Csml9+Bh/hdy/w=;
        b=eh2ubavZUsGG5S6fAfROxTM+SrcUyNQxwjDsfy662HiEVBfVnHCh9GzBDrTwZHALTe
         E1DtOxS26/hIYHgmbzWM5DRZLfnI1pqumK7nY08wN9OKge4GvmWcTnDPXVedsUNhZLqW
         iocdfc/CSDJjPvG0FwMrkiZW9izpjUmAcSXOXoljN3e6+tBpeVD0fP4x5y7Dso7FP7tB
         0+MKUYTI0ftzv9OX/dSFZNxSgjAYF75ndlNa4iBzglhpns6/mmTn8ssOft8e7IinBiSh
         dmKUC7tglTOlg4bYmU56lye5KVfZT4CJiaTfW1jwLT/OWRMGDGrCjNGYF/q2VkFRIAXB
         dzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=dhFaFNGf9P/hgzfpigNOAcNefTeR7Csml9+Bh/hdy/w=;
        b=LYb0MdNq8LilNnsXc1XzmWGBjwsyDxRKAq/XG/ofr5XGRxBNV5eWSBhw7FZTpLj1Zn
         gQokhiicBLIL09i6210DbgFl8h9q4nnloLU0Tx1A3bAQ9r4RuR3hR89Jf5RwzTFmZsXK
         pi++E1zare96M+RIsug8R4FGyp1TzFgyjMeMRTTx0dRPgbhOJ0qpDqVwlUgayYJfiXc6
         JmjF6kMAOBTTy3mM3tNuD8tJ6Aj8bHECQzyQkvM+eIK1vdefbb4GEqN2RpAGo8wXLTWL
         TvKFikfBzmgyNoqchA/x01wzQvH4j1KFlrb48wp0dvFxMYY/uCTXv417ThfGkwBOXxjV
         NRqg==
X-Gm-Message-State: AOAM532w46zvU58ghI8ZrDQp0tyhZBYoii2sizrIAIJ5JCq3oVOt+ArL
        /mE3ci7cwCbzq1rpCwgo6WhO4x27b05WSUNe
X-Google-Smtp-Source: ABdhPJzXtQC4s+Q5PNmUU2NIz9RHr8+B/rE75ygO6NgQnN7UczPaDceD3wMhTvnWLtKERHqC8Oxozw==
X-Received: by 2002:a17:902:e742:b0:149:49fc:315e with SMTP id p2-20020a170902e74200b0014949fc315emr37414283plf.35.1641032944910;
        Sat, 01 Jan 2022 02:29:04 -0800 (PST)
Received: from [192.168.0.153] ([143.244.48.136])
        by smtp.gmail.com with ESMTPSA id c24sm17039024pgj.57.2022.01.01.02.28.57
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sat, 01 Jan 2022 02:29:04 -0800 (PST)
Message-ID: <61d02cf0.1c69fb81.20b84.ed2c@mx.google.com>
From:   vipiolpeace@gmail.com
X-Google-Original-From: suport.prilend@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: RE:
To:     Recipients <suport.prilend@gmail.com>
Date:   Sat, 01 Jan 2022 12:28:41 +0200
Reply-To: andres.stemmet1@gmail.com
X-Mailer: TurboMailer 2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I want to confide in you to finalize this transaction of mutual benefits. I=
t may seem strange to you, but it is real. This is a transaction that has n=
o risk at all, due process shall be followed and it shall be carried out un=
der the ambit of the financial laws. Being the Chief Financial Officer, BP =
Plc. I want to trust and put in your care Eighteen Million British Pounds S=
terling, The funds were acquired from an over-invoiced payment from a past =
contract executed in one of my departments. I can't successfully achieve th=
is transaction without presenting you as foreign contractor who will provid=
e a bank account to receive the funds.

Documentation for the claim of the funds will be legally processed and docu=
mented, so I will need your full cooperation on this matter for our mutual =
benefits. We will discuss details if you are interested to work with me to =
secure this funds. I will appreciate your prompt response in every bit of o=
ur communication. Stay Blessed and Stay Safe.

Best Regards


Tel: +44 7537 185910
Andres  Stemmet
Email: andres.stemmet1@gmail.com  =

Chief financial officer
BP Petroleum p.l.c.

                                                                           =
                        Copyright =A9 1996-2021

