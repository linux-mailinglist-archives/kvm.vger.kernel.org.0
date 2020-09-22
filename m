Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D06C274675
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIVQUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgIVQUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 12:20:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF762086A;
        Tue, 22 Sep 2020 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600791630;
        bh=+Ol2f1a6qqykB0WuAVaSfN9rPddftBcmlZmKsY7qEsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ElzeL8r99SINPN1iYglJvtw8zwPXCnWvUa5AZcw0aXgRqrDmb1gYVtvCIGR7TF+aF
         ZUd3hlQkVWYKlP83M46eatNhLakip05MWAozoztNe8HkFHhAT7C2b74f+rUboa6KTu
         oMjdFYMzc5bQYMVaY/i76jH6BWRTHtQrcso7PCVY=
Date:   Tue, 22 Sep 2020 18:20:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v9 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
Message-ID: <20200922162049.GA2299429@kroah.com>
References: <20200911141141.33296-1-andraprs@amazon.com>
 <20200911141141.33296-15-andraprs@amazon.com>
 <20200914155913.GB3525000@kroah.com>
 <c3a33dcf-794c-31ef-ced5-4f87ba21dd28@amazon.com>
 <d7eaac0d-8855-ca83-6b10-ab4f983805a2@amazon.com>
 <358e7470-b841-52fe-0532-e1154ef0e93b@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <358e7470-b841-52fe-0532-e1154ef0e93b@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 05:13:02PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 21/09/2020 15:34, Paraschiv, Andra-Irina wrote:
> > 
> > 
> > On 14/09/2020 20:23, Paraschiv, Andra-Irina wrote:
> > > 
> > > 
> > > On 14/09/2020 18:59, Greg KH wrote:
> > > > On Fri, Sep 11, 2020 at 05:11:37PM +0300, Andra Paraschiv wrote:
> > > > > Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> > > > > Reviewed-by: Alexander Graf <graf@amazon.com>
> > > > I can't take patches without any changelog text at all, sorry.
> > > > 
> > > > Same for a few other patches in this series :(
> > > > 
> > > 
> > > I can move the changelog text before the Sob tag(s) for all the
> > > patches. I also can add a summary phrase in the commit message for
> > > the commits like this one that have only the commit title and Sob &
> > > Rb tags.
> > > 
> > > Would these updates to the commit messages match the expectations?
> > > 
> > > Let me know if remaining feedback to discuss and I should include as
> > > updates in v10. Otherwise, I can send the new revision with the
> > > updated commit messages.
> > > 
> > > Thanks for review.
> > 
> > Here we go, I published v10, including the updated commit messages and
> > rebased on top of v5.9-rc6.
> > 
> > https://lore.kernel.org/lkml/20200921121732.44291-1-andraprs@amazon.com/
> > 
> > Any additional feedback, open to discuss.
> > 
> > If all looks good, we can move forward as we've talked before, to have
> > the patch series on the char-misc branch and target v5.10-rc1.
> 
> Thanks for merging the patch series on the char-misc-testing branch and for
> the review sessions we've had.
> 
> Let's see how all goes next; if anything in the meantime to be done (e.g.
> and not coming via auto-generated mails), just let me know.

Will do, thanks for sticking with this and cleaning it up to look a lot
better than the original submission.

Now comes the real work, maintaining it for the next 10 years :)

greg k-h
