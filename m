Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90399221150
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 17:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgGOPjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 11:39:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48709 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbgGOPjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 11:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594827551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AO3HELiSeq5hjugDpVSW9pgmdZmoWY4N39MiwsHMrNM=;
        b=ZxrN3szdR5z7U6B9NgXex6pPR978j6RV5HFkRTJs4HjePBqJkz4WbeNy9cmUtbbU08bbCn
        Rw3o5mQ+wYhldQK21TbrecoQbYVEmpm9AQUAGEDsixHRUBySTe7QXy842XCrgb+pvAiXQV
        xYerKDNaJF5694q0w1nCxZ+6pNX561E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-hP_TMfRsOQyEv04NHJMHcw-1; Wed, 15 Jul 2020 11:39:04 -0400
X-MC-Unique: hP_TMfRsOQyEv04NHJMHcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B65E9800EB6;
        Wed, 15 Jul 2020 15:39:02 +0000 (UTC)
Received: from localhost (ovpn-115-22.ams2.redhat.com [10.36.115.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD7005D9CA;
        Wed, 15 Jul 2020 15:38:56 +0000 (UTC)
Date:   Wed, 15 Jul 2020 16:38:55 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Nikos Dragazis <ndragazis@arrikto.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200715153855.GA47883@stefanha-x1.localdomain>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 01:28:07PM +0200, Jan Kiszka wrote:
> On 15.07.20 13:23, Stefan Hajnoczi wrote:
> > Let's have a call to figure out:
> > 
> > 1. What is unique about these approaches and how do they overlap?
> > 2. Can we focus development and code review efforts to get something
> >    merged sooner?
> > 
> > Jan and Nikos: do you have time to join on Monday, 20th of July at 15:00
> > UTC?
> > https://www.timeanddate.com/worldclock/fixedtime.html?iso=20200720T1500
> > 
> 
> Not at that slot, but one hour earlier or later would work for me (so far).

Nikos: Please let us know which of Jan's timeslots works best for you.

Thanks,
Stefan

