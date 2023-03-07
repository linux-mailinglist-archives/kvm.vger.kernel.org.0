Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD46AD361
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjCGAf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCGAf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:35:27 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB84FA84
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:35:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 4F01437E2DC51F;
        Mon,  6 Mar 2023 18:35:25 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id LIXvqpxXO_fH; Mon,  6 Mar 2023 18:35:24 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 8D16037E2DC51B;
        Mon,  6 Mar 2023 18:35:24 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 8D16037E2DC51B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678149324; bh=d7tRh4DYJAstSYgGvXAe702lxliOTzbWbOIzKC9WOhs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=qf7OR8T2JBkMe1kolJf5Cyju1oEC0XygB435n0h2RPk7emq9hHgnUx0drcol2+h/v
         Hiscu4TChabtpQT8tpcShiQGvhEzj5nBmYAVKaIUzZny/3G0L7ECnkVYpsNxAWoVfk
         ZVCihApsSgYA5Aa4Ok36zjUbCxdC3CaJlIg8PIJ4=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xMzxfUrc0kdl; Mon,  6 Mar 2023 18:35:24 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 649FB37E2DC518;
        Mon,  6 Mar 2023 18:35:24 -0600 (CST)
Date:   Mon, 6 Mar 2023 18:35:22 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <1817332573.17073558.1678149322645.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20230306164607.1455ee81.alex.williamson@redhat.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com> <20230306164607.1455ee81.alex.williamson@redhat.com>
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Topic: Reenable VFIO support on POWER systems
Thread-Index: jJqBMtQQOZgPeIC+HYmueU64EZU6Ug==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



----- Original Message -----
> From: "Alex Williamson" <alex.williamson@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>
> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> Sent: Monday, March 6, 2023 5:46:07 PM
> Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems

> On Mon, 6 Mar 2023 11:29:53 -0600 (CST)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
> 
>> This patch series reenables VFIO support on POWER systems.  It
>> is based on Alexey Kardashevskiys's patch series, rebased and
>> successfully tested under QEMU with a Marvell PCIe SATA controller
>> on a POWER9 Blackbird host.
>> 
>> Alexey Kardashevskiy (3):
>>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>>   powerpc/pci_64: Init pcibios subsys a bit later
>>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>>     domains
>> 
>> Timothy Pearson (1):
>>   Add myself to MAINTAINERS for Power VFIO support
>> 
>>  MAINTAINERS                               |   5 +
>>  arch/powerpc/include/asm/iommu.h          |   6 +-
>>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
>>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>>  arch/powerpc/kernel/pci_64.c              |   2 +-
>>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
>>  arch/powerpc/platforms/pseries/setup.c    |   3 +
>>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>>  10 files changed, 338 insertions(+), 94 deletions(-)
>> 
> 
> For vfio and MAINTAINERS portions,
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> I'll note though that spapr_tce_take_ownership() looks like it copied a
> bug from the old tce_iommu_take_ownership() where tbl and tbl->it_map
> are tested before calling iommu_take_ownership() but not in the unwind
> loop, ie. tables we might have skipped on setup are unconditionally
> released on unwind.  Thanks,
> 
> Alex

Thanks for that.  I'll put together a patch to get rid of that potential bug that can be applied after this series is merged, unless you'd rather I resubmit a v3 with the issue fixed?
