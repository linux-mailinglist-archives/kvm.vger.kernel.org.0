Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EB9ECA41
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 22:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKAV0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 17:26:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51431 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726230AbfKAV0q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 17:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572643605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5g1dJ83xYMje0MLz6efrEudvgOBSIp8W03RhGkcafY=;
        b=LxqfaOKd04iPOO8jb1Bt7b9p7res+leSiFwCZ6yWdHlh/4tdrc1Zu+HAt0mEY8lrbDPHW3
        75xxMeaw2S7J5EmO/SWNbxn0JGRK9gE050kp4VYgnuSRBTeeRnzt+L1PAh/Z1ax23JnU6I
        Ai3I5+3c8zbwEXgSHG3k2iB5ma5TTnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-oaJ7QoXIPLaDl976H0a7hg-1; Fri, 01 Nov 2019 17:26:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7551C800A1E;
        Fri,  1 Nov 2019 21:26:40 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D043F60870;
        Fri,  1 Nov 2019 21:26:37 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 447D7105176;
        Fri,  1 Nov 2019 19:19:15 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id xA1LJB2V020685;
        Fri, 1 Nov 2019 19:19:11 -0200
Date:   Fri, 1 Nov 2019 19:19:11 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH 4/5] cpuidle-haltpoll: add a check to ensure grow start
 value is nonzero
Message-ID: <20191101211908.GA20672@amt.cnet>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-5-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1572060239-17401-5-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: oaJ7QoXIPLaDl976H0a7hg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 26, 2019 at 11:23:58AM +0800, Zhenzhong Duan wrote:
> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
> guest_halt_poll_shrink). If guest_halt_poll_grow_start is zero,
> dev->poll_limit_ns will never be larger than zero.
>=20
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  drivers/cpuidle/governors/haltpoll.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

I would rather disallow setting grow_start to zero rather
than silently setting it to one on the back of the user.

