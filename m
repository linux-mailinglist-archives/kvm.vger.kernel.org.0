Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C842009BB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 15:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgFSNQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 09:16:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56089 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728606AbgFSNQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 09:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=baDBAe02KQ36Q6NWRcq2fodzKUQjQGzUg0rUSF7F5Mg=;
        b=SFEDMHr42UyAJ7nSTgABBo+R08pRB2qqsDeWi4vTa320sORwiGiBQJeBMuThDcSF02SBg2
        lvuPqCwTE0sHygTUjzgD1Rd/s4EjOKu3ykvnFLlscSp9/xbFwU0KyV9Vm6W1h0QRT56yUN
        p/D2WNKC6kEthH5zYGrzXXFRQ9ROJNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-d7BrEqVdPhyY9OQtvkrZ6A-1; Fri, 19 Jun 2020 09:16:19 -0400
X-MC-Unique: d7BrEqVdPhyY9OQtvkrZ6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B58A51005512;
        Fri, 19 Jun 2020 13:16:18 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C8485D9CA;
        Fri, 19 Jun 2020 13:16:18 +0000 (UTC)
Date:   Fri, 19 Jun 2020 07:16:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: Re: [PATCH] vfio: Cleanup allowed driver naming
Message-ID: <20200619071617.25e46824@x1.home>
In-Reply-To: <20200619071802.GA28304@infradead.org>
References: <159251018108.23973.14170848139642305203.stgit@gimli.home>
        <20200619071802.GA28304@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 00:18:02 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jun 18, 2020 at 01:57:18PM -0600, Alex Williamson wrote:
> > No functional change, avoid non-inclusive naming schemes.  
> 
> Adding a bunch of overly long lines that don't change anything are
> everything but an improvement.

In fact, 3 of 5 code change lines are shorter, the other two are 3
characters longer each and arguably more descriptive.  One line does now
exceed 80 columns, though checkpatch no longer cares.  I'll send a v2
with that line wrapped.  Thanks,

Alex

