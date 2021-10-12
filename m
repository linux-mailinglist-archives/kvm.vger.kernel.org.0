Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6746A42A29F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 12:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhJLKvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 06:51:20 -0400
Received: from foss.arm.com ([217.140.110.172]:34740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236018AbhJLKvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 06:51:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EBA4101E;
        Tue, 12 Oct 2021 03:49:03 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27EBA3F694;
        Tue, 12 Oct 2021 03:49:02 -0700 (PDT)
Date:   Tue, 12 Oct 2021 11:50:35 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 0/7] vfio/pci: Fix MSIX table and PBA size
 allocation
Message-ID: <YWVoZqki4l+d0gdv@monolith.localdoman>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
 <20211012083133.GB5156@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012083133.GB5156@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Tue, Oct 12, 2021 at 09:31:33AM +0100, Will Deacon wrote:
> Hi Alex,
> 
> On Mon, Sep 13, 2021 at 04:44:06PM +0100, Alexandru Elisei wrote:
> > This series is meant to rework the way the MSIX table and PBA are allocated
> > to prevent situations where the size allocated by kvmtool is larger than
> > the size of the BAR that holds them.
> > 
> > Patches 1-3 are fixes for stuff I found when I was investing a bug
> > triggered by the incorrect sizing of the table and PBA.
> > 
> > Patch 4 is a preparatory patch.
> > 
> > Patch 5 is the proper fix. More details in the commit message.
> > 
> > Patch 6 is there to make it easier to catch such errors if the code
> > regresses.
> > 
> > Patch 7 is an optimization for guests with larger page sizes than the host.
> 
> Please can you post a version of this with Andre's tags/comments addressed
> so that I can pick it up?

Working on it, will post as soon as I can.

Thanks,
Alex

> 
> Thanks!
> 
> Will
