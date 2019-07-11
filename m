Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0D6551F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfGKLXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:23:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46612 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfGKLXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:23:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so5831873wru.13
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 04:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0xkQj6rXd6jhqOpnOodbdLnJbizN7yitMYfeVThGNA4=;
        b=eIxWS0MsiGF3tDnTjn75UMGjJxCQaZ8JZZvB9BJ88zeHmx3te+P9tBHNnLgLb8ABWL
         goQYTfYrb9Hv27GTrSN4B60YkrHzxsKe9KkHhxnh54rS2XUTMlYwAStinbF0D06LoKqv
         KHbabzdEHjcC+j59/Nl6menN7CuUcmXoyhgeohRkSmtWPyCp4GiUytIGsK/iFjnBxZYS
         z25j0x2eS1TeRtUPsMgJJqnweY3YqP6YrVRhepqT2j+KyzWOxSUwYGDXh04gFyWg13oQ
         JSUQd1vujcR3ZxeNzpmp1q0hhXV1jOrnI6mvWjEd3rJ+wMvqAWNUOj/7a+c/vcQhz1tQ
         BroA==
X-Gm-Message-State: APjAAAXH7XSNNVHTFFfvtafSxf/+iW0PL5JuwsppMnMiCsmx65m2mGW5
        MHgNu1euBNZ0Q8swFxE6GXX7u3yek0Y=
X-Google-Smtp-Source: APXvYqzYt0fhDogZwESZ0arD5eENr8od2gwLRRRfIBfJIOSu6WS+kRxhX99b+wAH8Ri/NQOohNvXXw==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr4641153wrn.285.1562844179011;
        Thu, 11 Jul 2019 04:22:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id y2sm3690485wrl.4.2019.07.11.04.22.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 04:22:58 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Eric Hankland <ehankland@google.com>,
        Wei Wang <wei.w.wang@intel.com>, rkrcmar@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30b7a0a1-1dc7-7ab0-938a-e34e61152ec8@redhat.com>
Date:   Thu, 11 Jul 2019 13:22:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 03:25, Eric Hankland wrote:
> 
> +/* for KVM_CAP_PMU_EVENT_FILTER */
> +struct kvm_pmu_event_filter {
> +       __u32 type;
> +       __u32 nevents;
> +       __u64 events[0];
> +};
> +
> +#define KVM_PMU_EVENT_WHITELIST 0
> +#define KVM_PMU_EVENT_BLACKLIST 1
> +

"type" is a bit vague, so I am thinking of replacing it with "action"
and rename the constants to KVM_PMU_EVENT_ACCEPT/REJECT.  What do you think?

Paolo
