Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0DFBD2BE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 21:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbfIXTf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 15:35:26 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:36045 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfIXTf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 15:35:26 -0400
Received: by mail-vk1-f194.google.com with SMTP id w3so89377vkm.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 12:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RXahQeK7cA3xBg4Yxa4oGPZXQaRxDeRbkTNGSpwm2s8=;
        b=AqgvSbK5Pdbnv4nKaJlvyxdR47x2R6itw8LhlGtgeaQIcEKcTQZtIf66gdkEbPJdFU
         LtPkRsEREO96Ukyn2Xd4zUu3jfPuOZNmsq0BJV2SU7iAMsx/eao1D9kzP6yCQUtzTx5v
         QDpkg2Y0qrIfflxyrZeKirOX8s6oMm1cuiAV2XzksuK7m50tHZaG+xcKCcrmOW24X38m
         UOjvyc+0qHiNpYCswgdQaIpbRZ2WWZnN0Q9cedOtDH3Y92UGQ9umIcXUpG+v8QJsdR/A
         IkhWOwFcJUqjK1MW0Ya6S28Zd4r+0i+3DTnScOu1EzKsoCv8HCko9m9zq7OsgiHEQRKz
         y/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RXahQeK7cA3xBg4Yxa4oGPZXQaRxDeRbkTNGSpwm2s8=;
        b=kOKuTLmTCXUogaSk2d3fFC+EU+RBS+IIsFGpyB0wI06hEKWtLyrZ1fU2Da9/D0ndfG
         terpdPKxArQ8gb/6lHlcTgbu7KEAYVpXW1sNaf/PBONQ/uyNZvsi7R5UuC5/3uw59iaV
         OD0RHbX6kSsqFs/JQ3sxfolZVn+SFqZ8NtHl0iYtt2evOibbWtnL/9LLNcDM2dVmWBm/
         bJYsC19/btF5pf39ZWyQGmiWSsPKTZBD5ksKn9LpqMzl1A08RT5ypX0XCAZyvffXrZR0
         28KoGEmEUM0Mf+lYmBebW9ozEN4gjcG/eeC4WaIRoo1rU69gOxG5F5cXZafINUDoyglB
         nMrQ==
X-Gm-Message-State: APjAAAVwQ4PsOD7lEjKtCgf6aFou/Yq0yZdqUh8SRBT9HN9rjsMhQEUJ
        09Yj0wMbXEy29YxD4+m3ds2S56t6NU4A/PmcQ9jA
X-Google-Smtp-Source: APXvYqxlsT5++ADNHLRKk72HPWyoCDra8TPkz/q84l0HYr2JZvUNmD1llRkI6Mvjw+ElVwMtm7ZvvGyfBrExsHsOWms=
X-Received: by 2002:a1f:b987:: with SMTP id j129mr296367vkf.27.1569353725248;
 Tue, 24 Sep 2019 12:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
 <20190911191127.GH1045@linux.intel.com> <CAGG=3QXbCriXR+FER2ex9nN_aHENRgDvJNQ_HDCFniPP0NJNpg@mail.gmail.com>
In-Reply-To: <CAGG=3QXbCriXR+FER2ex9nN_aHENRgDvJNQ_HDCFniPP0NJNpg@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 24 Sep 2019 12:35:13 -0700
Message-ID: <CAGG=3QWrr9Tg+ZKVh0N1hZ+LbVdYDcFiu8cHL=S8Za0M1uKg5w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: emulator: use "q" operand modifier
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Plain text now. Sorry for spam.


On Tue, Sep 24, 2019 at 12:33 PM Bill Wendling <morbo@google.com> wrote:
>
> +Paolo Bonzini, Radim Kr=C4=8Dm=C3=A1=C5=99
>
> On Wed, Sep 11, 2019 at 12:11 PM Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
>>
>> On Mon, Sep 09, 2019 at 02:28:22PM -0700, Bill Wendling wrote:
>> > The extended assembly documentation list only "q" as an operand modifi=
er
>> > for DImode registers. The "d" seems to be an AMD-ism, which appears to
>> > be only begrudgingly supported by gcc.
>> >
>> > Signed-off-by: Bill Wendling <morbo@google.com>
>> > ---
>>
>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
