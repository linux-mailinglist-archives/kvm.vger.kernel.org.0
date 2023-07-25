Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266D976247C
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjGYVa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjGYVax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A59B2136;
        Tue, 25 Jul 2023 14:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC72D6190B;
        Tue, 25 Jul 2023 21:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6E2C433C7;
        Tue, 25 Jul 2023 21:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690320631;
        bh=V6TKiwei04nE3RMXlxgDm9GDIfoUHRbLAP5mFRrxSIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dkhLGLiaFpp+WjJG779pBjcd3WWJVUu7utaxHvlhcCRdyzKeXxkvnWXgNVYfPoCrC
         00BYWkOLqS5AK4f/ex7wJFl3qsWzUCOOkzfm/Cyzl5oIfUQ7DqrXlAmvuyPuwBxUPA
         ONK4jTWRuMX1h4/Bl/vemPvweN7BSgbtdFdQORDKSnKMkr6ISQfqIHvsO7IiH5p3gK
         EJ70gqs8zlRPzntbZNEBREXXUhMcG42MjKUkPsZq0UCfuSLS4q/5yJ/zJbBJjWnurM
         FpnEVIVkuBSlkaZ72zuAYKfS4WzIJUU8X8YsdtvLqIitYGOEVk1jXey/IJMQ/mNsx1
         gAFGaUQUp5rTQ==
Date:   Tue, 25 Jul 2023 16:30:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     suijingfeng <suijingfeng@loongson.cn>
Cc:     Sui Jingfeng <sui.jingfeng@linux.dev>,
        David Airlie <airlied@gmail.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
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
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v3 4/9] PCI/VGA: Improve the default VGA device selection
Message-ID: <20230725213029.GA666158@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fbc1ec7-fb61-7e4d-960c-81cc11b706f5@loongson.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023 at 08:16:18PM +0800, suijingfeng wrote:
> On 2023/7/20 03:32, Bjorn Helgaas wrote:
> > > 2) It does not take the PCI Bar may get relocated into consideration.
> > > 3) It is not effective for the PCI device without a dedicated VRAM Bar.
> > > 4) It is device-agnostic, thus it has to waste the effort to iterate all
> > >     of the PCI Bar to find the VRAM aperture.
> > > 5) It has invented lots of methods to determine which one is the default
> > >     boot device, but this is still a policy because it doesn't give the
> > >     user a choice to override.
> > I don't think we need a list of*potential*  problems.  We need an
> > example of the specific problem this will solve, i.e., what currently
> > does not work?
> 
> 
> This version do allow the arbitration service works on non-x86 arch,
> which also allow me remove a arch-specific workaround.
> I will give more detail at the next version.

Yes.  This part I think we want.

> But I want to provide one more drawback of vgaarb here:
> 
> (6) It does not works for non VGA-compatible PCI(e) display controllers.
> 
> Because, currently, vgaarb deal with PCI VGA compatible devices only.
> 
> See another my patch set [1] for more elaborate discussion.
> 
> It also ignore PCI_CLASS_NOT_DEFINED_VGA as Maciej puts it[2].
> 
> While my approach do not required the display controller to be
> VGA-compatible to enjoy the arbitration service.

I think vgaarb is really only for dealing with the problem of the
legacy VGA address space routing.  For example, there may be VGA
devices that require the [pci 0xa0000-0xbffff] range but they don't
describe that via a BAR.  There may also be VGA option ROMs that
depend on that range so they can initialize the device.

The [pci 0xa0000-0xbffff] range can only be routed to one device at a
time, and vgaarb is what takes care of that by manipulating the VGA
Enable bits in bridges.

I don't think we should extend vgaarb to deal with non-VGA GPUs in
general, i.e., I don't think it should be concerned with devices and
option ROMs that do not require the [pci 0xa0000-0xbffff] range.

I think a strict reading of the PCI Class Code spec would be that only
devices with Programming Interface 0000 0000b can depend on that
legacy range.

If that's what vgaarb currently enforces, great.  If it currently
deals with more than just 0000 0000b devices, and there's some value
in restricting it to only 0000 0000b, we could try that, but I would
suggest doing that in a tiny patch all by itself.  Then if we trip
over a problem, it's easy to bisect and revert it.

> [1] https://patchwork.freedesktop.org/patch/546690/?series=120548&rev=1
> 
> [2] https://lkml.org/lkml/2023/6/18/315
> 
