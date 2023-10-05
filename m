Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FF17BAB60
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjJEUUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjJEUUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:20:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCC093;
        Thu,  5 Oct 2023 13:20:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913ACC433C8;
        Thu,  5 Oct 2023 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696537210;
        bh=zUYsds6wD0EANgOm8ilvedCIxPE85jI0zhv344IWr04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=nwuiqRaaI6WTdRN2MgBeAa9eIDYD5Bxe4ZQ4OxGb98g28Jr48Jzno9yy7wJIiQjxj
         gzw9J0oDlJlnhD+UlSYbHTSLjDhdYf+aFBsMi5tOPgZJPCiS3Qj1IKJ6sgq57pqyPX
         vrRJLvHdOwXE7ST968KMUYMuBTP84el+Jn12uDDpEoDV/klwmOdEvIIV4AlCMbN8im
         JVnGstVbJSoiFiC3yEZ+37AHV2b9O1PeR3lWWCBdyyhckMYgzDJcLWoyUzSBJCf0fv
         m4VK6hqgXUYj0/GMpuqn6zdYeBh9Do/jsMpOxXFj3r41RBF6WmqKhQ+jq6X1s+83O7
         h4McHeqlAmiRQ==
Date:   Thu, 5 Oct 2023 15:20:09 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 11/12] PCI/CMA: Expose in sysfs whether devices are
 authenticated
Message-ID: <20231005202009.GA790383@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821682573e57e0384162f365652171e5ee1e6611.1695921657.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 07:32:41PM +0200, Lukas Wunner wrote:
> The PCI core has just been amended to authenticate CMA-capable devices
> on enumeration and store the result in an "authenticated" bit in struct
> pci_dev->spdm_state.

>  drivers/pci/cma-sysfs.c                 | 73 +++++++++++++++++++++++++

Not really sure it's worth splitting this into cma.c, cma-sysfs.c,
cma-x509.c.  They're all tiny and ping-ponging between files is a bit
of a hassle:

 151 drivers/pci/cma.c
  73 drivers/pci/cma-sysfs.c
 119 drivers/pci/cma-x509.c

Bjorn
