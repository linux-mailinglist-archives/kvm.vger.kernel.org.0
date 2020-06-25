Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120B62099E1
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 08:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390090AbgFYGbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 02:31:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44019 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726742AbgFYGbn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 02:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593066701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LyDrngkDg+6iBhDtD6oC/1TO4hEBSTxlWLbuzJNG8Mg=;
        b=Gb7KJHDWsunGCgwKEc47N71Oc3jcDGmnjED561ieT+FihGds45iUPhnfeFafMteMyvLD3s
        qiTHqagf6NO/bkuREaLqvOuceSTc/ADVktAVs0bZpjikaiqtQVu7g91ebZtIVCVv8QM/f9
        X+nSmvR4hN82p48m+pItXjhGfnU9wfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-BVxxHgDPPRqFWq1gJsHDEA-1; Thu, 25 Jun 2020 02:31:40 -0400
X-MC-Unique: BVxxHgDPPRqFWq1gJsHDEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A639C8015F7;
        Thu, 25 Jun 2020 06:31:38 +0000 (UTC)
Received: from gondolin (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9787D5D9D3;
        Thu, 25 Jun 2020 06:31:33 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:31:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 1/2] docs: kvm: add documentation for
 KVM_CAP_S390_DIAG318
Message-ID: <20200625083130.420819c9.cohuck@redhat.com>
In-Reply-To: <20200624202200.28209-2-walling@linux.ibm.com>
References: <20200624202200.28209-1-walling@linux.ibm.com>
        <20200624202200.28209-2-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 16:21:59 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> Documentation for the s390 DIAGNOSE 0x318 instruction handling.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 426f94582b7a..056608e8f243 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6150,3 +6150,22 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.24 KVM_CAP_S390_DIAG318
> +-------------------------
> +
> +:Architecture: s390
> +
> +This capability allows for information regarding the control program that may

Maybe s/allows for/covers/ ?

> +be observed via system/firmware service events. The availability of this
> +capability indicates that KVM handling of the register synchronization, reset,
> +and VSIE shadowing of the DIAGNOSE 0x318 related information is present.
> +
> +The information associated with the instruction is an 8-byte value consisting
> +of a one-byte Control Program Name Code (CPNC), and a 7-byte Control Program
> +Version Code (CPVC). The CPNC determines what environment the control program
> +is running in (e.g. Linux, z/VM...), and the CPVC is used for extraneous
> +information specific to OS (e.g. Linux version, Linux distribution...)
> +
> +If this capability is available, then the CPNC and CPVC can be synchronized
> +between KVM and userspace via the sync regs mechanism (KVM_SYNC_DIAG318).

Anyway,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

