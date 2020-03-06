Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258BA17B663
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 06:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgCFFc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 00:32:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgCFFc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 00:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583472777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Dg5l40fFklgiXW3Pi2JeGrXIz1t8W6lNvDgLqT7nN8=;
        b=O0OFStgO1b52R7gzeun8YK17I52hVzQPLYKaAbNCmWo2Q2/hdtvlNq2cXVkn/sHkMQB6M7
        9ut7HLULUbpqczqj6XLqMyAlQKOrewAwOx9OxYyqmalnaNfUoM3cg86W2wbGpsgiVNFhP8
        Aax6u1LA74DHKzpTpAtp9XosrpG8lko=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-FuoJly7tMnq_OZWWO_BWhg-1; Fri, 06 Mar 2020 00:32:53 -0500
X-MC-Unique: FuoJly7tMnq_OZWWO_BWhg-1
Received: by mail-wr1-f72.google.com with SMTP id m13so542008wrw.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 21:32:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Dg5l40fFklgiXW3Pi2JeGrXIz1t8W6lNvDgLqT7nN8=;
        b=YxGr3oqICb/1KROvb9zjoWxBVytlzcfA/T/CFMjPG3VaAs32aEzIJS5eg8dvMPa9Rg
         ZyBsyb4QxKMi1vupRPxDmM/Uil4SnDomMNh9ER4m7ofy3ehwQJ36zAvhvx7gi0BoYu1k
         npieicGwXT3yyKyoNaKBAWFnwnKCPp+ZjeYAg+TRu1OaYhdGkje69ChwEXkuUTW1458T
         ZqD6hsOwMyuu8EwcR0KmmbrMmbxNknJWlXNn4dM1NitQoAj6v/YyngcR9HBNO+PjoOzD
         V7rUWgQjwNtE9JWX5kHoPWXNL6wq8E7IywQe2ouXOAkHugfrztTiOSvtiXqHgqx3eD7Y
         QSIA==
X-Gm-Message-State: ANhLgQ0HibzuCTjk8SpXZ7rUcs7v9k1tpc0Oy5cMnu06RWCjk5VWxwwj
        lE133AJAHfINxO/YU5oe1VgdFcwhu/spVZIv58dZoX564RjtPy315EhavQ+5TmQFoRQTgJ7EwJv
        ImKw+ApKi9GW6
X-Received: by 2002:a5d:4902:: with SMTP id x2mr2045480wrq.301.1583472772190;
        Thu, 05 Mar 2020 21:32:52 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsk/wfYFESgN2vEQJ3IVYE/ThGeS0U1JqD+oUUhMbb4iHplVb00stFd0EPUaYUZcTYTgaTK1Q==
X-Received: by 2002:a5d:4902:: with SMTP id x2mr2045463wrq.301.1583472771981;
        Thu, 05 Mar 2020 21:32:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id b13sm12635205wme.2.2020.03.05.21.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 21:32:51 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro
 ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
To:     linmiaohe <linmiaohe@huawei.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1e3f7ff0-0159-98e8-ba21-8806c3a14820@redhat.com>
Date:   Fri, 6 Mar 2020 06:32:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/20 03:17, linmiaohe wrote:
> Define a macro RMODE_HOST_OWNED_EFLAGS_BITS for (X86_EFLAGS_IOPL |
> X86_EFLAGS_VM) as suggested by Vitaly seems a good way to fix this ?
> Thanks.

No, what if a host-owned flag was zero?  I'd just leave it as is.

Paolo

