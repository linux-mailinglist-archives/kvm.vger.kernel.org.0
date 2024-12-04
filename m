Return-Path: <kvm+bounces-33059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5239E45D9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B7D9B3B7EB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859901A8F62;
	Wed,  4 Dec 2024 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miqNfU3/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D172391B8
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733336167; cv=none; b=qC0ajiaP9YWtcRqR4nSFA4ePU9Aj8fb/zQee2vhYFl7+1A6I5HqGFcsUyNhvto+47lCQC6bD7/jz9bOSwGZhCnGoGO6t6uQddE9aFMTLFB5DWF+l55NM+D3hR3wXEx6OHyvD9i0aQGd1SU130cTJBGXnW4Fx0filGIygvJPDOdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733336167; c=relaxed/simple;
	bh=OQ/DTeSHuXcQ3cs9GY6uWtcOsCFC+KsZnoZMd6/m3/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPWe5s6q8JKS4HwTrkyx01Fx9jVCflyV/p00439Uu1JtCCnCLcTpgtbLzh0kjzdnXkESOKgrUC6UPfCESUGmMkoC8dtAtkdFOMj2ISyu7qs6tv9dheYxeGjhliIqPztnBLvtSkThxVQNjIxuuZifFb9DmoJ0AK8myULlMfXha4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miqNfU3/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71076C4CECD;
	Wed,  4 Dec 2024 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733336166;
	bh=OQ/DTeSHuXcQ3cs9GY6uWtcOsCFC+KsZnoZMd6/m3/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=miqNfU3/uJZvnbHAvw/kPMs3tp5XuuuOMhS5s6ZMeL88xVoXDxG39P9Oe7sDNz1HJ
	 ev+HESzCtVEdciUA4+WaYwDE04Bq9qFjugFtcpT3h7WPAl0pW7SH7Dv4yBOFHm1xqz
	 +nebS/kojoNqHfCwvcF4Z1qQ00QFhMbFWOxxxk2M=
Date: Wed, 4 Dec 2024 19:16:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <2024120410-promoter-blandness-efa1@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>

On Wed, Dec 04, 2024 at 06:01:36PM +0100, Heiner Kallweit wrote:
> On 04.12.2024 10:32, Greg Kroah-Hartman wrote:
> > On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:
> >> vfio/mdev is the last user of class_compat, and it doesn't use it for
> >> the intended purpose. See kdoc of class_compat_register():
> >> Compatibility class are meant as a temporary user-space compatibility
> >> workaround when converting a family of class devices to a bus devices.
> > 
> > True, so waht is mdev doing here?
> > 
> >> In addition it uses only a part of the class_compat functionality.
> >> So inline the needed functionality, and afterwards all class_compat
> >> code can be removed.
> >>
> >> No functional change intended. Compile-tested only.
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
> >>  1 file changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> >> index ed4737de4..a22c49804 100644
> >> --- a/drivers/vfio/mdev/mdev_core.c
> >> +++ b/drivers/vfio/mdev/mdev_core.c
> >> @@ -18,7 +18,7 @@
> >>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
> >>  #define DRIVER_DESC		"Mediated device Core Driver"
> >>  
> >> -static struct class_compat *mdev_bus_compat_class;
> >> +static struct kobject *mdev_bus_kobj;
> > 
> > 
> > 
> >>  
> >>  static LIST_HEAD(mdev_list);
> >>  static DEFINE_MUTEX(mdev_list_lock);
> >> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> >>  	if (ret)
> >>  		return ret;
> >>  
> >> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
> >> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));
> > 
> > This feels really wrong, why create a link to a random kobject?  Who is
> > using this kobject link?
> > 
> >>  	if (ret)
> >>  		dev_warn(dev, "Failed to create compatibility class link\n");
> >>  
> >> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
> >>  	dev_info(parent->dev, "MDEV: Unregistering\n");
> >>  
> >>  	down_write(&parent->unreg_sem);
> >> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> >> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
> >>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
> >>  	parent_remove_sysfs_files(parent);
> >>  	up_write(&parent->unreg_sem);
> >> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
> >>  	if (ret)
> >>  		return ret;
> >>  
> >> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
> >> -	if (!mdev_bus_compat_class) {
> >> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");
> > 
> > But this isn't a class, so let's not fake it please.  Let's fix this
> > properly, odds are all of this code can just be removed entirely, right?
> > 
> 
> After I removed class_compat from i2c core, I asked Alex basically the
> same thing: whether class_compat support can be removed from vfio/mdev too.
> 
> His reply:
> I'm afraid we have active userspace tools dependent on
> /sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
> devices here and I believe it's the only way for userspace to find
> those parent devices registered for creating mdev devices.  If there's a
> desire to remove class_compat, we might need to add some mdev
> infrastructure to register the class ourselves to maintain the parent
> links.
> 
> 
> It's my understanding that /sys/class/mdev_bus has nothing in common
> with an actual class, it's just a container for devices which at least
> partially belong to other classes. And there's user space tools depending
> on this structure.

That's odd, when this was added, why was it added this way?  The
class_compat stuff is for when classes move around, yet this was always
done in this way?

And what tools use this symlink today that can't be updated?

thanks,

greg k-h

