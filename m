Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B405F1249E3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 15:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfLROjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 09:39:55 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34767 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLROjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 09:39:55 -0500
Received: by mail-yw1-f65.google.com with SMTP id b186so847886ywc.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 06:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CeeDtpjMokJukuH1miomF5Oz08aqVjt3ots/YpdA6R8=;
        b=h82zrN1ibs5o7hMcUzkE46dylc/YEU7Rw81+t/6F8A7BjKY9UXv6OTXrYWnXC800Tm
         X0phIqxks1Pt1VG79zGmgi2qUfPB5W04B7hWkzbtBZq7G86lTemjYVDYNiMJWL+lcgaq
         7H4mGv2ot4t38bu826ljx9dk0L3cEVs6Q89k8lt0arNHWALW1V/SAtVLmVX9g47Hbwwh
         r8nuXaDt/beqQHQvFY6gOOxLDZZsM7ssrRSkl+Trk1oaXIFubRnJ1dDLNqUoc00ke4ki
         bDJ/jQTHs7not/rmPoIjPE5VJCeSGxD3yoiSE/8sJ2T+zMHEoYLzQJ4yiW4skuTr3Zju
         mzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=CeeDtpjMokJukuH1miomF5Oz08aqVjt3ots/YpdA6R8=;
        b=HIR+nMPCs/5H7slLY0EOF/ccShSBNuv87LJw96xBdhFPxkBEXf0GmTXPnMy8eB1VAd
         2OTQJMmSMnqtZJheoHgiV6ZKxgA/najyALyekEEXi8rKY1+84Cb/Ta7eMRuu870gRieO
         LS3ZF1UwOjRZuaBHQaVG8RF8o42xWtgjK/O73wufUTEal3K9eaePL+D0Gu7S9z5vWypq
         Nj/+eeR4T6Oq1NmWoUOqCFgvEWOYhqsMA6b406twk0V2Rzr8D8DD1zH5rZ5G/ivVwJdb
         qIKEC5ef1rcn8V5RLZimTDyLSRmsS6GO684Bkwh21aRjWWLVJQoADxGV8h97O0lh4aIf
         7dQw==
X-Gm-Message-State: APjAAAVLJvUeHWY6fdEEqTDMsZttZtfl6h1N+ZAygNPU5nvSzx/EPGA6
        3/kY+kcEexjAvvj1iv6zKK6iMASjtZ8j3x/hj6E=
X-Google-Smtp-Source: APXvYqzzFrkqag9pP2/r1rgPa8PCOqPgJdZVINgq6HIaCrQKLeuB481lFOw5S9tSSnPyv/noMIEFJnrc7zCr55WHcrM=
X-Received: by 2002:a0d:ca47:: with SMTP id m68mr2298635ywd.286.1576679994582;
 Wed, 18 Dec 2019 06:39:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a81:9b90:0:0:0:0:0 with HTTP; Wed, 18 Dec 2019 06:39:54
 -0800 (PST)
Reply-To: aakkaavvii@gmail.com
From:   Abraham Morrison <abrahamabrahammorrison@gmail.com>
Date:   Wed, 18 Dec 2019 06:39:54 -0800
Message-ID: <CAC1R54bb2Z2TaCzFOzaWO2B+HFdCWdX80xV5ZRv+rZTaAq1aKQ@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RGVhciBGcmllbmQsDQpJIGFtIEJhcnJpc3RlciBBYnJhaGFtIE1vcnJpc29uLCBEaWQgeW91IHJl
Y2VpdmUgbXkgcHJldmlvdXMgbWVzc2FnZQ0KdG8geW91PyBJIGhhdmUgYW4gaW1wb3J0YW50IGlu
Zm9ybWF0aW9uIGZvciB5b3UgYWJvdXQgeW91ciBpbmhlcml0YW5jZQ0KZnVuZCB3b3J0aCBvZiAo
JDIwLDUwMCwwMDAuMDApIE1pbGxpb24gd2hpY2ggd2FzIGxlZnQgZm9yIHlvdSBieSB5b3VyDQps
YXRlIHJlbGF0aXZlLCBNci4gQ2FybG9zLiBTbyBpZiB5b3UgYXJlIGludGVyZXN0ZWQgZ2V0IGJh
Y2sgdG8gbWUgZm9yDQptb3JlIGRldGFpbHMuDQpUaGFuayB5b3UuDQpCYXJyaXN0ZXIgQWJyYWhh
bSBNb3JyaXNvbi4NCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uDQrQlNC+0YDQvtCz0L7QuSDQtNGA0YPQsywNCtCvINCR0LDRgNGA0LjR
gdGC0LXRgCDQkNCy0YDQsNCw0Lwg0JzQvtGA0YDQuNGB0L7QvSwg0JLRiyDQv9C+0LvRg9GH0LjQ
u9C4INC80L7QtSDQv9GA0LXQtNGL0LTRg9GJ0LXQtSDRgdC+0L7QsdGJ0LXQvdC40LUg0LTQu9GP
DQrQstCw0YE/INCjINC80LXQvdGPINC10YHRgtGMINC00LvRjyDQstCw0YEg0LLQsNC20L3QsNGP
INC40L3RhNC+0YDQvNCw0YbQuNGPINC+INCy0LDRiNC10Lwg0L3QsNGB0LvQtdC00YHRgtCy0LXQ
vdC90L7QvA0K0YTQvtC90LTQtSDQvdCwINGB0YPQvNC80YMgKDIwIDUwMCAwMDAsMDAg0LTQvtC7
0LvQsNGA0L7QsiDQodCo0JApLCDQutC+0YLQvtGA0YvQuSDQvtGB0YLQsNCy0LjQuyDQstCw0Lwg
0LLQsNGIDQrQv9C+0LrQvtC50L3Ri9C5INGA0L7QtNGB0YLQstC10L3QvdC40LosINC80LjRgdGC
0LXRgCDQmtCw0YDQu9C+0YEuINCi0LDQuiDRh9GC0L4sINC10YHQu9C4INCy0Ysg0LfQsNC40L3R
gtC10YDQtdGB0L7QstCw0L3RiywNCtGB0LLRj9C20LjRgtC10YHRjCDRgdC+INC80L3QvtC5INC0
0LvRjyDQsdC+0LvQtdC1INC/0L7QtNGA0L7QsdC90L7QuSDQuNC90YTQvtGA0LzQsNGG0LjQuC4N
CtCh0L/QsNGB0LjQsdC+Lg0K0JHQsNGA0YDQuNGB0YLQtdGAINCQ0LLRgNCw0LDQvCDQnNC+0YDR
gNC40YHQvtC9Lg0K
