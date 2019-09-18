Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B2B6178
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfIRKai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 06:30:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32799 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbfIRKah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 06:30:37 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68C47C058CA4
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 10:30:37 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id o188so900044wmo.5
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 03:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9UfC779la/3EU3JpqPYe3tcB1zqmfFk+Bxp+Hj5B6OY=;
        b=pBuVeD8vBTA+oifrfqzSVEku/+LXIKdtPhLb18hJPiQxnSqTLLvgwwwLw6f/sgzO7+
         a/7/bdDDJ1KyyGkxvnXCawpZ9EJCLKf3PEQYbugia4yXv+ZMOXNDzHgnVr2FRzZTRYTO
         UpDOTnfIjOLfelsoeKQ0nd5je07StQyGjHUtaW2Gj3r2+kfjj5ZQEfztk5kK/h6XIJB9
         ZqdyvHQhWrwSoWJaPVVrmAzKhLBLSyxyQ4RHOwNcm2pz5Zotok4CsDUJy+7ZY1Cncaiu
         6SSSIq3EnISYq484eVjVvaB8+IO/pod3akmRCEWJJfu3o2LodaUFQgJdcgpugSmd5Z72
         oogQ==
X-Gm-Message-State: APjAAAXEFGyMVczrfBoOxMKQ6aPi2Xm+EsWwfxM2qwTWAGE5HMXdzAA4
        +pwfhxEDE/AE2gIhOIhVLDccl5egFk3dhajRhmme/I6WvIdRdwr0hfim+8WMLcir+y59BkDrpK1
        +YFAJ9Daky1bq
X-Received: by 2002:a5d:4944:: with SMTP id r4mr2553475wrs.283.1568802635983;
        Wed, 18 Sep 2019 03:30:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw6nNBT3XJdjWdxI+pldHhp+0Kn2FngVKGdPW1gl+FwG+4eu3B1aBSJEm2tQynXf2zYNJyzlQ==
X-Received: by 2002:a5d:4944:: with SMTP id r4mr2553458wrs.283.1568802635772;
        Wed, 18 Sep 2019 03:30:35 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id r20sm7410524wrg.61.2019.09.18.03.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 03:30:35 -0700 (PDT)
Date:   Wed, 18 Sep 2019 12:30:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, libvir-list@redhat.com,
        kvm <kvm@vger.kernel.org>
Subject: Re: [libvirt] Call for volunteers: LWN.net articles about KVM Forum
 talks
Message-ID: <20190918103033.upz7q5spfnyhea5z@steredhat>
References: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
 <20190918082825.nnrjqvicqwjg3jq6@steredhat>
 <CAJSP0QXCJY4+5P9zU4670dfwjmKEUagB9gFrqF3H9cCPZPbzbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXCJY4+5P9zU4670dfwjmKEUagB9gFrqF3H9cCPZPbzbA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 11:02:54AM +0100, Stefan Hajnoczi wrote:
> On Wed, Sep 18, 2019 at 9:28 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Tue, Sep 17, 2019 at 02:02:59PM +0100, Stefan Hajnoczi wrote:
> > I volunteer for "Libvirt: Never too Late to Learn New Tricks" by
> > Daniel Berrange.
> 
> Hi Stefano,
> Paolo has already volunteered for that.  Is there another talk you are
> interested in covering?

Hi Stefan,
another talk I'm interested in is "Making the Most of NBD" by Eric Blake &
Richard Jones.

I hope it's not already covered :-)

Cheers,
Stefano
