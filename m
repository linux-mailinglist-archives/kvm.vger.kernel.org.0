Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193256C3CF0
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 22:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCUVnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 17:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCUVnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 17:43:23 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CAC132C3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:43:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ph4pt1JcLz4x7s;
        Wed, 22 Mar 2023 08:43:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1679434998;
        bh=DQoCdq+b2bx9rdvtk6umenZDmjKooijaQcEpaO+ZVco=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TN3gsWuqoyfbIswbKDnAiHOxB/3KPhhBs08nA9tVAUEtpyNuWyi+TTcVaSIrDMSiS
         OCyZKbniaffCwecPYoRxnKpQ0aVF5XEi8nQ+p3/s2EPbJAcW9gTfllFteXp+Vn/qo1
         u/I47TJGStKY+7lsMBL2yydOPHx+aRwbfPH/q4ycShw1Xe+XS4dQH3XRhxsPXAhISM
         i7Ass30bVS4Ly9gA2Owf+e4L1nLhwjPNXrWog4Zhp1AQPURHurdZPq43fK9Z+dN7eu
         qrg+2ZymSC6h2uOg1H1o9L7apLVZIFTkeYpQBN5C6pkUrFjEiUOMteYrZcMYyd6D+L
         C/sH8/2pALKmA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Timothy Pearson <tpearson@raptorengineering.com>
Cc:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
In-Reply-To: <1328231683.26510466.1679404685113.JavaMail.zimbra@raptorengineeringinc.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
 <87bkl2ywz2.fsf@mpe.ellerman.id.au>
 <1816556668.17777469.1678390100763.JavaMail.zimbra@raptorengineeringinc.com>
 <2099448392.25626899.1679166370571.JavaMail.zimbra@raptorengineeringinc.com>
 <877cvav1ey.fsf@mpe.ellerman.id.au>
 <1328231683.26510466.1679404685113.JavaMail.zimbra@raptorengineeringinc.com>
Date:   Wed, 22 Mar 2023 08:43:15 +1100
Message-ID: <874jqdvkzw.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Timothy Pearson <tpearson@raptorengineering.com> writes:
> ----- Original Message -----
>> From: "Michael Ellerman" <mpe@ellerman.id.au>
>> To: "Timothy Pearson" <tpearson@raptorengineering.com>, "Timothy Pearson" <tpearson@raptorengineering.com>
>> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
>> Sent: Tuesday, March 21, 2023 5:33:57 AM
>> Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
>
>> Timothy Pearson <tpearson@raptorengineering.com> writes:
>>> ----- Original Message -----
>>>> From: "Timothy Pearson" <tpearson@raptorengineering.com>
>>>> To: "Michael Ellerman" <mpe@ellerman.id.au>
>>>> Cc: "Timothy Pearson" <tpearson@raptorengineering.com>, "kvm"
>>>> <kvm@vger.kernel.org>, "linuxppc-dev"
>>>> <linuxppc-dev@lists.ozlabs.org>
>>>> Sent: Thursday, March 9, 2023 1:28:20 PM
>>>> Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
>>>
>>>> ----- Original Message -----
>>>>> From: "Michael Ellerman" <mpe@ellerman.id.au>
>>>>> To: "Timothy Pearson" <tpearson@raptorengineering.com>, "kvm"
>>>>> <kvm@vger.kernel.org>
>>>>> Cc: "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
>>>>> Sent: Thursday, March 9, 2023 5:40:01 AM
>>>>> Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
>>>> 
>>>>> Timothy Pearson <tpearson@raptorengineering.com> writes:
>>>>>> This patch series reenables VFIO support on POWER systems.  It
>>>>>> is based on Alexey Kardashevskiys's patch series, rebased and
>>>>>> successfully tested under QEMU with a Marvell PCIe SATA controller
>>>>>> on a POWER9 Blackbird host.
>>>>>>
>>>>>> Alexey Kardashevskiy (3):
>>>>>>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>>>>>>   powerpc/pci_64: Init pcibios subsys a bit later
>>>>>>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>>>>>>     domains
>>>>> 
>>>>> As sent the patches had lost Alexey's authorship (no From: line), I
>>>>> fixed it up when applying so the first 3 are authored by Alexey.
>>>>> 
>>>>> cheers
>>>> 
>>>> Thanks for catching that, it wasn't intentional.  Probably used a wrong Git
>>>> command...
>>>
>>> Just wanted to touch base on the patches, since they're still listed as Under
>>> Review on patchwork.  Are we good to go for the 6.4 merge window?
>> 
>> They've been in my next (and so linux-next), since last week. I just
>> haven't updated patchwork yet.
>> 
>> So yeah they are on track to go into mainline during the v6.4 merge window.
>> 
>> cheers
>
> Sounds great, thanks!  Saw them in the next tree but wasn't sure if the patchwork status was more reflective of overall status.

Yeah I guess patchwork is more reflective.

I sometimes put things in next for a few days to see if any issues shake
out, before I update patchwork. Mainly because it's a pain to un-update
patchwork if the patch needs to be backed out, but also as a signal that
the patch isn't quite locked into next yet.

cheers
