Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F643518A8
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhDARqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235113AbhDARmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVLqapItOA/EaVZeXNlebDO6Dltek96tn/+vGZSaHts=;
        b=CPlqqTHClbRM5KPOmYyeBdjuKQT53o+IdXSSWIa9abiIUz1X5P0Vng98p9+5R1Ksf89IXG
        8UisnqAFxUOfhxa7jCfx9LwPRr4Esn/JeUybeBWNWYWU/cI3647GpfWccptNjXlvnyf9R8
        Dz6LIaYhdnHSCquPczN4fWnEIGzzG2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-TujzzwuYMh-MopBdyoSh5w-1; Thu, 01 Apr 2021 13:11:04 -0400
X-MC-Unique: TujzzwuYMh-MopBdyoSh5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08DA681744F;
        Thu,  1 Apr 2021 17:11:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 166885D6D1;
        Thu,  1 Apr 2021 17:10:57 +0000 (UTC)
Message-ID: <6db4acb8ce2d1ddb271cd7de465f1db4744ed1d4.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: use KVM_{GET|SET}_SREGS2 when supported by kvm.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>
Date:   Thu, 01 Apr 2021 20:10:56 +0300
In-Reply-To: <d221fa13-8e3b-0666-ff15-8c86d4e08237@redhat.com>
References: <20210401144545.1031704-1-mlevitsk@redhat.com>
         <20210401144545.1031704-3-mlevitsk@redhat.com>
         <d221fa13-8e3b-0666-ff15-8c86d4e08237@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-01 at 18:09 +0200, Paolo Bonzini wrote:
> On 01/04/21 16:45, Maxim Levitsky wrote:
> > +
> > +    for (i = 0; i < 4; i++) {
> > +        sregs.pdptrs[i] = env->pdptrs[i];
> > +    }
> > +
> > +    sregs.flags = 0;
> > +    sregs.padding = 0;
> > +
> > +    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_SREGS2, &sregs);
> > +}
> > +
> 
> This breaks when migrating from old to new kernel, because in that case 
> the PDPTRs are not initialized.

True, I haven't thought about it!
I'll fix this in the next version.

Best regards,
	Maxim Levitsky


> 
> Paolo
> 


