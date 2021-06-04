Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC8E39BE1F
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFDRMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:12:01 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:44902 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDRMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:12:01 -0400
Received: by mail-pf1-f181.google.com with SMTP id u18so7892134pfk.11
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4weTdJ0YTmu/DRfilhk/akmqrzVHfOJIQkj3DUooUhI=;
        b=MJB7ImK/CAg1nYEW6Hvm4blv80CA113bxBLtCYiM9z161+eBkSWprF36aGhWm/2jFx
         7h2K3i4L8PPbXYQzua2ebsE7W611C4L3rFpVaVzVPdi8pnkDLT/xae4Hlrzdm5Cq17GO
         cZu2N03dBHSTfP2rUdvjlpRd9RwbWknGq/phWJ8vV6OSb4sqeFAtQ4ZVbNgGa0B5DxSU
         D1Xq38YEig9SbUKp0XNgICzkpnaM+UgdwYs9utCGcrBOJgzM0udvu/HuAztMBz0VeqOu
         WvzyoCneTMWNrSQdJpDcn7Sgq1ZLS6iWGd90voUpknMWnDYhFb8DuWGmJuRHFS8FOKOa
         Na6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4weTdJ0YTmu/DRfilhk/akmqrzVHfOJIQkj3DUooUhI=;
        b=LOihSrp+qYyPMzSP1ImuNeHGo7lpMcNeGj60ZKKshD0P8wdK9HmW8/LNqMa1CV+hX3
         vhYL/yYmUP+GIev2xFaO3ij66SUPWlpCivAek7PM4TxGlM26gVF/kMfAu4EL/iczNevE
         tPUb6aqJI+U+0kPUjKm1aQBVf0P3C0bf9mqN/oreatKRT39qEbhs0EiFzw6YpX9ByGVf
         O23sb4++GRniV1DtP2s3qXMOnTZ1NMNwuHu+cdUFLmVQclCnoA1TiBnOI3LrbNkzb81+
         pM/hpwYd0LAc0Axn/m3A7zoNSjJ5DOFIpOkOCysbS8a47GanUS59+YS175g6eXIvnaAd
         qe9g==
X-Gm-Message-State: AOAM533imjmqPn7pohAwXKXREdTQ4xAF2iJOO+Ovx/PvcX3C1fyd0sak
        xCbfUhGf5DTDGjwMVRnm6R0=
X-Google-Smtp-Source: ABdhPJybh0iZwLLQyBbvZQU4vG1lDemaKcggc9Lwfj3B3RGvAWIxHZlmxxFJNfjDbLcT1vXId9AVpw==
X-Received: by 2002:a65:528d:: with SMTP id y13mr6055183pgp.276.1622826540742;
        Fri, 04 Jun 2021 10:09:00 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id t24sm5081485pji.56.2021.06.04.10.08.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jun 2021 10:09:00 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <DM6PR11MB311557D8C203529903BEFB2F993B9@DM6PR11MB3115.namprd11.prod.outlook.com>
Date:   Fri, 4 Jun 2021 10:08:58 -0700
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2516617A-CFDE-4EEF-89D9-896951A9C68D@gmail.com>
References: <20210604023453.905512-1-yi.sun@intel.com>
 <20210604023453.905512-2-yi.sun@intel.com>
 <30FA4AAE-DBC9-4DB7-8742-079F2B3067C3@gmail.com>
 <DM6PR11MB311557D8C203529903BEFB2F993B9@DM6PR11MB3115.namprd11.prod.outlook.com>
To:     "Sun, Yi" <yi.sun@intel.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 4, 2021, at 5:32 AM, Sun, Yi <yi.sun@intel.com> wrote:
>=20
> Hi Nadav,
>=20
> Let me confirm if  I got what you meant. Do you want the grub entry =
look like following?=20
> Take case memory as an example:
> Add module command line taking '/boot/module' as its parameter, =
meanwhile package the file 'module' in the folder?
>=20
> menuentry "memory.elf" {
>    multiboot /boot/memory.elf  tscdeadline_immed
>    module   /boot/module    # Add one line like this ?
> }

Yes. The entry should look exactly like that.

Just to make sure we are on the same page, the =E2=80=9Cmodule=E2=80=9D =
should be provided as a second parameter for the script. The additional =
=E2=80=9Cmodule=E2=80=9D entry should only be added if a second =
parameter is provided.

Thanks,
Nadav=
