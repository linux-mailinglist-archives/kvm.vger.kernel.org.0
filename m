Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E69521306D
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGCASL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 20:18:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgGCASI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 20:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593735486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hIQsc7L3mlUnsPjNRq6vMDMF6qPjtCUsaG1+ltKNRpk=;
        b=IyMxKZ4/cDNyoB4ARgCg4So7edE0O9HayXIJE/CtfXXd21wjHeSnBr5hof0LJNDOvmYw60
        A7KN3ZZ7GSuoRmombVzWYoi1HnnTPnVbNPLzAxlJChomuuUzkG0xWETkvSG0Se8CFkZZcT
        AKyoLdC/m6e26U8D6E86fFWKdHRiwHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-DW0ViCadM4GSoHNNdXZJGg-1; Thu, 02 Jul 2020 20:18:03 -0400
X-MC-Unique: DW0ViCadM4GSoHNNdXZJGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1B22800C60;
        Fri,  3 Jul 2020 00:18:00 +0000 (UTC)
Received: from llong.remote.csb (ovpn-112-121.rdu2.redhat.com [10.10.112.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D9555C1B0;
        Fri,  3 Jul 2020 00:17:57 +0000 (UTC)
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
References: <20200702221237.2517080-1-abhishekbh@google.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com>
Date:   Thu, 2 Jul 2020 20:17:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200702221237.2517080-1-abhishekbh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/2/20 6:12 PM, Abhishek Bhardwaj wrote:
> This change adds a new kernel configuration that sets the l1d cache
> flush setting at compile time rather than at run time.
>
> Signed-off-by: Abhishek Bhardwaj <abhishekbh@google.com>

Can you explain in the commit log why you need a compile time option 
whereas the desired mitigation can also be set via a boot command line 
option?

The code looks OK, but the question I have is why.

Cheers,
Longman

