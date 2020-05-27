Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702AA1E38F6
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 08:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgE0GTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 02:19:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44638 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727990AbgE0GTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 02:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590560383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxfwzRNG95Oxyrb9f3NJd3/tCgACFOCY/En2PVe3ZWQ=;
        b=CZbTdZ6NhUNzA2ektL7u11fQM/1WS8pWsm4RvaHOH+8vKr3RQOx+3zsQ2KEJJ0/RN5lIlo
        AfcfpCXalTk8CAODz9eFf3/DCgjnjVp+VTskaRjL4qXFvCbk7mnrkb5xECwgHk3sTsHolG
        q6WK+dB/kLE7eBP+zW6hWeF34jWOvMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-OmxVI4bbM9WkoEHBo--1jQ-1; Wed, 27 May 2020 02:19:39 -0400
X-MC-Unique: OmxVI4bbM9WkoEHBo--1jQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7265835B41;
        Wed, 27 May 2020 06:19:37 +0000 (UTC)
Received: from gondolin (ovpn-112-223.ams2.redhat.com [10.36.112.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE3C11CA;
        Wed, 27 May 2020 06:19:36 +0000 (UTC)
Date:   Wed, 27 May 2020 08:19:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-ccw: document possible errors
Message-ID: <20200527081934.2dceda89.cohuck@redhat.com>
In-Reply-To: <ed9b7c9b-3dc7-e573-55a8-d52f28877da9@linux.ibm.com>
References: <20200407111605.1795-1-cohuck@redhat.com>
        <55932365-3d36-1629-5d65-06c71e8231f9@linux.ibm.com>
        <20200508125541.72adc626.cohuck@redhat.com>
        <ed9b7c9b-3dc7-e573-55a8-d52f28877da9@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 May 2020 15:39:22 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/8/20 6:55 AM, Cornelia Huck wrote:
> > On Fri, 17 Apr 2020 12:33:18 -0400
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> On 4/7/20 7:16 AM, Cornelia Huck wrote:  
> >>> Interacting with the I/O and the async regions can yield a number
> >>> of errors, which had been undocumented so far. These are part of
> >>> the api, so remedy that.    
> >>
> >> (Makes a note to myself, to do the same for the schib/crw regions we're
> >> adding for channel path handling.)  
> > 
> > Yes, please :) I plan to merge this today, so you can add a patch on
> > top.  
> 
> I finally picked this up and realized that the io and async regions both
> document the return codes that would be stored in a field within their
> respective regions. The schib/crw regions don't have any such field, so
> the only values to be documented are the ones that the .read callback
> itself returns. What obvious thing am I missing?

The fact that you are right :)

No need to do anything, I might have spread my own confusion here ;)

