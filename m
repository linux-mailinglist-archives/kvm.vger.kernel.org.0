Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36F659AB1
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfF1MWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 08:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbfF1MW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 08:22:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DBB7811A9;
        Fri, 28 Jun 2019 12:22:22 +0000 (UTC)
Received: from amt.cnet (ovpn-112-9.gru2.redhat.com [10.97.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C6F95D9CA;
        Fri, 28 Jun 2019 12:22:22 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 7998610517E;
        Thu, 27 Jun 2019 15:09:08 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5RI94SM027978;
        Thu, 27 Jun 2019 15:09:04 -0300
Date:   Thu, 27 Jun 2019 15:08:59 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'Radim Krcmar'" <rkrcmar@redhat.com>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Wanpeng Li'" <kernellwp@gmail.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Raslan KarimAllah'" <karahmed@amazon.de>,
        "'Boris Ostrovsky'" <boris.ostrovsky@oracle.com>,
        "'Ankur Arora'" <ankur.a.arora@oracle.com>,
        "'Christian Borntraeger'" <borntraeger@de.ibm.com>,
        linux-pm@vger.kernel.org, "'kvm-devel'" <kvm@vger.kernel.org>
Subject: Re: [patch 3/5] cpuidle: add haltpoll governor
Message-ID: <20190627180856.GA27865@amt.cnet>
References: <20190613224532.949768676@redhat.com>
 <20190613225023.011025297@redhat.com>
 <002e01d527c9$23be6e10$6b3b4a30$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01d527c9$23be6e10$6b3b4a30$@net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 28 Jun 2019 12:22:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 05:34:46PM -0700, Doug Smythies wrote:
> Hi,
> 
> I tried your patch set, but only to check
> that they didn't cause any regression for situations
> where idle state 0 (Poll) is used a lot (teo governor).
> 
> They didn't (my testing was not thorough).
> 
> I do not know if the below matters or not.
> 
> On 2019.06.13 15:46 Marcelo Tosatti wrote:
> 
> ... [snip] ...
> 
> > Index: linux-2.6.git/Documentation/virtual/guest-halt-polling.txt
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.git/Documentation/virtual/guest-halt-polling.txt	2019-06-13 18:16:22.414262777 -0400
> > @@ -0,0 +1,79 @@
> > +Guest halt polling
> > +==================
> > +
> > +The cpuidle_haltpoll driver, with the haltpoll governor, allows
> > +the guest vcpus to poll for a specified amount of time before
> > +halting.
> > +This provides the following benefits to host side polling:
> > +
> > +	1) The POLL flag is set while polling is performed, which allows
> > +	   a remote vCPU to avoid sending an IPI (and the associated
> > + 	   cost of handling the IPI) when performing a wakeup.
>    ^
>    |_ While applying the patches, git complains about this space character before the TAB.
> 
> It also complains about a few patches with a blank line before EOF.
> 
> ... Doug

Hi Doug,

Will fix those, thanks.

