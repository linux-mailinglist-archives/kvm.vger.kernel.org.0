Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1314EBE3
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 12:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgAaLoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 06:44:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728428AbgAaLoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 06:44:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=qQon9H8oirA0BfQXr/ZQWuhlqVRCE1JMZ5FOC58Vsj8=;
        b=bQvNBK2M0lruF/RafwwUc9ztrVj/BmhlNP5hHbycFszS5/2JjQ5gCwocH3pCgTXPHLx4Xm
        9dD+eD33AHhouYzNiwyxB78Sd25VjJioVQsEzzZDK80WGlUtr2tUVvtEXwKvqxF39eWfgJ
        6bj3wqrKbm/Ns/bLs4YP5MtxliFuRnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-Bxrlac-vONe8hpsGwbdSQA-1; Fri, 31 Jan 2020 06:44:12 -0500
X-MC-Unique: Bxrlac-vONe8hpsGwbdSQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0CB4800D48;
        Fri, 31 Jan 2020 11:44:10 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE4ACFC1;
        Fri, 31 Jan 2020 11:44:06 +0000 (UTC)
Subject: Re: [PATCH v10 3/6] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200131100205.74720-1-frankja@linux.ibm.com>
 <20200131100205.74720-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7e36cbd4-3f37-8509-400e-c2c708281aeb@redhat.com>
Date:   Fri, 31 Jan 2020 12:44:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200131100205.74720-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/2020 11.02, Janosch Frank wrote:
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
>  arch/s390/kvm/kvm-s390.c       | 84 +++++++++++++++++++++++-----------
>  include/uapi/linux/kvm.h       |  5 ++
>  3 files changed, 105 insertions(+), 27 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

