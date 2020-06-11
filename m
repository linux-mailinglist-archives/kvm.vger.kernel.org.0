Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB91F5F50
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 02:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgFKAuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 20:50:39 -0400
Received: from ozlabs.org ([203.11.71.1]:55187 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgFKAui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 20:50:38 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49j4yz4Tdrz9sSF; Thu, 11 Jun 2020 10:50:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1591836635; bh=4AXGR2xvTWr5HjYhNZKDfLSGIdikACQ9DW5GKrfqUMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XyeU4s964pg2uiKZppdhYqRnDaUx1RfsPnmy4sCCL8bJJRqEbSEUMPVp1v9sMHH30
         cDqVzJUBz3xN37RDe201x6eH6Xd+BcXxO5GGdqFnJcld4Ca8tTIkvEs9Z3P5PWN+2z
         +I/ntZ3dbUfuluLIxDAYgpchFUzLVHDu6x/gRUow6k+6nzayv8G4t6D1ACw5+XZypW
         TUbjC9RYKJiU0vR/L/5xvlFsldub4XQOnurWwWhruCKMDyahSl/Gh6OI1lEeJwpVmK
         2mmJLwwFTcn/jdwpv6UqxsZUhGsXg6q/l/O7w6TPCtgrJ8DcC4sG0MVyuQbOIxueQN
         2HhHsj5pw+EfQ==
Date:   Thu, 11 Jun 2020 10:48:07 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.8-1 tag
Message-ID: <20200611004807.GA2414929@thinks.paulus.ozlabs.org>
References: <20200601235357.GB428673@thinks.paulus.ozlabs.org>
 <87d0e310-8714-0104-90ef-d4f82920f502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0e310-8714-0104-90ef-d4f82920f502@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 08:58:06PM +0200, Paolo Bonzini wrote:
> On 02/06/20 01:53, Paul Mackerras wrote:
> > Hi Paolo,
> > 
> > Please do a pull from my kvm-ppc-next-5.8-1 tag to get a PPC KVM
> > update for 5.8.  It's a relatively small update this time.  Michael
> > Ellerman also has some commits in his tree that touch
> > arch/powerpc/kvm, but I have not merged them here because there are no
> > merge conflicts, and so they can go to Linus via Michael's tree.
...
> 
> Pulled, thanks.
> 
> Paolo

Thanks.

Are you planning to send Linus another pull request for this merge
window, with this stuff in it?

Regards,
Paul.
