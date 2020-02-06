Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82B715462B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgBFO3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:29:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728096AbgBFO3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:29:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580999377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMFnyJzQhfSotr83Gq4aBnLI/ISwr9/hTZQ/mPJrwIM=;
        b=gGqTYm47rSGrtMKnW+KBy/ZgfMyAEc98ltaChkQbj1K0aJbi9q3vYMphlNVKHpkvseGtZk
        uOKjOyocV4Fxl5dSZ4BChOpO612vdliCg6JyLqUJ7nQnDg6qGB52RGcCy4b7b6M9NXaPJt
        ZE8KJLu2G5RVFJAM4IiW2sMU0MBUWuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-9k5TJ0A9OeWn2Tn0nHU-Tg-1; Thu, 06 Feb 2020 09:29:35 -0500
X-MC-Unique: 9k5TJ0A9OeWn2Tn0nHU-Tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D1A4108442F;
        Thu,  6 Feb 2020 14:29:34 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97FDE790EE;
        Thu,  6 Feb 2020 14:29:30 +0000 (UTC)
Date:   Thu, 6 Feb 2020 15:29:28 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 32/37] KVM: s390: protvirt: Report CPU state to
 Ultravisor
Message-ID: <20200206152928.50a303b1.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-33-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-33-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:52 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> VCPU states have to be reported to the ultravisor for SIGP
> interpretation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

