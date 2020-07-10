Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAAD21B9C0
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJPog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJPog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:44:36 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175E8207BB;
        Fri, 10 Jul 2020 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594395875;
        bh=X8c/R3Qn9kobWNREt9IFObBlN5vW/pJr0E9nZBeLL5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=t+xYKzI/czGn6BDQy40JKkZQWywkgDpu3a4ZCx7PSN6Naq90Jagdi4C8ZH7Loii47
         Eweef2nPyidMPZ1df+5a7t/C9dLXA8B4o0BoaR3nZ/diQVEMu/QF+d1576F6kMKZ4o
         mDqP+fhKj2Y685Ph994PFZ07pdcJh2ogNH3MaIag=
Date:   Fri, 10 Jul 2020 10:44:33 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] vfio/pci: add qat devices to blocklist
Message-ID: <20200710154433.GA62583@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200710153742.GA61966@bjorn-Precision-5520>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 10:37:45AM -0500, Bjorn Helgaas wrote:
> On Fri, Jul 10, 2020 at 04:08:19PM +0100, Giovanni Cabiddu wrote:
> > On Wed, Jul 01, 2020 at 04:28:12PM -0500, Bjorn Helgaas wrote:
> > > On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote:
> > > > The current generation of Intel® QuickAssist Technology devices
> > > > are not designed to run in an untrusted environment because of the
> > > > following issues reported in the release notes in
> > > > https://01.org/intel-quickassist-technology:
> > > 
> > > It would be nice if this link were directly clickable, e.g., if there
> > > were no trailing ":" or something.
> > > 
> > > And it would be even better if it went to a specific doc that
> > > described these issues.  I assume these are errata, and it's not easy
> > > to figure out which doc mentions them.
> > Sure. I will fix the commit message in the next revision and point to the
> > actual document:
> > https://01.org/sites/default/files/downloads/336211-015-qatsoftwareforlinux-rn-hwv1.7-final.pdf
> 
> Since URLs tend to go stale, please also include the Intel document
> number and title.

Oh, and is "01.org" really the right place for that?  It looks like an
Intel document, so I'd expect it to be somewhere on intel.com.

I'm still a little confused.  That doc seems to be about *software*
and Linux software in particular.  But when you said these "devices
are not designed to run in an untrusted environment", I thought you
meant there was some *hardware* design issue that caused a problem.

Bjorn
