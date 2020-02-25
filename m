Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2E16BF5A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 12:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgBYLLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 06:11:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48057 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728963AbgBYLLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 06:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582629077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohHYmw3DAWy914UTCwzckzwlp2/Ll2y8a4PRzU8jW6M=;
        b=HmfvGuj97M8ER3ppo3mAnhyVDtJWHAG6LayOJrIcp1U/yqetzRowjEakBTzSsf0gwGQcaS
        zB6xHUgKb5rmdXLPN1ZB1W7WmX0amD9FlSY6cF2VkN38jNmQbWPMIpJTiVQgESt28NujyJ
        P+Cpie+Wf/U3SQVyQVQUy/Qz3icvCeM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-Q8L3_ZsSNe2t9hGouynCdA-1; Tue, 25 Feb 2020 06:11:14 -0500
X-MC-Unique: Q8L3_ZsSNe2t9hGouynCdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 690061005512;
        Tue, 25 Feb 2020 11:11:12 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C84F5C1D6;
        Tue, 25 Feb 2020 11:11:07 +0000 (UTC)
Date:   Tue, 25 Feb 2020 12:11:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 12/36] KVM: s390: protvirt: Handle SE notification
 interceptions
Message-ID: <20200225121105.0274cbb0.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-13-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-13-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:43 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Since there is no interception for load control and load psw
> instruction in the protected mode, we need a new way to get notified
> whenever we can inject an IRQ right after the guest has just enabled
> the possibility for receiving them.
> 
> The new interception codes solve that problem by providing a
> notification for changes to IRQ enablement relevant bits in CRs 0, 6
> and 14, as well a the machine check mask bit in the PSW.
> 
> No special handling is needed for these interception codes, the KVM
> pre-run code will consult all necessary CRs and PSW bits and inject
> IRQs the guest is enabled for.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/intercept.c        | 11 ++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

