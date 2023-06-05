Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C72723304
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 00:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjFEWQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 18:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjFEWQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 18:16:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA3310B;
        Mon,  5 Jun 2023 15:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686003379; x=1717539379;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j6OmYXev5dSof4jSEuXxwO0jYGsXKhESRMOiQiPGbO8=;
  b=mC6TBdQLFdpYDYhvAwVefcc6CubhmVJbtt8JgmfYE7ODIWhMZ99FprbB
   zrkGvmNM8NmdDnsu8yJuSNx1iDJb9oeeXTzBF19RN+SxZAOCGn+JbHU/s
   KwxWALxTO0wcAHJazhztoKJe7bwZrMySWcHpKhqy69VUOPfADaLha2oqo
   +utgT/T1mKQx2UJZ7P5r9+DXmvNJm574ENKJLACdJIYWJv6RDSfrDpvrW
   wKkjEx0+1pb2yHttBGb0hb7i5nnjIP604VpvYRPrYOTPzTU4jf1Rt8Rgr
   1Ow4MHDpYEHuz0kX7yHmBKQ+tkyv3ikRRdY56NEUQc329quCy2F/M5FtZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359812693"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359812693"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 15:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="686267039"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="686267039"
Received: from twgeistx-mobl.ger.corp.intel.com (HELO intel.com) ([10.249.42.176])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 15:16:09 -0700
Date:   Tue, 6 Jun 2023 00:16:04 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Sui Jingfeng <15330273260@189.cn>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
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
        Li Yi <liyi@loongson.cn>,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <ZH5epG6rfTOWT6CS@ashyti-mobl2.lan>
References: <20230604205831.3357596-1-15330273260@189.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604205831.3357596-1-15330273260@189.cn>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sui,

On Mon, Jun 05, 2023 at 04:58:30AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> To keep consistent with vga_iostate_to_str() function, the third argument
> of vga_str_to_iostate() function should be 'unsigned int *'.

I think the real reason is not to keep consistent with
vga_iostate_to_str() but because vga_str_to_iostate() is actually
only taking "unsigned int *" parameters.

> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
> ---
>  drivers/pci/vgaarb.c   | 29 +++++++++++++++--------------
>  include/linux/vgaarb.h |  8 +++-----
>  2 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index 5a696078b382..e40e6e5e5f03 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -61,7 +61,6 @@ static bool vga_arbiter_used;
>  static DEFINE_SPINLOCK(vga_lock);
>  static DECLARE_WAIT_QUEUE_HEAD(vga_wait_queue);
>  
> -

drop this change

>  static const char *vga_iostate_to_str(unsigned int iostate)
>  {
>  	/* Ignore VGA_RSRC_IO and VGA_RSRC_MEM */
> @@ -77,10 +76,12 @@ static const char *vga_iostate_to_str(unsigned int iostate)
>  	return "none";
>  }
>  
> -static int vga_str_to_iostate(char *buf, int str_size, int *io_state)
> +static int vga_str_to_iostate(char *buf, int str_size, unsigned int *io_state)

this is OK, it's actually what you are describing in the commit
log, but...

>  {
> -	/* we could in theory hand out locks on IO and mem
> -	 * separately to userspace but it can cause deadlocks */
> +	/*
> +	 * we could in theory hand out locks on IO and mem
> +	 * separately to userspace but it can cause deadlocks
> +	 */

... all the rest needs to go on different patches as it doesn't
have anything to do with what you describe.

Andi
