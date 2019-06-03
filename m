Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8432E6B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 13:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfFCLQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 07:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfFCLQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 07:16:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE889776C6;
        Mon,  3 Jun 2019 11:16:46 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A93F2619C4;
        Mon,  3 Jun 2019 11:16:44 +0000 (UTC)
Date:   Mon, 3 Jun 2019 13:16:41 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/7] vfio-ccw: fixes
Message-ID: <20190603131641.4ad411f0.cohuck@redhat.com>
In-Reply-To: <20190603111124.GB20699@osiris>
References: <20190603105038.11788-1-cohuck@redhat.com>
        <20190603111124.GB20699@osiris>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 03 Jun 2019 11:16:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jun 2019 13:11:24 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Jun 03, 2019 at 12:50:31PM +0200, Cornelia Huck wrote:
> > The following changes since commit 674459be116955e025d6a5e6142e2d500103de8e:
> > 
> >   MAINTAINERS: add Vasily Gorbik and Christian Borntraeger for s390 (2019-05-31 10:14:15 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190603
> > 
> > for you to fetch changes up to 9b6e57e5a51696171de990b3c41bd53d4b8ab8ac:
> > 
> >   s390/cio: Remove vfio-ccw checks of command codes (2019-06-03 12:02:55 +0200)
> > 
> > ----------------------------------------------------------------
> > various vfio-ccw fixes (ccw translation, state machine)
> > 
> > ----------------------------------------------------------------
> > 
> > Eric Farman (7):
> >   s390/cio: Update SCSW if it points to the end of the chain
> >   s390/cio: Set vfio-ccw FSM state before ioeventfd
> >   s390/cio: Split pfn_array_alloc_pin into pieces
> >   s390/cio: Initialize the host addresses in pfn_array
> >   s390/cio: Don't pin vfio pages for empty transfers
> >   s390/cio: Allow zero-length CCWs in vfio-ccw
> >   s390/cio: Remove vfio-ccw checks of command codes  
> 
> Given that none of the commits contains a stable tag, I assume it's ok
> to schedule these for the next merge window (aka 'feature branch')?

All are bug fixes, but for what I think are edge cases. Would be nice
if they could still make it into 5.2, but I have no real problem with
deferring them to the next release, either.

Eric, Farhan: Do you agree?
