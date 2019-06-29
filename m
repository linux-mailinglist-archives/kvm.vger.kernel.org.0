Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87305A857
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 04:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfF2Cax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 22:30:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41394 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfF2Caw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 22:30:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so1891377pgj.8
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 19:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=N1tdRzqrc2j4Dg/GZdMSVN0lwMqdBkkPwRuYn5NOA6w=;
        b=GVC4xXlJujv3jvkPOGt3H4gHoPqaREMRFmmyF3cEwue1k+BLz4L5ZDNZr80Qw2OxYS
         YrSFGNrBxyjq8nwcXxRXX9/f47yosK1w7duRW5U8ANvalFLSvOgZSto1MGpsdMbByDp+
         /7Mz/Kld/3ANAIO/qkBhI2f47E3zwbjcUkDwT1/MSbQbQVaD6arJ2Bnf9WCcKV/vjqq6
         lKcapajbZ2s8zz1gW/w5ddS5HtOtSHZ6BLYhSMfMeRlBP4qEWH7G587Tp3n+X0HpfBeI
         kNfS8etjMfFeYSobrS9drAVUJ9FvA179b2wUpirAbdOHZvLzUhARsdFHh6Hb+zqjyGmg
         0Qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=N1tdRzqrc2j4Dg/GZdMSVN0lwMqdBkkPwRuYn5NOA6w=;
        b=h6irKF6I4kaxdouUvSx5TFCbXir7guWg0jlN7JE7BVjP7skkE4L7cRoBFFFfFoYpzn
         arIgHKS0UbIF4+yJHftGlISewrkZ97j4zwGVX9zYKBIylXaE6NKnUyA2R4/Yr8+Mgnsh
         BOCxTGtEwceYbiV+U/1m2N6M4ZXsfxxkOisTtHiLz0vuszNoIPN2nvbA6D5eM0ofNWsw
         NxUMk0RQyuehhi8agWgGMxI+FM1Hc1hwuOuteU6Sgf2t7HXCd2XmBWdR43KCbA7USQuU
         YDQ+iaqcwIY2nLrtWycEOn/PeQyG42wlnb92n7CMlV+7QkVNM+vJB5rrKRXh2HxJxHKR
         tkEg==
X-Gm-Message-State: APjAAAUq016xyaKJRGb72qaqhomoTDaBjDPi0Imq3RF5phbFuLQxFIEG
        WCChbD94WBw/3GcpdvkhGfY=
X-Google-Smtp-Source: APXvYqxNDoZ3xN2zZsjkt3wrn7QfkuvpJ8BNqYWrM2WY+ud2r4QAURl3SuXOajVjlsw7LYz8I/726Q==
X-Received: by 2002:a63:d748:: with SMTP id w8mr11921226pgi.157.1561775451390;
        Fri, 28 Jun 2019 19:30:51 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id w7sm3809268pfb.117.2019.06.28.19.30.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 19:30:50 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2] kvm-unit-test nVMX: Test Host Segment Registers and
 Descriptor Tables on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <5F6321E0-0F9F-464B-B20B-2A6669C7C76E@gmail.com>
Date:   Fri, 28 Jun 2019 19:30:49 -0700
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F9E8464-8861-4870-B3E0-1D3F54E50972@gmail.com>
References: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
 <20190628221447.23498-3-krish.sadhukhan@oracle.com>
 <5F6321E0-0F9F-464B-B20B-2A6669C7C76E@gmail.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 28, 2019, at 7:00 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Jun 28, 2019, at 3:14 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>>=20
>> According to section "Checks on Host Segment and Descriptor-Table
>> Registers" in Intel SDM vol 3C, the following checks are performed on
>> vmentry of nested guests:
>>=20
>>   - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, =
the
>>     RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>>   - The selector fields for CS and TR cannot be 0000H.
>>   - The selector field for SS cannot be 0000H if the "host =
address-space
>>     size" VM-exit control is 0.
>>   - On processors that support Intel 64 architecture, the =
base-address
>>     fields for FS, GS, GDTR, IDTR, and TR must contain canonical
>>     addresses.
>>=20
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>> lib/x86/processor.h |   5 ++
>> x86/vmx_tests.c     | 159 =
++++++++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 164 insertions(+)
>>=20
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 4fef0bc..c6edc26 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -461,6 +461,11 @@ static inline void write_pkru(u32 pkru)
>>        : : "a" (eax), "c" (ecx), "d" (edx));
>> }
>>=20
>> +static u64 make_non_canonical(u64 addr)
>> +{
>> +	return (addr | 1ull << 48);
>> +}
>=20
> You may wan to make it =E2=80=9Cstatic inline=E2=80=9D. On my system I =
get:
>=20
> processor.h:464:12: error: =E2=80=98make_non_canonical=E2=80=99 =
defined but not used [-Werror=3Dunused-function]

And I also get on bare-metal:

  FAIL: HOST_SEL_SS 0: VMX inst error is 8 (actual 7)


