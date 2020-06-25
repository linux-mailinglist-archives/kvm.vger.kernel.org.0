Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5362099E5
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 08:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbgFYGel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 02:34:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389617AbgFYGel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 02:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593066879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOGPW4iqB2BAVPdKSs/l6tFu14U0yVMld2Wp+wO+/b4=;
        b=WE/zOcc9pa2+bhw4sZz0N8pHVEsT3l28SH4IPr82/nYGNhqSJ4JcwdaraSdU6I8Xu+sbrQ
        VGEcdx3qkTXXe/elRTzR3GLRnuyjqJ1FRJGVARZ0QV5wA5B0HR7ToObZB6njSCFzX/N7oh
        q8tFjUsoqWzQDT1zCTdpPNqa36c/kG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-2iyiyblTPmC5huaotI7Mpw-1; Thu, 25 Jun 2020 02:34:37 -0400
X-MC-Unique: 2iyiyblTPmC5huaotI7Mpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F945805EEF;
        Thu, 25 Jun 2020 06:34:36 +0000 (UTC)
Received: from gondolin (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24DCA7CADB;
        Thu, 25 Jun 2020 06:34:27 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:34:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 2/2] docs: kvm: fix rst formatting
Message-ID: <20200625083423.2ee75bb1.cohuck@redhat.com>
In-Reply-To: <20200624202200.28209-3-walling@linux.ibm.com>
References: <20200624202200.28209-1-walling@linux.ibm.com>
        <20200624202200.28209-3-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 16:22:00 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> KVM_CAP_S390_VCPU_RESETS and KVM_CAP_S390_PROTECTED needed
> just a little bit of rst touch-up
> 

Fixes: 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API")
Fixes: 04ed89dc4aeb ("KVM: s390: protvirt: Add KVM api documentation")

> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 056608e8f243..2d1572d92616 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6134,16 +6134,17 @@ in CPUID and only exposes Hyper-V identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
>  
>  8.22 KVM_CAP_S390_VCPU_RESETS
> +-----------------------------
>  
> -Architectures: s390
> +:Architectures: s390
>  
>  This capability indicates that the KVM_S390_NORMAL_RESET and
>  KVM_S390_CLEAR_RESET ioctls are available.
>  
>  8.23 KVM_CAP_S390_PROTECTED
> +---------------------------
>  
> -Architecture: s390
> -
> +:Architecture: s390
>  
>  This capability indicates that the Ultravisor has been initialized and
>  KVM can therefore start protected VMs.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

