Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE44C11E06A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLMJNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:13:48 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33481 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMJNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 04:13:48 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so1428090lfl.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 01:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=miSOuBuBS8hzmgNagLT6jYURcwUJ/tPdE04TWcJPNdY=;
        b=HT9/AiaU3mYcL0cIpmPZIoyzF9E8bX5R4SvbzX9gwLjzL1S++jGnYd/pQS9vXrpWWw
         pqHXn7C0m2yypqEvZ9zwYIQetr5XhX9BSuykSc7eSrMia6m6NbWhxvWoe8RPafyTBhEz
         UXA5MNwDVQL4zjcl26wuU31afh2etYj/fKhV86towRCh5zJXMl+e/kZxV4sfmyUANYoB
         i8uTlUxDbx/ngXENHLAVTpFgXSgcCLPxTmb77ce5f4mGoJO1ynufTEyPdF1AJWcbaRmU
         ni2hRmvVMxdCKQXbI9R0EJ/mtuJiRZUMQz4rRxBQUF6UOJBG31Qx8SCZ54wTl5f7/PD3
         GKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=miSOuBuBS8hzmgNagLT6jYURcwUJ/tPdE04TWcJPNdY=;
        b=ST3yCElY39Soxy/DogwaPMLrEv6BYSU3P6bjldX5EKXxFSZMtKLH1S0sN4zlP04dyn
         Eoo4Q+nd/PUWC5rLAS7f/yJgBzSRNbiq86T3hcKF/dS/GaSQig+xNcw130bSxh6mrSFI
         jMnbvMHa/oZOaljRxw96EQUj2lrma/dyfVKbw8bB16Y/IG1NF9lxZjiyPnxmC8UeFXqo
         GCyNk7Hwv6gY+84CrSaDvxP/fLi8MkUZSmGLHW6+rtYhGn3eUxaVGbTXb4ybJyAFyjKT
         mui09cIzfshRRKp65t4ab/WIv56df91RBWeZZDbF8fphyJHJx34kLhfhxdt9igzS6HeI
         dEIg==
X-Gm-Message-State: APjAAAVLcEAYlhZJUdaiK4xBWN24eWAgjPXPUqR096vMau9y937+OOFb
        y29em17CWBSS1/MaX/GhcD4=
X-Google-Smtp-Source: APXvYqxfCcrlPkcZ2A/oGPQji/dcEMZ83vMuepl1Bpm1APuzzLBKliLTVe5moUfEEKxEqZr0rFJEFA==
X-Received: by 2002:ac2:51de:: with SMTP id u30mr8175010lfm.69.1576228426272;
        Fri, 13 Dec 2019 01:13:46 -0800 (PST)
Received: from [192.168.1.28] ([77.137.83.197])
        by smtp.gmail.com with ESMTPSA id t9sm4137015lfl.51.2019.12.13.01.13.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 01:13:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index
 check
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
Date:   Fri, 13 Dec 2019 11:13:42 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <51BBC492-AD4F-4AA4-B9AD-8E0AAFFC276F@gmail.com>
References: <20190518163743.5396-1-nadav.amit@gmail.com>
 <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 13, 2019, at 12:59 AM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Sat, May 18, 2019 at 4:58 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>> The test that checks the maximum VMCS field encoding does not probe =
all
>> possible VMCS fields. As a result it might fail since the actual
>> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.
>>=20
>> Change the test to check that the maximum of the supported probed
>> VMCS fields is lower/equal than the actual reported
>> IA32_VMX_VMCS_ENUM.MAX_INDEX.
>=20
> Wouldn't it be better to probe all possible VMCS fields and keep the
> test for equality?

It might take a while though=E2=80=A6

How about probing VMREAD/VMWRITE to MAX_INDEX in addition to all the =
known
VMCS fields and then checking for equation?

