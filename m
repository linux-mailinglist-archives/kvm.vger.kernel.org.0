Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D011E0D8
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLMJd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 04:33:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725799AbfLMJd4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 04:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576229635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nh3zCbxtjCl18S6Q04ND1zkG9HFChL+lTbaFNn3qp4I=;
        b=dRlE4aSOQV6gib4SM6mkP5OlsuP+5USeq1l6cwmhVsI4iLg3FrkmyvQE6gwdeyl6D7UMip
        zfdXuBvT3oO6xtKQnAOoEQ+nXBaaBHURLN+sn18E0NY2YqDGPmDsx+shldWHV2FfCS0Oi6
        Vn9QU5dmK+b43i62oCypT6ksY/kV85I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-J7FaUXLFMcitnQ45hteM6w-1; Fri, 13 Dec 2019 04:33:54 -0500
X-MC-Unique: J7FaUXLFMcitnQ45hteM6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD78B800D41;
        Fri, 13 Dec 2019 09:33:52 +0000 (UTC)
Received: from gondolin (ovpn-116-226.ams2.redhat.com [10.36.116.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B0F163647;
        Fri, 13 Dec 2019 09:33:49 +0000 (UTC)
Date:   Fri, 13 Dec 2019 10:33:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
Message-ID: <20191213103346.1e42d52b.cohuck@redhat.com>
In-Reply-To: <d34fdb07-c2ff-3a1e-eb31-cf9d160ebac9@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
        <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
        <20191212130111.0f75fe7f.cohuck@redhat.com>
        <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
        <20191212151002.1c7ca4eb.cohuck@redhat.com>
        <c92089cf-39f4-3b64-79a8-3264654130b1@linux.ibm.com>
        <20191212153303.6444697e.cohuck@redhat.com>
        <a29048f4-1783-54c6-8bf3-91d573b2d49d@linux.ibm.com>
        <d34fdb07-c2ff-3a1e-eb31-cf9d160ebac9@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Dec 2019 18:33:15 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> After all, I make it simple by testing if the MSCH works as expected, no 
> retry, no delay.
> This is just a test.

That's probably fine if you only run under kvm (not sure what your
further plans here are).

> 
> I will add a new patch to add a library function to enable the channel, 
> with retry to serve when we really need to enable the channel, not to test.

A simple enable should be enough for kvm-only usage, we can add a retry
easily if needed.

We probably can also defer adding the library function until after we
get another user :)

