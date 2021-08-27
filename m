Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7323F9BAD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245502AbhH0PZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245487AbhH0PZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A97960F91;
        Fri, 27 Aug 2021 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630077865;
        bh=T0LXrf0+Sv8WAaCgOMsOKWo8Vz/pjYKXbzBuzZqmUq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mB3sf5D5PZtcXFuQEEjrtqjZU6C8eIr1+DBhX/uoIWBoQ2DCln9UvCnCs9+v3TPzJ
         iD1S0BYf3/QfTQ+zNjlT7azkmdwUMRhYFKYdoCdAaF5i243fparO1l6p6wYKENi885
         ppBu8eC+oVpFaUtp7tMte9m8zp4uCyz3QjDXN8V4=
Date:   Fri, 27 Aug 2021 17:24:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v2 1/7] nitro_enclaves: Enable Arm64 support
Message-ID: <YSkDounI6wcZP/Dt@kroah.com>
References: <20210827133230.29816-1-andraprs@amazon.com>
 <20210827133230.29816-2-andraprs@amazon.com>
 <YSj15tWpwQ41BFy3@kroah.com>
 <f5b75895-5ba8-7715-9deb-6c003477e334@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b75895-5ba8-7715-9deb-6c003477e334@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 06:02:57PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 27/08/2021 17:25, Greg KH wrote:
> > On Fri, Aug 27, 2021 at 04:32:24PM +0300, Andra Paraschiv wrote:
> > > Update the kernel config to enable the Nitro Enclaves kernel driver for
> > > Arm64 support.
> > > 
> > > Changelog
> > > 
> > > v1 -> v2
> > > 
> > > * No changes.
> > > 
> > changelogs for different all go below the --- line, as is documented.
> > No need for them here in the changelog text itself, right?
> > 
> > Please fix up and send a v3 series.
> 
> Alright, I can modify the patches so that the changelog is after the line.
> 
> I followed the same pattern as the initial time, when I received feedback to
> have the changelogs in the commit message, before SoB(s).

Only the crazy drm developers seem to use that format :)

> But that's fine with me, I can switch to this way of doing it, as mentioned
> also in the docs.

Thank you.

greg k-h
