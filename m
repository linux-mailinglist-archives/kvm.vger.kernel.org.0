Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B943C52CC2E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 08:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbiESGsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiESGsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 02:48:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B73150049;
        Wed, 18 May 2022 23:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xVNgLNspLSR5Zdl3y2dXwcEBrzDQ/5UKA9hIbWaD6p8=; b=OK5oxehFsQh/LcIiP98mvU1qO2
        ozZuJXF3hyQwN72+zLrsBNTfp9RlauKjgJrWRA4E0THsZuC3t9qpVIMF54cqrdRvcFWf2OplSA2Q1
        DcuXnyVmqcZuuRcYtJF7PCKqwilMsyg40AZqGeTEPvyiSjLKFZPhJqjwmWivF3bbBxagNf1tyYaTN
        9rQ57e/MmHy+vJJpJc5LRTC80LM7PVYQSUm2AX+Fhoq6IPWdJ7X+m9UovLRVLSLQBT9A5wrRdqV6f
        c5QVWX8k+pM00LSq8eJz0pN3wyOz/PueU5OUErC3uZC0TTrHIJfhrCktGbZ+pKseBSoTNBUqQPmyb
        pHLEj4/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrZxH-005MH9-5n; Thu, 19 May 2022 06:48:15 +0000
Date:   Wed, 18 May 2022 23:48:15 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <YoXoL2tt06sEz9Rd@infradead.org>
References: <20220518212607.467538-1-mjrosato@linux.ibm.com>
 <20220518212607.467538-2-mjrosato@linux.ibm.com>
 <BN9PR11MB527684F9BD1B906B930E4A468CD09@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527684F9BD1B906B930E4A468CD09@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Thu, May 19, 2022 at 06:43:06AM +0000, Tian, Kevin wrote:
> > This fixes a user-triggerable oops in GVT.
> 
> No changelog.

??

the cover latter clearly states what has changed since v1, and this
patch has a good commit log.  This is exactly how it is supposed to
be done.

> 
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> Not sure whether Christoph wants a s-o-b here when he wrote
> the snippet to remove the release work of gvt...

That's just tivial code removal, so no.

> 
> > @@ -1083,11 +1083,22 @@ static struct file *vfio_device_open(struct
> > vfio_device *device)
> > 
> >  	mutex_lock(&device->dev_set->lock);
> >  	device->open_count++;
> > +	down_read(&device->group->group_rwsem);
> > +	if (device->open_count == 1 && device->group->kvm) {
> > +		/*
> > +		 * Here we pass the KVM pointer with the group under the
> > read
> > +		 * lock.  If the device driver will use it, it must obtain a
> > +		 * reference and release it during close_device.
> > +		 */
> > +		device->kvm = device->group->kvm;
> > +	}
> > +
> >  	if (device->open_count == 1 && device->ops->open_device) {
> 
> Merge the two branches so both are under if (device->open_count == 1) {}
> (and group_rwsem can be also moved inside)

Yeah.  And we don't really need the device->group->kvm check, as
it would otherwise assign NULL which is perfectly fine.

But otherwise this also looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
