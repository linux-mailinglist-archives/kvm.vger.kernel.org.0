Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12D421BA63
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGJQLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:11:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726496AbgGJQLF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 12:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594397464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WRdRX06OBfTzPGHNG+U6NKjLgvHWpzwYgjehUMy8e0=;
        b=AON+ubUW9s7QcASXBhJh2E0NLtcdgz2R/ZFK756Bs1AqEVJ9Mcs2VYzr4VvnGFXXmaXIs6
        QE3f3GNb1LUy9TMKZTlvPzz1rfvZlEhaFXyp/HRcsoUERsBI4LtO3Oh/nu2Fu3lWlXHUPA
        CNUPDNqoLEWYNRNm8icqnKh1EFrdReM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-hD_JHk6iMOeXnTRYh98IeQ-1; Fri, 10 Jul 2020 12:10:40 -0400
X-MC-Unique: hD_JHk6iMOeXnTRYh98IeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DB9919057A7;
        Fri, 10 Jul 2020 16:10:39 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFC1171676;
        Fri, 10 Jul 2020 16:10:34 +0000 (UTC)
Date:   Fri, 10 Jul 2020 10:10:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        herbert@gondor.apana.org.au, cohuck@redhat.com, nhorman@redhat.com,
        vdronov@redhat.com, bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] vfio/pci: add qat devices to blocklist
Message-ID: <20200710101034.5a8c1be5@x1.home>
In-Reply-To: <20200710154433.GA62583@bjorn-Precision-5520>
References: <20200710153742.GA61966@bjorn-Precision-5520>
        <20200710154433.GA62583@bjorn-Precision-5520>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jul 2020 10:44:33 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> On Fri, Jul 10, 2020 at 10:37:45AM -0500, Bjorn Helgaas wrote:
> > On Fri, Jul 10, 2020 at 04:08:19PM +0100, Giovanni Cabiddu wrote: =20
> > > On Wed, Jul 01, 2020 at 04:28:12PM -0500, Bjorn Helgaas wrote: =20
> > > > On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote: =
=20
> > > > > The current generation of Intel=C2=AE QuickAssist Technology devi=
ces
> > > > > are not designed to run in an untrusted environment because of the
> > > > > following issues reported in the release notes in
> > > > > https://01.org/intel-quickassist-technology: =20
> > > >=20
> > > > It would be nice if this link were directly clickable, e.g., if the=
re
> > > > were no trailing ":" or something.
> > > >=20
> > > > And it would be even better if it went to a specific doc that
> > > > described these issues.  I assume these are errata, and it's not ea=
sy
> > > > to figure out which doc mentions them. =20
> > > Sure. I will fix the commit message in the next revision and point to=
 the
> > > actual document:
> > > https://01.org/sites/default/files/downloads/336211-015-qatsoftwarefo=
rlinux-rn-hwv1.7-final.pdf =20
> >=20
> > Since URLs tend to go stale, please also include the Intel document
> > number and title. =20
>=20
> Oh, and is "01.org" really the right place for that?  It looks like an
> Intel document, so I'd expect it to be somewhere on intel.com.
>=20
> I'm still a little confused.  That doc seems to be about *software*
> and Linux software in particular.  But when you said these "devices
> are not designed to run in an untrusted environment", I thought you
> meant there was some *hardware* design issue that caused a problem.

There seems to be a fair bit of hardware errata in the doc too, see:

3.1.2 QATE-7495 - GEN - An incorrectly formatted request to Intel=C2=AE QAT=
 can
hang the entire Intel=C2=AE QAT Endpoint

3.1.9 QATE-39220 - GEN - QAT API submissions with bad addresses that
trigger DMA to invalid or unmapped addresses can cause a platform
hang

3.1.17 QATE-52389 - SR-IOV -Huge pages may not be compatible with QAT
VF usage

3.1.19 QATE-60953 - GEN =E2=80=93 Intel=C2=AE QAT API submissions with bad =
addresses
that trigger DMA to invalid or unmapped addresses can impact QAT
service availability

Thanks,
Alex

