Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FABF550933
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiFSHnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 03:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiFSHnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 03:43:02 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACD10EA;
        Sun, 19 Jun 2022 00:43:01 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C513967373; Sun, 19 Jun 2022 09:42:57 +0200 (CEST)
Date:   Sun, 19 Jun 2022 09:42:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
Subject: Re: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220619074257.GA27867@lst.de>
References: <20220614045428.278494-1-hch@lst.de> <20220614045428.278494-4-hch@lst.de> <6900fbd9-5f12-e53d-1a57-d9671491372b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6900fbd9-5f12-e53d-1a57-d9671491372b@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 01:25:25AM +0530, Kirti Wankhede wrote:
>> +	parent->mdev_types_kset = kset_create_and_add("mdev_supported_types",
>> +					       NULL, &parent->dev->kobj);
>> +	if (!parent->mdev_types_kset)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < nr_types; i++) {
>> +		ret = mdev_type_add(parent, types[i]);
>> +		if (ret)
>> +			break;
>> +	}
>
> Above code should be in parent_create_sysfs_files(), all sysfs related 
> stuff should be placed in mdev_sysfs.c

Yes, it could. But why?  This is core logic of the interface and has
nothing to do with sysfs.
