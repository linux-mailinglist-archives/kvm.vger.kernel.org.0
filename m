Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A18151A96
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBDMfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:35:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727127AbgBDMfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 07:35:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580819708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j8Ze2k/48T7ypOx2Rm4M44WtrOODhWxg8OlktpwSU50=;
        b=XCH8EOaUY1za/Q1bF/J61mfzpH8z9tGgphv4XndgAxGH1AsPlSLyl5hynxMp3BdcqMjzB6
        NNGwdnxcFO0fm+QjBpwVCtGKNM4EgdSwol9ms8Qu3E4Yqu+AB2AY9x+B1Lvy8q/erm09yc
        PsyXUzCBjOkFHMdfruFds5VIDqRfJyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311--mquGWQMODKRuxC6PwBksg-1; Tue, 04 Feb 2020 07:35:04 -0500
X-MC-Unique: -mquGWQMODKRuxC6PwBksg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9241C10753FB;
        Tue,  4 Feb 2020 12:35:03 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1569060BE0;
        Tue,  4 Feb 2020 12:34:56 +0000 (UTC)
Date:   Tue, 4 Feb 2020 13:34:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 07/37] KVM: s390: add new variants of UV CALL
Message-ID: <20200204133455.050de29b.cohuck@redhat.com>
In-Reply-To: <20200204133002.5ddf78fd@p-imbrenda>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-8-borntraeger@de.ibm.com>
        <20200204131107.6c7b3dae.cohuck@redhat.com>
        <20200204133002.5ddf78fd@p-imbrenda>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 13:30:02 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Tue, 4 Feb 2020 13:11:07 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> [...]
> 
> >   
> > > +	rc = uv_call_sched(0, (u64)&uvcb);
> > > +	if (ret)
> > > +		*ret = *(u32 *)&uvcb.header.rc;    
> > 
> > Does that rc value in the block contain anything sensible if you
> > didn't get cc==0?  
> 
> yes, RC is always meaningful. 
> 
> CC == 0 implies RC == 1, which means success.
> CC == 1 implies RC != 1, which means something went wrong in some way
> 
> in theory you could always disregard CC and only check RC

Ok, thx.

