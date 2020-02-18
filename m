Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E84162A03
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgBRQCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:02:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgBRQCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:02:48 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9BE3208C4;
        Tue, 18 Feb 2020 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582041768;
        bh=o4w+569dv1GCGrISoBWEYP5IMjCUbMFmPglubauRSUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sJmwamejBIh3JXI/OSELinawXIDJYC1HxfJRZVLI5ILdnQ7aawHvEqfEt0T0dI05k
         topeyzIoba5rPa/6up/cflILnFesz1plk8Qf7fAGQJDWV8/GXTtQW3Wu9+ag8OoamK
         ShWIVWTZHDliROe7qPK2rjufBVu0wLY1kdMxeWbs=
Date:   Tue, 18 Feb 2020 16:02:42 +0000
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 01/42] mm:gup/writeback: add callbacks for
 inaccessible pages
Message-ID: <20200218160242.GB1133@willie-the-truck>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-2-borntraeger@de.ibm.com>
 <107a8a72-b745-26f2-5805-c4d99ce77b35@redhat.com>
 <dd33cc1a-214d-b949-8f5e-9c2d40a8e518@de.ibm.com>
 <a8f8786e-1ed0-0c44-08d0-ebc58f43ae40@redhat.com>
 <20200218154610.GB27565@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218154610.GB27565@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 07:46:10AM -0800, Sean Christopherson wrote:
> On Tue, Feb 18, 2020 at 09:27:20AM +0100, David Hildenbrand wrote:
> > On 17.02.20 12:10, Christian Borntraeger wrote:
> > > So yes, if everything is setup properly this should not fail in real life
> > > and only we have a kernel (or firmware) bug.
> > > 
> > 
> > Then, without feedback from other possible users, this should be a void
> > function. So either introduce error handling or convert it to a void for
> > now (and add e.g., BUG_ON and a comment inside the s390x implementation).
> 
> My preference would also be for a void function (versus ignoring an int
> return).

The gup code could certainly handle the error value, although the writeback
is a lot less clear (so a BUG_ON() would seem to be sufficient for now).

Will
