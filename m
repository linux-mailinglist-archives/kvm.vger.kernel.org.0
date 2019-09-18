Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E9AB60F2
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfIRKA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 06:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfIRKA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 06:00:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D03010DCC8E;
        Wed, 18 Sep 2019 10:00:58 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E2BD5C21E;
        Wed, 18 Sep 2019 10:00:54 +0000 (UTC)
Date:   Wed, 18 Sep 2019 12:00:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, libvir-list@redhat.com,
        kvm <kvm@vger.kernel.org>
Subject: Re: Call for volunteers: LWN.net articles about KVM Forum talks
Message-ID: <20190918120052.6120f8d8.cohuck@redhat.com>
In-Reply-To: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
References: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 18 Sep 2019 10:00:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Sep 2019 14:02:59 +0100
Stefan Hajnoczi <stefanha@gmail.com> wrote:

> Hi,
> LWN.net is a popular open source news site that covers Linux and other
> open source communities (Python, GNOME, Debian, etc).  It has published
> a few KVM articles in the past too.
> 
> Let's raise awareness of QEMU, KVM, and libvirt by submitting articles covering
> KVM Forum.

Great idea!

> 
> I am looking for ~5 volunteers who are attending KVM Forum to write an article
> about a talk they find interesting.
> 
> Please pick a talk you'd like to cover and reply to this email thread.
> I will then send an email to LWN with a heads-up so they can let us know
> if they are interested in publishing a KVM Forum special.  I will not
> ask LWN.net for money.
> 
> KVM Forum schedule:
> https://events.linuxfoundation.org/events/kvm-forum-2019/program/schedule/

I think it might make sense to cover "Managing Matryoshkas: Testing
Nested Guests" (Marc Hartmayer) and "Nesting&testing" (Vitaly
Kuznetsov) in one article, and I volunteer for that.
> 
> LWN.net guidelines:
> https://lwn.net/op/AuthorGuide.lwn
> "Our general guideline is for articles to be around 1500 words in
> length, though somewhat longer or shorter can work too. The best
> articles cover a fairly narrow topic completely, without any big
> omissions or any extra padding."
> 
> I volunteer to cover Michael Tsirkin's "VirtIO without the Virt -
> Towards Implementations in Hardware" talk.
> 
> Thanks,
> Stefan

