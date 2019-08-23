Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48EF9B246
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390533AbfHWOkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 10:40:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389691AbfHWOkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 10:40:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8663C309175F;
        Fri, 23 Aug 2019 14:40:14 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 515BE5F9D2;
        Fri, 23 Aug 2019 14:40:13 +0000 (UTC)
Date:   Fri, 23 Aug 2019 08:40:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>
Subject: Re: [PATCH kernel] vfio/spapr_tce: Fix incorrect tce_iommu_group
 memory free
Message-ID: <20190823084012.202ba70f@x1.home>
In-Reply-To: <20190823053241.hogc44em2ccwdwq4@oak.ozlabs.ibm.com>
References: <20190819015117.94878-1-aik@ozlabs.ru>
        <20190823053241.hogc44em2ccwdwq4@oak.ozlabs.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 23 Aug 2019 14:40:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Aug 2019 15:32:41 +1000
Paul Mackerras <paulus@ozlabs.org> wrote:

> On Mon, Aug 19, 2019 at 11:51:17AM +1000, Alexey Kardashevskiy wrote:
> > The @tcegrp variable is used in 1) a loop over attached groups
> > 2) it stores a pointer to a newly allocated tce_iommu_group if 1) found
> > nothing. However the error handler does not distinguish how we got there
> > and incorrectly releases memory for a found+incompatible group.
> > 
> > This fixes it by adding another error handling case.
> > 
> > Fixes: 0bd971676e68 ("powerpc/powernv/npu: Add compound IOMMU groups")
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>  
> 
> Good catch.  This is potentially nasty since it is a double free.
> Alex, are you going to take this, or would you prefer it goes via
> Michael Ellerman's tree?
> 
> Reviewed-by: Paul Mackerras <paulus@ozlabs.org>

I can take it, I've got it queued, but was hoping for an ack/review by
you or David.  I'll add the R-b and push it out to my next branch.
Thanks,

Alex
