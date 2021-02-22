Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B275321E4A
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhBVRjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:39:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhBVRjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:39:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614015495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4lA4izgL6BmBHFfoBO0go7fPCtxFMbj7pq95MLNGllc=;
        b=LnFc6ewXYM4QD9GMDLV9UCERGgaDu5QETE3r3gLZ4aaK1JFNJqKlYdzUURtKeFq9Hatv+T
        L4qz7jClJmYYDyfgmlrdqruyINFRGll7k5pkm+pBJGSp47K960S6J9buQHB6dWnnDEUz5q
        GdW6wRyh4rGPv6MvZX/u6nIcTr9tjM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-011n0yg1NUOpvcUU3B4QYw-1; Mon, 22 Feb 2021 12:38:10 -0500
X-MC-Unique: 011n0yg1NUOpvcUU3B4QYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92829195D560;
        Mon, 22 Feb 2021 17:38:06 +0000 (UTC)
Received: from gondolin (ovpn-113-115.ams2.redhat.com [10.36.113.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11BEF5C1BD;
        Mon, 22 Feb 2021 17:37:53 +0000 (UTC)
Date:   Mon, 22 Feb 2021 18:37:51 +0100
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
Subject: Re: [PATCH v2 07/11] hw/s390x: Explicit the s390-ccw-virtio
 machines support TCG and KVM
Message-ID: <20210222183751.0a8f2d2d.cohuck@redhat.com>
In-Reply-To: <20210219173847.2054123-8-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
        <20210219173847.2054123-8-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 18:38:43 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

I'd lose the 'Explicit' in $SUBJECT.


> All s390-ccw-virtio machines support TCG and KVM.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  hw/s390x/s390-virtio-ccw.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 2972b607f36..1f168485066 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -586,6 +586,10 @@ static ram_addr_t s390_fixup_ram_size(ram_addr_t sz)
>      return newsz;
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void ccw_machine_class_init(ObjectClass *oc, void *data)
>  {
>      MachineClass *mc =3D MACHINE_CLASS(oc);
> @@ -612,6 +616,7 @@ static void ccw_machine_class_init(ObjectClass *oc, v=
oid *data)
>      mc->possible_cpu_arch_ids =3D s390_possible_cpu_arch_ids;
>      /* it is overridden with 'host' cpu *in kvm_arch_init* */
>      mc->default_cpu_type =3D S390_CPU_TYPE_NAME("qemu");
> +    mc->valid_accelerators =3D valid_accels;
>      hc->plug =3D s390_machine_device_plug;
>      hc->unplug_request =3D s390_machine_device_unplug_request;
>      nc->nmi_monitor_handler =3D s390_nmi;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

