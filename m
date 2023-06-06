Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C553E72406E
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 13:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjFFLE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 07:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbjFFLDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 07:03:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A59B1BC0;
        Tue,  6 Jun 2023 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686049231; x=1717585231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3b3vmHcNenRMEV+YtNGwUxporwj/nTLjEg7K71x0dfQ=;
  b=AcRdxOI+9OebY+UyY0Q/mUlWqU3+9MNwRzRFfYEikRRnqDf6aK6XfxMh
   E161QxvJJ0SmtkHicbucZ1ZOzInRnZjnE+KXu22hZcULNpLyDEgtclyfo
   mBc9rXdRJaQ7/g93RU8Y4CsWsfKPG9HQ4o91lV8LBCMiGP3+x7OgFUTVe
   cMcy+oi1UTGiydlQa0exKeItvuqgnK7q5bLl8gVVAWqY4dSkE/Vg4wfLy
   Z3rWZxx4+M0R/YotpWOMR7AFgoHvKcZ6WmV00zwaivls0I52G/Jhf/Okk
   QaU7uIk9Q6rdjXEhTBZVRy/zyEFYZxhkTnkzXi5VWR1vvyQ2Z4twhPQNV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384944988"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="384944988"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 04:00:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="703119390"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="703119390"
Received: from yuguen-mobl2.ger.corp.intel.com (HELO intel.com) ([10.252.57.68])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 04:00:08 -0700
Date:   Tue, 6 Jun 2023 13:00:02 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Sui Jingfeng <15330273260@189.cn>
Cc:     Sui Jingfeng <suijingfeng@loongson.cn>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Li Yi <liyi@loongson.cn>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        loongson-kernel@lists.loongnix.cn, amd-gfx@lists.freedesktop.org,
        linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 1/2] vgaarb: various coding style and
 comments fix
Message-ID: <ZH8RslOfwIVf527x@ashyti-mobl2.lan>
References: <20230604205831.3357596-1-15330273260@189.cn>
 <ZH5epG6rfTOWT6CS@ashyti-mobl2.lan>
 <f9e67fe9-a93b-75ab-1fdb-87d3783fe5fc@loongson.cn>
 <680cea2e-7984-5f26-c440-46047f4733fa@189.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <680cea2e-7984-5f26-c440-46047f4733fa@189.cn>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sui,

On Tue, Jun 06, 2023 at 06:27:05PM +0800, Sui Jingfeng wrote:
> Hi,
> 
> On 2023/6/6 10:06, Sui Jingfeng wrote:
> > Originally, I also want to express the opinion.
> 
> 
> Originally,  I want to express the same opinion as you told me.
> 
> Because vga_iostate_to_str() function is taking unsigned int parameter.
> 
> so, I think, using 'unsigned int *' type as the third parameter
> vga_str_to_iostate() function is more suitable.
> 
> 
> But this patch is too trivial, so I smash them into one patch.

it does not matter. Please keep patches separated. A trivial
patch can be ignored, however lots of trivial patches in a bigger
series might be appreciated.

Have fun!

Andi
