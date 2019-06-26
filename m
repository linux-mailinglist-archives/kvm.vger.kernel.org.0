Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B6D5684F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfFZMJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:09:43 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45666 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZMJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:09:43 -0400
Received: by mail-ua1-f67.google.com with SMTP id v18so649760uad.12
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=qWh/EgdzOh68E9KKq1aUl6lkQ8mAhAP0pUgHg6BRLk8=;
        b=Js5vBpdGtj62gCAgjVnR37jkKP43wJH5cuCK12dO4AQlbaD42ifjmYiwQXt3VMgoi/
         THKR4b4A2EG2W88fkLXjeMu9OCCeYiLjJeQN6yzilTe9IDRpAxVr2VYQlybBvEfxIELO
         Ghx9B7s8nWaoWCCayjKJ/fY4nCkoMkpRtJFYFgMYZm+IpwR4vZH99ChTZo+THeFku6Gr
         a6iayUwNn2bwIhJq5Rkxu5eB56EEYs7IT96f9DZMgbkOHVl7Xi3mBDjB2bolhhsEAGKf
         4wZA8iIkvp8FzRdWQ1kO/I2cf6NPjX7Fpz7lrZ4APZGN0Yss/WpWGiqZxqEOXrPQBPRh
         OOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=qWh/EgdzOh68E9KKq1aUl6lkQ8mAhAP0pUgHg6BRLk8=;
        b=aaxZRcsgqcvoauxmIFu22VHYbo08sM6Or9U+G/4OMf+26ypmBCMMSCKkwrSuBPZqwn
         goonbWnF6ri7oMhbIkoC4mkM3uzi7FNggMlR1NIDQbnyDjAP1Td4ISRIjfMDvDEzNQwt
         R1Mwy+Qm9RUUnXPegHxNXp+GY9CS5vpqLg90EXSNh8FfVS8Mmpt+hUTrTS6it8pqrjqs
         btvt+mzO/lp9b1TP2wnKVod7Lk5C6G6WVH/F1Q8uENLl6KvwMly+r0Vigt95xD4+qQ4m
         /9KkbVDlQ8D4AoBYrm/Qu3PuMf8ZS/cfrq2z44h7sc7V/Pw2mr40E8bg/fKBq1bxNgcq
         5dnw==
X-Gm-Message-State: APjAAAUMNMDLrJFl50ITF6mKBxHmiEyPrZlSMK1ln9hDelkF7Kd3Ovkw
        JeXdGWJwjfG0Qhvk7iCi49UZOjkGSdgFfVBXDPwK1w==
X-Google-Smtp-Source: APXvYqyF9JV+5Av4f4w33Nsn8RsaVAM4p67vDttBBtYQL7YAuqszVBTyTurrDkYdKwu2KaTqb9CZeGQezRIH4iLyOnw=
X-Received: by 2002:ab0:30a3:: with SMTP id b3mr559322uam.3.1561550981921;
 Wed, 26 Jun 2019 05:09:41 -0700 (PDT)
MIME-Version: 1.0
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 26 Jun 2019 14:09:31 +0200
Message-ID: <CAG_fn=VyAYUYJuCqR1rL_KjGm5i1mBzffA=uuCnTa0QOBRsvaA@mail.gmail.com>
Subject: Re: WARNING in kvm_set_tsc_khz
To:     syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com,
        pbonzini@redhat.com, haozhong.zhang@intel.com
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Haozhong, Paolo,

KMSAN bot is hitting this warning every now and then.
Is it possible to replace it with a pr_warn()?

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
