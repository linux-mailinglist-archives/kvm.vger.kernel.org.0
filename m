Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41413459E1
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 12:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfFNKDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 06:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfFNKDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 06:03:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40AE18830A;
        Fri, 14 Jun 2019 10:03:24 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55E17608A4;
        Fri, 14 Jun 2019 10:03:23 +0000 (UTC)
Date:   Fri, 14 Jun 2019 12:03:21 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/9] s390: vfio-ccw code rework
Message-ID: <20190614120321.1c662472.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 14 Jun 2019 10:03:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:22 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Now that we've gotten a lot of other series either merged or
> pending for the next merge window, I'd like to revisit some
> code simplification that I started many moons ago.
> 
> In that first series, a couple of fixes got merged into 4.20,
> a couple more got some "seems okay" acks/reviews, and the rest
> were nearly forgotten about.  I dusted them off and did quite a
> bit of rework to make things a little more sequential and
> providing a better narrative (I think) based on the lessons we
> learned in my earlier changes.  Because of this rework, the
> acks/reviews on the first version didn't really translate to the
> code that exists here (patch 1 being the closest exception), so
> I didn't apply any of them here.  The end result is mostly the
> same as before, but now looks like this:
> 
> Patch summary:
> 1:   Squash duplicate code
> 2-4: Remove duplicate code in CCW processor
> 5-7: Remove one layer of nested arrays
> 8-9: Combine direct/indirect addressing CCW processors
> 
> Using 5.2.0-rc3 as a base plus the vfio-ccw branch of recent fixes,
> we shrink the code quite a bit (8.7% according to the bloat-o-meter),
> and we remove one set of mallocs/frees on the I/O path by removing
> one layer of the nested arrays.  There are no functional/behavioral
> changes with this series; all the tests that I would run previously
> continue to pass/fail as they today.

Very nice cleanup!

All the patches look good to me; I'll wait if anyone else has any
comments and will probably pick them next week if nobody objects.
