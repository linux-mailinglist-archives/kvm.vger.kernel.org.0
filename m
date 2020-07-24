Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AEB22C3FC
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 13:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgGXLCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 07:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgGXLCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 07:02:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF975C0619D3;
        Fri, 24 Jul 2020 04:02:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so5044236pjg.3;
        Fri, 24 Jul 2020 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FfesR7ZT5qXcTi29yTDLUUd3CkRzbDIr3gddgJd2pEA=;
        b=ULjTfKn6wgQjuRYnfk8arHeojc4it0s3Z02NGt8se0n375u4P9/6ZpQJaMQDGIFQKn
         btV9lnLarheBlK4BIPbxANr+sZ7BTv5TU0gO5NhHRd9pqUhIxsM7Q+9Ez+hO1TKrIaDY
         YWBOHIiQsEknnUh5tqbM2HZECVwUOcuRt68ouJQ9v60+H/lmbbIDZ+TPQD9iKtNeJpLc
         f/aqzZ85NGNeLoJFJSBfgXRMPqCap5M6gGuD+wwiNz+fkLXoRHudH3NBGakI1i88uEDp
         9WJ0dubTZAkauBJUhVfRi+Vc2/0TPmN/RrALdDQXtGNspj61LV7p3qiwsHVEzSz0zE/d
         0chA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FfesR7ZT5qXcTi29yTDLUUd3CkRzbDIr3gddgJd2pEA=;
        b=OdIKUDZ1ghyldwhaWiPpZMLWXBndywxlz3UaZYmfLdv1Q2bFvNmKMNVa2qRowNZAGA
         Pl8n4DAQfD5/Xe1/SMhEzdUK/Dc/SY9KPh97THGx/L6DWmBYZXb3epAeqGSUGJ0CTRDr
         2tLS71MxgVNMzm686vCvsc7wfeixik6RzMyoP5f8dgrIO+r9VENehXwxP1MWzl+v/T7L
         aduL1YzOA3R1Gra7YN1bdbuu7hDtGYzpfedDbAX6mMu3GtBSU3WKcBs4gNdQ0FLn3YZz
         ZS4bpzB045twPbaxJnpF2eYWgnumeOu+6mP/WdlxBLfcmrtxLyLxDCQHXiXLZBOkCfTk
         a3gw==
X-Gm-Message-State: AOAM530JETJ23Jt64sIAjGB1uPYJX3pKcESc/WRTf0h5c56mkE/pQvlt
        +e3oM1la2cDyIyrHrzeTvSVG31fGT+NP+7Jl4Zs=
X-Google-Smtp-Source: ABdhPJwYcmTO2+w+O+IAx4ADzupDHHlyAIJOZJ9tCjeFSztHK+LtA282fIxvP10WiGCMf0PxilSuIy5I/vXfX09D5BY=
X-Received: by 2002:a17:902:8491:: with SMTP id c17mr7580569plo.262.1595588563901;
 Fri, 24 Jul 2020 04:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200724105600.10814-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20200724105600.10814-1-giovanni.cabiddu@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 24 Jul 2020 14:02:27 +0300
Message-ID: <CAHp75VduFnt=5eBiyUgV-B+Kes-JgkKvxMQ_YQOCGv4j5=qx6g@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] vfio/pci: add denylist and disable qat
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cornelia Huck <cohuck@redhat.com>, nhorman@redhat.com,
        vdronov@redhat.com, Bjorn Helgaas <bhelgaas@google.com>,
        mark.a.chambers@intel.com, gordon.mcfadden@intel.com,
        ahsan.atta@intel.com, fiona.trahe@intel.com, qat-linux@intel.com,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 1:59 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> This patchset defines a denylist of devices in the vfio-pci module and ad=
ds
> the current generation of Intel(R) QuickAssist devices to it as they are
> not designed to run in an untrusted environment.
>
> By default, if a device is in the denylist, the probe of vfio-pci fails.
> If a user wants to use a device in the denylist, he needs to disable the
> full denylist providing the option disable_denylist=3D1 at the load of
> vfio-pci or specifying that parameter in a config file in /etc/modprobe.d=
.
>
> This series also moves the device ids definitions present in the qat driv=
er
> to linux/pci_ids.h since they will be shared between the vfio-pci and the=
 qat
> drivers and replaces the custom ADF_SYSTEM_DEVICE macro with PCI_VDEVICE.
>
> The series is applicable to Herbert's tree. Patches 1 to 3 apply also to
> Alex's tree (next). Patches 4 and 5 are optional and can be applied at a =
later
> stage.

Thanks!
FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>


> Changes from v4:
>  - Patch #2: added Reviewed-by tag from Cornelia Huck
>  - Patch #5: added Suggested-by tag as this change was suggested internal=
ly
>    by Andy Shevchenko
>  - Patches 1-5: added Reviewed-by tag from Fiona Trahe
>
> Changes from v3:
>  - Patch #1: included Acked-by tag, after ack from Bjorn Helgaas
>  - Patch #2: s/prevents/allows/ in module parameter description
>
> Changes from v2:
>  - Renamed blocklist in denylist
>  - Patch #2: reworded module parameter description to clarify why a devic=
e is
>    in the denylist
>  - Patch #2: reworded warning that occurs when denylist is enabled and de=
vice
>    is present in that list
>
> Changes from v1:
>  - Reworked commit messages:
>    Patches #1, #2 and #3: capitalized first character after column to com=
ply to
>    subject line convention
>    Patch #3: Capitalized QAT acronym and added link and doc number for do=
cument
>    "Intel=C2=AE QuickAssist Technology (Intel=C2=AE QAT) Software for Lin=
ux"
>
>
> Giovanni Cabiddu (5):
>   PCI: Add Intel QuickAssist device IDs
>   vfio/pci: Add device denylist
>   vfio/pci: Add QAT devices to denylist
>   crypto: qat - replace device ids defines
>   crypto: qat - use PCI_VDEVICE
>
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c        | 11 ++---
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      | 11 ++---
>  drivers/crypto/qat/qat_c62x/adf_drv.c         | 11 ++---
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c       | 11 ++---
>  .../crypto/qat/qat_common/adf_accel_devices.h |  6 ---
>  drivers/crypto/qat/qat_common/qat_hal.c       |  7 +--
>  drivers/crypto/qat/qat_common/qat_uclo.c      |  9 ++--
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c     | 11 ++---
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   | 11 ++---
>  drivers/vfio/pci/vfio_pci.c                   | 48 +++++++++++++++++++
>  include/linux/pci_ids.h                       |  6 +++
>  11 files changed, 87 insertions(+), 55 deletions(-)
>
> --
> 2.26.2
>


--=20
With Best Regards,
Andy Shevchenko
