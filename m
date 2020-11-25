Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25452C3C34
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgKYJbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:31:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728192AbgKYJbd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606296692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QK+O3UEC4UN4tdmD+gquS30QGpiQLEcNyl66MqTAWag=;
        b=ekXhJUJmBdEiDPgLtyGPcyMomwPILCgIU0ksSVpu1nR622oNcww0K/SG7iqb29dtpWNSWZ
        Kg8oFtnfbtSHS0REppVP3SvDjlRn/UHF0v03gMQQdvrJ/l2yjy3QjgUUXCEiR5n12eV5hy
        xUtGuOm2zEZDsMRj2EmjC8qdPDwacm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-8aC4Aw32OT2Y1lLtND4fTQ-1; Wed, 25 Nov 2020 04:31:30 -0500
X-MC-Unique: 8aC4Aw32OT2Y1lLtND4fTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7D75180A0B8;
        Wed, 25 Nov 2020 09:31:28 +0000 (UTC)
Received: from gondolin (ovpn-113-39.ams2.redhat.com [10.36.113.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47B8B100238C;
        Wed, 25 Nov 2020 09:31:24 +0000 (UTC)
Date:   Wed, 25 Nov 2020 10:31:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH] KVM: s390: track synchronous pfault events in kvm_stat
Message-ID: <20201125103121.3d4f154a.cohuck@redhat.com>
In-Reply-To: <20201125090658.38463-1-borntraeger@de.ibm.com>
References: <20201125090658.38463-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Nov 2020 10:06:58 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Right now we do count pfault (pseudo page faults aka async page faults
> start and completion events). What we do not count is, if an async page
> fault would have been possible by the host, but it was disabled by the
> guest (e.g. interrupts off, pfault disabled, secure execution....).  Let
> us count those as well in the pfault_sync counter.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 1 +
>  arch/s390/kvm/kvm-s390.c         | 2 ++
>  2 files changed, 3 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

