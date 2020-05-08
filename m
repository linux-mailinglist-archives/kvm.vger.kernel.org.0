Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D211E1CA8DE
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEHLAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 07:00:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726091AbgEHLAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 07:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588935610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JyRWIuVrAYOFin3V3Gd3+xo18KzWAt8o59PzgDsGUjQ=;
        b=hFfMCWOolQmgC51r1IYKM4ZjZxp+VID4VnUJNJS6fRGlI3J4cG4EdACqKMkKTMhLP3KHEZ
        QN5O2KeXJwM2FvoFSO+aiok2rlUPbXVcR7SRwcqwAf1z+waaff0Z0kD+Yc0oT9QpC+CTx1
        4AiMog9rNT7IzdLS+/To2HHlN2n3og8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-7s1aJyLiMJujSorXkV_0nQ-1; Fri, 08 May 2020 07:00:08 -0400
X-MC-Unique: 7s1aJyLiMJujSorXkV_0nQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35F8F1009610;
        Fri,  8 May 2020 11:00:07 +0000 (UTC)
Received: from gondolin (ovpn-112-144.ams2.redhat.com [10.36.112.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149BC707A6;
        Fri,  8 May 2020 11:00:00 +0000 (UTC)
Date:   Fri, 8 May 2020 12:59:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-ccw: document possible errors
Message-ID: <20200508125958.3c0d3ee5.cohuck@redhat.com>
In-Reply-To: <20200407111605.1795-1-cohuck@redhat.com>
References: <20200407111605.1795-1-cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 13:16:05 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Interacting with the I/O and the async regions can yield a number
> of errors, which had been undocumented so far. These are part of
> the api, so remedy that.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  Documentation/s390/vfio-ccw.rst | 54 ++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)

Queued with the mentioned minor changes.

