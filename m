Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A59153250
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 14:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBENxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 08:53:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgBENxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 08:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580910790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D25bNTxf7IebHCL/s8A7Q+pPtOOsqrKpoggtAEI9Hfc=;
        b=huwsyoVwZwNgU1y7ZTmIrH1Hmvp62c7l32vc7xS7A+aTmcvrTkuNADslVkNkyYqkcgTEEG
        nj2QoAzwnDVlJiI44mq/DmdHwOJwbQztEdR/h5Nbg6Tk+iPsJW8wVNOquITSilFEmI+Gdv
        ItDlroKontYrlqjGOsoYAcXEnEnKIAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-AJZ0P5PVPv-yZGcOfSlh0g-1; Wed, 05 Feb 2020 08:53:06 -0500
X-MC-Unique: AJZ0P5PVPv-yZGcOfSlh0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD886801F74;
        Wed,  5 Feb 2020 13:53:05 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97E125C299;
        Wed,  5 Feb 2020 13:53:01 +0000 (UTC)
Date:   Wed, 5 Feb 2020 14:52:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 20/37] KVM: s390: protvirt: Add new gprs location
 handling
Message-ID: <20200205145259.0b228033.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-21-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-21-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:40 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Guest registers for protected guests are stored at offset 0x380.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 

With the things pointed out by Thomas fixed:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

