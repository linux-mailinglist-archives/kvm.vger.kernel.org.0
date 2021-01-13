Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3572F49BC
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbhAMLKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:10:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbhAMLKp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 06:10:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610536159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ta5KowgD5SbxEhCb/p5ttMnInAN1M6Mm7tnQr0MO3IY=;
        b=KuMA3xU7brn+sAE4sMkt3R06G9HLmw4Ph1aCrgfhp6N7xpLeUKb8oYnlISlObzyWVpcI0m
        89L+98RAmVn5UPy7vad8flBAbna9SlKirP+03jFkqRFMncG7kdB4nQ615aXE3bKBxarBA4
        nHWrZFEkhon6RqiMSpRfFZJTlJonDM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-5nz6rWPzPKakNe4O7qkRSg-1; Wed, 13 Jan 2021 06:09:17 -0500
X-MC-Unique: 5nz6rWPzPKakNe4O7qkRSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17043107ACF7;
        Wed, 13 Jan 2021 11:09:16 +0000 (UTC)
Received: from gondolin (ovpn-114-8.ams2.redhat.com [10.36.114.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A89A5C253;
        Wed, 13 Jan 2021 11:09:11 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:09:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset
 comment
Message-ID: <20210113120909.5df06717.cohuck@redhat.com>
In-Reply-To: <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-10-frankja@linux.ibm.com>
        <6f93c964-9606-246c-7266-85044803e49b@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 11:25:45 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 12.01.21 14:20, Janosch Frank wrote:
> > Let's make it clear that there is something at the end of the
> > struct. The exact offset is reported by the cpu_offset member.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  lib/s390x/sclp.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> > index dccbaa8..395895f 100644
> > --- a/lib/s390x/sclp.h
> > +++ b/lib/s390x/sclp.h
> > @@ -134,7 +134,10 @@ typedef struct ReadInfo {
> >  	uint8_t reserved7[134 - 128];
> >  	uint8_t byte_134_diag318 : 1;
> >  	uint8_t : 7;
> > -	struct CPUEntry entries[0];
> > +	/*
> > +	 * The cpu entries follow, they start at the offset specified
> > +	 * in offset_cpu.
> > +	 */  
> 
> I mean, that's just best practice. At least when I spot "[0];" and the
> end of a struct, I know what's happening.

Agreed.

> 
> No strong opinion about the comment, I wouldn't need it to understand it.

I'd keep it as-is; maybe add a comment where offset_cpu points to?

> 
> >  } __attribute__((packed)) ReadInfo;
> >  
> >  typedef struct ReadCpuInfo {
> >   
> 
> 

