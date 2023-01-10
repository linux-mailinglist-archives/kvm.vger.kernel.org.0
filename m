Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C969F6644C3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbjAJP2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239021AbjAJP1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:27:44 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230188E99D;
        Tue, 10 Jan 2023 07:27:26 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EB9D268AFE; Tue, 10 Jan 2023 16:27:22 +0100 (CET)
Date:   Tue, 10 Jan 2023 16:27:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/4] vfio-mdev: allow building the samples into the
 kernel
Message-ID: <20230110152722.GB9485@lst.de>
References: <20230110091009.474427-1-hch@lst.de> <20230110091009.474427-2-hch@lst.de> <b317380e-26bf-b478-4aea-0355e0de4017@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b317380e-26bf-b478-4aea-0355e0de4017@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 09:54:51AM -0500, Anthony Krowiak wrote:
>> +	tristate "Build VFIO mtty example mediated device sample code"
>> +	depends on VFIO_MDEV
>
>
> Admittedly, I'm not very fluent with Kconfig, but in patch 2 you stated, 
> "VFIO_MDEV is just a library with helpers for the drivers. Stop making it a 
> user choice and just select it by the drivers that use the helpers". Why 
> are you not selecting it here?

Because this changes one thing at a time.  Patch 2 then switches this
depends to a select.
