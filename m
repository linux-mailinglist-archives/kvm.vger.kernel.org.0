Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296BA798470
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 10:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbjIHIuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 04:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjIHIut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 04:50:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0ED1BDA;
        Fri,  8 Sep 2023 01:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yjPdL2NtSdMXje+btfQrS7+p0IAzr/Enm0/cWKKLJV8=; b=oZwHHccOhlx2fQ/n+cBHuiabTn
        FIZW/eCCL3QJ9/4Y3Ry0z/FnD3IkQFbuG0VSwc7lxIUK41pVRmtw8AjpBpO01qeI/KZ9wPadHXt5E
        Rxl5inN3vruODg0KpbxYFQFn7KVYTr0vrWUAFPLvLg3Z2vj/9URlIlP+nwGkz9xmlPqqn4XFmo1CK
        J1aEgG9OHnWTgSA5uAXYMOR2Ktl0KYGjMQQvlaHLZppwBDAc7OCTAtjixXS3f89t7aIk8uCchW2Bm
        vUKdXVgayqJtiNlCXfJYhcII9wnBrs00bpAw4hmzDxY6Pbj9DsylSUmAQdsxdFbYtYjJ9OVAF5rbS
        zduoDilQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qeXCG-00DLss-37;
        Fri, 08 Sep 2023 08:50:36 +0000
Date:   Fri, 8 Sep 2023 01:50:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, ankita@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZPrgXAfJvlDLsWqb@infradead.org>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907220410.31c6c2ab.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 10:04:10PM -0600, Alex Williamson wrote:
> > I think it really depends on what the qemu side wants to do..
> 
> Ok, I thought you had been one of the proponents of the fake BAR
> approach as more resembling CXL.  Do we need to reevaluate that the
> tinkering with the VM machine topology and firmware tables would better
> align to a device specific region that QEMU inserts into the VM address
> space so that bare metal and virtual machine versions of this device
> look more similar?  Thanks,

Yes, providing something to a VM that doesn't look anything like the
underlying hardware feels pretty strange.
