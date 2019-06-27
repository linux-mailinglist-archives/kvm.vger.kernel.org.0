Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001B1589BE
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfF0ST6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:19:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37066 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfF0ST6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:19:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id bh12so1726096plb.4
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7KJ/0lAbZ/7y/XSZllCDvs93clOM3RgHbDtSd5VENeM=;
        b=LHOlBNSb+PZMNsESPkQ6LUjryGRHflCwWaYjNNJmU8heJUHffKa2OvRD6HcAT2eQOJ
         XXFBEYtxNG3Lz/9WXxUB6Ifb3SZowwGMe+e0XC+QOhk/O02HLQ7mFK/GgVagyGsAPRet
         JNC7ulyDMoACxSvv2/KAcui07yuYPe9lcczFfx/J1TbQmfauIMl4Od+kAZVUDQm8oIzR
         MZkQW3Z84QT67GY6ehmfxB5n6yb4za5ZAT2Nym5GF8QsgkovzlfhRaZ8YdDrjSMOKmOW
         7JXoIKW05bXwHnrNFZSgXM56UaCgF9TgKDYfeOB2ybyzUrCd2/E/Qf9Wj/hJEGiNB71h
         j9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7KJ/0lAbZ/7y/XSZllCDvs93clOM3RgHbDtSd5VENeM=;
        b=g7IfRCeBWFbgQImQGuLdFuAexOnTwGH/K8NzNddLQCGC6QQWprJqfi8u41wD2DXqTP
         O3xpqWlT+oXkNmjeqMNMqNNo9HTzG1N3KkLM8yU0VCZY7v9KW4ftO4OhgHkK/2/ibGEb
         DRNcUhxErMSFPDaeVzJD1+gr8lcai7lwL5Z052d99IUPNmRBMsc71MJEZDjetVW/k2R/
         w/MXQwHifjGbteKACacxUVPyaEm/u4mpZ5SaoCyTz+ukpK1t/+zqTSdscWRo4FJ87Zxi
         2hE7sfaS7CHB1VSfm3YDz++HU3gbrjcwEZsPLphvxxaWX5leJ4WcVHFoZgvw8d6DV4fe
         yK1Q==
X-Gm-Message-State: APjAAAWym8uENeU/ew8apihLG7OBWjLkg21niQcSKKpyrP4Kvj+tnG0A
        5b9yIFu6BcTzYcmg5XiqeZkCfxJd/40=
X-Google-Smtp-Source: APXvYqwOIPnDo34jDaJw2pO/dR2yO0/0zXZJEYMGwMdzDbg2z3l89kguGJIqjeve2SdE00UrphXNDA==
X-Received: by 2002:a17:902:3341:: with SMTP id a59mr6122118plc.186.1561659597223;
        Thu, 27 Jun 2019 11:19:57 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id f10sm3761474pfd.151.2019.06.27.11.19.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 11:19:56 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
Date:   Thu, 27 Jun 2019 11:19:50 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Orr <marcorr@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BABD010E-DF8D-46F1-B279-4357690261A3@gmail.com>
References: <20190625120627.8705-1-nadav.amit@gmail.com>
 <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2019, at 3:32 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 6/25/19 5:06 AM, Nadav Amit wrote:
>> Cc: Marc Orr <marcorr@google.com>
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  lib/x86/apic.h | 1 +
>>  1 file changed, 1 insertion(+)
>>=20
>> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
>> index 537fdfb..b5bf208 100644
>> --- a/lib/x86/apic.h
>> +++ b/lib/x86/apic.h
>> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>>  	switch (reg) {
>>  	case 0x000 ... 0x010:
>>  	case 0x040 ... 0x070:
>> +	case 0x090:
>>  	case 0x0c0:
>>  	case 0x0e0:
>>  	case 0x290 ... 0x2e0:
>=20
>=20
>  0x02f0 which is also reserved, is missing from the above list.

I tried adding it, and I get on bare-metal:

  FAIL: x2apic - reading 0x2f0: x2APIC op triggered GP.

And actually, the SDM table 10-6 =E2=80=9CLocal APIC Register Address =
Map Supported
by x2APIC=E2=80=9D also shows this register (LVT CMCI) as =
"Read/write=E2=80=9D. So I don=E2=80=99t
know why you say it is reserved.

