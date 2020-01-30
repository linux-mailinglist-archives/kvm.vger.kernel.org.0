Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9C14DB26
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgA3NBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:01:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA3NBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pu0+SRHRSAyXiXTnwvw/1mcoVAgT1lLc9d0FL6VQ1OU=;
        b=P4ti4uMDr/mnNC/lssPfGHYuVMfjV3+W8czfFj4MSc9TfQMkABlgHeYcIAyNjReB8s/FO0
        jqkVngyKNMPaqyPT5Js5KXWLhJ+RQVo4WYEUKZPWXw+acep0mdrtRPgBqZKAuhuWb5neJz
        fMJS7PMfhVk6ui8AxJ9GnHszgBpPDlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-XMmBdvUoOM-xDa3qo_2uww-1; Thu, 30 Jan 2020 08:01:46 -0500
X-MC-Unique: XMmBdvUoOM-xDa3qo_2uww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AEF6800D5F;
        Thu, 30 Jan 2020 13:01:45 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D40C219756;
        Thu, 30 Jan 2020 13:01:43 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:01:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v9] KVM: s390: Add new reset vcpu API
Message-ID: <20200130140141.0e759a62.cohuck@redhat.com>
In-Reply-To: <20200130125559.30032-1-frankja@linux.ibm.com>
References: <9d64917a-2a0a-46e7-0d78-da2f31eb01c4@linux.ibm.com>
        <20200130125559.30032-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 07:55:59 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that on a normal reset.
> 
> Let's implement an interface for the missing normal and clear resets
> and reset all local IRQs, registers and control structures as stated
> in the architecture.
> 
> Userspace might already reset the registers via the vcpu run struct,
> but as we need the interface for the interrupt clearing part anyway,
> we implement the resets fully and don't rely on userspace to reset the
> rest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/api.txt | 43 +++++++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 86 +++++++++++++++++++++++-----------
>  include/uapi/linux/kvm.h       |  5 ++
>  3 files changed, 106 insertions(+), 28 deletions(-)

This version looks good to me.

