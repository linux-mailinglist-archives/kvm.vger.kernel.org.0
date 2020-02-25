Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F1016C073
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgBYML6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:11:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60224 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729048AbgBYML6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582632717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TgnRf/3TZgQKhn8ZU/eOQ3Pi2LtIUi+ZK9/q6tq/Kcc=;
        b=VuA7Mokba+/w6xPbejOmma/0toBYPGsA8N+vKBbH1rG0co97FYYFJC356MoUOTo4KBnMRI
        S0Zd9gYGFPLRPJGITIg7Hg5xE3VTTjw42w4ZOmsF3C+uikbq1SYKww4AImX5P9U6hb1QWT
        C0V5Jiou9QbIYi9pIU0Gl0ln3qs0YwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-krfnrPJnN2-aDy9o9ttiaQ-1; Tue, 25 Feb 2020 07:11:55 -0500
X-MC-Unique: krfnrPJnN2-aDy9o9ttiaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97AED1005512;
        Tue, 25 Feb 2020 12:11:53 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46491909EE;
        Tue, 25 Feb 2020 12:11:49 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:11:46 +0100
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
Subject: Re: [PATCH v4 15/36] KVM: s390: protvirt: Add SCLP interrupt
 handling
Message-ID: <20200225131146.686f0fe0.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-16-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-16-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:46 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> The sclp interrupt is kind of special. The ultravisor polices that we
> do not inject an sclp interrupt with payload if no sccb is outstanding.
> On the other hand we have "asynchronous" event interrupts, e.g. for
> console input.
> We separate both variants into sclp interrupt and sclp event interrupt.
> The sclp interrupt is masked until a previous servc instruction has
> finished (sie exit 108).
> 
> [frankja@linux.ibm.com: factoring out write_sclp]
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  6 +-
>  arch/s390/kvm/intercept.c        | 27 +++++++++
>  arch/s390/kvm/interrupt.c        | 95 ++++++++++++++++++++++++++------
>  arch/s390/kvm/kvm-s390.c         |  6 ++
>  4 files changed, 115 insertions(+), 19 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

