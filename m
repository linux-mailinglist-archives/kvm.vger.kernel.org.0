Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9E1F434B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbfKHJaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:30:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55525 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730308AbfKHJaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 04:30:04 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so5388461wmb.5
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 01:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eRd0zmMB4Oip3e8n6DWloWHkrMJLlIZOg5WL86fDovg=;
        b=0NSpx/IDuQdnoIZy19Y0yM2QJt58YDICwJ4a7AMmOg48/omhFz00Y3Q7fjfm/u43pS
         qJoPv2TxzTidCqU4Yk+KCzg8RliD/nMvHjLYCL9c0cX0jN2V4noSCASC26saLAeIkPqY
         B0I+MLE22D+vDwKXA0hKALOrmVcEu1pRQ3Cv24z6vZhCi8eIhlJEEQvsQoPv5syyEA3+
         KHHBcFYYgqqe9H7QLxc9f4OtSkxXu1KaZJBSfRVoce1L7aKqElEruVQJRS6ejpTcibWr
         FSD5MV3h+aYhvB97vgIWI2eXYP9O93ZIcdrpsz9ulyaPcr83FZrftkrKcCREv4DCmhgo
         v63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eRd0zmMB4Oip3e8n6DWloWHkrMJLlIZOg5WL86fDovg=;
        b=c5JKHlrRTAS1N7akQynDcv92sv9wea3sos9NplF25ENnwfS1hWSINUZXIa0G7Unoq5
         L3o2373kcQ98Z4WbVc6c6ckN9AaaEUzaj99aN00GDtQ5zKyJBv1Ri59VS6+CLJfq6uE3
         RqVZgmUcwpqrf0prYAZ1EKCb/04snqS5FCh7UuR/XtMetvm4NW3GW7StIXGhI9uqKpFg
         Dclqmvy5i046eUhwIa6ql1eM7R8ik/VuLPrhj+Ji56g+DdT67HIO/Oprumb/MATHQ5fj
         0QnpUZRai6ixaSp+xAqKmxUyJmTg8f69ny0/4tB0ptBmRMQshb8KRh/ESuRwtJ1XcwrE
         L3mQ==
X-Gm-Message-State: APjAAAUb+dxzzjlUffbif4frO8krBWbhTNnqkE3qGqfExoQSKYgefngw
        J3LhELkJX9YjLMUShKiQjTOJyg==
X-Google-Smtp-Source: APXvYqxFxGq6zoV4dqGUNzRMeIm6xAvEtpyaWMtpTKpSJPx4AuHUcLsFpiL3EB2rj/hFxjSgv7WKcg==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr7630339wmi.67.1573205402525;
        Fri, 08 Nov 2019 01:30:02 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id z13sm5907160wrm.64.2019.11.08.01.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 01:30:02 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:30:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191108093001.GA6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107212024.61926e11@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fri, Nov 08, 2019 at 03:20:24AM CET, jakub.kicinski@netronome.com wrote:
>On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:

[...]

>> > > > > @@ -6649,6 +6678,9 @@ static int  
>> > > > __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,  
>> > > > >  		n = snprintf(name, len, "pf%uvf%u",
>> > > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>> > > > >  		break;
>> > > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
>> > > > > +		n = snprintf(name, len, "p%s", attrs->mdev.mdev_alias);  
>> > > >
>> > > > Didn't you say m$alias in the cover letter? Not p$alias?
>> > > >  
>> > > In cover letter I described the naming scheme for the netdevice of the
>> > > mdev device (not the representor). Representor follows current unique
>> > > phys_port_name method.  
>> > 
>> > So we're reusing the letter that normal ports use?
>> >  
>> I initially had 'm' as prefix to make it easy to recognize as mdev's port, instead of 'p', but during internal review Jiri's input was to just use 'p'.
>
>Let's way for Jiri to weigh in then.

Hmm, it's been so far I can't really recall. But looking at what we have
now:
DEVLINK_PORT_FLAVOUR_PHYSICAL "p%u"/"p%us%u"
DEVLINK_PORT_FLAVOUR_PCI_PF   "pf%u"
DEVLINK_PORT_FLAVOUR_PCI_VF   "pf%uvf%u"
For mdev, the ideal format would be:
"pf%um%s" or "pf%uvf%um%s", but that would be too long.
I guess that "m%s" is fine.
"p" is probably not a good idea as phys ports already have that.

[...]
