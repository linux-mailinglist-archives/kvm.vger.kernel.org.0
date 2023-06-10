Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C372A764
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjFJBRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFJBRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:17:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D64330F2
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 18:17:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b034ca1195so10848035ad.2
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 18:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686359858; x=1688951858;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6lKVuvUc71IPN4PDHC+H65W3OZBdepXzHzvvlHzhg8=;
        b=ZKgA90zryEFhJggHNRcydoQkhATnssECBpq0hoQqLL/EMEXHYYVKbklC5dP0MkGUi6
         HFfZRF7fYCckQIhI4dJJ5CU0e3f9m4xZ5bVzes/PsVlpHRAwnGWZ7tMaC8WtHADBHlY0
         SMEPd67AaAz0Im5pygzz0AAZP4Qq1PhAPu8CpgPd6QK+ZIdFTyGUfvIX7rNPJNu4Yfve
         nf/1O9S+FM2ngGcXYBukU2r2nW8omJOJ3s3bywauM4k98kKKON1b6wr4eXAj5GL3sqzY
         5LWHBqQ0PIL6nYHlGjMv+G9qFWwWKn30MAKAPoSxIgEcgEZWeB6oNe6ufZ0ObcdQuQI1
         Bsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686359858; x=1688951858;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6lKVuvUc71IPN4PDHC+H65W3OZBdepXzHzvvlHzhg8=;
        b=CxDtEO7MTNHPv0/sPAigJ0wVlMyOrReksAX8paRJ7G9gfNr0JLDE+ySsSddGa8EpZO
         tjLoWfrApv5AbDiEMfRaR7Ux0RLnRgXpsezAUEhwU8vGbBRUP0Mfn1zbr3p8HBKZWoJH
         GdpSSbXR6rkwO3JqUZ8w/oiQh53Z91ZrJNaCbdymGU8xO1z4Tk8XEduTpHvw5FOktZBw
         bjw7o+XYlcmBHb4A5J6EaU1r+NWb0bQDSNlw4ZM1J2/C19drO20/fqVXUjRj8uknghJk
         aWp6oa+bafIBtWiHmbbVp1GATewJL4G+w7aoniyu5merEtZ8rDO7gfSW2O8GPjBt6wjw
         v4XA==
X-Gm-Message-State: AC+VfDyiusoaRSsjZ2QiT5UeJIrequpZgVprFjceRfgoH1Bi8D1PSbl+
        QsgL+3XsTUXPL1exVGuM8Z8=
X-Google-Smtp-Source: ACHHUZ4B9TocPQJmi77aEf7J+wtJVDWXKUGFB11GmDOHvlHtgojDEqQQOWrhuF0RW+CIMlCOhfs1kA==
X-Received: by 2002:a17:902:c943:b0:1b2:a63:9587 with SMTP id i3-20020a170902c94300b001b20a639587mr510272pla.36.1686359857847;
        Fri, 09 Jun 2023 18:17:37 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id ja11-20020a170902efcb00b001b016313b1dsm3855729plb.86.2023.06.09.18.17.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 18:17:37 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 23/32] arm64: Add a setup sequence for
 systems that boot through EFI
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-24-nikos.nikoleris@arm.com>
Date:   Fri, 9 Jun 2023 18:17:25 -0700
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-24-nikos.nikoleris@arm.com>
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

>=20
>=20
> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> +{
> +   int i;
> +   unsigned long free_mem_pages =3D 0;
> +   unsigned long free_mem_start =3D 0;
> +   struct efi_boot_memmap *map =3D &(efi_bootinfo->mem_map);
> +   efi_memory_desc_t *buffer =3D *map->map;
> +   efi_memory_desc_t *d =3D NULL;
> +   phys_addr_t base, top;
> +   struct mem_region r;
> +   uintptr_t text =3D (uintptr_t)&_text, etext =3D =
__ALIGN((uintptr_t)&_etext, 4096);
> +   uintptr_t data =3D (uintptr_t)&_data, edata =3D =
__ALIGN((uintptr_t)&_edata, 4096);

I am not a fan of the initialization of multiple variables in one line.

But that=E2=80=99s not the issue I am complaining about...

Shouldn't it be ALIGN() instead of __ALIGN() ?

