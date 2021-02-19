Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE731F91E
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBSMMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:12:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhBSMM0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 07:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613736659;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45Dm/mZfrJbWzizoN9wLVx4pShqBQ+9iMXBHgbG5TR0=;
        b=VIcFCYwwxZkaEh9FI7T3JH5HW0ogcVtMvS+Wvssi+66HaS5X2mizXEwZV/tQUMLi+YSNql
        fO24TCnW+MG1GPHHSW/G7cPjtW0awyoyfgsENRgbU08yQBXihWkUBOQp0Ck9kesZsXcUaI
        yNBJQ8Jb+oFqz3zQPWLTIfyBBafK4gI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-AFE5aQfpPteMhmzp8Pa9qA-1; Fri, 19 Feb 2021 07:10:43 -0500
X-MC-Unique: AFE5aQfpPteMhmzp8Pa9qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDEB1100A8E9;
        Fri, 19 Feb 2021 12:10:40 +0000 (UTC)
Received: from redhat.com (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 653155C1BB;
        Fri, 19 Feb 2021 12:10:30 +0000 (UTC)
Date:   Fri, 19 Feb 2021 12:10:27 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        kvm-devel <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?utf-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x <qemu-s390x@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH 2/7] hw/boards: Introduce 'kvm_supported' field to
 MachineClass
Message-ID: <YC+qs7R140qAWnJY@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <20210219114428.1936109-3-philmd@redhat.com>
 <YC+nxWnB+eaiq736@redhat.com>
 <CAFEAcA-A=TG43w2yNfrDwCgYYNZBEa25cM_yYgREfQyKa=PZEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-A=TG43w2yNfrDwCgYYNZBEa25cM_yYgREfQyKa=PZEQ@mail.gmail.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 12:08:05PM +0000, Peter Maydell wrote:
> On Fri, 19 Feb 2021 at 11:58, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > Is the behaviour reported really related to KVM specifically, as opposed
> > to all hardware based virt backends ?
> >
> > eg is it actually a case of some machine types being  "tcg_only" ?
> 
> Interesting question. At least for Arm the major items are:
>  * does the accelerator support emulation of EL3/TrustZone?
>    (KVM doesn't; this is the proximate cause of the assertion
>    failure if you try to enable KVM for the raspi boards.)
>  * does the board type require a particular CPU type which
>    KVM doesn't/can't support?
> Non-KVM accelerators could at least in theory have different answers
> to those questions, though in practice I think they do not.
> 
> I think my take is that we probably should mark the boards
> as 'tcg-only' vs 'not-tcg-only', because in practice that's
> the interesting distinction. Specifically, our security policy
> https://qemu.readthedocs.io/en/latest/system/security.html
> draws a boundary between "virtualization use case" and
> "emulated", so it's really helpful to be able to say clearly
> "this board model does not support virtualization, and therefore
> any bugs in it or its devices are simply outside the realm of
> being security issues" when doing analysis of the codebase or
> when writing or reviewing new code.

Oh, yes, that is useful to correlate with.

> If we ever have support for some new accelerator type where there's
> a board type distinction between KVM and that new accelerator and
> it makes sense to try to say "this board is supported by the new
> thing even though it won't work with KVM", the folks interested in
> adding that new accelerator will have the motivation to look
> into exactly which boards they want to enable support for and
> can add a funky_accelerator_supported flag or whatever at that time.
> 
> Summary: we should name this machine class field
> "virtualization_supported" and check it in all the virtualization
> accelerators (kvm, hvf, whpx, xen).

Agreed.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

