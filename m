Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BD231F954
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhBSMT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhBSMT4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 07:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613737109;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u7HT95kkWTHrCt+Iv/CYRhOhkzd75rYC+HIZYMaBL0w=;
        b=XRli+cy8a84OZv7lFiTrl1Nss2cL2f9hzBRUK/PbagRXIdURu5vc+IQCxiO7+9YIDvTthB
        cJxM4ilIvfhKXGJp+5vQdPvSIU2RssAGVdFyWCCDXf3Qwf01RaPHkPEDRH5b2Swf1sX94g
        NFCxU0qCzQiZH7o+df3/KE+kMMGfta8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-F-2IZ9plOnqioXOAJ81nqg-1; Fri, 19 Feb 2021 07:18:26 -0500
X-MC-Unique: F-2IZ9plOnqioXOAJ81nqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EA278030B7;
        Fri, 19 Feb 2021 12:18:23 +0000 (UTC)
Received: from redhat.com (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2547560BE5;
        Fri, 19 Feb 2021 12:18:11 +0000 (UTC)
Date:   Fri, 19 Feb 2021 12:18:09 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
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
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
Message-ID: <YC+sgaN1EyKeyyOQ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <YC+oZWDs3PnWHPQo@redhat.com>
 <9540912b-1a81-1fd2-4710-2b81d5e69c5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9540912b-1a81-1fd2-4710-2b81d5e69c5f@redhat.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 01:15:25PM +0100, Philippe Mathieu-Daudé wrote:
> On 2/19/21 1:00 PM, Daniel P. Berrangé wrote:
> > On Fri, Feb 19, 2021 at 12:44:21PM +0100, Philippe Mathieu-Daudé wrote:
> >> Hi,
> >>
> >> This series aims to improve user experience by providing
> >> a better error message when the user tries to enable KVM
> >> on machines not supporting it.
> > 
> > Improved error message is good, but it is better if the mgmt apps knows
> > not to try this in the first place.
> 
> I am not sure this is the same problem. This series addresses
> users from the command line (without mgmt app).

Users of mgmt apps can launch the same problematic raspbi + KVM config
as people who  don't use a mgmt app.

> > IOW, I think we want "query-machines" to filter out machines
> > which are not available with the currently configured accelerator.
> > 
> > libvirt will probe separately with both TCG and KVM enabled, so if
> > query-machines can give the right answer in these cases, libvirt
> > will probably "just work" and not offer to even start such a VM.
> 
> Yes, agreed. There are other discussions about 'query-machines'
> and an eventual 'query-accels'. This series doesn't aim to fix
> the mgmt app problems.

I think this should be fixing query-machines right now. It shouldn't
be much harder than a single if (...) test in the code.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

