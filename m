Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE583C1F39
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 08:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhGIGLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 02:11:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhGIGLg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Jul 2021 02:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625810932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vy3RT833Zluxm0D5IqTflstNdttnmf/u6KXeL7O1ITo=;
        b=Vd3xvmoYOOBIFmcgZbiv5SiDcJhhR2NrTj7ElLvZ/QgL5nXdcsJy+EC6qB8qWItZ1oHg2I
        nNffCThSCtEtVkwCBCAQdUxsWqxu6R6EidjszeuDwA5WFXNVDxB74Swi/vkMlm8p5nuoo3
        5tamOjmGeiQgNMbYx4M9DbHdEm2h16E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-zL_CMw1sPXixCGMcENOB2A-1; Fri, 09 Jul 2021 02:08:49 -0400
X-MC-Unique: zL_CMw1sPXixCGMcENOB2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37D49362FA;
        Fri,  9 Jul 2021 06:08:48 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2128100EBAF;
        Fri,  9 Jul 2021 06:08:44 +0000 (UTC)
Message-ID: <67e2e6b4fcbc2ec0bdda1e1af1cfe61d3c1fde6f.camel@redhat.com>
Subject: Re: [PATCH 1/6] KVM: nSVM: Check the value written to
 MSR_VM_HSAVE_PA
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 09 Jul 2021 09:08:43 +0300
In-Reply-To: <4318c980-6eff-7b74-ae99-b3210021789d@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-2-vkuznets@redhat.com>
         <595c45e8fb753556b2c01b25ac7052369c8357ac.camel@redhat.com>
         <4318c980-6eff-7b74-ae99-b3210021789d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-07-08 at 19:27 +0200, Paolo Bonzini wrote:
> On 07/07/21 12:28, Maxim Levitsky wrote:
> > Minor nitpick: I would have checked the host provided value as well,
> > just in case since there is no reason why it won't pass the same check,
> > and fail if the value is not aligned.
> 
> The reason not to do so is that it would allow a guest running an old 
> kernel to defeat live migration.
I understand now, and I will keep this in mind next time.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > Other than that:
> > Reviewed-by: Maxim Levitsky<mlevitsk@redhat.com>


