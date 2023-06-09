Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05972A097
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjFIQtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjFIQs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C640F3A8C;
        Fri,  9 Jun 2023 09:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58DC665A02;
        Fri,  9 Jun 2023 16:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7117EC433EF;
        Fri,  9 Jun 2023 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686329331;
        bh=wj6ps6y4ft6WvpJQrBdcLusOhuloDy4bHnascQVlTT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=O4xMnvyru9ylkQLSbinraMlwoqqoCRzqiohujByEGtJFDGMM2+bIqDUl5eHnyQxXo
         rY6Jt+s9J9b2BJMm3LdqlppNkZafwg1ABQk0do5vWtrwv0HjpULglS2SDN2D6aMymp
         CWxzgfiCmay+hbv7MVTWZ0mdVEp8uqGYXaqtxKSQkL5P7BHI2KgvO4BKLhYRuItyUe
         b1MGXu2c7L7tT5+p5OajerVERb9IENBTZBVZNst9tkM+K3jNo95v+iyFA8Z0Q9QZCe
         4IkGGUvPbx+9E+dUiQyq/RGdROHaFJmb7Ilr8VJ8sFWFpVVNEi3FletAovP7YIwJSa
         +jJM45seUVXUw==
Date:   Fri, 9 Jun 2023 11:48:50 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Sui Jingfeng <15330273260@189.cn>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Karol Herbst <kherbst@redhat.com>,
        nouveau@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        David Airlie <airlied@gmail.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        loongson-kernel@lists.loongnix.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>, Li Yi <liyi@loongson.cn>,
        Pan Xinhui <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>
Subject: Re: [Intel-gfx] [PATCH v3 4/4] PCI/VGA: introduce is_boot_device
 function callback to vga_client_register
Message-ID: <20230609164850.GA1251187@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2ba099-9817-13be-c85b-997211443119@loongson.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 10:27:39AM +0800, Sui Jingfeng wrote:
> On 2023/6/9 03:19, Bjorn Helgaas wrote:
> > On Thu, Jun 08, 2023 at 07:43:22PM +0800, Sui Jingfeng wrote:
> > > From: Sui Jingfeng <suijingfeng@loongson.cn>
> > > 
> > > The vga_is_firmware_default() function is arch-dependent, which doesn't
> > > sound right. At least, it also works on the Mips and LoongArch platforms.
> > > Tested with the drm/amdgpu and drm/radeon drivers. However, it's difficult
> > > to enumerate all arch-driver combinations. I'm wrong if there is only one
> > > exception.
> > > 
> > > With the observation that device drivers typically have better knowledge
> > > about which PCI bar contains the firmware framebuffer, which could avoid
> > > the need to iterate all of the PCI BARs.
> > > 
> > > But as a PCI function at pci/vgaarb.c, vga_is_firmware_default() is
> > > probably not suitable to make such an optimization for a specific device.
> > > 
> > > There are PCI display controllers that don't have a dedicated VRAM bar,
> > > this function will lose its effectiveness in such a case. Luckily, the
> > > device driver can provide an accurate workaround.
> > > 
> > > Therefore, this patch introduces a callback that allows the device driver
> > > to tell the VGAARB if the device is the default boot device. This patch
> > > only intends to introduce the mechanism, while the implementation is left
> > > to the device driver authors. Also honor the comment: "Clients have two
> > > callback mechanisms they can use"
> > s/bar/BAR/ (several)
> > 
> > Nothing here uses the callback.  I don't want to merge this until we
> > have a user.
> 
> This is chicken and egg question.
> 
> If you could help get this merge first, I will show you the first user.
> 
> > I'm not sure why the device driver should know whether its device is
> > the default boot device.
> 
> It's not that the device driver should know,
> 
> but it's about that the device driver has the right to override.
> 
> Device driver may have better approach to identify the default boot
> device.

The way we usually handle this is to include the new callback in the
same series as the first user of it.  That has two benefits:
(1) everybody can review the whole picture and possibly suggest
different approaches, and (2) when we merge the infrastructure,
we also merge a user of it at the same time, so the whole thing can be
tested and we don't end up with unused code.

Bjorn
