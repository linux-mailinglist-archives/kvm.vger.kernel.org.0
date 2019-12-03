Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3D10F94B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 08:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLCHsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 02:48:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727376AbfLCHsw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 02:48:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575359331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkhTpBDfMGilBSgN0jOZ1InPL5ChpTlIvBxpVi2lXMU=;
        b=eDTFXtoqGzh20mwSdZgNuRUwFf37wX7PAbz3JC3nyP2Ifrm5I0pGLVDS5Ay4zTyyXc3Pmx
        5suERsKj5Z3a+/zpnVZAQXuBM+ZMD/J4j7MyFaQG7D4GlAc+1EwmAGlL/sFik3M3aKw+60
        M8/+eMCWzPBtdw8cDBG1KvFSFxLHgGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-LQfyTKLMNF22IjYnLy8cjQ-1; Tue, 03 Dec 2019 02:48:50 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D4218557C0;
        Tue,  3 Dec 2019 07:48:49 +0000 (UTC)
Received: from gondolin (ovpn-116-214.ams2.redhat.com [10.36.116.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86A8D67E5F;
        Tue,  3 Dec 2019 07:48:45 +0000 (UTC)
Date:   Tue, 3 Dec 2019 08:48:43 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] KVM: Remove duplicated declaration of kvm_vcpu_kick
Message-ID: <20191203084843.5a397060.cohuck@redhat.com>
In-Reply-To: <20191203074408.1758-1-yuzenghui@huawei.com>
References: <20191203074408.1758-1-yuzenghui@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: LQfyTKLMNF22IjYnLy8cjQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 Dec 2019 15:44:08 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> There are two declarations of kvm_vcpu_kick() in kvm_host.h where
> one of them is redundant. Remove to keep the git grep a bit cleaner.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  include/linux/kvm_host.h | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

