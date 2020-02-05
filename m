Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29446153560
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBEQjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:39:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726534AbgBEQjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 11:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580920739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWD6UJ2NIuZR9K+CMe6lwRSiCWkCNn9RlwiMxiL1gP8=;
        b=KpHj74He/FH7FukbQa9sm8fqjAIPftud4kSBXa+Nclg6d7P/Fi4dfmCL7Jm20h3hPC5z5l
        Mz2qP8lfyHhWloypemTx3jNUz7pjwOPzkj0GC4QYjaFErbkzBG2UpwgodmnUXkenDADxFJ
        wEmcOEZvsiXzm50m0BA65orznWXyBhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-_RP9adNiNtmh669rKfug3Q-1; Wed, 05 Feb 2020 11:38:55 -0500
X-MC-Unique: _RP9adNiNtmh669rKfug3Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F186D1137841;
        Wed,  5 Feb 2020 16:38:53 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00BF781213;
        Wed,  5 Feb 2020 16:38:49 +0000 (UTC)
Date:   Wed, 5 Feb 2020 17:38:47 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 28/37] KVM: s390: protvirt: Add program exception
 injection
Message-ID: <20200205173847.70086ac7.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-29-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-29-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:48 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Only two program exceptions can be injected for a protected guest:
> specification and operand

s/operand/operand./

> 
> Both have a code in offset 248 of the state description, as the lowcore

"For both, a code needs to be specified at offset 248 (iictl) of the
state description," ?

> is not accessible by KVM for such guests.

s/by/to/

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

