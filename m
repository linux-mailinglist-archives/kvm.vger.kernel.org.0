Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FFC3BC5A5
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 06:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhGFEmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 00:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhGFEmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 00:42:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE51AC061574;
        Mon,  5 Jul 2021 21:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tm9bbwSLIXHzncYHK7SPpmMxLf8Q613BrbD6KMaacCU=; b=ZHopiEcE65spd6w6KieC7YH/9O
        7KIMWJOGo8MuL0N/hif+7In1wZ4nMYAxts4WI+bThg19A1gHVk+zbNn2Pdxi3smtBEqehnkKz3sUg
        k27f5BUV881/+Qpx5UChOFiMXm9luIVQZi/+TgVqY8ogi4Oa/Q4lrsG/BS/5k2aBCiOEpB7lsIxGC
        8Jzdbi9F6JmB7U+ZCCeU4u7wPa2bEo73kJeRXc2I+LSTTKq3IzhaQOjtTWzwJ7yX5yzQ5hKoD6zkY
        mJBkWTzUqrfkYMvY/Mxmr/0GsRBj026jW33bZuhIsz/UVAymC4vFNHkcOzqpC5t6HCwCADz2oI5fM
        /k80Alig==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0crl-00Apu4-QR; Tue, 06 Jul 2021 04:39:31 +0000
Date:   Tue, 6 Jul 2021 05:39:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <YOPefSD9x+mv5jO6@infradead.org>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
 <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
 <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
 <YONPGcwjGH+gImDj@unreal>
 <20210705183247.GU4459@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705183247.GU4459@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 03:32:47PM -0300, Jason Gunthorpe wrote:
> It would be improved a bit by making the ops struct mutable and
> populating it at runtime like we do in RDMA. Then the PCI ops and
> driver ops could be merged together without the repetition.

No, that would be everything but an improvement.
