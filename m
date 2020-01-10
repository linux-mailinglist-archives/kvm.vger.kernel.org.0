Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA326136A5E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 10:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgAJJ73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 04:59:29 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34282 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgAJJ73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 04:59:29 -0500
Received: by mail-lj1-f193.google.com with SMTP id z22so1525902ljg.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 01:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7JlzPibRcf0IgPM6L/pRPXmRhZqX6hDwJe/LfcYdab8=;
        b=K7Y72Csly7MWqJMzL3CkWbTrMW2/2vhNHffTGbrtgJOr8gPUiGjGjQdP0tTmzV3E0W
         A927SweuQJqAzR2mrjN7uAfYmNhfWOTwNpnxNCla+S+3hAUTSd1bghy3J3Eq+Oj5Tc/t
         dFHrgnGrdy96RqRknK4r6Q+9U1A11UenbliYexZsT/0+Mfpb+4xyhxTpjMzkoSNuxSsI
         iZItbxMB3wNzTmJZBVg5WdFOJrTD67BRpKMjl5DQWe+KYfrC0XnUt0itnkYHzFox2ZJ8
         Rxn8L0arRJ8E4EkbpshAsBDkmctDgCjcyd/XMuk6qEKmIDMx3+2eZ8/473mN98+V/Fla
         8SNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7JlzPibRcf0IgPM6L/pRPXmRhZqX6hDwJe/LfcYdab8=;
        b=S1Z188KNJat5K3p4nder3cHjV1CVeHAk2fQOPxQxR4xEwk1s36JpNOQFnKvKoSOgyK
         v9mide6oFa0QHkkUhSnyfUDPQMBJ/Ex/zIF5uZ4XzV1sIFFIzZWGORZ0vkiPCtEOlZCO
         YljaohSysBCBpPs0fGlppHKU3wpH88gUVcYMWflh9BwPdnbHG7nNSaO59F0at7uoK6d4
         RjOEdRLw5HHHSiX8rkxXSmMe5oIWbbo9FY15QIVgEKQay9HH2skP3SQfRvS1sdPLQ1up
         7jLSd2mV8HiZyqFaLH9I0NmQRIcaJd63QspY7DGEPXOSIyn55tlduFSC55UEOWnxq5e1
         vIjA==
X-Gm-Message-State: APjAAAX1qdjw0DLN+Il+6U9sq/oKNYtVT1zwxg7/7Uujp2gOKBDMzi4H
        3Hif/vQihurjz1fO68SwDsZumXoJAuj2Jc+u0/0=
X-Google-Smtp-Source: APXvYqxzu0M/AnGftTw+RYkbJmDaeTygSU9qN8VejwFvlXKqWRamkOK0VDxcEWbRXKmYV/ncIV+w7yjo5nHIp/WwRtA=
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr2127868lja.16.1578650367261;
 Fri, 10 Jan 2020 01:59:27 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-2-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-2-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Fri, 10 Jan 2020 17:59:00 +0800
Message-ID: <CAKmqyKPe-K5omNe2wJC-vb35YQ2iiH4yJUTDgydDna+7ONnvuw@mail.gmail.com>
Subject: Re: [PATCH 01/15] target/arm/kvm: Use CPUState::kvm_state in kvm_arm_pmu_supported()
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 9, 2020 at 11:22 PM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> KVMState is already accessible via CPUState::kvm_state, use it.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/arm/kvm.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b87b59a02a..8d82889150 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -181,9 +181,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>
>  bool kvm_arm_pmu_supported(CPUState *cpu)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> -
> -    return kvm_check_extension(s, KVM_CAP_ARM_PMU_V3);
> +    return kvm_check_extension(cpu->kvm_state, KVM_CAP_ARM_PMU_V3);
>  }
>
>  int kvm_arm_get_max_vm_ipa_size(MachineState *ms)
> --
> 2.21.1
>
>
