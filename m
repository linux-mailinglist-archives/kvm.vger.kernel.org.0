Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1663248158
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHRJGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:06:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53789 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726473AbgHRJGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 05:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597741603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7T9mpdruf8/QbUxmM0HKIFYsILTP2sJfo1DUZlpHsno=;
        b=f1bSGFXcw8iFqBoFMDZT7kmVP9X55zfYHd8+mqKOHEWCm8C3eEfIxNBs8CyS2Ft8EiduHr
        6BztyuflYYYw39yPU8//G/dUGI6SNZz0aw8plW5ADhEUep17wg/u073stFNt0SKmvzjR2w
        K14LhMSt27XVeAGXG5vG5RCBAbCebpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-vpgG3SJYObuxw_q781AWlQ-1; Tue, 18 Aug 2020 05:06:41 -0400
X-MC-Unique: vpgG3SJYObuxw_q781AWlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC45C81F02B;
        Tue, 18 Aug 2020 09:06:38 +0000 (UTC)
Received: from gondolin (ovpn-112-221.ams2.redhat.com [10.36.112.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED7F5C716;
        Tue, 18 Aug 2020 09:06:19 +0000 (UTC)
Date:   Tue, 18 Aug 2020 11:06:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        eskultet@redhat.com, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200818110617.05def37c.cohuck@redhat.com>
In-Reply-To: <20200818085527.GB20215@redhat.com>
References: <20200805021654.GB30485@joy-OptiPlex-7040>
        <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
        <20200805075647.GB2177@nanopsycho>
        <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
        <20200805093338.GC30485@joy-OptiPlex-7040>
        <20200805105319.GF2177@nanopsycho>
        <20200810074631.GA29059@joy-OptiPlex-7040>
        <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
        <20200814051601.GD15344@joy-OptiPlex-7040>
        <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
        <20200818085527.GB20215@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 09:55:27 +0100
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > Another point, as we discussed in another thread, it's really hard to m=
ake
> > sure the above API work for all types of devices and frameworks. So hav=
ing a
> > vendor specific API looks much better. =20
>=20
> From the POV of userspace mgmt apps doing device compat checking / migrat=
ion,
> we certainly do NOT want to use different vendor specific APIs. We want to
> have an API that can be used / controlled in a standard manner across ven=
dors.

As we certainly will need to have different things to check for
different device types and vendor drivers, would it still be fine to
have differing (say) attributes, as long as they are presented (and can
be discovered) in a standardized way?

(See e.g. what I came up with for vfio-ccw in a different branch of
this thread.)

E.g.
version=3D
<type>.type_specific_value0=3D
<type>.type_specific_value1=3D
<vendor_driver>.vendor_driver_specific_value0=3D

with a type or vendor driver having some kind of
get_supported_attributes method?

