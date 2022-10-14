Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A21D5FEDA5
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 13:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJNLyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 07:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJNLy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 07:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90171958F8;
        Fri, 14 Oct 2022 04:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98937B8231D;
        Fri, 14 Oct 2022 11:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43D1C433C1;
        Fri, 14 Oct 2022 11:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665748449;
        bh=8ziD9oexEiCA700ImIeJmUn8Kxl7qdwb3DSu9XVCTKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IvD543xlF57jpRAblzqk63fULdBTlD9IjA/Ikw6Ie2o/14fu6m7T8PddN5F6F2mSz
         dYFdq66x+/JW/DzS/4h/t7t/djnfE0cvy/04rhi1JXmsfs1v+otrZNR/Dc7/FLEWDW
         818cXP0p3r9nstJZbnKPKhJZXGci72bvjmBQKhq8=
Date:   Fri, 14 Oct 2022 13:54:53 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <Y0lODVFsp4KMfPdu@kroah.com>
References: <20220906134801.4079497-5-nipun.gupta@amd.com>
 <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0gH8R8tEqn6sqZ5@ziepe.ca>
 <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 11:18:36AM +0000, Radovanovic, Aleksandar wrote:
> Anyway, I think we're straying off topic here, none of this is visible to the kernel anyway. The question that we still need to answer is, are you OK with the limitations I listed originally?

What original limitations?  This thread is crazy and complex and you
need to use your \n key more :)

thanks,

greg k-h
