Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8955724D83
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 21:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbjFFTts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 15:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbjFFTte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 15:49:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E3610F2;
        Tue,  6 Jun 2023 12:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF87B63799;
        Tue,  6 Jun 2023 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22544C433D2;
        Tue,  6 Jun 2023 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686080963;
        bh=pbIbz4/tc0Rq6Sy3ly+bzAO4xmFxE3ciFF0GfdmXFBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=E4U6lVYqlhekeW3u/0dM8shOTdRaShUhgAE4YQMPUQTzSh3LHrvZwaPYvl2dhjAET
         WPV8DqyvjoKuBIdDnyDIpmDQsniskymtjKrWlOkzg5qXGIAQmqLw7N4WEx5g65xC9V
         hClqEzeTSafaEiu2/E95qwmKUqSeLLQxydJmHgApphwCzWJnDfQ1TV7MnAvvUVlH4J
         sITvP9IMTddL1S/66qiiVLnOf58x4/Sta6Xf2qKsbjFW/LqQRqXqNeMI2yB83s/Ooj
         SYujT0vnhtU1m7idliZPEQQZqcLDK7iZ7OM7xoQoZW/TzUXEESrkF3jvvgyj0f1mlz
         2J8SpOPxGoCyA==
Date:   Tue, 6 Jun 2023 14:49:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
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
Message-ID: <20230606194921.GA1139774@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604205831.3357596-1-15330273260@189.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Match the subject line style:

  $ git log --oneline drivers/pci/vgaarb.c
  f321c35feaee PCI/VGA: Replace full MIT license text with SPDX identifier
  d5109fe4d1ec PCI/VGA: Use unsigned format string to print lock counts
  4e6c91847a7f PCI/VGA: Log bridge control messages when adding devices
  dc593fd48abb PCI/VGA: Remove empty vga_arb_device_card_gone()
  ...

Subject line should be a summary of the commit log, not just "various
style fixes".  This one needs to say something about
vga_str_to_iostate().

On Mon, Jun 05, 2023 at 04:58:30AM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> To keep consistent with vga_iostate_to_str() function, the third argument
> of vga_str_to_iostate() function should be 'unsigned int *'.
> 
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
>  static const char *vga_iostate_to_str(unsigned int iostate)
>  {
>  	/* Ignore VGA_RSRC_IO and VGA_RSRC_MEM */
> @@ -77,10 +76,12 @@ static const char *vga_iostate_to_str(unsigned int iostate)
>  	return "none";
>  }
>  
> -static int vga_str_to_iostate(char *buf, int str_size, int *io_state)
> +static int vga_str_to_iostate(char *buf, int str_size, unsigned int *io_state)
>  {
> -	/* we could in theory hand out locks on IO and mem
> -	 * separately to userspace but it can cause deadlocks */
> +	/*
> +	 * we could in theory hand out locks on IO and mem
> +	 * separately to userspace but it can cause deadlocks
> +	 */

Omit all the comment formatting changes.  They are distractions from the
vga_str_to_iostate() parameter change.

I think this patch should be the single line change to the
vga_str_to_iostate() prototype so it matches the callers.

If you want to do the other comment formatting changes, they're fine,
but they should be all together in a separate patch that clearly
doesn't change the generated code.

Bjorn
