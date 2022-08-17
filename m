Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173BA597314
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbiHQPcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbiHQPcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:32:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E57C9D644;
        Wed, 17 Aug 2022 08:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAECB61580;
        Wed, 17 Aug 2022 15:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B12C433D6;
        Wed, 17 Aug 2022 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660750368;
        bh=SLqJ5eMxEKpEfFY4KwxKtcftm4KEHJnRCGNOUUErrQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XOwfhPacAxhjEvskcrt8wqCIDRrTRpqrrfJiKMAG37uynPsROpA8Ai0OxLqqKOW59
         evO5OEGY2nwWJszF36ytSOIPi0U8MhQZYdEC1FO+sjS4HtBsQqsdb7hyI+9lWpSO1x
         kEIi+4xqtzsAtm5Z1qeTwUbm+6W7bYRaGlFr2XEI=
Date:   Wed, 17 Aug 2022 17:32:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org, okaya@kernel.org,
        harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, git@amd.com
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <Yv0KHROjESUI59Pd@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817150542.483291-3-nipun.gupta@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 08:35:38PM +0530, Nipun Gupta wrote:
> CDX bus driver manages the scanning and populating FPGA
> based devices present on the CDX bus.
> 
> The bus driver sets up the basic infrastructure and fetches
> the device related information from the firmware. These
> devices are registered as platform devices.

Ick, why?  These aren't platform devices, they are CDX devices.  Make
them real devices here, don't abuse the platform device interface for
things that are not actually on the platform bus.

> CDX bus is capable of scanning devices dynamically,
> supporting rescanning of dynamically added, removed or
> updated devices.

Wonderful, that's a real bus, so be a real bus please.

thanks,

greg k-h
