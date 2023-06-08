Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA45728641
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbjFHRY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 13:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjFHRYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 13:24:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3EA1BDF
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 10:24:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-53fa455cd94so445615a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 10:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686245064; x=1688837064;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XL9bsC//gXuc7C5OzuzU0d50fzWgPEd1BsIEsVnXnhE=;
        b=rYGyLuoP4Kkzt9M/GDqS8KCUwQPNzaazOWhKXdvuy9QlWEmPpWhs5o3gix5PYVRmT4
         GswcLn8C9ttTFBwcTM25aR+WPf7vjE0p1GoFzBUfuSCG6/Lek8DEGC3tnYva6lOQlXGj
         YE7MGgIwcsMX7EVCTp+kt5R8DER2vI/M2w4peW7MiqE3OdQlkasL55NUG5Qvwk7aFI4K
         hLYFPhA/cOh56eXHQfFAvtsT+TSRPDvSsJfxabl/RXONG3IfWYaEAVDw6pORrDnPT9DA
         DDDXAQErQd/0Re0Ey4l2G/UR6E/ndZf2lP1yO/Jvny0o8S0sU+dg0K3QRCfLkERafB6e
         +q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245064; x=1688837064;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL9bsC//gXuc7C5OzuzU0d50fzWgPEd1BsIEsVnXnhE=;
        b=TLwWyn/+DbDVOpu4wKgvs0p32+iuD1IxqfMIFBK3/NbDovGVo17Gd1zOWkTONudWhu
         5WpCiaRv2YkReUAf7LDpcXyVSGBckDLJgFLgl4AWpDA9IvG62lKdtj3FCh9dDWuSaEbb
         zZj3pBDQ5RrOPynXHbvU0ToYFtWuFdEBgv2yLRZeLlz9ROC7DbbqNwA192a2F+6WAdud
         pBa69vOjptiqiYAegKnrJpZy2VhNEYs0ya83ggfOR3z3mphGz0OD8zh0tkSx1jZuAlvi
         72EW2eRDGklMxcw5KxejXT3GIsjieyilJdijv1Hstiw20toH6KV+uQOQkgD5I2oidl+g
         kr8Q==
X-Gm-Message-State: AC+VfDzyN6OlvHlmO9o59QvnbUclM0oXtjzUF3Oq/H7yPj9MkHtGN5KX
        VxjdjkEFHtTv7APYvtXSOuc=
X-Google-Smtp-Source: ACHHUZ6CzWfNWAROq8fvBWQOGQH9Net4T3vU6TxOvUP/DQ2oGfEPtYQn+AO91Tgkyn6pWYg7r/FU8g==
X-Received: by 2002:a05:6a20:3944:b0:106:c9b7:c932 with SMTP id r4-20020a056a20394400b00106c9b7c932mr4999752pzg.1.1686245063924;
        Thu, 08 Jun 2023 10:24:23 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id d3-20020aa78143000000b0064d681c753csm1352967pfn.40.2023.06.08.10.24.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2023 10:24:23 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
Date:   Thu, 8 Jun 2023 10:24:11 -0700
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>=20
> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
>>=20
>> +static void uart0_init_acpi(void)
>> +{
>> + struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
>> +
>> + assert_msg(spcr, "Unable to find ACPI SPCR");
>> + uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
>> +}
>=20
> Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
> address and bit_width as bit-width?
>=20
> I would appreciate it, since it would help my setup.
>=20

Ugh - typo, 8 as bit-width for the fallback (ioremap with these =
parameters to
make my request clear).

