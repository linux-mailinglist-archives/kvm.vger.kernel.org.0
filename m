Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3646E58801
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfF0RJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 13:09:14 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46328 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfF0RJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 13:09:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so1613106pls.13
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XSULTdlWxFhJFf97Es8V1g+EGt9OnSt1Dth3lSOKkJ4=;
        b=HYYfmygUMrInoicCZZuH7cxphhjUzubMTHNJNRcPJoIAUybKicjQaB1pQKMjFoyUvp
         ufrH7ZXq1XU/Pcof9eZ3C6WsOwe/hf+SfNOzqiL17rwkHcnFd4/XwsInuT45xspuNWhE
         pNB6riZ3yqX+XIz3nL5XO71yXcBDVqaxgKbA3Y6SA8btQSTvRdpYzkBZaA73sYipDUe+
         /7ad0GRXSN8SFhTgFJdWtFKqtasgdKKuVOoS1RCDdVc22rAAWAiozss1RH+urhkMF969
         4IT4hTj99uVwrCVkieibLt5VgZ4Ak/6nAj3G1KXiddIuo/Ky6/5rnJmBbrDdm3hn0V3Z
         XaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XSULTdlWxFhJFf97Es8V1g+EGt9OnSt1Dth3lSOKkJ4=;
        b=UUtqYAOCsjLvRNMEfJt2f0JSUCL53tzoplSXVLXgbLto5x1FxJlXCH5uZn7f/giwh5
         nZVkHgjjKU7OXUHwpKMCTQrKq1giOkNxFpir+4TgP7Ld6Agr5xZZTWtdc2v8Q2aXA1JT
         8br+L7nZinMiiwveDOORlPe0zor+nYvPLFKtm5iTtwdpPpEAfM4F8IcKQ6fYuCMhuf9r
         MZ8ZcwlcorGOd7PZZMrcZkbNsTSbMoC5nUK2tbuUA75rKwThYrtRk1AeaP8aQm+d4llU
         Oxz/fsJ2sdad3dKju/sZK4PRO2M5NLi4BnymRT73IXMlNSk64NyIU/m1UtKHSYyD9Or4
         Od0w==
X-Gm-Message-State: APjAAAUim+sY+VmNt0+w6qL08AlEESmXM9K3Y1/PDcVYBF9gorsDiAsd
        2Vv9K3Fh7FsgCzMeH59q1vs=
X-Google-Smtp-Source: APXvYqxiJQ1rFi+RW37mDnA2k8EOaZ8QalRp77sZF2y23FcwHZo/86qbNxjVDpTl3HzKd2R+VOj04g==
X-Received: by 2002:a17:902:bcc4:: with SMTP id o4mr5760184pls.90.1561655352931;
        Thu, 27 Jun 2019 10:09:12 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id t11sm3438132pgb.33.2019.06.27.10.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:09:12 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Reset lapic after boot
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <9df90756-003e-0c0f-984e-07293fdc2eb1@oracle.com>
Date:   Thu, 27 Jun 2019 10:09:10 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1C1AFF9-CAE5-45CE-AF61-A61DA43211B2@gmail.com>
References: <20190625121042.8957-1-nadav.amit@gmail.com>
 <9df90756-003e-0c0f-984e-07293fdc2eb1@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2019, at 5:26 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 6/25/19 5:10 AM, Nadav Amit wrote:
>> Do not assume that the local APIC is in a xAPIC mode after reset.
>> Instead reset it first, since it might be in x2APIC mode, from which =
a
>> transition in xAPIC is invalid.
>>=20
>> Note that we do not use the existing disable_apic() for the matter,
>> since it also re-initializes apic_ops.
>=20
>=20
> Is there any issue if apic_ops is reset ?
>=20
>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>> ---
>>  x86/cstart64.S | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>=20
>> diff --git a/x86/cstart64.S b/x86/cstart64.S
>> index 9791282..03726a6 100644
>> --- a/x86/cstart64.S
>> +++ b/x86/cstart64.S
>> @@ -118,6 +118,15 @@ MSR_GS_BASE =3D 0xc0000101
>>  	wrmsr
>>  .endm
>>  +lapic_reset:
>> +	mov $0x1b, %ecx
>=20
>=20
> Why not use MSR_IA32_APICBASE instead of 0x1b ?

I don=E2=80=99t remember, but it does require taking care of =
MSR_GS_BASE.

I can include =E2=80=9Cmsr.h=E2=80=9D and remove MSR_GS_BASE and =
MSR_IA32_APICBASE. I=E2=80=99ll add
another patch to do so (since MSR_GS_BASE must be taken care of too).

