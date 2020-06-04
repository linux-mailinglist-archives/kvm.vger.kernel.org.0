Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C261EE874
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgFDQUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:20:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:7979 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgFDQUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 12:20:14 -0400
IronPort-SDR: TJ4g35KO/D5ITUYBk1DtAhh99bai3V5Rvl9E+ThcYAq8U/8SwoErN0ZI/VoP4+oCNZ128sImI+
 KDMg0wodQLYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 09:20:13 -0700
IronPort-SDR: 0STHlrEs9f5V4unbDzgHVn1raqy2xRABHf/PWcn7KiK0SmxBBhUd0TkB/ahsSvElQ21AXW5beg
 3r2QJS0aRH/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="471584291"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jun 2020 09:20:12 -0700
Date:   Thu, 4 Jun 2020 09:20:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, pair@us.ibm.com, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200604162012.GA30456@linux.intel.com>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200529221926.GA3168@linux.intel.com>
 <20200601091618.GC2743@work-vm>
 <20200604031129.GB228651@umbus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604031129.GB228651@umbus.fritz.box>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 01:11:29PM +1000, David Gibson wrote:
> On Mon, Jun 01, 2020 at 10:16:18AM +0100, Dr. David Alan Gilbert wrote:
> > * Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> > > On Thu, May 21, 2020 at 01:42:46PM +1000, David Gibson wrote:
> > > > Note: I'm using the term "guest memory protection" throughout to refer
> > > > to mechanisms like this.  I don't particular like the term, it's both
> > > > long and not really precise.  If someone can think of a succinct way
> > > > of saying "a means of protecting guest memory from a possibly
> > > > compromised hypervisor", I'd be grateful for the suggestion.
> > > 
> > > Many of the features are also going far beyond just protecting memory, so
> > > even the "memory" part feels wrong.  Maybe something like protected-guest
> > > or secure-guest?
> > > 
> > > A little imprecision isn't necessarily a bad thing, e.g. memory-encryption
> > > is quite precise, but also wrong once it encompasses anything beyond plain
> > > old encryption.
> > 
> > The common thread I think is 'untrusted host' - but I don't know of a
> > better way to describe that.
> 
> Hrm..  UntrustedHost? CompromisedHostMitigation? HostTrustMitigation
> (that way it has the same abbreviation as hardware transactional
> memory for extra confusion)?  HypervisorPowerLimitation?

GuestWithTrustIssues?  Then we can shorten it to InsecureGuest and cause all
kinds of confusion :-D.

> HostTrustLimitation? "HTL". That's not too bad, actually, I might go
> with that unless someone suggests something better.

DePrivelegedHost?  "DPH".  The "de-privelege" phrase seems to be another
recurring theme.
