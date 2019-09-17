Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D2BB4F84
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfIQNlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 09:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfIQNlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 09:41:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B58206C2;
        Tue, 17 Sep 2019 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568727704;
        bh=oa/4nOZwscX7fJECfu6ZfsIgFP/r3y0PiE+DkpJMf4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKCKOSrzPROvnoLTu9U0VkMsJditMQViVCuWSw5uwon/EAQQHv46HALMuc6S/HBRy
         +ZIaAfsnRu5rBTpdFxWI1dD9okrqMrl0kC3alUpJrhlvyQvBoHjnFcA/OXpRcq9jrv
         fUt/taO3GGD87XwxGzQtXGjfv7Lyx5SlXVkv2C3Q=
Date:   Tue, 17 Sep 2019 15:41:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Harvey <jamespharvey20@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, Alex Willamson <alex.williamson@redhat.com>
Subject: Re: 5.2.11+ Regression: > nproc/2 lockups during initramfs
Message-ID: <20190917134142.GA864903@kroah.com>
References: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
 <20190910183255.GB11151@linux.intel.com>
 <CA+X5Wn4ngf92GEU=9fuxL1FVfPtq9tJE5D5VMBq6gGp5pd4Nkw@mail.gmail.com>
 <f897f18b-9a98-abeb-9caf-cfdca7e66124@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f897f18b-9a98-abeb-9caf-cfdca7e66124@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 03:36:00PM +0200, Paolo Bonzini wrote:
> On 12/09/19 09:59, James Harvey wrote:
> > Yes, confirmed reverting this commit (to restore the originally
> > reverted commit) fixes the issue.
> > 
> > I'm really surprised to have not found similar reports, especially of
> > Arch users which had 5.2.11 put into the repos on Aug 29.  Makes me
> > wonder if it's reproducible on all hardware using host hyperthreading
> > and giving a VM > nproc/2 virtual cpus.
> > 
> > In the meantime, what should go into distro decisions on whether to
> > revert?  Since you mentioned: "Reverting the revert isn't a viable
> > solution."
> 
> Hi James,
> 
> the fix (which turned out to be livelock) is now part of 5.3.  You
> should expect it sometime soon in 5.2 stable kernels.
> 
>     commit 002c5f73c508f7df5681bda339831c27f3c1aef4
>     KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot

Will be in the next 5.2-stable release in a few days.

thanks,

greg k-h
