Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74A545EA97
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 10:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352869AbhKZJqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 04:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346393AbhKZJoA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 04:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637919647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7UUe35TCPwnWrlRfuadrJjdwO/yhSUHrYr8BjHXjKnE=;
        b=Ea7G5scEc+rTInZf23f1EBlc5ID6NWLLy7ydgOX7XSiyLzyPoDwJRSBVtia8T9D38kODPd
        t0sVCnybAOnGJSfkUZB3knqpwtswcREzOfZoyjosVg6Il5tU7TvlykgtMzoR+Xgf3Szcif
        GjNijYtWPAX2blUFl7q+0z3LJmMfQKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-iMtrPbjDPVKCij-lsuqYIQ-1; Fri, 26 Nov 2021 04:40:44 -0500
X-MC-Unique: iMtrPbjDPVKCij-lsuqYIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B2FE83DD20;
        Fri, 26 Nov 2021 09:40:42 +0000 (UTC)
Received: from [10.39.194.96] (unknown [10.39.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B8E19C46;
        Fri, 26 Nov 2021 09:40:17 +0000 (UTC)
Message-ID: <7693d3a8-fea7-fb61-b3fb-d0bf8a89c57b@redhat.com>
Date:   Fri, 26 Nov 2021 10:40:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore 4
 host MSRs on exit to user space
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx> <20211126091913.GA11523@gao-cwp>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211126091913.GA11523@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 10:19, Chao Gao wrote:
> Of course. Will remove all "later patch" phrases.

Chao, see my comment on patch 54, for how to do this.  In this case, 
this patch would be right before the one that enables KVM_RUN on a TDX 
module.

Paolo

