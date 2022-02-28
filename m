Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4BC4C7A18
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiB1UNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiB1UNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:13:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7908B39815;
        Mon, 28 Feb 2022 12:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ECC660B2A;
        Mon, 28 Feb 2022 20:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FD6C340F2;
        Mon, 28 Feb 2022 20:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646079181;
        bh=7itQ1YN7sWBEvhZSZBZDP5YIBB1m6b0J0BY8JZ3d9tI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LpSSl4Pvrp8HCxpc3HNz9Ev+ThT8eVsPR878QUgqSRGMZ6Kfxt92/qs79ay0u6Fwm
         IJZUnbV+zWmWE6LwHWIwNAWw91+3X75H1sW48deIlX+ujjZusHvla4eqBS1VJEvGq1
         qW+p5UYEQcqM6pNM34qZawV9YxnUpq4dTIWH/KhbYbutUY5Jza4qKTqZFmonor4ryU
         qgPw82VLMmhmybka/6ojUhBzUyHwUvK6P2FSEXpMN5Vx1qiv7GDRWB6Ig+Wza4Ji9l
         ebGGxve2VH++Vefu1VxQ5mEwFeuxVzCsLO6q5OxEzq0o5h7QkbcPmUvyu9nsTxaYy2
         Yb+I2zEcH8WqA==
Date:   Mon, 28 Feb 2022 14:12:59 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, jgg@nvidia.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 03/10] hisi_acc_qm: Move PCI device IDs to common
 header
Message-ID: <20220228201259.GA516607@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228103338.76da0b3b.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 10:33:38AM -0700, Alex Williamson wrote:
> [Cc+ Bjorn, linux-pci]
> 
> On Mon, 28 Feb 2022 09:01:14 +0000
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > Move the PCI Device IDs of HiSilicon ACC devices to
> > a common header and use a uniform naming convention.

> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2529,6 +2529,12 @@
> >  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
> >  
> >  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> > +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
> > +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> > +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
> > +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> > +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
> > +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259

We usually don't add things to pci_ids.h unless they're used in more
than one place (see the comment at the top of the file).  AFAICT,
these device IDs are only used in one file, so you can leave the
#defines in the file that uses them or use bare hex values.

These device IDs are all in https://pci-ids.ucw.cz/read/PC/19e5
already, thanks for that!

> >  #define PCI_VENDOR_ID_NETRONOME		0x19ee
> >  #define PCI_DEVICE_ID_NETRONOME_NFP4000	0x4000
> 
