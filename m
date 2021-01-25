Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA1030325C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbhAYNZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 08:25:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728780AbhAYNYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 08:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611580977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0HGRoOq6BrrbzjHTsXqbOX8EfSf6zyIl/yxyGyvENJM=;
        b=hKg9wC3fJ8UJSDDalt+dcqIuZsR781KqVnRZlLAscFnBIlqMJj5BmW8XTh9aOFp3WKHPVj
        rLGKMOXdTBT5p6DHE98HvkqgzC4DGfu/NGaAMDUaInzB+XOolSKOgd4ekBW3Mc4ZzBsQBU
        povqt745LleleWuusMmPkejHCPmTY7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-zDQWX4KjMwav68AebMd7pQ-1; Mon, 25 Jan 2021 08:22:56 -0500
X-MC-Unique: zDQWX4KjMwav68AebMd7pQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49B6E107ACE8;
        Mon, 25 Jan 2021 13:22:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1901D60936;
        Mon, 25 Jan 2021 13:22:46 +0000 (UTC)
Message-ID: <c13849a741793d2f177447efb93f1719f73bf669.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: SVM: Add emulation support for #GP
 triggered by SVM instructions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <whuang2@amd.com>, Wei Huang <wei.huang2@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
Date:   Mon, 25 Jan 2021 15:22:46 +0200
In-Reply-To: <YAoCy5C0Zj97iSjN@google.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
         <20210121065508.1169585-3-wei.huang2@amd.com>
         <cc55536e913e79d7ca99cbeb853586ca5187c5a9.camel@redhat.com>
         <c77f4f42-657a-6643-8432-a07ccf3b221e@amd.com>
         <cd4e3b9a5d5e4b47fa78bfb0ce447e856b18f8c8.camel@redhat.com>
         <YAoCy5C0Zj97iSjN@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-21 at 14:40 -0800, Sean Christopherson wrote:
> On Thu, Jan 21, 2021, Maxim Levitsky wrote:
> > BTW, on unrelated note, currently the smap test is broken in kvm-unit tests.
> > I bisected it to commit 322cdd6405250a2a3e48db199f97a45ef519e226
> > 
> > It seems that the following hack (I have no idea why it works,
> > since I haven't dug deep into the area 'fixes', the smap test for me)
> > 
> > -#define USER_BASE      (1 << 24)
> > +#define USER_BASE      (1 << 25)
> 
> https://lkml.kernel.org/r/20210121111808.619347-2-imbrenda@linux.ibm.com
> 
Thanks!

Best regards,
	Maxim Levitsky

