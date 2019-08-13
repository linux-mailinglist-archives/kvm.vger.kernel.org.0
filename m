Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B848BEAE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 18:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfHMQe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 12:34:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfHMQe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 12:34:57 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF48E300D21F;
        Tue, 13 Aug 2019 16:34:56 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D02A794BE;
        Tue, 13 Aug 2019 16:34:52 +0000 (UTC)
Date:   Tue, 13 Aug 2019 18:34:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190813183449.703b2bf2.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 13 Aug 2019 16:34:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 16:28:53 +0000
Parav Pandit <parav@mellanox.com> wrote:

> In bigger objective, I wanted to discuss post this cleanup patch, is to expand mdev to have more user friendly device names.

Uh, what is unfriendly about uuids?

> 
> Before we reach there, I should include a patch that eliminates storing UUID itself in the mdev_device.

I do not think that's a great idea. A uuid is, well, a unique
identifier. What's so bad about it that it should be eliminated?

> 
> > Also, let's not
> > overstate what this particular API callback provides, it's simply access to the
> > uuid of the device, which is a fundamental property of a mediated device.  
> This fundamental property is available in form of device name already.

Let me reiterate that the device name is a string containing a
formatted uuid, not a uuid.

> 
> > API was added simply to provide data abstraction, allowing the struct
> > mdev_device to be opaque to vendor drivers.  Thanks,
> >   
> I get that part. I prefer to remove the UUID itself from the structure and therefore removing this API makes lot more sense?

What I don't get is why you want to eliminate the uuid in the first
place? Again, what's so bad about it?
