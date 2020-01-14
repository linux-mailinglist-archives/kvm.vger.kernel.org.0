Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83567139F4A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 03:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgANCCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 21:02:32 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33950 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgANCCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 21:02:31 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so8493483lfc.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 18:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wUZSPSo0jt960buXgMC7KYm3AgJo4uzvA53Zew/Py5Q=;
        b=J0CWiR4RfUBEtaiY+wnwC0FHHmZ47a8ntwx3gMaRqap2PHYZWw43nZ7+I2tAerRtM3
         6jeyoaZwoS7bsoBMuSOviZyLV/Jgja1civsWdB5w6EWruAONPpe2MZliTNTbJ/3J6pEa
         ocvpegu6AGHuLT3pMi0K9m+OFtmJ6Wu9BP6cj+o9X7EiUJpBfNBzwJqivZsfCiSIAY34
         zy7NygsFLlI9qmRFgQZSdcs/iFiKSPMLXJRMHX19jrRx4qKDeIF2prWW3p0M3dZKeQsV
         qXFEf2CTXrX7J1LdEyiykv3IDQ8a+sh02m4PCxIkhnIVj+LLDeNLeS9DwYQWI5oPQ43n
         yICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wUZSPSo0jt960buXgMC7KYm3AgJo4uzvA53Zew/Py5Q=;
        b=eSwOZCPf9WMpOzlHaSar7W/gc2JsgL8DTTJLlJn6UmYZdZTehplcpl9CDQ5bBqEGZi
         pbvOtWS4nVABLjZ4NWFK6n7RUmNvoWPC/cdBEkIlmDT3/Frmu+uOI6abSEO8HQDhvH1V
         dPRs8BGPGJeCDSf92NnqYBa6VrRw34fqkG3S/yCQ9pg8VV1nABOqVqzmOMx+6KekNBX7
         STILC2XbvAvzup3zUs4K9vyoNCFcpTCJzj1R3X+7RrqXbXOZkg8/+Be5OnUNerdsGDvP
         uOERY8XY7gLJ75idhd0HbRoKa9pBoAI/WRdrJD9zX3oapL0w3rhjBzA5hkETRMf+zIkc
         xUMA==
X-Gm-Message-State: APjAAAUELftWOgMdHJJtdT47+H7x92pxYHnM/UcuBWfYiteT380PbqIw
        3baDbBsVzuIYab3r91qKp8EwpPRPOeRDhFjxsl8=
X-Google-Smtp-Source: APXvYqyouBD1xiebvS2Zk4hXxg76VrTocGGq5YSmQpO/+jvM/ul9CzMiHyzODVOre5V8qAlauIiAdI9HwiaH0r7qC9o=
X-Received: by 2002:a19:e30b:: with SMTP id a11mr249814lfh.48.1578967349135;
 Mon, 13 Jan 2020 18:02:29 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-11-philmd@redhat.com>
 <CAKmqyKNrgTbiipNK1wrwCMqk_=7cJmc4rBwO1zxjFiVV+TRSgQ@mail.gmail.com> <f7e3539a-4506-0df1-ee66-f3d8a6aa8fce@redhat.com>
In-Reply-To: <f7e3539a-4506-0df1-ee66-f3d8a6aa8fce@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 14 Jan 2020 12:02:02 +1000
Message-ID: <CAKmqyKNxNE0nCODQp37T4eKcq+0cDTCpW9SJkbby+q6Q99vg7g@mail.gmail.com>
Subject: Re: [PATCH 10/15] memory: Replace current_machine by qdev_get_machine()
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

On Sun, Jan 12, 2020 at 11:45 PM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> On 1/12/20 10:48 AM, Alistair Francis wrote:
> > On Thu, Jan 9, 2020 at 11:29 PM Philippe Mathieu-Daud=C3=A9
> > <philmd@redhat.com> wrote:
> >>
> >> As we want to remove the global current_machine,
> >> replace 'current_machine' by MACHINE(qdev_get_machine()).
> >>
> >> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> >> ---
> >>   memory.c | 4 +++-
> >>   1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/memory.c b/memory.c
> >> index d7b9bb6951..57e38b1f50 100644
> >> --- a/memory.c
> >> +++ b/memory.c
> >> @@ -3004,6 +3004,7 @@ static void mtree_print_flatview(gpointer key, g=
pointer value,
> >>       int n =3D view->nr;
> >>       int i;
> >>       AddressSpace *as;
> >> +    MachineState *ms;
> >>
> >>       qemu_printf("FlatView #%d\n", fvi->counter);
> >>       ++fvi->counter;
> >> @@ -3026,6 +3027,7 @@ static void mtree_print_flatview(gpointer key, g=
pointer value,
> >>           return;
> >>       }
> >>
> >> +    ms =3D MACHINE(qdev_get_machine());
> >
> > Why not set this at the top?
>
> Calling qdev_get_machine() is not free as it does some introspection
> checks. Since we can return earlier if there are no rendered FlatView, I
> placed the machinestate initialization just before it we need to access i=
t.

Works for me, maybe worth putting this in the commit?

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

>
> > Alistair
> >
> >>       while (n--) {
> >>           mr =3D range->mr;
> >>           if (range->offset_in_region) {
> >> @@ -3057,7 +3059,7 @@ static void mtree_print_flatview(gpointer key, g=
pointer value,
> >>           if (fvi->ac) {
> >>               for (i =3D 0; i < fv_address_spaces->len; ++i) {
> >>                   as =3D g_array_index(fv_address_spaces, AddressSpace=
*, i);
> >> -                if (fvi->ac->has_memory(current_machine, as,
> >> +                if (fvi->ac->has_memory(ms, as,
> >>                                           int128_get64(range->addr.sta=
rt),
> >>                                           MR_SIZE(range->addr.size) + =
1)) {
> >>                       qemu_printf(" %s", fvi->ac->name);
> >> --
> >> 2.21.1
> >>
> >>
> >
>
