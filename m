Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBC78EF2F
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 16:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344706AbjHaOEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 10:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbjHaOEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 10:04:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D89C3;
        Thu, 31 Aug 2023 07:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1SWpGuD0KAPwny6nFb7h3tcRQQzmHIwSo1V8zXl2M7w=; b=qAfMPKJ+s+tSpiRNCSXWUOdVU7
        iEs3qsK2cvk3FkxIUcYSX7nOlv8RkTKrU6vIWd2KoD8yV2so3azqanfoG61mSleeMh9AKPNmPKze6
        Yyai3HzY+AzNfMDJeW5eMS/B36EcifUZQtkhJBKTv7TQGt+vubGFA5v4ZD165a+jdEzcK2+s1SsK9
        4ZopkQWOX9xFIXpfmqkNTPB8XTmCsVQ3sM+ZfgmDmEc/mXirolMrWHVdDTUV8w6ISjHx0H3JFStz9
        Ivk507Lx+5Xj4SZoYWhWZihUWZDDtEyTp3xsbGchpr+y2jixb695MF+TUF3FBzaMAH1VPu+4/JtTf
        5/Jy/Arg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qbiHK-00FPO9-1V;
        Thu, 31 Aug 2023 14:04:10 +0000
Date:   Thu, 31 Aug 2023 07:04:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPCd2sHXrAZHjsHg@infradead.org>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZO9JKKurjv4PsmXh@infradead.org>
 <ZO9imcoN5l28GE9+@nvidia.com>
 <ZPCG9/P0fm88E2Zi@infradead.org>
 <BY5PR12MB37631B2F41DB62CBDD7B1F69B0E5A@BY5PR12MB3763.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB37631B2F41DB62CBDD7B1F69B0E5A@BY5PR12MB3763.namprd12.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023 at 01:51:11PM +0000, Ankit Agrawal wrote:
> Hi Christoph,
> 
> >Whats the actual consumer running in a qemu VM here?
> The primary use case in the VM is to run the open source Nvidia
> driver (https://github.com/NVIDIA/open-gpu-kernel-modules)
> and workloads.

So this infrastructure to run things in a VM that we don't even support
in mainline?  I think we need nouveau support for this hardware in the
drm driver first, before adding magic vfio support.
