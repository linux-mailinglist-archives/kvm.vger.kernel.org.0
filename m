Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA047BD805
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411843AbfIYF76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411840AbfIYF76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:59:58 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FC0D46288
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:59:57 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id q10so1729078wro.22
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=2rWQStlWupt/Z24TTL6lXMY4phw4PsYAZ9Oo/jibkfw=;
        b=Bqv3DRsq/aslJoWTCg5Jr4fK3ebeng7qblJct0N0uXI0PHdj8hVXvvNz9+IryFtJgZ
         T/xdpnUe+7u+7wA6G0UE12UA0HZMt514AC7NMV5JSaSgC9d9nJPWoPlRVmJVb9pWbsu9
         xhXKEoh2pEKuzv6WNQFtBpi7ZaQuAlG3+5XNtgnwzkR/Oe9gTJFK9+rTcYTiPx5lYzGZ
         qHksg5DwkDWjI64bkB9hjfF9Ui40Onx1nwU3/6b3hWOFelxIxWWhvjQuveuu9DdaUo6u
         2pL1bTMGvQWd9uuHnZU90V5TKAFzB1k1dt0JHySbcuN0fdfvTrqAZRQCu6qMWag2mip1
         ccCA==
X-Gm-Message-State: APjAAAVbNwCmW3jCDcoxFhKRcGULmsa451ddyeUEtEX+ezeseJOz0JEp
        2PaXPMESrfuYS0kACy67JK4mDaSndq5yVeXnLLZGAQ6hhWgTmadhkGsUB2LWfsjewKMqEKYjS+x
        PGXZoTLlvnFoZ
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr5292528wmh.105.1569391195506;
        Tue, 24 Sep 2019 22:59:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYsg3NHkzxXtluX8/5dWZw8dizHFTfjE4iL5oJt5hPO61FZNhNsb/+TrfEACW6zW6l6rhI7A==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr5292506wmh.105.1569391195327;
        Tue, 24 Sep 2019 22:59:55 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id z142sm5548158wmc.24.2019.09.24.22.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:59:54 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-9-slp@redhat.com> <20190924092435-mutt-send-email-mst@kernel.org>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
In-reply-to: <20190924092435-mutt-send-email-mst@kernel.org>
Date:   Wed, 25 Sep 2019 07:59:52 +0200
Message-ID: <87muessyp3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Michael S. Tsirkin <mst@redhat.com> writes:

> On Tue, Sep 24, 2019 at 02:44:33PM +0200, Sergio Lopez wrote:
>> +static void microvm_fix_kernel_cmdline(MachineState *machine)
>> +{
>> +    X86MachineState *x86ms = X86_MACHINE(machine);
>> +    BusState *bus;
>> +    BusChild *kid;
>> +    char *cmdline;
>> +
>> +    /*
>> +     * Find MMIO transports with attached devices, and add them to the kernel
>> +     * command line.
>> +     *
>> +     * Yes, this is a hack, but one that heavily improves the UX without
>> +     * introducing any significant issues.
>> +     */
>> +    cmdline = g_strdup(machine->kernel_cmdline);
>> +    bus = sysbus_get_default();
>> +    QTAILQ_FOREACH(kid, &bus->children, sibling) {
>> +        DeviceState *dev = kid->child;
>> +        ObjectClass *class = object_get_class(OBJECT(dev));
>> +
>> +        if (class == object_class_by_name(TYPE_VIRTIO_MMIO)) {
>> +            VirtIOMMIOProxy *mmio = VIRTIO_MMIO(OBJECT(dev));
>> +            VirtioBusState *mmio_virtio_bus = &mmio->bus;
>> +            BusState *mmio_bus = &mmio_virtio_bus->parent_obj;
>> +
>> +            if (!QTAILQ_EMPTY(&mmio_bus->children)) {
>> +                gchar *mmio_cmdline = microvm_get_mmio_cmdline(mmio_bus->name);
>> +                if (mmio_cmdline) {
>> +                    char *newcmd = g_strjoin(NULL, cmdline, mmio_cmdline, NULL);
>> +                    g_free(mmio_cmdline);
>> +                    g_free(cmdline);
>> +                    cmdline = newcmd;
>> +                }
>> +            }
>> +        }
>> +    }
>> +
>> +    fw_cfg_modify_i32(x86ms->fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(cmdline) + 1);
>> +    fw_cfg_modify_string(x86ms->fw_cfg, FW_CFG_CMDLINE_DATA, cmdline);
>> +}
>
> Can we rearrange this somewhat? Maybe the mmio constructor
> would format the device description and add to some list,
> and then microvm would just get stuff from that list
> and add it to kernel command line?
> This way it can also be controlled by a virtio-mmio property, so
> e.g. you can disable it per device if you like.
> In particular, this seems like a handy trick for any machine type
> using mmio.

Disabling it per-device won't be easy, as transport options can't be
specified using the underlying device properties.

But, otherwise, sounds like a good idea to avoid having to traverse the
qtree. I'll give it a try.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LAlgACgkQ9GknjS8M
AjUhcA//eFnLyXm4bKxsytJSS/e8bSAYiTJvcfXB3XqLuCJaYyyIbrwu6B0Pxhaa
b8INN/koJiPKPwvfLtbUm8vf0Rwq4oDfEPpfd0xZ4+hf3RzpzUFAiqz6OP8gTtgf
fWmwU6/07gYOLUcUuokwI+7FZpN55BYnkA2cer3Qx5kw1jkvq8TO6C1SDVbC8o4H
eTSb8SHVZeoysvn9CLnjZxXXKuP/SWHrHUtj2BIS8ThQyn17mB5BVdU9d/ym2AxK
ygEU6DN7Rc6lZxVkqXW2kVloe4o+5KRU0zNxp8Zxr6U/6af0U61lvMFQLb7PrSW2
Yd/VSoEmiR2MqCMt8QPo1CqYaU1QBRvz4h7JFp0ynxPJbWDpLCdC4vKNWM/7+7gC
R/KR3SLOD7/uIabyxpMPZCZB34K0noiI6Go0eU/J+4gkOGLkAbHoBJTRqvnGgwi9
TdB2j5lEllJwzABTJo21mR5KvRfGuPsVss9TfBRj8w0OHt7tMEb4ATGq/7WiqmVU
eLfQr9LngtFMIseXcgc1uXyIMyVxWyQUVxJj7KqxdXylrOL7djiRoq+++CD1RSGc
Wx/IS6Vqg66lvMPjLpBHPBbdzzmMoxBjEk0lpgDuFlLyeRYINvohQEbDjuOC/iTj
rRvhwLDvGd/F+S3Es5PHy/PT10SXNKzmMYogvhtLxWByjcAdCwc=
=00LM
-----END PGP SIGNATURE-----
--=-=-=--
