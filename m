Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1551C54A8A0
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 07:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiFNFRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 01:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiFNFRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 01:17:30 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D39BDC6;
        Mon, 13 Jun 2022 22:17:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 49D5368AA6; Tue, 14 Jun 2022 07:17:23 +0200 (CEST)
Date:   Tue, 14 Jun 2022 07:17:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v2
Message-ID: <20220614051723.GA30556@lst.de>
References: <20220614045428.278494-1-hch@lst.de> <0e517684-8b10-5410-8ad0-df7caed860b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e517684-8b10-5410-8ad0-df7caed860b7@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 01:03:55PM +0800, Yi Liu wrote:
> Is this series available on any github repo? I'd like to apply your series 
> and apply my vfio_device cdev series on top of it.

I have a git repository available, but nothing on crappy platforms like
github.
