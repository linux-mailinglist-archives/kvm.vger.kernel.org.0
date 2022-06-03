Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39653C4FF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiFCGgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbiFCGgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:36:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6AF377E8;
        Thu,  2 Jun 2022 23:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0gN/O2qqFG9+DfzkqIoNq9u9eFv5IpvHk8XoCZp1rOE=; b=SQimyw27hv4kngBGdjVQYAKvSg
        WdwqAsaCkNSm2J0BpHUE3DAEdByq2ALQ9dTazgpkWBCGgULTXcPZ0vn+ByxTF87Qqgq+pHvr7z3+R
        fnDfCyPvRZ8B8qYRsqYGTkTKuw01bM/4NK1Mq2gsPKnGrz4flPfCllP219BFFym5T9CHUUXJwY5Fh
        rX8qWTQHTuXD6ZZis7DVRpxwwpPV/EgMPND34wWO2qoInVIJm+ts1G5iEmmT3A3UQ8gdfF262RzCS
        IirmLEDl5vAzHzoyCLXkJCKDMnsRNPZh+FzToaUhm4sSdsygQ3nIfREE/VCpX2BtA0qkaninHbCZF
        aTwXbrfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0ur-0061h9-CZ; Fri, 03 Jun 2022 06:36:13 +0000
Date:   Thu, 2 Jun 2022 23:36:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH v1 13/18] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Message-ID: <Ypmr3TvgHXIfsyBf@infradead.org>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-14-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-14-farman@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:43PM +0200, Eric Farman wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
