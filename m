Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E38165E82
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBTNQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:16:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727931AbgBTNQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ru3ADtcHYP8MfN/oIVe5nGPDlqA+ClJ+343y1IgOloY=;
        b=CSck3AKETPRi+rIlgust7ZVO+ImhQAT8qP4QFovK2zrcRgBT5xmmY19+ROetim4nhJzvpR
        eV697Mg5X/tWObbzDzaesNEh8/vi4ICqTCzPiS7OkfM9WrKvv4WMvL0AYbOD18C+2lBuuQ
        bjH6yL443mmL7UlvWE2/1sH3da2Wp6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-RcZlOOoRPWG_gnpP3lfEWQ-1; Thu, 20 Feb 2020 08:16:45 -0500
X-MC-Unique: RcZlOOoRPWG_gnpP3lfEWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D202C1005510;
        Thu, 20 Feb 2020 13:16:41 +0000 (UTC)
Received: from [10.3.116.180] (ovpn-116-180.phx2.redhat.com [10.3.116.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1755B8B570;
        Thu, 20 Feb 2020 13:16:28 +0000 (UTC)
Subject: Re: [PATCH v3 02/20] hw: Remove unnecessary cast when calling
 dma_memory_read()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-block@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        John Snow <jsnow@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-3-philmd@redhat.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <68120807-6f6b-1602-8208-fd76d64e74bc@redhat.com>
Date:   Thu, 20 Feb 2020 07:16:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220130548.29974-3-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/20 7:05 AM, Philippe Mathieu-Daud=C3=A9 wrote:
> Since its introduction in commit d86a77f8abb, dma_memory_read()
> always accepted void pointer argument. Remove the unnecessary
> casts.
>=20
> This commit was produced with the included Coccinelle script
> scripts/coccinelle/exec_rw_const.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>   scripts/coccinelle/exec_rw_const.cocci | 15 +++++++++++++++
>   hw/arm/smmu-common.c                   |  3 +--
>   hw/arm/smmuv3.c                        | 10 ++++------
>   hw/sd/sdhci.c                          | 15 +++++----------
>   4 files changed, 25 insertions(+), 18 deletions(-)
>   create mode 100644 scripts/coccinelle/exec_rw_const.cocci
>=20
> diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinell=
e/exec_rw_const.cocci
> new file mode 100644
> index 0000000000..a0054f009d
> --- /dev/null
> +++ b/scripts/coccinelle/exec_rw_const.cocci
> @@ -0,0 +1,15 @@
> +// Usage:
> +//  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . --=
in-place

This command line should also use '--macro-file=20
scripts/cocci-macro-file.h' to cover more of the code base (Coccinelle=20
skips portions of the code that uses macros it doesn't recognize).


> @@ -726,13 +724,10 @@ static void get_adma_description(SDHCIState *s, A=
DMADescr *dscr)
>           }
>           break;
>       case SDHC_CTRL_ADMA2_64:
> -        dma_memory_read(s->dma_as, entry_addr,
> -                        (uint8_t *)(&dscr->attr), 1);
> -        dma_memory_read(s->dma_as, entry_addr + 2,
> -                        (uint8_t *)(&dscr->length), 2);
> +        dma_memory_read(s->dma_as, entry_addr, (&dscr->attr), 1);
> +        dma_memory_read(s->dma_as, entry_addr + 2, (&dscr->length), 2)=
;

The () around &dscr->length are now pointless.

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

