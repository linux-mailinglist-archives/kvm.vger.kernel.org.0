Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AC61FC66B
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 08:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgFQGvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 02:51:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:43236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgFQGvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 02:51:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9127EAC5E;
        Wed, 17 Jun 2020 06:51:20 +0000 (UTC)
Date:   Wed, 17 Jun 2020 08:51:15 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com, cai@lca.pw
Subject: Re: [PATCH] vfio/pci: Clear error and request eventfd ctx after
 releasing
Message-ID: <20200617065115.ccaawd5ehap6pqfq@beryllium.lan>
References: <159234276956.31057.6902954364435481688.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159234276956.31057.6902954364435481688.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Tue, Jun 16, 2020 at 03:26:36PM -0600, Alex Williamson wrote:
> The next use of the device will generate an underflow from the
> stale reference.
> 
> Cc: Qian Cai <cai@lca.pw>
> Fixes: 1518ac272e78 ("vfio/pci: fix memory leaks of eventfd ctx")
> Reported-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Thanks for the quick fix. I gave it a try and the warning is gone.

Tested-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel

