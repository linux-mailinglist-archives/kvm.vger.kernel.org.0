Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705DE16C089
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgBYMPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:15:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgBYMPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 07:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582632922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tm15AJ2TveSvvqTK3PpWYU6q9nm7Mjj4j36M52Oj6iY=;
        b=D6HDtvdqeIYVRCa1NIX79vSh5EgngMDOfCUC43puqEs2d9GAMTmbdWirkQCC967X5cOkRK
        STPCGosztjlyetzfKD2cllBMa9/zJzDX2qJvz0syNWr+qKDoaGju2GLI8q9Ytc3WHat2T3
        UeazGUIqIR45ZWVyKvm0XcSCOF7POtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-aKBwSOkLPkq2aqlPULaC-A-1; Tue, 25 Feb 2020 07:15:18 -0500
X-MC-Unique: aKBwSOkLPkq2aqlPULaC-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26ED41007268;
        Tue, 25 Feb 2020 12:15:17 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C74391001925;
        Tue, 25 Feb 2020 12:15:12 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:15:10 +0100
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
Subject: Re: [PATCH v4 19/36] KVM: s390: protvirt: handle secure guest
 prefix pages
Message-ID: <20200225131510.083cf61a.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-20-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-20-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:50 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> The SPX instruction is handled by the ultravisor. We do get a
> notification intercept, though. Let us update our internal view.
> 
> In addition to that, when the guest prefix page is not secure, an
> intercept 112 (0x70) is indicated. Let us make the prefix pages
> secure again.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/intercept.c        | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

