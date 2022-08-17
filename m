Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8775972FE
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbiHQPbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiHQPbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:31:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA108C028;
        Wed, 17 Aug 2022 08:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBBD4B81DBA;
        Wed, 17 Aug 2022 15:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD293C433C1;
        Wed, 17 Aug 2022 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660750259;
        bh=d/FJfKqmE+4mWdoX8d+ChMQU/Kkst9TDtaxZD7wIgIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSoHMsyzI7smwd82uDLxGUKoigW3f8nM/LAWg7JhgdiAXMOXqORDciqGPCaZON/wV
         UVLudLV5g9cUA2wshQ/lU9nMXNRLcnE4iLOuay3YoFUX/ciKI2NvttWrUxTHy72tUI
         TiXrsqp7FRVsu2b+Z8iCc0PhicvB3gtIS/zcI3TY=
Date:   Wed, 17 Aug 2022 17:30:56 +0200
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
Subject: Re: [RFC PATCH v2 6/6] driver core: add compatible string in sysfs
 for platform devices
Message-ID: <Yv0JsOJBfVW1lAOy@kroah.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-7-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817150542.483291-7-nipun.gupta@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 08:35:42PM +0530, Nipun Gupta wrote:
> This change adds compatible string for the platform based
> devices.

What exactly is a "compatible string"?

> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-platform |  8 +++++++
>  drivers/base/platform.c                      | 23 ++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-platform b/Documentation/ABI/testing/sysfs-bus-platform
> index c4dfe7355c2d..d95ff83d768c 100644
> --- a/Documentation/ABI/testing/sysfs-bus-platform
> +++ b/Documentation/ABI/testing/sysfs-bus-platform
> @@ -54,3 +54,11 @@ Description:
>  		Other platform devices use, instead:
>  
>  			- platform:`driver name`
> +
> +What:		/sys/bus/platform/devices/.../compatible
> +Date:		August 2022
> +Contact:	Nipun Gupta <nipun.gupta@amd.com>
> +Description:
> +		compatible string associated with the device. This is
> +		a read only and is visible if the device have "compatible"
> +		property associated with it.

Where is it defined what a compatible property is?

> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 51bb2289865c..94c33efaa9b8 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -1289,10 +1289,25 @@ static ssize_t driver_override_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(driver_override);
>  
> +static ssize_t compatible_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	const char *compat;
> +	int ret;
> +
> +	ret = device_property_read_string(dev, "compatible", &compat);
> +	if (ret != 0)
> +		return 0;

Shouldn't you return an error here?

thanks,

greg k-h
