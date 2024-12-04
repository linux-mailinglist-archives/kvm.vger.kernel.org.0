Return-Path: <kvm+bounces-33060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C329E433B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07272B63DA9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABB31A8F75;
	Wed,  4 Dec 2024 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLb725TZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91178156997
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733336227; cv=none; b=AwSnBaDXofErfGtks1J1h5rwhU4hLOT6N8QyhyTeqk3/FsLRKcPAKLtzyMLmXNh2pvjf8NKs4c0pPgwZ5wgbbR6rXUXlVtlt6+q5Xys2958aSlKb7HUqbWBF/e+BviYOVFKB5BpSPr6mxR31vNKfsK6R5z/FmUD+EEtelsdGHbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733336227; c=relaxed/simple;
	bh=w85VI+PNVYvSUtAszjBNpanvGWkNg924XHVLCuI9X90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQNKHNSzSHnEijZk8qd+zipn5v9Woq8LuoSb1Z8M2i5kWPyAoZ9tq2pop0cuLp79MIZ0DnuhqLgDw9dAe8/6/TiXgqBmrdpwijBOIhy3ZUhEDf1Sz+mvcZokyl1IrFnuzqhS6Gvn7UINnle9SvILY7os7Ekv00qRkAOvFI2hgRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLb725TZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A689DC4CECD;
	Wed,  4 Dec 2024 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733336227;
	bh=w85VI+PNVYvSUtAszjBNpanvGWkNg924XHVLCuI9X90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLb725TZ36qyHfj65Klxv4wggmjKBBhFTDI3SHp7H23w7k7qllakkSWvOVFh0417U
	 pZIk2tiJnZChlgVkSJ3HUPRFxUj4JJc82SZL9+/HS5CVwMEu/BZ6TvvgAEPsaCc23O
	 fqsgGO2IaClH4FIKMxWWD8qIPKcguqU0qq3qxKl0=
Date: Wed, 4 Dec 2024 19:17:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core: class: add class_pseudo_register
Message-ID: <2024120407-partake-pounce-67be@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <b8122113-5863-4057-81b5-73f86c9fde4d@gmail.com>
 <2024120435-deserving-elf-c1e1@gregkh>
 <169a836b-2cab-40a1-8c92-4ee4c979dd3b@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169a836b-2cab-40a1-8c92-4ee4c979dd3b@gmail.com>

On Wed, Dec 04, 2024 at 06:04:32PM +0100, Heiner Kallweit wrote:
> On 04.12.2024 10:33, Greg Kroah-Hartman wrote:
> > On Tue, Dec 03, 2024 at 09:10:05PM +0100, Heiner Kallweit wrote:
> >> In preparation of removing class_compat support, add a helper for
> >> creating a pseudo class in sysfs. This way we can keep class_kset
> >> private to driver core. This helper will be used by vfio/mdev,
> >> replacing the call to class_compat_create().
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >>  drivers/base/class.c         | 14 ++++++++++++++
> >>  include/linux/device/class.h |  1 +
> >>  2 files changed, 15 insertions(+)
> >>
> >> diff --git a/drivers/base/class.c b/drivers/base/class.c
> >> index 582b5a02a..f812236e2 100644
> >> --- a/drivers/base/class.c
> >> +++ b/drivers/base/class.c
> >> @@ -578,6 +578,20 @@ struct class_compat *class_compat_register(const char *name)
> >>  }
> >>  EXPORT_SYMBOL_GPL(class_compat_register);
> >>  
> >> +/**
> >> + * class_pseudo_register - create a pseudo class entry in sysfs
> >> + * @name: the name of the child
> >> + *
> >> + * Helper for creating a pseudo class in sysfs, keeps class_kset private
> >> + *
> >> + * Returns: the created kobject
> >> + */
> >> +struct kobject *class_pseudo_register(const char *name)
> >> +{
> >> +	return kobject_create_and_add(name, &class_kset->kobj);
> >> +}
> >> +EXPORT_SYMBOL_GPL(class_pseudo_register);
> > 
> > I see the goal here, but let's not continue on and create fake kobjects
> > in places where there should NOT be any kobjects.  Also, you might get
> > in trouble when removing this kobject as it thinks it is a 'struct
> > class' but yet it isn't, right?  Did you test that?
> > 
> 
> It's removed using kobject_put(), same as what class_compat_unregister() does.
> I only compile-tested the changes.

I would not be able to take these unless someone actually runs them as
the kobject removal here might be getting confused a bit.

thanks,

greg k-h

