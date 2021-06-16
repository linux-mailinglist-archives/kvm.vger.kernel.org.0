Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF333A9DF8
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhFPOqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 10:46:22 -0400
Received: from verein.lst.de ([213.95.11.211]:54723 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233854AbhFPOqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 10:46:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0534867357; Wed, 16 Jun 2021 16:44:14 +0200 (CEST)
Date:   Wed, 16 Jun 2021 16:44:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Auger Eric <eric.auger@redhat.com>,
        jean-philippe <jean-philippe@linaro.org>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH] iommu: add domain->nested
Message-ID: <20210616144413.GA2593@lst.de>
References: <1623854282-26121-1-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623854282-26121-1-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 10:38:02PM +0800, Zhangfei Gao wrote:
> +++ b/include/linux/iommu.h
> @@ -87,6 +87,7 @@ struct iommu_domain {
>  	void *handler_token;
>  	struct iommu_domain_geometry geometry;
>  	void *iova_cookie;
> +	int nested;

This should probably be a bool : 1;

Also this needs a user, so please just queue up a variant of this for
the code that eventually relies on this information.
