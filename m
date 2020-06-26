Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF8620ACC4
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFZHGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgFZHGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:06:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C1EC08C5C1
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:06:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so4572945pgh.3
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+2SQeYXfZPFPN+3og3wAWnz5vIZqK7Dy21jhHI7JK8o=;
        b=lF8vyxZBeRNTRVnaiSgRBD2BAB+6vk5x8nkf1xp/zPk2hRkNflvNMRWo8B7vayakdM
         yB/PW62B4CTBkgT/OrpLbkYkLQZ7TYB3wkxhhiaPeq5SWaUTqCO9vh75lPYSjedRfQi9
         8tN7ovPuwnyp6fZPxS0mmW4zQHDadSMMmoMqhedNOdg/fNklsRvougY8B1h+x0RSolVN
         8/DKG9apD7iv9LTF556MEQh+lVCoNXa/odwtL7fy9o4CRlyNbqohJozmu6mO7mAY5Wdf
         atuN1yEJ5sIYF88+r4xaAtU1f/W0tZHhMMEf1vYRy3RmS1SCaz+2qqmVN84l80lbJfEL
         OHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+2SQeYXfZPFPN+3og3wAWnz5vIZqK7Dy21jhHI7JK8o=;
        b=IPcfRW7GQMz70L1BGrtq8yHtpoGuXhPS1hbe2lE5hIZH8EOCiPlc/Qo7rf1FN0zSZn
         r3z1QZBwuMNDh98jaHvDbiAasWxhXHDXHvhWS/K1hM1tpsL55SgY/DiTatmv2TWzZBtO
         dMmNDUUvVwFxTjfcrJg51kzTs0p1N4XrKBJYfq2Ajm3Vw47Bn1m0NP3Kxs7BV1vqEDwd
         SkDL5PW95R5/trXSlnOWfEQVKsZ/xzB4JLeFGVfNbs+Y+qBkUmeJMDGiufr7GgNRkSYD
         XbGyP0UINrheYRDw8Zwshn2YhCNKOTAWazkEOrF9iyDAeNhZ9ek3D2OQ+5mRH4RdfY3F
         lNtw==
X-Gm-Message-State: AOAM531QNOBVBVwJtSWpiPp4+grwIDGBiMqgZfrNAGkHv3avK6C4Nv7K
        XMOgLkx/Ck33Vz3h5AVVMsqO8OjxrGo=
X-Google-Smtp-Source: ABdhPJxz5vBDvtT4ZG0FHsB6TR/30AJNKP81unozA6BgGrvP6Ih3gNvu8rI5WChHpL7XAhOVzaBZ0A==
X-Received: by 2002:a63:f316:: with SMTP id l22mr1436293pgh.291.1593155206954;
        Fri, 26 Jun 2020 00:06:46 -0700 (PDT)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id z8sm19245945pgz.7.2020.06.26.00.06.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 00:06:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1b981258-6b03-a120-622f-8e597570ed53@redhat.com>
Date:   Fri, 26 Jun 2020 00:06:44 -0700
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F270BE77-F66B-42CC-B6BE-D4D3272B9F17@gmail.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
 <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
 <ded0805e-15a4-5af8-0edd-10f9c9cf57d7@redhat.com>
 <1b981258-6b03-a120-622f-8e597570ed53@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2020, at 12:05 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 25/06/20 21:18, Paolo Bonzini wrote:
>> On 25/06/20 20:59, Nadav Amit wrote:
>>> I think that there is a hidden assumption about the IDT location in
>>> realmode=E2=80=99s test_int(), which this would break:
>>>=20
>>> static void test_int(void)
>>> {
>>>        init_inregs(NULL);
>>>=20
>>>        boot_idt[11] =3D 0x1000; /* Store a pointer to address 0x1000 =
in IDT entry 0x11 */
>>>        *(u8 *)(0x1000) =3D 0xcf; /* 0x1000 contains an IRET =
instruction */
>>>=20
>>>        MK_INSN(int11, "int $0x11\n\t");
>>>=20
>>>        exec_in_big_real_mode(&insn_int11);
>>>        report("int 1", 0, 1);
>>> }
>>=20
>> Uuuuuuuuuuuuuuuumph... you're right. :(  Will send a patch tomorrow.
>=20
> Actually the IDTR is not reloaded by exec_in_big_real_mode, so this
> (while a bit weird) works fine.

Err=E2=80=A6 So it means I need to debug why it does not work for =
*me*=E2=80=A6



