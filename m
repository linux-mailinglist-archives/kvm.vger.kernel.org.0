Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463586662B8
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbjAKSXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbjAKSXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:23:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D842455B2;
        Wed, 11 Jan 2023 10:23:10 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673461389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vMqcs3d/mQXSbj2yIxtSqUpEXzHA4uoYUEBxosyu6A=;
        b=pIQg6pyY0w4XO9bR3CcnGPeNxLEQwXr4ATdOnewL1XufZswdlaNB1lX+AbKqpIKO096KRz
        kwkwNyDReRag2iZxJEYqBt2tQgC4hWu2mXJA8YDaj2hdW274/vZqkNf4JTPqzeCtyP/35P
        ImWjaqQNgB2l2P2/b/wEiovvdgAlJGMfFDKDN4mS2ZuS16OxPbb1euTx2ptE7KQC602Sc2
        3Nb3QC+yMaGb+90nl1RtbEG84uHfdXAxgOUFgFs3aqIZ8O6wiIcaoMU3lFGN9mrrblwr/J
        uNCXznRa0l6Glxuzs5i4l6T/oJgZc9uv4KL9/4jt3MwWbytk4+c6TqQHWBmmDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673461389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vMqcs3d/mQXSbj2yIxtSqUpEXzHA4uoYUEBxosyu6A=;
        b=u1oEAJ2Vkn4Rr+vY8LJ8BhU1HHgnxfpu5AoG7tZW6UaUez7wwrqIeoDg+4fWAj36ZmcHp6
        LKrS0zoKjBPZKYDQ==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v3 6/9] irq: Rename IRQ_DOMAIN_MSI_REMAP to
 IRQ_DOMAIN_ISOLATED_MSI
In-Reply-To: <6-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: <6-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Date:   Wed, 11 Jan 2023 19:23:08 +0100
Message-ID: <878ri9hqwj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05 2023 at 15:33, Jason Gunthorpe wrote:

Comment about prefix allplies here as well...

Other than that:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
