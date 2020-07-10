Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4E221B9A7
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGJPhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgGJPhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:37:45 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FFE20725;
        Fri, 10 Jul 2020 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594395464;
        bh=jf8q7n27+kP9L8DDPlNvcNUJRjNvy/mml7kUbzQ89Oo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JE9TsAInvipOp7YWw0VDP1pE0nJXL97yW6rRV3fU0ODrQia3jRnm8KpQbpz65k91g
         BbH3KE2h/e/wJ98jZc4PYwNWUPGw7LidXXtG3Wrob6yOfPNjaRVYwndZ+RolHXKCYo
         UDeh75CK9hmoJvewF+McMQaCMqkfFDhFD7m4zTGs=
Date:   Fri, 10 Jul 2020 10:37:42 -0500
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
Message-ID: <20200710153742.GA61966@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200710150819.GA410874@silpixa00400314>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 04:08:19PM +0100, Giovanni Cabiddu wrote:
> On Wed, Jul 01, 2020 at 04:28:12PM -0500, Bjorn Helgaas wrote:
> > On Wed, Jul 01, 2020 at 12:03:00PM +0100, Giovanni Cabiddu wrote:
> > > The current generation of Intel® QuickAssist Technology devices
> > > are not designed to run in an untrusted environment because of the
> > > following issues reported in the release notes in
> > > https://01.org/intel-quickassist-technology:
> > 
> > It would be nice if this link were directly clickable, e.g., if there
> > were no trailing ":" or something.
> > 
> > And it would be even better if it went to a specific doc that
> > described these issues.  I assume these are errata, and it's not easy
> > to figure out which doc mentions them.
> Sure. I will fix the commit message in the next revision and point to the
> actual document:
> https://01.org/sites/default/files/downloads/336211-015-qatsoftwareforlinux-rn-hwv1.7-final.pdf

Since URLs tend to go stale, please also include the Intel document
number and title.

When you update this, you might also update the subject lines.  It
looks like the VFIO convention is "vfio/pci: <Capitalized> ...",
based on "git log --oneline drivers/vfio/pci/".  And "QAT" should be
capitalized also since it's not a word by itself (and to match usage
in the spec).

Bjorn
