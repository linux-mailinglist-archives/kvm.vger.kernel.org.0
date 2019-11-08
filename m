Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2134AF5112
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 17:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfKHQ2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 11:28:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37664 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfKHQ2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 11:28:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id q130so6853554wme.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 08:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qfw5+H5+VmRkk4Ngvgedyo88XB4FJADrjMcpnGrVOlM=;
        b=kVwQhDRdB+PtDsgGYBN4ieYVRQFhPWUmmm7I4+MwKbUE/w96AHS5jaQE2ALn+NLQjx
         nRwiQs7KBIh1oEeFNQgpf1ahq0vO8GaXH8rECuB81idG2G9jH6wH70nazQsOmmAQZeuL
         BHos7sM45dMUzR3EL40enqoTeMS+XPJcmz17sSEG8ljs2BBPstC+7PABDJ6MXKtEDizH
         bFFfPnwFl266yn7sLDEuU32lWobBJYI1lFxg3cRs9eU8ybUCqsDnCReT9DA1uuUUX6GH
         r4gll9sloNUprhxU7igSGkoFy1lkWOeZLRse9CV7AP2QetKhopbTqNrH/RjGaSjgLuQH
         pceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qfw5+H5+VmRkk4Ngvgedyo88XB4FJADrjMcpnGrVOlM=;
        b=gL9m61wMCom5vYcI0Ao9NkGqcTUW3PAohhhHgpArjonkgMl0zwfNyG1zzhdEefKnvj
         5rmO6FrSJJ0FBjsskq+oN4M7/aHhOHkKrEu4vcMYYzZ71HZu4Mw6uumGnG3GnloxfM/R
         lJxvhl4kJlWHDKzOoWTxWys+QOrqNxP6xHEZT2Gn1FHsJZx0qjgTK6DwnAyI1n2SHioD
         /MnLk12Jon8YmIswgyQ6CARPRo/2upfCCLicXIuYrsQhqN21bcezhiCQpn3Jq9Eep0ca
         08yq9Qx+3nuXyO5IQpkh47S84MbCXHh1qITLvtUIxoh2FKTnRUbocLyI99zhc4qmojei
         /D8g==
X-Gm-Message-State: APjAAAU6LQTwPvJwtuj0jsJQcPUJs75WdfEgG+h1Jf2pKO1sJNylfth9
        VD8Oh822AyCWaVhY/sbo+dfU/g==
X-Google-Smtp-Source: APXvYqzpb9EnZi/4lRhF2ee6bghRGriqVMLc9rb5ubvCJ+9fxX3LCe/M6BbPWImctFMPwDj9ntURng==
X-Received: by 2002:a1c:4089:: with SMTP id n131mr9410705wma.86.1573230484274;
        Fri, 08 Nov 2019 08:28:04 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id 16sm9805181wmf.0.2019.11.08.08.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 08:28:03 -0800 (PST)
Date:   Fri, 8 Nov 2019 17:28:03 +0100
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
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev alias
Message-ID: <20191108162803.GO6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-7-parav@mellanox.com>
 <20191108110456.GH6990@nanopsycho>
 <AM0PR05MB48667AF9F6EACF0CE1688262D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48667AF9F6EACF0CE1688262D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fri, Nov 08, 2019 at 04:59:53PM CET, parav@mellanox.com wrote:

[...]

>> >+	if (parent->ops->get_alias_length) {
>> >+		unsigned int alias_len;
>> >+
>> >+		alias_len = parent->ops->get_alias_length();
>> >+		if (alias_len) {
>> 
>> I think this should be with WARN_ON. Driver should not never return such
>> 0 and if it does, it's a bug.
>>
>Ok. will add it.
> 
>> Also I think this check should be extended by checking value is multiple of 2.
>Do you mean driver must set alias length as always multiple of 2? Why?

Why not? Why would driver want to have even len? If say 11 is too long,
it should return 10. The last byte for even is set by your code
to '0' anyway...


>
>> Then you can avoid the roundup() above. No need to allow even len.
>Did you mean "no need to allow odd"? or? 

Yes, odd.


> 
>> 
>> [...]
>> 
>> >diff --git a/drivers/vfio/mdev/mdev_sysfs.c
>> >b/drivers/vfio/mdev/mdev_sysfs.c index 7570c7602ab4..43afe0e80b76
>> >100644
>> >--- a/drivers/vfio/mdev/mdev_sysfs.c
>> >+++ b/drivers/vfio/mdev/mdev_sysfs.c
>> >@@ -63,15 +63,18 @@ static ssize_t create_store(struct kobject *kobj,
>> struct device *dev,
>> > 		return -ENOMEM;
>> >
>> > 	ret = guid_parse(str, &uuid);
>> >-	kfree(str);
>> > 	if (ret)
>> >-		return ret;
>> >+		goto err;
>> >
>> >-	ret = mdev_device_create(kobj, dev, &uuid);
>> >+	ret = mdev_device_create(kobj, dev, str, &uuid);
>> 
>> Why to pass the same thing twice? Move the guid_parse() call to the
>> beginning of mdev_device_create() function.
>>
>Because alias should be unique and need to hold the lock while searching for duplicate.
>So it is not done twice, and moving guid_parse() won't help due to need of lock.

I'm not saying anything about a lock. Not sure why do you think so.
I'm saying that you pass the same value in 2 args. That's it.
Better to pass it as char* only and process it inside.
If by guid_parse() or otherwise, does not matter. That is my point.

> 
>> 
>> > 	if (ret)
>> >-		return ret;
>> >+		goto err;
>> >
>> >-	return count;
>> >+	ret = count;
>> >+
>> >+err:
>> >+	kfree(str);
>> >+	return ret;
>> > }
>> >
>> > MDEV_TYPE_ATTR_WO(create);
>> 
>> [...]
