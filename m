Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658A8158CEF
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 11:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgBKKvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 05:51:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32278 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgBKKvq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 05:51:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581418305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wcyxf6NJeWTzFTTd7ngQGUJSq/GL3N66hN3Lol5zgv4=;
        b=F/CRTKkBn/gF5/7EZzf4pn2g8LXgY2lHCw4VU4MLtvNzXZM6TvYm+HMPaecXl2ggQzSuss
        NdfPsJa0VRhwhEBUAO1TiqSXOtDesmfdOGdoLajuKb2fgwQzmxh3mBVJC/6/z7t9OusxWi
        HHyjFUgnR/w7Bjw1ycUHbr8+Q9O117o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-sJFTBCenMR6wTA3kUvwUGA-1; Tue, 11 Feb 2020 05:51:42 -0500
X-MC-Unique: sJFTBCenMR6wTA3kUvwUGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83FF6800EB2;
        Tue, 11 Feb 2020 10:51:40 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBB675C1B2;
        Tue, 11 Feb 2020 10:51:34 +0000 (UTC)
Date:   Tue, 11 Feb 2020 11:51:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 25/35] KVM: s390: protvirt: Only sync fmt4 registers
Message-ID: <20200211115117.33a2e3a5.cohuck@redhat.com>
In-Reply-To: <20200207113958.7320-26-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-26-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Feb 2020 06:39:48 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> +static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +{
> +	/*
> +	 * at several places we have to modify our internal view to not do

s/at/In/ ?

> +	 * things that are disallowed by the ultravisor. For example we must
> +	 * not inject interrupts after specific exits (e.g. 112). We do this

Spell out what 112 is?

> +	 * by turning off the MIE bits of our PSW copy. To avoid getting

And also spell out what MIE is?

> +	 * validity intercepts, we do only accept the condition code from
> +	 * userspace.
> +	 */

