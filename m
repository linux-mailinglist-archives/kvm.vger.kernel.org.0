Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E11514597
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356684AbiD2Jq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 05:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244541AbiD2Jq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 05:46:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B532EBE9F1;
        Fri, 29 Apr 2022 02:43:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81E111063;
        Fri, 29 Apr 2022 02:43:39 -0700 (PDT)
Received: from lpieralisi (unknown [10.57.46.17])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BE913F73B;
        Fri, 29 Apr 2022 02:43:35 -0700 (PDT)
Date:   Fri, 29 Apr 2022 10:43:20 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Jake Oshins <jakeo@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to
 reduce VM boot time
Message-ID: <YmuzOJy/6F5wSjY7@lpieralisi>
References: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
 <20220428191213.GA36573@bhelgaas>
 <SN4PR2101MB08786192CE6DFC3450BEC571ABFD9@SN4PR2101MB0878.namprd21.prod.outlook.com>
 <BYAPR21MB12709F42ED7C2496D366792EBFFC9@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB12709F42ED7C2496D366792EBFFC9@BYAPR21MB1270.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 01:11:29AM +0000, Dexuan Cui wrote:
> > From: Jake Oshins <jakeo@microsoft.com>
> > Sent: Thursday, April 28, 2022 12:21 PM
> > ... 
> > Thanks everybody for responding to my questions.
> > 
> > Bjorn, from your response, it sounds like this change is safe until some possible
> > future which new functionality is introduced for rebalancing resources.
> > 
> > Dexuan, I don't have any further objection to the patch.
> > 
> > -- Jake Oshins
> 
> Thank all for the informative discussion!!
> 
> @Bjorn, Lorenzo: can this patch go through the hyperv tree?
> I see some recent pci-hyperv commits in the hyperv tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git

For this patch it should be fine as long as it does not become a rule,
we still want to be in the review loop for PCI hyper-V changes.

I will comment and ACK shortly.

Lorenzo
