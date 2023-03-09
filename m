Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C190A6B2D8C
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 20:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCIT2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 14:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCIT21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 14:28:27 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A077F234E7
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 11:28:24 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id B3A4F37E30F1CD;
        Thu,  9 Mar 2023 13:28:23 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jGN-8Xydj9s9; Thu,  9 Mar 2023 13:28:21 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id E9E2137E30F1C5;
        Thu,  9 Mar 2023 13:28:20 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com E9E2137E30F1C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678390101; bh=CbCsmLeX1ddXkdY4a/6wh2/kLAFwgvzxaddcb7TsXOg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=hvo0srl2W1wk/0z2PB6k0D1eYDMw88uUE9wZw4OFoEkiqFEXVwVYwmCfafJN+Pqb+
         p/lup1bjmyKawNSvlZdUEOan4eLhURzMnlHXnC1iOIs5AZ5bQecVxsB28gP/l+IHLA
         MXBXLV6oHsmH7EwsLYveQDgia9kHbhNMHaQkRS+o=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3QKyq8qYSowy; Thu,  9 Mar 2023 13:28:20 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id C417637E30F1BE;
        Thu,  9 Mar 2023 13:28:20 -0600 (CST)
Date:   Thu, 9 Mar 2023 13:28:20 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <1816556668.17777469.1678390100763.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <87bkl2ywz2.fsf@mpe.ellerman.id.au>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com> <87bkl2ywz2.fsf@mpe.ellerman.id.au>
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC111 (Linux)/8.5.0_GA_3042)
Thread-Topic: Reenable VFIO support on POWER systems
Thread-Index: 5A2fst0q4NGeOTQFqq+CS6XF3WZlKw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



----- Original Message -----
> From: "Michael Ellerman" <mpe@ellerman.id.au>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>, "kvm" <kvm@vger.kernel.org>
> Cc: "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> Sent: Thursday, March 9, 2023 5:40:01 AM
> Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems

> Timothy Pearson <tpearson@raptorengineering.com> writes:
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
> 
> As sent the patches had lost Alexey's authorship (no From: line), I
> fixed it up when applying so the first 3 are authored by Alexey.
> 
> cheers

Thanks for catching that, it wasn't intentional.  Probably used a wrong Git command...
