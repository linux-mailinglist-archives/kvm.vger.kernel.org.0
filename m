Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C812255D99F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiF1Aht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241782AbiF1Ahg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:37:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FB717E21
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 17:37:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so10991578pju.1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 17:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8a93OuhpjreVYzo76RmkI4B3eEXm4mUxKLTozrgybQU=;
        b=Ycz7A+HyvwoFXM9VM5JvMajXweofB0X4bGDuM5m4fA+iOBEMPF5zK/7kr3ZBx+/yZ1
         CKb3STN4KS3HgZM08m6sGJCuUr3NhfiOF8MX+pmeeBow4+1zQUM6f1cWO9LEFioeXQvz
         Kg//FJIUPsFfexJSu4IY8t8ZNfYPWcS3wN0HcR7fLpV3SMWKSd6AV/fvuckRVBTkb/LU
         OyNTv5y2i4xRVsUvzL52/uedxteHXnTj0AobbpeTiDJLVdFxKAs0JDkaHGBCyoiX8BG9
         VuEd4wwpbfItaIy+rSjuv92KT2ibkEACfAIhR1WsP10Sp4OLR+PoD4vtGcLOkEDWmyee
         vIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8a93OuhpjreVYzo76RmkI4B3eEXm4mUxKLTozrgybQU=;
        b=XqoB6D0Ve5n6GiDfEyaq8Ee64MqPrWKKurjPN9vPe8O69F67W6NJPFv/PZI5OPisFg
         rzVmf26RTgOSwOseBR1r7w7iY4SkvCZtOcj8OyShhReeBzAnph7TZLd/cdV/tY6rfj04
         Eb+jspK1EBIzpqxoqYN7KSyAeQWMvRzoniPDAmW3jYZh+IgzWGnrz/Dc5y4eu0aT75gD
         rl1Hgyt+z0Q4VmUNpKi73nD7ccO5QowGh1NW8aSVm0t1C5jJYaQ2PUYU5MxNyov2sGzz
         5ZveSCdHJJJOSwFrzD/UsacfD/y4DkZ/QgakeAqwKwG3exKIwbppsSXrAUUnh6uOgEkr
         QRSA==
X-Gm-Message-State: AJIora/Fd5/V56lPmp29C1ZFEs7DsQgJJyz8HQ/Q7Hao8aJWlQg0oEsW
        x1eq7cw9XC2loLK5VzF9IiVjb/j/WvPk4A==
X-Google-Smtp-Source: AGRyM1udf/LbIVHoMEkYEo7cMMsRURcodw5zMdH+nBg/sOGJFqIQYETQBCPUgm24qRDrkIkoKZN5XQ==
X-Received: by 2002:a17:903:1209:b0:16b:81f6:e952 with SMTP id l9-20020a170903120900b0016b81f6e952mr911900plh.48.1656376655274;
        Mon, 27 Jun 2022 17:37:35 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id i7-20020aa796e7000000b0051bb61c0eacsm7956503pfq.20.2022.06.27.17.37.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2022 17:37:34 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <bug-216177-28872-7AaU43xNGH@https.bugzilla.kernel.org/>
Date:   Mon, 27 Jun 2022 17:37:33 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE848F70-5745-4973-AD39-A905AC8ED724@gmail.com>
References: <bug-216177-28872@https.bugzilla.kernel.org/>
 <bug-216177-28872-7AaU43xNGH@https.bugzilla.kernel.org/>
To:     bugzilla-daemon@kernel.org
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>=20
> Sean Christopherson (seanjc@google.com) changed:
>=20
>           What    |Removed                     |Added
> =
--------------------------------------------------------------------------=
--
>                 CC|                            |seanjc@google.com
>=20
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> It's vmx_preemption_timer_expiry_test, which is known to be flaky =
(though IIRC
> it's KVM that's at fault).
>=20
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)

For the record:

=
https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com=
/=
