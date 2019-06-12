Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DCC423E3
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfFLLSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:18:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfFLLSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:18:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99AB9C1EB1E0;
        Wed, 12 Jun 2019 11:18:54 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28E4560CD1;
        Wed, 12 Jun 2019 11:18:52 +0000 (UTC)
Date:   Wed, 12 Jun 2019 13:18:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/9] s390/cio: Use generalized CCW handler in
 cp_init()
Message-ID: <20190612131850.4a7efc04.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-5-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 12 Jun 2019 11:18:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:26 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> It is now pretty apparent that ccwchain_handle_ccw()
> (nee ccwchain_handle_tic()) does everything that cp_init()
> wants to do.
> 
> Let's remove that duplicated code from cp_init() and let
> ccwchain_handle_ccw() handle it itself.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)

Nice cleanup :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
