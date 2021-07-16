Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A714F3CB6CE
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhGPLnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 07:43:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:27816 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhGPLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 07:43:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="190397772"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="190397772"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 04:40:06 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="496363853"
Received: from ooderhoh-mobl1.amr.corp.intel.com (HELO intel.com) ([10.212.81.13])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 04:40:03 -0700
Date:   Fri, 16 Jul 2021 07:40:02 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: Re: misc vgaarb cleanups
Message-ID: <YPFwEiztEUVFcdCh@intel.com>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 08:16:27AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up a bunch of lose ends in the vgaarb code.
> 
> Diffstat:
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 +-
>  drivers/gpu/drm/drm_irq.c                  |    4 
>  drivers/gpu/drm/i915/display/intel_vga.c   |    9 +-

The parts touching i915 looks clean to me

Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

>  drivers/gpu/drm/nouveau/nouveau_vga.c      |    8 -
>  drivers/gpu/drm/radeon/radeon_device.c     |   11 +-
>  drivers/gpu/vga/vgaarb.c                   |   67 +++++-----------
>  drivers/vfio/pci/vfio_pci.c                |   11 +-
>  include/linux/vgaarb.h                     |  118 ++++++++++-------------------
>  8 files changed, 93 insertions(+), 146 deletions(-)
