Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633CB4D8D9C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244813AbiCNUAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244842AbiCNUAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:00:04 -0400
X-Greylist: delayed 955 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 12:58:48 PDT
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F0840923;
        Mon, 14 Mar 2022 12:58:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:35::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id CACC5383;
        Mon, 14 Mar 2022 19:58:46 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CACC5383
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1647287927; bh=AnNaxE8wlTsBWEEhticAn+sEqcwIS4iNBDpH7ZLYvUs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=CDvfTzXvXnFFBj3xyAdIntEyefM2+PlaaW8TL3DmFkeWbHStcrxtF2dpNA+BOkDIj
         zdn7mjcCDKLLmkygxJMwMqVw4bWBzvaEbM6IWjJGsVgHbERiaYfkRfm1MMkifJapKe
         G+5WMo7B4v6Q5Yr7eFzt6fOwgaUbcSSEWK00WlmFwpoBNPAoWDzS4GfjpIM6WDIKDH
         Rd+zBy2C36Vnf9cv680u02iVT7ljK1Js7ZrE2PUZj+39TVj6BiLTbowuzgdo7G5fkp
         DPL4ZAf/fs/YKg/hDykFITs3wTtIKaWkAdFOlwjzwX9dW+kUilpndb+8/9oYnL7HvB
         U8w7JKvVebuqg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        yishaih@nvidia.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
In-Reply-To: <20220314135216.0cd5e16a.alex.williamson@redhat.com>
References: <164728518026.40450.7442813673746870904.stgit@omen>
 <87pmmoxqv8.fsf@meer.lwn.net>
 <20220314135216.0cd5e16a.alex.williamson@redhat.com>
Date:   Mon, 14 Mar 2022 13:58:46 -0600
Message-ID: <87lexcxq4p.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:

>> Also, though: can we avoid creating a new top-level documentation
>> directory for just this file?  It seems like it would logically be a
>> part of the maintainers guide (Documentation/maintainer) ... ?
>
> I'm not sure it's appropriate for Documentation/maintainer/ but it
> would make sense to link it from maintainer-entry-profile.rst there.
> What if I move it to Documentation/driver-api where there are a couple
> other vfio docs?  Thanks,

Sure, that's fine.

Thanks,

jon
