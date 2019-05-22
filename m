Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3652F260E0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfEVJ55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 05:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728527AbfEVJ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 05:57:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3A023084039;
        Wed, 22 May 2019 09:57:56 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C04608C2;
        Wed, 22 May 2019 09:57:53 +0000 (UTC)
Date:   Wed, 22 May 2019 11:57:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Message-ID: <20190522115751.104dd381.cohuck@redhat.com>
In-Reply-To: <VI1PR0501MB2271652CB38FC0C33656DC89D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-2-parav@mellanox.com>
        <VI1PR0501MB2271652CB38FC0C33656DC89D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 22 May 2019 09:57:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 19:54:59 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Seems 3rd patch will take few more days to settle down with new flag and its review.
> Given that fix of 3rd patch is fixing a different race condition, if patch 1 and 2 look ok, shall we move forward with those 2 fixes it in 5.2-rc?
> Fixes 1,2 prepare mdev to be usable for non vfio use case for the series we are working on.

I think it's fine to merge the first two patches (I've given my R-b.)

The only issue I'm aware of is that the vfio-ap code might need some
fixes as well; but I'll leave that to the vfio-ap folks to sort out.
