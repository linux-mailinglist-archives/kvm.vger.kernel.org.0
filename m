Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8F152689
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgBEHBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:01:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBEHBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CIMLPTOIpIkqW6rCSCB/RZ2YWA0k6ASd16expdYFtQA=; b=gHFWUnHsOh5Qz70a1+BMJe/lh9
        jRQ0lozk6QzxKXJhswoCOd5tJShhYPjcygqGKk7D7DkYLMfohtgHmGHopX+cD2q1tYtz7ebLJWJpK
        nTUJgLVgTuVvcivsOk0E1LA6TlIWtN3ns17g2nu5GBBOkxn+28gPJpnQGrPB1QgX9Rnz4ZSzDd6YP
        Spsn91t1/bPc5MnUEjZpdUXgdLlS3vO9TFNY069WNynKrss490n6VpqeFdwO3721JOOUuOI1yOiH7
        OaPVOqMP6+Gu59g7RkCVSVAMtQVnrAa+HoWIQy8FSlIx9GyIWKwq7lMO5G5WYtYHOd1Kc1xMn/xmn
        9NcaMjyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izEgP-00061P-A1; Wed, 05 Feb 2020 07:01:09 +0000
Date:   Tue, 4 Feb 2020 23:01:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200205070109.GA18027@infradead.org>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 04:05:34PM -0700, Alex Williamson wrote:
> We address this in a few ways in this series.  First, we can use a bus
> notifier and the driver_override facility to make sure VFs are bound
> to the vfio-pci driver by default.  This should eliminate the chance
> that a VF is accidentally bound and used by host drivers.  We don't
> however remove the ability for a host admin to change this override.

That is just such a bad idea.  Using VFs in the host is a perfectly
valid use case that you are breaking.
