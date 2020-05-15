Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53B1D46D0
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgEOHLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:11:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726604AbgEOHLk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 03:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589526699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mc9kG8LAPsO0qKOlkofqgHjGFnV3phaduS+Q8YgAvZU=;
        b=EPzupSIoceU+tZ1pE0f8Gw4nrm6l+Hg56h5/3bLebXGaLG8sVWseKFj211hX4ugA+uYjGY
        W4TPW8GYRRERG1Wz1m/2VIkMz0yaA4FCuh1Fmkz+PEpuob7p4p9FoePwS8xUub7Lf9vDML
        5dJRUOUTXlT1kwWNcA6cemce9hoNT2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-Vtazt2_aOey4ZLdar6xjkA-1; Fri, 15 May 2020 03:11:35 -0400
X-MC-Unique: Vtazt2_aOey4ZLdar6xjkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE60A1899528;
        Fri, 15 May 2020 07:11:33 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCB1662474;
        Fri, 15 May 2020 07:11:29 +0000 (UTC)
Date:   Fri, 15 May 2020 09:11:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 05/10] s390x: Library resources for
 CSS tests
Message-ID: <20200515091127.3cd629d7.cohuck@redhat.com>
In-Reply-To: <42beb241-8cc1-51a1-b374-3fb89968df36@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-6-git-send-email-pmorel@linux.ibm.com>
        <20200514140315.6077046b.cohuck@redhat.com>
        <42beb241-8cc1-51a1-b374-3fb89968df36@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 09:02:37 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-05-14 14:03, Cornelia Huck wrote:
> > On Fri, 24 Apr 2020 12:45:47 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> + * - IRB  : Interuption response Block, describes the result of an operation  
> > 
> > s/operation/operation;/  
> 
> ? I do not understand, do you want a ";" at the end of "operation"

Yes, I think that makes the description read more like a proper
sentence (describe what its purpose is; describe its contents).

> Isn't it a typo error?
> 
> >   
> >> + *          holds a SCSW and model-dependent data.

