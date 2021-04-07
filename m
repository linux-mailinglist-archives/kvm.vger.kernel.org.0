Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0A356928
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350784AbhDGKPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:15:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350765AbhDGKPc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617790507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHKNxI/KnDrBpIC4c9Oeb/QbZZEcDJOFc5wPyAfiqJI=;
        b=a1/AC1VIt81dzvnnS8eNUTjYXnf588lJ2HRYMrAyq+sbULG6WhhvFDIm0L3j80TGczgxym
        PzQzKiHo4kCsw+DQjte7LBIjohoTfzeD9rjToJ35dQv12+jtGl3VJQ2g6VgzT16Aq1O1SG
        N6byu5jL0T0KIbM2oMCnc/kYtPN8cNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-AZoLgi0zMYybey72uAuxMw-1; Wed, 07 Apr 2021 06:15:04 -0400
X-MC-Unique: AZoLgi0zMYybey72uAuxMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DB69107ACC7;
        Wed,  7 Apr 2021 10:15:03 +0000 (UTC)
Received: from gondolin (ovpn-113-88.ams2.redhat.com [10.36.113.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB6491000324;
        Wed,  7 Apr 2021 10:14:58 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:14:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 11/16] s390x: css: No support for
 MIDAW
Message-ID: <20210407121456.6a76f82f.cohuck@redhat.com>
In-Reply-To: <6112a74d-1536-830c-e665-64f508462f0f@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-12-git-send-email-pmorel@linux.ibm.com>
        <20210406175805.304b8abb.cohuck@redhat.com>
        <6112a74d-1536-830c-e665-64f508462f0f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 12:06:03 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 4/6/21 5:58 PM, Cornelia Huck wrote:
> > On Tue,  6 Apr 2021 09:40:48 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> Verify that using MIDAW triggers a operand exception.  
> > 
> > This is only for current QEMU; a future QEMU or another hypervisor may
> > support it. I think in those cases the failure mode may be different
> > (as the ccw does not use midaws?)  
> 
> Yes, should I let fall this test case?

I'm not sure how much value it adds, so I'm for dropping it.

Any other opinions?

