Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC2321E33
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhBVRgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:36:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230083AbhBVRgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614015277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWsN624cEMx0QkfAoPhColDm3XkV4SngFq4vEfyfRY4=;
        b=bWkzt97m1DB9/hBj6zfigU1dvkOvR1bTKfxSJJhcpmCREKXzsM6fZZtCbqh2FbkupmySle
        N3ViGfX5YrEzTurh/daVebfvRPNTD64RTFw4chm2LvxZq8XxMbqEEAa0WLxFm8Qnj8NSRD
        a7wDteQs4Vr0lWxnpy8I9gGfeHj+WrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-vQd1LyseM5qTcpsZxvKmjQ-1; Mon, 22 Feb 2021 12:34:33 -0500
X-MC-Unique: vQd1LyseM5qTcpsZxvKmjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E7AB1850233;
        Mon, 22 Feb 2021 17:34:10 +0000 (UTC)
Received: from gondolin (ovpn-113-115.ams2.redhat.com [10.36.113.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30F26E2CE;
        Mon, 22 Feb 2021 17:34:03 +0000 (UTC)
Date:   Mon, 22 Feb 2021 18:34:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>
Subject: Re: [PATCH v2 02/11] hw/boards: Introduce
 machine_class_valid_for_accelerator()
Message-ID: <20210222183400.0c151d46.cohuck@redhat.com>
In-Reply-To: <20210219173847.2054123-3-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
        <20210219173847.2054123-3-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 18:38:38 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> Introduce the valid_accelerators[] field to express the list
> of valid accelators a machine can use, and add the
> machine_class_valid_for_current_accelerator() and
> machine_class_valid_for_accelerator() methods.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  include/hw/boards.h | 24 ++++++++++++++++++++++++
>  hw/core/machine.c   | 26 ++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
>=20
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 68d3d10f6b0..4d08bc12093 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -36,6 +36,24 @@ void machine_set_cpu_numa_node(MachineState *machine,
>                                 const CpuInstanceProperties *props,
>                                 Error **errp);
> =20
> +/**
> + * machine_class_valid_for_accelerator:
> + * @mc: the machine class
> + * @acc_name: accelerator name
> + *
> + * Returns %true if the accelerator is valid for the machine, %false
> + * otherwise. See #MachineClass.valid_accelerators.

Naming confusion: is the machine class valid for the accelerator, or
the accelerator valid for the machine class? Or either? :)

> + */
> +bool machine_class_valid_for_accelerator(MachineClass *mc, const char *a=
cc_name);
> +/**
> + * machine_class_valid_for_current_accelerator:
> + * @mc: the machine class
> + *
> + * Returns %true if the accelerator is valid for the current machine,
> + * %false otherwise. See #MachineClass.valid_accelerators.

Same here: current accelerator vs. current machine.

> + */
> +bool machine_class_valid_for_current_accelerator(MachineClass *mc);
> +
>  void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char=
 *type);
>  /*
>   * Checks that backend isn't used, preps it for exclusive usage and
> @@ -125,6 +143,11 @@ typedef struct {
>   *    should instead use "unimplemented-device" for all memory ranges wh=
ere
>   *    the guest will attempt to probe for a device that QEMU doesn't
>   *    implement and a stub device is required.
> + * @valid_accelerators:
> + *    If this machine supports a specific set of virtualization accelera=
tors,
> + *    this contains a NULL-terminated list of the accelerators that can =
be
> + *    used. If this field is not set, any accelerator is valid. The QTest
> + *    accelerator is always valid.
>   * @kvm_type:
>   *    Return the type of KVM corresponding to the kvm-type string option=
 or
>   *    computed based on other criteria such as the host kernel capabilit=
ies
> @@ -166,6 +189,7 @@ struct MachineClass {
>      const char *alias;
>      const char *desc;
>      const char *deprecation_reason;
> +    const char *const *valid_accelerators;
> =20
>      void (*init)(MachineState *state);
>      void (*reset)(MachineState *state);
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 970046f4388..c42d8e382b1 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -518,6 +518,32 @@ static void machine_set_nvdimm_persistence(Object *o=
bj, const char *value,
>      nvdimms_state->persistence_string =3D g_strdup(value);
>  }
> =20
> +bool machine_class_valid_for_accelerator(MachineClass *mc, const char *a=
cc_name)
> +{
> +    const char *const *name =3D mc->valid_accelerators;
> +
> +    if (!name) {
> +        return true;
> +    }
> +    if (strcmp(acc_name, "qtest") =3D=3D 0) {
> +        return true;
> +    }
> +
> +    for (unsigned i =3D 0; name[i]; i++) {
> +        if (strcasecmp(acc_name, name[i]) =3D=3D 0) {
> +            return true;
> +        }
> +    }
> +    return false;
> +}
> +
> +bool machine_class_valid_for_current_accelerator(MachineClass *mc)
> +{
> +    AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
> +
> +    return machine_class_valid_for_accelerator(mc, ac->name);
> +}

The implementation of the function tests for the current accelerator,
so I think you need to tweak the description above?

> +
>  void machine_class_allow_dynamic_sysbus_dev(MachineClass *mc, const char=
 *type)
>  {
>      QAPI_LIST_PREPEND(mc->allowed_dynamic_sysbus_devices, g_strdup(type)=
);

