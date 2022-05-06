Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54651D8CB
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 15:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbiEFNYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 09:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbiEFNYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 09:24:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7CB2D1F7
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 06:20:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59DE5B832E8
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0697EC385A9;
        Fri,  6 May 2022 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651843230;
        bh=7bIHgtHjJ3z9Mvdl0eVlI3w9LSIcBQnh3LHSSyziSRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C1GGyyDsZq7ZdEeuF6UcbMW2U/RArtQg43d0CDIc1BygZpV+XR+wZxhgpCMIlP99d
         s5/KADvz3zVIJl19hAqECnZ7noY/cPVI6mSILSvC7r+Dy1dGy0wfYqNtxhhR149BBm
         5BxFAzq1w7G/xlS+gAZudryeSHWGKwlcbuT0u9kensV37MMX7Rm/h1yDXZ2XFJJVHR
         gKnEYbUIuFKxGI/Mh7Quqn4NK1BEA/arG2/QHjed3qmWB2No76IKqTORgagK8ex2Jd
         dSOBt+EKTNqK7gofD/8oeHRk8nR77LWiDZwyUwuGKYPphpiQnn6OtweT+4WR1SNAEa
         ZuahTTITV/NYg==
Date:   Fri, 6 May 2022 14:20:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 kvmtool 0/5] Fix few small issues in virtio code
Message-ID: <20220506132024.GF22892@willie-the-truck>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303231050.2146621-1-martin.b.radev@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 01:10:45AM +0200, Martin Radev wrote:
> Hello everyone,
> 
> Thanks for the reviews in the first patch set.
> 
> This is the second version of the original patch set which addresses
> few found overflows in the common virtio code. Since the first version,
> the following changes were made:
> - the virtio_net warning patch was removed.
> - a WARN_ONCE macro is added to help signal that an issue was observed,
>   but without polluting the log.
> - a couple of improvements in sanitization and style.
> - TODO comment for missing handling of multi-byte PCI accesses.
> 
> The Makefile change is kept in its original form because I didn't understand
> if there is an issue with it on aarch64.

It looks like we're nearly there with this series. Martin, do you plan to
spin a v3, please?

Will
