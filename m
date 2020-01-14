Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D804013AF32
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANQXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 11:23:12 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43694 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANQXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 11:23:11 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so14437188ioo.10
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 08:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4RbjksI4ZVf8jlMAui9QSDoZFwWF9mQNUo5m2497TSc=;
        b=ivxeIqnDGG2IPj9/lbhO5RIgpchuTRJIBcbtiK0vCwtmMsgUCquQtt1lgRB24Rdi3U
         433Z4zGeEF1dtED3XsNhNO4TECggm2mOYJLSz2bgeeGQAePcA8xrCdrMey7alEh+T08Z
         uyBSIn7pi+Dvg5f5h/pOicZt1oRmaEBB87obVZ3Cxz4XMliFF9DjSPUBIBR0cCkYDXtu
         d6C864QDoOzkX9MlLKqHwSEYVJkjGdyJGaHAvpO4ajrvtL/IrtSjV5aLb873FwjD9ou1
         5IsTK9x5qHkJCM0MIfrtFo9Z+aBanyKN+Efhh/rAjtru4Ij5uja0ffMxT34I4BD7RtGv
         lsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4RbjksI4ZVf8jlMAui9QSDoZFwWF9mQNUo5m2497TSc=;
        b=fDQbmV2Ow6R+EBLTySUSILBI/c73B5xs8zX0v1chzgpAdBYLSY6rU+Bk/f+2ekrwkq
         ZJyz4ltFPtX07F9qkWvMvw9AAh3kxExEE1t8C6PlcY4uyYTMBYtUNbroW9y2d5il5oDI
         IHwDLQGtolkyMYqgGqvklN/O1UFh00uiGamxvDs99Bg5I/IhQWfh0LWV/8UOdBSfzIgO
         wTzA7Fsk4GkZnBZ2gAtBasUN3pEknqjlXrz3JVABYtkmhEbc4NkCc/PX9mw9ytYym6iJ
         3txwnIAPzV7dGZxl3zedJZ281ickmfi5wfMr/e5VEJa6hujktSsAJixpgFNjClhcJcgv
         3j9A==
X-Gm-Message-State: APjAAAVTEnTHLhFT0f2wrTxYZr7abCqgcIrFrPyhWBMZkWT4sM1sNbxZ
        AMtVwJS1Es7qUad62eCjDeMMJl6DRdi0klC40Jw=
X-Google-Smtp-Source: APXvYqw8FoAyu9xw6e8ZLdUILqg1lBJXWS1Bdg7P+lIfjlrLnKw89R/gpPcrpU/TYg8ySypzehsm+PTRVghC7vf3k0c=
X-Received: by 2002:a5e:9507:: with SMTP id r7mr17073461ioj.152.1579018991200;
 Tue, 14 Jan 2020 08:23:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:5a0a:0:0:0:0:0 with HTTP; Tue, 14 Jan 2020 08:23:10
 -0800 (PST)
Reply-To: aakkaavvii@gmail.com
From:   Abraham Morrison <mrbidokeke@gmail.com>
Date:   Tue, 14 Jan 2020 08:23:10 -0800
Message-ID: <CADSEnMo6OUNvTLAhAVat_EReeXY1KWOwX_MxwkRnrvNNwWgO-g@mail.gmail.com>
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
YXRlIHJlbGF0aXZlLCBNci4gQWxleGFuZGVyLiBTbyBpZiB5b3UgYXJlIGludGVyZXN0ZWQgZ2V0
IGJhY2sgdG8gbWUNCmZvciBtb3JlIGRldGFpbHMuDQpUaGFuayB5b3UuDQpCYXJyaXN0ZXIgQWJy
YWhhbSBNb3JyaXNvbi4NCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uDQrQlNC+0YDQvtCz0L7QuSDQtNGA0YPQsywNCtCvINCR0LDRgNGA
0LjRgdGC0LXRgCDQkNCy0YDQsNCw0Lwg0JzQvtGA0YDQuNGB0L7QvSwg0JLRiyDQv9C+0LvRg9GH
0LjQu9C4INC80L7QtSDQv9GA0LXQtNGL0LTRg9GJ0LXQtSDRgdC+0L7QsdGJ0LXQvdC40LUg0LTQ
u9GPDQrQstCw0YE/INCjINC80LXQvdGPINC10YHRgtGMINC00LvRjyDQstCw0YEg0LLQsNC20L3Q
sNGPINC40L3RhNC+0YDQvNCw0YbQuNGPINC+INCy0LDRiNC10Lwg0L3QsNGB0LvQtdC00YHRgtCy
0LXQvdC90L7QvA0K0YTQvtC90LTQtSDQsiDRgNCw0LfQvNC10YDQtSAoMjAgNTAwIDAwMCwwMCkg
0LzQuNC70LvQuNC+0L3QvtCyINC00L7Qu9C70LDRgNC+0LIsINC+0YHRgtCw0LLQu9C10L3QvdC+
0Lwg0LLQsNC8DQrQv9C+0LrQvtC50L3Ri9C8INGA0L7QtNGB0YLQstC10L3QvdC40LrQvtC8LCDQ
vNC40YHRgtC10YAg0JDQu9C10LrRgdCw0L3QtNGALiDQotCw0Log0YfRgtC+LCDQtdGB0LvQuCDQ
stGLDQrQt9Cw0LjQvdGC0LXRgNC10YHQvtCy0LDQvdGLLCDRgdCy0Y/QttC40YLQtdGB0Ywg0YHQ
viDQvNC90L7QuSDQtNC70Y8g0LHQvtC70LXQtSDQv9C+0LTRgNC+0LHQvdC+0Lkg0LjQvdGE0L7R
gNC80LDRhtC40LguDQrQodC/0LDRgdC40LHQvi4NCtCR0LDRgNGA0LjRgdGC0LXRgCDQkNCy0YDQ
sNCw0Lwg0JzQvtGA0YDQuNGB0L7QvS4NCg==
