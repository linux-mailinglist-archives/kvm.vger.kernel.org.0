Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BDEF5324
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKHSBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 13:01:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40256 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfKHSBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 13:01:49 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so7124190wmc.5
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 10:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lJ5jYSYxhWBiOLUeasctvNN0Hz6ObkARKS3FfphoEWE=;
        b=BGhONis13M+ywDk1AvdmiOqVp8vekKBmHqhmwUKaNxUf1K8JWL6dEOmnaNNWgR0Slt
         4MuQvTq1pliuNG4ssyraSutV2oixZ3/HQqcCT9t8ZMGAD6rCnFUXSpNJqjbAmMm37AMf
         XeF920AdDUgXLlZmxT56HMgSgk0d/KSYavgQeructzjusPzvdVHIY+229tUlFSCBbJ/Y
         qjz9WwOpMJF27utd5f3l0LZeft3LOM6N5iDbZLQFKze3AthagXgUL0ahdcDsGBGRXIPg
         W0EgqQBsDhcYpkcPYl4ETlD/P3QVDBgQMrNlCwf7e8AiOQKg+CmiA5IE7tfttvkjZzJM
         0Clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lJ5jYSYxhWBiOLUeasctvNN0Hz6ObkARKS3FfphoEWE=;
        b=L1VEMsTT8TQ3X6YfA30/OY6snmk84cD1tI/5jxvnpmuMoVXzfQo35ZpJkOMGNk8I0O
         EM62BNiaPDqNRg7nDQSiLq4KrTfKXjVpUaKCnerPnbTp9XG8AhrjSn7SeJC4LkLepvjn
         2hGeMuTfaGxz9U+G5MsbyyRabuuNFt7UffRPlANJ4ONixPpPVHI7J5WnEHijgypscBV2
         lfNiMhLiv7lDTsRb9FURTYiC9AKP1oAmiVg4uV/wWqQvPXYLxH61mqfYj3VtUb1+2NUq
         GA8NqLHb2W4yIrY7+VOr9xrSjRrpVtW+1Fqi/RXJd9GNPZs+m5suTwJEweMZVmxp8TBP
         5PhA==
X-Gm-Message-State: APjAAAUTdBxfJ8sco1mSWKiPQ1rYfq1eBPi1qwtwqu7v5+BAzuJ9awG8
        /wiefsBZaVcWO4EToGW9ZyL1gA==
X-Google-Smtp-Source: APXvYqz6By7AwEG0RnM5sj6NXy/zyu8RmoDQsp5yK0pUQ/9wpODZnCOqWqRATuLgmapWVvfVwjsTCg==
X-Received: by 2002:a1c:6885:: with SMTP id d127mr9050622wmc.64.1573236107632;
        Fri, 08 Nov 2019 10:01:47 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id h124sm8183706wmf.30.2019.11.08.10.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 10:01:47 -0800 (PST)
Date:   Fri, 8 Nov 2019 19:01:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>
Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for mediated
 devices in switchdev mode
Message-ID: <20191108180146.GR6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-6-parav@mellanox.com>
 <20191108103249.GE6990@nanopsycho>
 <AM0PR05MB486609CBD40E1E26BB18C6B3D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108162246.GN6990@nanopsycho>
 <AM0PR05MB48665096F40059F63B0895C6D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48665096F40059F63B0895C6D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fri, Nov 08, 2019 at 05:29:56PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, November 8, 2019 10:23 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: alex.williamson@redhat.com; davem@davemloft.net;
>> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
>> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
>> rdma@vger.kernel.org; Vu Pham <vuhuong@mellanox.com>
>> Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for mediated
>> devices in switchdev mode
>> 
>> Fri, Nov 08, 2019 at 05:03:13PM CET, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> Sent: Friday, November 8, 2019 4:33 AM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: alex.williamson@redhat.com; davem@davemloft.net;
>> >> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> >> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
>> >> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
>> >> rdma@vger.kernel.org; Vu Pham <vuhuong@mellanox.com>
>> >> Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for
>> >> mediated devices in switchdev mode
>> >>
>> >> Thu, Nov 07, 2019 at 05:08:21PM CET, parav@mellanox.com wrote:
>> >> >From: Vu Pham <vuhuong@mellanox.com>
>> >>
>> >> [...]
>> >>
>> >>
>> >> >+static ssize_t
>> >> >+max_mdevs_show(struct kobject *kobj, struct device *dev, char *buf) {
>> >> >+	struct pci_dev *pdev = to_pci_dev(dev);
>> >> >+	struct mlx5_core_dev *coredev;
>> >> >+	struct mlx5_mdev_table *table;
>> >> >+	u16 max_sfs;
>> >> >+
>> >> >+	coredev = pci_get_drvdata(pdev);
>> >> >+	table = coredev->priv.eswitch->mdev_table;
>> >> >+	max_sfs = mlx5_core_max_sfs(coredev, &table->sf_table);
>> >> >+
>> >> >+	return sprintf(buf, "%d\n", max_sfs); } static
>> >> >+MDEV_TYPE_ATTR_RO(max_mdevs);
>> >> >+
>> >> >+static ssize_t
>> >> >+available_instances_show(struct kobject *kobj, struct device *dev,
>> >> >+char *buf) {
>> >> >+	struct pci_dev *pdev = to_pci_dev(dev);
>> >> >+	struct mlx5_core_dev *coredev;
>> >> >+	struct mlx5_mdev_table *table;
>> >> >+	u16 free_sfs;
>> >> >+
>> >> >+	coredev = pci_get_drvdata(pdev);
>> >> >+	table = coredev->priv.eswitch->mdev_table;
>> >> >+	free_sfs = mlx5_get_free_sfs(coredev, &table->sf_table);
>> >> >+	return sprintf(buf, "%d\n", free_sfs); } static
>> >> >+MDEV_TYPE_ATTR_RO(available_instances);
>> >>
>> >> These 2 arbitrary sysfs files are showing resource size/usage for the
>> >> whole eswitch/asic. That is a job for "devlink resource". Please implement
>> that.
>> >>
>> >Jiri,
>> >This series is already too long. I will implement it as follow on. It is already
>> in plan.
>> >However, available_instances file is needed regardless of devlink resource,
>> as its read by the userspace for all mdev drivers.
>> 
>> If that is the case, why isn't that implemented in mdev code rather than
>> individual drivers? I don't understand.
>>
>It should be. It isn't yet.
>It is similar to how phys_port_name preparation was done in legacy way in individual drivers and later on moved to devlink.c
>So some other time, can move this to mdev core.

Okay, I see it now for "available_instances".

Please avoid the "max_mdevs" attribute. Devlink resources should handle
that, possibly in future.


>
> 
>> 
>> >
>> >>
>> >> >+
>> >> >+static struct attribute *mdev_dev_attrs[] = {
>> >> >+	&mdev_type_attr_max_mdevs.attr,
>> >> >+	&mdev_type_attr_available_instances.attr,
>> >> >+	NULL,
>> >> >+};
>> >> >+
>> >> >+static struct attribute_group mdev_mgmt_group = {
>> >> >+	.name  = "local",
>> >> >+	.attrs = mdev_dev_attrs,
>> >> >+};
>> >> >+
>> >> >+static struct attribute_group *mlx5_meddev_groups[] = {
>> >> >+	&mdev_mgmt_group,
>> >> >+	NULL,
>> >> >+};
>> >>
>> >> [...]
