Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412CDF39A0
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 21:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKGUip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 15:38:45 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40898 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKGUip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 15:38:45 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so2727450pgt.7
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 12:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=atbXQEkEcO1HpajO+U+SyWU18BioZk9DgM4LgjPJLDE=;
        b=mzFB2zycVG8n/Q447VPD/8axjhd/Zcv/fO5M9TlmDHqeGtlUXcE3/YuyAUz2P1uLhf
         Oi+5KTTEU3wc03yaNbEMqiurThzOiMxIQmPjJlMpD6GYM+97+AT28SGRDw14cBXTqHo/
         4XR9z6pjr46wiRtLf1MOeZzr5glMl4VSQVmJTPDYW9SDK2yet55Pf3hiMlFpoVqymmCS
         x7AHCccI82mnOOiFwqxUMftIYyQ4jgQZOpKssg3bo9Czjt1JRqkbDuXnYERAwn0tmEJh
         gdSLKxU0yAai9VMeHHPf8QUsS2zpDzgVoyUWe44TYhLYaQJlGN0V7QtN8eXYD4yAJcUo
         dnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=atbXQEkEcO1HpajO+U+SyWU18BioZk9DgM4LgjPJLDE=;
        b=gtU7ecBCcEK3fazQ8LCpM0Ty3vDfWKFJpQTihEfeb6t3gzC5U0b4lr3Vrl81BKD13h
         y5OOV5b9RFY/+8X1MFZHS+zz0dR4tvCy+uyTqVYPKhexJYYZO2tWVZbIux7zZTmxjMsb
         XSWT3wV3F8a09nz2eAyjFPhcDtxwDfZAIMRTizgfmwA7YnYvBjlkELPPqyCY8pelA3Cs
         pqE/Y0S8WyqLpah7eSkanBJRJD4Xhp8nBD0fS+Djk6ByHq/bQF64f0XfnmKiQAzXvjGS
         bEKZbQMF1NZhNaDjNl0Hd/OZbhog655fezN3S2YgwIJv1AmwLtqpWgHg4tHVV3WuOgbH
         HnDw==
X-Gm-Message-State: APjAAAWnbJ2Df4bcoxdK6IxBxYGmrcF6d4RosCAvkz2V97/xONXbNaZ3
        1P/xSzfixQuvxLIiShqgYa9+cA==
X-Google-Smtp-Source: APXvYqyQS3xwwMmx8ubjVAkiyb41jzXwOXPEopHyK9U6F+fqFCyG9estARb6dABioa5y7hZBC/JQwg==
X-Received: by 2002:a63:4506:: with SMTP id s6mr6843363pga.27.1573159124723;
        Thu, 07 Nov 2019 12:38:44 -0800 (PST)
Received: from cakuba.netronome.com ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id e11sm3292613pff.104.2019.11.07.12.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 12:38:44 -0800 (PST)
Date:   Thu, 7 Nov 2019 15:38:36 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191107153836.29c09400@cakuba.netronome.com>
In-Reply-To: <20191107160834.21087-12-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Nov 2019 10:08:27 -0600, Parav Pandit wrote:
> Introduce a new mdev port flavour for mdev devices.
> PF.
> Prepare such port's phys_port_name using unique mdev alias.
> 
> An example output for eswitch ports with one physical port and
> one mdev port:
> 
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev p0 flavour physical port 0
> pci/0000:06:00.0/32768: type eth netdev p1b0348cf880a flavour mdev alias 1b0348cf880a

Surely those devices are anchored in on of the PF (or possibly VFs)
that should be exposed here from the start.

> Signed-off-by: Parav Pandit <parav@mellanox.com>

> @@ -6649,6 +6678,9 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  		n = snprintf(name, len, "pf%uvf%u",
>  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>  		break;
> +	case DEVLINK_PORT_FLAVOUR_MDEV:
> +		n = snprintf(name, len, "p%s", attrs->mdev.mdev_alias);

Didn't you say m$alias in the cover letter? Not p$alias?

> +		break;
>  	}
>  
>  	if (n >= len)

