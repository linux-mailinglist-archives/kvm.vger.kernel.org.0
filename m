Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160C940B51A
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhINQoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229975AbhINQoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32437610A6;
        Tue, 14 Sep 2021 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631637778;
        bh=1wIid1GWYYDJRk4B5EvkgvC53Qon11JjbEFV0N5VjJs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CnA1MDjvY30m3+AvGHVXgYJ4xMipP36WxUxNERnBAC5APzX/VRn9FeCmV4N4apDY8
         iQelVlYqQV01SoKdspBWC3259gorEkulQ4aIdA4fch55pw6actv3jeN9+GImh99KHV
         rOiajUDstHS3rQYNtNyN6XqpaGLCTR1036GEtZj+vhioZBaBKKmLP9jd3tzQigDFCh
         wkqDsGUh43hydcsrtsJe7Mm+YSw9qsI2iouS28goF0F4He1emcNDbdR8wf5URKC79w
         y8HhBZS9xTvb8lXWNphXLBP0wwcLPlf7eq4yCsRqNZL9QqEGkAJsKW8CVy9QeSKFM1
         sW2N8cCEINNWw==
Message-ID: <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE
 all pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
Date:   Tue, 14 Sep 2021 19:42:56 +0300
In-Reply-To: <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210914071030.GA28797@yangzhon-Virtual>
         <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 12:19 +0200, Paolo Bonzini wrote:
> On 14/09/21 09:10, Yang Zhong wrote:
> > On Mon, Sep 13, 2021 at 09:11:51AM -0400, Paolo Bonzini wrote:
> > > Based on discussions from the previous week(end), this series impleme=
nts
> > > a ioctl that performs EREMOVE on all pages mapped by a /dev/sgx_vepc
> > > file descriptor.  Other possibilities, such as closing and reopening
> > > the device, are racy.
> > >=20
> > > The patches are untested, but I am posting them because they are simp=
le
> > > and so that Yang Zhong can try using them in QEMU.
> > >=20
> >=20
> >    Paolo, i re-implemented one reset patch in the Qemu side to call thi=
s ioctl(),
> >    and did some tests on Windows and Linux guest, the Windows/Linux gue=
st reboot
> >    work well.
> >=20
> >    So, it is time for me to send this reset patch to Qemu community? or=
 wait for
> >    this kernel patchset merged? thanks!
>=20
> Let's wait for this patch to be accepted first.  I'll wait a little more=
=20
> for Jarkko and Dave to comment on this, and include your "Tested-by".
>=20
> I will also add cond_resched() on the final submission.

Why these would be conflicting tasks? I.e. why could not QEMU use
what is available now and move forward using better mechanism, when
they are available?

BTW, I do all my SGX testing ATM in QEMU (for some weeks). IMHO, it's
already "good enough" for many tasks, even if this fallback case is
not perfectly sorted out.

/Jarkko
