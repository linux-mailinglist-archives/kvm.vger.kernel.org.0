Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C9A7AF059
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbjIZQMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjIZQML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:12:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED1711D
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:12:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-68cc1b70e05so2152185b3a.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695744725; x=1696349525; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ng7mcmr4QJ6ZL7X9dSXkz6scbTE1whqwn58ZUV1v7fU=;
        b=Mo4P8Osi/0yV0ZmGD2FZgl2XXaQxhBVeiMgXNDNqk0U6wlqKl6zqUdaAScXx/k7wpQ
         0d3aBkEX3Rg4Yx/5M0KmOuMtJ9zZSSUjvuKNo9maQAO+HqHtyjBv19F3vHKiyDUuoUhI
         /9daoF96baapxx7FipLB84jNvVZapiwOSP3Oi27iSoZPE+64+w+OyK2URnid4pp7AZf+
         gF9uDcl6iEN/JMCu18gIHVInA2saliDu+L+yYUWQ7csM86qMOe10MNsgVsuS1WLEMk5p
         N4F0lhVFwdF2r8kHeJVmIx1xj2v/LlEBEDX58HfYH8j0Z1xfVKDQtjqolgaljv4ljuVc
         tAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695744725; x=1696349525;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ng7mcmr4QJ6ZL7X9dSXkz6scbTE1whqwn58ZUV1v7fU=;
        b=ueaiPtSZ6+hNEDzy+ymCM//JD8jS06+CTr3WKsnTgkS96/wAbKPVBNSM230ieGN2yA
         ZZB/O/Nwg+Ge6yOZgBj73YL1cQGygeKeI7hUEcSWRb3M6lhlFce7goOiFAMmaTQ9qquz
         fXDV1/vC5PGRS5vYbD4+gM3o03+A7xkAO18WjvK97jqL7YBeKP5rqDnv4owtL61uAybC
         UGWeQ9FyBCzuPN3Pp8ce1c96V4UKLWRue8sbJ4TE1EbyT0YF8+YS1PG4D+Cvj8oFoB76
         wtthoiy1LzGtKDtovDEAOS6CSpUQtfndtSlGJcvj6OKCEp7TmbeMUHK1PwzkAgMZW/pU
         jYZQ==
X-Gm-Message-State: AOJu0YycuN5IaWYL6GZzsFjZjr5MtAvvtjLycZpeuinmeWZsIwvOqEe3
        O2F09CAPHbnijdLbiBJJ6vTVyvU20skG5dG706E=
X-Google-Smtp-Source: AGHT+IHqgdOOsr/X14qiOubFS86n52Wa2MyyA8YGLjLKmhJYsA7M+z603MZvQUFHVeU+aezcjq6xm9VBGOZWjVWHVRs=
X-Received: by 2002:a05:6a20:5481:b0:15a:4634:e4c with SMTP id
 i1-20020a056a20548100b0015a46340e4cmr13807106pzk.5.1695744725120; Tue, 26 Sep
 2023 09:12:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:3a9:b0:4da:425a:267e with HTTP; Tue, 26 Sep 2023
 09:12:04 -0700 (PDT)
Reply-To: stephenbord61@yahoo.com
From:   Stephen Bordeaux <samu7582369@gmail.com>
Date:   Tue, 26 Sep 2023 16:12:04 +0000
Message-ID: <CAGykCHpt_EJaazTwXnYfNhWygvEkakmvzp2nOhz8AfDj1M2=ug@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dobr=C3=BD den

Jsem Stephen Bordeaux, pr=C3=A1vn=C3=AD z=C3=A1stupce z advok=C3=A1tn=C3=AD=
 kancel=C3=A1=C5=99e Bordeaux.
Kontaktoval jsem v=C3=A1s ohledn=C4=9B poz=C5=AFstalosti fondu zesnul=C3=A9=
ho Dr. Edwin ve
v=C3=BD=C5=A1i 8,5 milionu dolar=C5=AF, kter=C3=A9 maj=C3=AD b=C3=BDt repat=
riov=C3=A1ny na v=C3=A1=C5=A1 =C3=BA=C4=8Det.
Nav=C3=ADc v t=C3=A9to transakci chci, abyste odpov=C4=9Bd=C4=9Bli d=C5=AFv=
=C4=9Brn=C4=9B.

Stephen Bordeaux
