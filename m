Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91AF429FEA
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhJLIdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234522AbhJLIdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:33:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2D7560E74;
        Tue, 12 Oct 2021 08:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634027497;
        bh=gZuIn9M0bCAfXL8Xvy+qDNNBFponfdLBlmdIeQcbVTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZky99hnTz0+mm43CuKNqT1QJB72h+RdfUJxjaCOCaIA8Xhuot/+sR5x72RGTPGmm
         etgB4BpjlfYTSFfFoJbdbXjeSGtwPYwO7pokE/zRtJ4YR2XKb6itF/aiulkqUxNmoz
         t/efRTSpVn2tWMYXtt1GmoyEhEHpt1TGfP2IKzDXeGKcPJuvM3z0LVlCQF0dhcMnO4
         6ABXCgRQX5MeqfajD71jJfgd6zKyTDZi769HsdCDtP0ASizUbAuNK1ng/h+YOUFhjn
         stPC/HSE1SJskM/I4IitfnvsydluFG86IrXWA3nwWQAtnxDWHlfXOYvhVj5eoK+rP5
         S388B0iAhJLcw==
Date:   Tue, 12 Oct 2021 09:31:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 0/7] vfio/pci: Fix MSIX table and PBA size
 allocation
Message-ID: <20211012083133.GB5156@willie-the-truck>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Mon, Sep 13, 2021 at 04:44:06PM +0100, Alexandru Elisei wrote:
> This series is meant to rework the way the MSIX table and PBA are allocated
> to prevent situations where the size allocated by kvmtool is larger than
> the size of the BAR that holds them.
> 
> Patches 1-3 are fixes for stuff I found when I was investing a bug
> triggered by the incorrect sizing of the table and PBA.
> 
> Patch 4 is a preparatory patch.
> 
> Patch 5 is the proper fix. More details in the commit message.
> 
> Patch 6 is there to make it easier to catch such errors if the code
> regresses.
> 
> Patch 7 is an optimization for guests with larger page sizes than the host.

Please can you post a version of this with Andre's tags/comments addressed
so that I can pick it up?

Thanks!

Will
