Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A901C724C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgEFN7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:59:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50219 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725915AbgEFN7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588773560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjZokrbJOMlp/7YCieJ8Es8p82IPSqWhzI4zUigA26A=;
        b=HwPB3V15y2LBMlrhIhGJ4Zcz6jtm5FDlGCq4/JPAysj0Bgx5DozMNkVdWULj4PiIAqyW9e
        xwc954XzknQ3CD9Wed5UyuyVsggU4Vyu9aRlqfvAAVHJBGpxLWSub/aboU2im/kcl0+9Ys
        YjaWbVhO82e1luLRdlJfbwBTpOy5KZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-1AxOEMdWNDKhOpC9QMIqtA-1; Wed, 06 May 2020 09:59:18 -0400
X-MC-Unique: 1AxOEMdWNDKhOpC9QMIqtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 243BE1005510;
        Wed,  6 May 2020 13:59:17 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B330899D2;
        Wed,  6 May 2020 13:59:15 +0000 (UTC)
Date:   Wed, 6 May 2020 15:59:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v4 0/8] s390x/vfio-ccw: Channel Path Handling [KVM]
Message-ID: <20200506155912.478a2ac5.cohuck@redhat.com>
In-Reply-To: <14c3cf68-c1e5-b46f-d75e-955dbdd63df8@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
        <20200505145435.40113d4c.cohuck@redhat.com>
        <14c3cf68-c1e5-b46f-d75e-955dbdd63df8@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 May 2020 09:00:20 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/5/20 8:56 AM, Cornelia Huck wrote:
> > On Tue,  5 May 2020 14:27:37 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:

> >>  
> >>> One thing though that keeps coming up: do we need any kind of
> >>> serialization? Can there be any confusion from concurrent reads from
> >>> userspace, or are we sure that we always provide consistent data?    
> >>
> >> I _think_ this is in good shape, though as suggested another set of
> >> eyeballs would be nice. There is still a problem on the main
> >> interrupt/FSM path, which I'm not attempting to address here.  
> > 
> > I'll try to think about it some more.  

I've convinced myself that the patches do not add any new races on top
of what already might be lurking in the existing code.

> 
> Re: interrupt/FSM, I now have two separate patches that each straighten
> things out on their own.  And a handful of debug patches that probably
> only make things worse.  :)  I'll get one/both of those meaningful
> patches sent to the list so we can have that discussion separately from
> this code.

Yes, let's do that on top.

I think that the series looks good now, but I'd still like to see
someone else give it a quick look before I queue it.

