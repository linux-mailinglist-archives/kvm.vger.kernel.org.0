Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D10BEF82
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfIZKZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfIZKZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 06:25:24 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6221D89ACA
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 10:25:24 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id j125so948758wmj.6
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wg1F6fhHfjGl1CmkFUDQZE8b2uXlEUi5cZIaWD+93Ng=;
        b=FWcRzEOgvASzBoGQdRpdPqtFqbddDjkljupm5eThvpJHY5RoZPjk/BaYyDEkkD8K/H
         iHJlN3DDJ68p7n7n9izwvSA4ef3K3NbRcMYyXZN7WJf02KikwsFBJ4mmelftu47u7oa7
         RBrgov3Rh4Y4W8gCclb3DrI8Chj94plq1pNxBjJfmXUAb+IFeeZST7Tl4iJYntbNM6O6
         7vvSWXiZcroaQ2Fu7zJOjk6qeuipAW4fjWT4drsPLg4+8FBpmh6+pl7k9rjO8X4uSd7B
         77jNgcnk9NwsDonnNwo50Ska8yAaTIHhq5RjBtbDls9vp5SESkWfeWhgpOWfLDNuru0A
         ZsMQ==
X-Gm-Message-State: APjAAAWzu9EwHbe/Agso/0Fanj+kTPQTYnNvmMb+p3uU+Bh/e9avWsNP
        xfnJ73fyrP6hDyHUsnel5uaQDfDm4lGoP54NoYESahitk/oCVMa904wsEjZN5K3pgBQdoyLqqRK
        xMXtr1HiLWHo/
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr2286931wmb.158.1569493523028;
        Thu, 26 Sep 2019 03:25:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8yGv+a6tmqUttSQfZ1O++o0RvOjj04j7ifv0aGAkM22LS/PTzhHvNMrwLsv4fuUKFDDqmMQ==
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr2286906wmb.158.1569493522778;
        Thu, 26 Sep 2019 03:25:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id o9sm3012505wrh.46.2019.09.26.03.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:25:22 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: LAPIC: Loose fluctuation filter for auto tune
 lapic_timer_advance_ns
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1569459243-21950-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ea06c6bb-c6ff-ef34-55ca-c58cb77ed39e@redhat.com>
Date:   Thu, 26 Sep 2019 12:25:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569459243-21950-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 02:54, Wanpeng Li wrote:
> -#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
> -#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
> -#define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
> +#define LAPIC_TIMER_ADVANCE_EXPIRE_MIN	100
> +#define LAPIC_TIMER_ADVANCE_EXPIRE_MAX	10000
> +#define LAPIC_TIMER_ADVANCE_NS_INIT	1000
> +#define LAPIC_TIMER_ADVANCE_NS_MAX     5000

I think the old #define value is good.  What about:

-#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
-#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
-#define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
+#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100	/* clock cycles */
+#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 10000	/* clock cycles */
+#define LAPIC_TIMER_ADVANCE_NS_INIT	1000
+#define LAPIC_TIMER_ADVANCE_NS_MAX     5000

?

Thanks,

Paolo
