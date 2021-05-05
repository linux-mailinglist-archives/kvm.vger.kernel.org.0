Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529D13734C0
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 07:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhEEFo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 01:44:56 -0400
Received: from verein.lst.de ([213.95.11.211]:41590 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhEEFo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 01:44:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 837E268AFE; Wed,  5 May 2021 07:43:57 +0200 (CEST)
Date:   Wed, 5 May 2021 07:43:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, groug@kaod.org, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        qemu-devel@nongnu.org, linuxppc-dev@lists.ozlabs.org,
        qemu-ppc@nongnu.org
Subject: Re: [PATCH] vfio/pci: Revert nvlink removal uAPI breakage
Message-ID: <20210505054357.GA12728@lst.de>
References: <162014341432.3807030.11054087109120670135.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162014341432.3807030.11054087109120670135.stgit@omen>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
