Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7261D4A38D9
	for <lists+kvm@lfdr.de>; Sun, 30 Jan 2022 21:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356061AbiA3UER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 15:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiA3UEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jan 2022 15:04:16 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE19C061714
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 12:04:15 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id p4-20020a4a8e84000000b002e598a51d60so2750889ook.2
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 12:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RUFY00YXJJeLqbxVmMRjX1UPqKr+v6j2Q2Lb/hHCorE=;
        b=LPeT4qjco75qSbMEgp8OpA9UV2o3+cItPv0N6jmP0bCMSNu2xrPFHz0ah01uh1woDU
         Id33jO4GCgvFtCz3p5LD7xv2VMGmROjXgRipZdOKFbKTkWjobeIai5h1vmaw+2bhoiDn
         MP7BsOTsJBlvvPKhVvlGR3YDLpPt1jjHuboXtoQT9i5KvL7Vk8miTXC/+5IY/r6GcBI8
         /MmmVtU7G+Rg51i+Y3vGiGD4wg5eDJ7TW6Fx4M+1SVj+VjAxL3uhcSVDxEcEP9jLEb8K
         IuDMf+GBYhK0yBibJZCmOZCIIM1Fd+bVu1kJQbkFcbQyKACAG+h6r7FqSrHUR1josmf0
         lpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RUFY00YXJJeLqbxVmMRjX1UPqKr+v6j2Q2Lb/hHCorE=;
        b=1UGw5ELyJVwt64vnNDNbCJQYd54NtMUEnrAOvHQDxnYjzdUxpL0OEfep3Y0I2bDtgQ
         yXRKWxXYjUtZsA0PqmYyBteDOcucADXhqs0kCMVrydUUAd4YyKJw5dPL5FvG+HJno0J2
         TN/RRQKSFHnXlbTS+iQe0b7ESHk3LwvVsaauVZ6Cp4rXIC8Du6UzmUc0pNpo/hREYRIs
         ENiR5tv8RndAQ1xWEbn+NaWUF/uS+l0oh0XE2pSag2gbmnz2LOmFdV/FV3PkXn2cYDXV
         cAmltV0h6Aef4wl8tDQXkEgL2BoRhT4QVgEoHbLqZ4+9BxW/NN9dYDVbs90nKqr48bX0
         QJTA==
X-Gm-Message-State: AOAM5339LDPtL7xJ/vGW8cERyuyhS4mGl1b3UYZDPCcAMEdPJ6nFYpf0
        bYrlMfBwggOonGBVwUo9WYyia+2LykIRyK0uWJH56A==
X-Google-Smtp-Source: ABdhPJxDsmMx4xhIr/eiWZyJ3fXPpjr2yjebys6uNVyOexKFr7ad9dxES3ikPHPM5rvY9E8xia0SaM6fQitdetOti2Q=
X-Received: by 2002:a4a:c606:: with SMTP id l6mr8959085ooq.27.1643573054093;
 Sun, 30 Jan 2022 12:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-2-varad.gautam@suse.com>
In-Reply-To: <20220120125122.4633-2-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sun, 30 Jan 2022 12:04:03 -0800
Message-ID: <CAA03e5FS3SnM6nSgemPi441x11+M_=Hc+YUiJfPA40R83PDFsw@mail.gmail.com>
Subject: Re: [kvm-unit-tests 01/13] x86/efi: Allow specifying AMD SEV/SEV-ES
 guest launch policy
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Make x86/efi/run check for AMDSEV envvar and set SEV/SEV-ES parameters
> on the qemu cmdline.
>
> AMDSEV can be set to `sev` or `sev-es`.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  x86/efi/README.md |  5 +++++
>  x86/efi/run       | 16 ++++++++++++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/x86/efi/README.md b/x86/efi/README.md
> index a39f509..1222b30 100644
> --- a/x86/efi/README.md
> +++ b/x86/efi/README.md
> @@ -30,6 +30,11 @@ the env variable `EFI_UEFI`:
>
>      EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
>
> +To run the tests under AMD SEV/SEV-ES, set env variable `AMDSEV=sev` or
> +`AMDSEV=sev-es`. This adds the desired guest policy to qemu command line.
> +
> +    AMDSEV=sev-es EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/amd_sev.efi
> +
>  ## Code structure
>
>  ### Code from GNU-EFI
> diff --git a/x86/efi/run b/x86/efi/run
> index ac368a5..b48f626 100755
> --- a/x86/efi/run
> +++ b/x86/efi/run
> @@ -43,6 +43,21 @@ fi
>  mkdir -p "$EFI_CASE_DIR"
>  cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>
> +amdsev_opts=
> +if [ -n "$AMDSEV" ]; then
> +       policy=
> +       if [ "$AMDSEV" = "sev" ]; then
> +               policy="0x1"
> +       elif [ "$AMDSEV" = "sev-es" ]; then
> +               policy="0x5"

Rather than bare constants, I think we should define these as bit
fields. Something like:

$ git diff
diff --git a/x86/efi/run b/x86/efi/run
index b48f626b0435..427865807720 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -19,6 +19,10 @@ source config.mak
 : "${EFI_SMP:=1}"
 : "${EFI_CASE:=$(basename $1 .efi)}"

+# Define guest policy bits, used to form QEMU command line.
+readonly SEV_POLICY_NODBG=$(( 1 << 0 ))
+readonly SEV_POLICY_ES=$(( 1 << 2 ))
+
 if [ ! -f "$EFI_UEFI" ]; then
        echo "UEFI firmware not found: $EFI_UEFI"
        echo "Please install the UEFI firmware to this path"
@@ -47,9 +51,9 @@ amdsev_opts=
 if [ -n "$AMDSEV" ]; then
        policy=
        if [ "$AMDSEV" = "sev" ]; then
-               policy="0x1"
+               policy="$(( $GUEST_POLICY_NODBG ))"
        elif [ "$AMDSEV" = "sev-es" ]; then
-               policy="0x5"
+               policy="$(( $GUEST_POLICY_NODBG | $GUEST_POLICY_ES ))"
        else
                echo "Cannot set AMDSEV policy. AMDSEV must be one of
'sev', 'sev-es'."
                exit 2

> +       else
> +               echo "Cannot set AMDSEV policy. AMDSEV must be one of 'sev', 'sev-es'."
> +               exit 2
> +       fi
> +
> +       amdsev_opts="-object sev-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,policy=$policy -machine memory-encryption=sev0"
> +fi
> +
>  # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
>  # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
>  # memory region is ~42MiB. Although this is sufficient for many test cases to
> @@ -61,4 +76,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
>         -nographic \
>         -m 256 \
>         "$@" \
> +       $amdsev_opts \
>         -smp "$EFI_SMP"
> --
> 2.32.0
>

We don't have QEMU working on our internal setup because it doesn't
support INIT_EX. So I wasn't able to test this patch in its entirety.
But this patch seems pretty reasonable, independent of the rest of the
series. Depending on maintainer review bandwidth, it might make sense
to send this patch on its own (with Tom's feedback incorporated),
outside of the series, so it can get merged quicker.
