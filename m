Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F093468B8
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhCWTPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:15:23 -0400
Received: from verein.lst.de ([213.95.11.211]:33870 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233223AbhCWTPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:15:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0A22C68BEB; Tue, 23 Mar 2021 20:15:09 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:15:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct
 mdev_device
Message-ID: <20210323191508.GB17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
