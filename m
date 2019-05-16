Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6D3205EA
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 13:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfEPLoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 07:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbfEPLon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 07:44:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEB5C3004419;
        Thu, 16 May 2019 11:44:43 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8164C2E19A;
        Thu, 16 May 2019 11:44:42 +0000 (UTC)
Date:   Thu, 16 May 2019 13:44:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] s390: vfio-ccw fixes
Message-ID: <20190516134440.35be758c.cohuck@redhat.com>
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 16 May 2019 11:44:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 01:42:41 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> They are based on 5.1.0, not Conny's vfio-ccw tree even though there are
> some good fixes pending for 5.2 there.  I've run this series both with
> and without that code, but couldn't decide which base would provide an
> easier time applying patches.  "I think" they should apply fine to both,
> but I apologize in advance if I guessed wrong!  :)

Patch 2 stumbled over a trivial-to-fix context change; else, things
applied cleanly.

Thanks, queued patches 1-4.
