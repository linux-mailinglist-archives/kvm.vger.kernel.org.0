Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C18C2F60
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 10:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbfJAI4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 04:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33443 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729642AbfJAI4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 04:56:55 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DEF48553A
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 08:56:54 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o188so1100304wmo.5
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 01:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=08Kv1bOCjIPz07pAWnv+ptQSVZepJUeUHGLusc/epn0=;
        b=s0HVjajPHCKPovpM8+NddNGb+dl5P2S5pMsQbXYlHbKnMUeML/bHPnyhFKypoT3snM
         E8+Hy0XHL4mAIixgGkaqCMo9N1z12L9OEMBOpxNfCcNFzBdnRtDoO2AMPumBJysjFg2c
         1ynES05ABEA6JrBvPoc710cAIgjPwklOh/xzD732yPq2V14fDIF24w6CxsaZan9R6qLp
         qFT0RZ5f81aLqAOZ6dtTXCzRI1NfXoVMb1m67LgfCUuFVQot3RUcdZDPzWR699C2G53S
         Zjv+LI/hkizPpVML8xdYfuTYWJiiD7z77UioqTqtbEEingdW2B48EXqs97VPDYB8mMug
         AYUw==
X-Gm-Message-State: APjAAAV+NP2oyvr0YEEtOKplS1QGETex1uxxcY/yTZt1u40NoI6abo+6
        BrOdySDqip3Wk1jNIdYl2cvJu1Zbxr218xVxbJE/nzr6NymgCb72Bh2VfWlj3vu8ujPVtI0oZor
        i+Y0TsVJp+Pw0
X-Received: by 2002:a5d:4742:: with SMTP id o2mr15703358wrs.253.1569920212616;
        Tue, 01 Oct 2019 01:56:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzmhGQ3VOsgnOqme02E7DhmvaTdlwV473fcWPh63GfCMeC7xV7TxoHM7fHXvzwGCok9neGftQ==
X-Received: by 2002:a5d:4742:: with SMTP id o2mr15703339wrs.253.1569920212400;
        Tue, 01 Oct 2019 01:56:52 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id r18sm2438815wme.48.2019.10.01.01.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 01:56:51 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-9-slp@redhat.com> <20190924092435-mutt-send-email-mst@kernel.org> <87muessyp3.fsf@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
In-reply-to: <87muessyp3.fsf@redhat.com>
Date:   Tue, 01 Oct 2019 10:56:48 +0200
Message-ID: <87ftkcu9m7.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Sergio Lopez <slp@redhat.com> writes:

> Michael S. Tsirkin <mst@redhat.com> writes:
>
>> On Tue, Sep 24, 2019 at 02:44:33PM +0200, Sergio Lopez wrote:
>>> +static void microvm_fix_kernel_cmdline(MachineState *machine)
>>> +{
>>> +    X86MachineState *x86ms = X86_MACHINE(machine);
>>> +    BusState *bus;
>>> +    BusChild *kid;
>>> +    char *cmdline;
>>> +
>>> +    /*
>>> +     * Find MMIO transports with attached devices, and add them to the kernel
>>> +     * command line.
>>> +     *
>>> +     * Yes, this is a hack, but one that heavily improves the UX without
>>> +     * introducing any significant issues.
>>> +     */
>>> +    cmdline = g_strdup(machine->kernel_cmdline);
>>> +    bus = sysbus_get_default();
>>> +    QTAILQ_FOREACH(kid, &bus->children, sibling) {
>>> +        DeviceState *dev = kid->child;
>>> +        ObjectClass *class = object_get_class(OBJECT(dev));
>>> +
>>> +        if (class == object_class_by_name(TYPE_VIRTIO_MMIO)) {
>>> +            VirtIOMMIOProxy *mmio = VIRTIO_MMIO(OBJECT(dev));
>>> +            VirtioBusState *mmio_virtio_bus = &mmio->bus;
>>> +            BusState *mmio_bus = &mmio_virtio_bus->parent_obj;
>>> +
>>> +            if (!QTAILQ_EMPTY(&mmio_bus->children)) {
>>> +                gchar *mmio_cmdline = microvm_get_mmio_cmdline(mmio_bus->name);
>>> +                if (mmio_cmdline) {
>>> +                    char *newcmd = g_strjoin(NULL, cmdline, mmio_cmdline, NULL);
>>> +                    g_free(mmio_cmdline);
>>> +                    g_free(cmdline);
>>> +                    cmdline = newcmd;
>>> +                }
>>> +            }
>>> +        }
>>> +    }
>>> +
>>> +    fw_cfg_modify_i32(x86ms->fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(cmdline) + 1);
>>> +    fw_cfg_modify_string(x86ms->fw_cfg, FW_CFG_CMDLINE_DATA, cmdline);
>>> +}
>>
>> Can we rearrange this somewhat? Maybe the mmio constructor
>> would format the device description and add to some list,
>> and then microvm would just get stuff from that list
>> and add it to kernel command line?
>> This way it can also be controlled by a virtio-mmio property, so
>> e.g. you can disable it per device if you like.
>> In particular, this seems like a handy trick for any machine type
>> using mmio.
>
> Disabling it per-device won't be easy, as transport options can't be
> specified using the underlying device properties.
>
> But, otherwise, sounds like a good idea to avoid having to traverse the
> qtree. I'll give it a try.

Hi Michael,

I'm working on this, but can't find an easy way to obtain the actual IRQ
number with the data I have access on virtio_mmio_realizefn(). I there a
way to do that without building a new access interface? If it isn't,
knowing this is an specific hack for microvm, is it really worth
building it or can we just keep it as is in v4?

Thanks,
Sergio.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2TFNAACgkQ9GknjS8M
AjUncQ/8CriN+0QG5xd4pPYgM1rF5i3eKBx7mfLtektAPRhIwfKINHkL71KFIK/3
oexZzUm4xYMfHxzJvHSBSgpEGtoBs85ycVG3AQ+6/GvfB/VEB6Zt89toMCBwcTI4
UqTfOm+lXv9pp8W/Hx5iqZd2Psi+QD+P7xHQuaPjM3mgP3M8TYmXQwjjrcrAx5Ao
p3Xodw34TV/GK7BVzViuwzSFPOM06BbC5lliZ6lScrmlneOlu9vge6bZ/+/ZxG9z
AWZvzH2zGja/AgJDHquF968jIjnGv8k+TbAfIMm+TEIrNYuRy1ciDqN6Lq1Tbjh/
70T6YJ7lCZHkKa9bRuawxEIknew36VtJU6YpfbEp7PDTH+0H8fCVNS6r0rRGlguS
Oo+B1m9sHKJANNlyiEMUmAmJpbBz7nLVm1n61ATDn3MVINp4SvugEBzrVtWVY/Fe
75wGLeUv/J0t4bsZsrOnxNxJB1cGH4np4VWypiSQ1/tR+9q9bQP4TYsmYceGod5t
IBpzAvaMeYAdyThLr5OD5DeGKeVXEFxVq2Rud/4kTu8bGl5W+wDwknGnkJI60OFH
/iLUljHmSBcbr9D201aoC5cdOBdF/YmD+hGl5nnaZjL/BVb1MC6SBbnw6UimZxfI
hP9SIA5McmKxiamJ++GMICRUAqtmBKfh0viD67MGy7shr302YGY=
=qWwG
-----END PGP SIGNATURE-----
--=-=-=--
