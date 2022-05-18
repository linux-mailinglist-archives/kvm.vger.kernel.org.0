Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2C052B411
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 09:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiERHj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 03:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiERHjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 03:39:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9C0106A47;
        Wed, 18 May 2022 00:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P5UqBAHM0WQnE0g9GWkUw6qeNdkfJBe6hJymXR6R360=; b=zP2u3zx4Nqx82fjyBoNHLz6AOY
        fHpXQJ24sWyjJtbHiAfCUHkKqWlu+/N5+S0QbL3dxp8min4ZnwWiMdlFcvfoW1l3rHL6lvSU8JyPu
        tI3TV57NNnj4Bq/keqxZOTeeF9+9ZA4sWjS7BtUPWhT9DC+xFJLcsYPpuaji0p2/Oxwir7jvsuX/U
        y9dpkmCJOjq2ER5XK5/faIeJxiQU9bZ+mnUsplo/ChCMm+unL1KWLS94bBjJDlzxjHqeD1l6dxzdJ
        VudQgLy9jb8GOsrg3Fazw16gK5iNYGZFgwlNxo8CYGkPD+FAuZ8uZSZp9jKMhuX8XVLWsUSQokF10
        K34xQl0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrEHV-00084D-Sx; Wed, 18 May 2022 07:39:41 +0000
Date:   Wed, 18 May 2022 00:39:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <YoSivTU7nivO9FMD@infradead.org>
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
 <20220517185643.GY1343366@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517185643.GY1343366@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  	if (device->ops->flags & VFIO_DEVICE_NEEDS_KVM)
>  	{

Nit: this is not the normal brace placement.

But what is you diff against anyway?  The one Matthew sent did away
with the VFIO_DEVICE_NEEDS_KVM flags, which does the wrong thing for
zpci, so it can't be that..

Also if we want to do major code movement, it really needs to go into
a separate patch or patches, as the combinations of all these moves
with actual code changes is almost unreadable.
