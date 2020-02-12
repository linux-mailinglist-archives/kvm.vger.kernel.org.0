Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B805415A83F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgBLLtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:49:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgBLLtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581508170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JnelCP0BeqCKzB5HUK/Y879g+TjBn3kcCBi0brqpess=;
        b=ZJlMiwNSev/DjItLdpr5qq49hhhiloLf/3GwER+0FGlHIxRWt0P8Bz/7iVyTlwVg6+P9fP
        qyjARjfU8OkbFaVPTxaATje4PRz4PanU2ZyvYphL/rKHUZ8z4ra5U14iX8H7g/RRvPpU+0
        jFTfFT6BUAYc5dyKYQX8uaMsZ/vEKZc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-Fj2BjzH9NSeYMvbyBDjWaw-1; Wed, 12 Feb 2020 06:49:29 -0500
X-MC-Unique: Fj2BjzH9NSeYMvbyBDjWaw-1
Received: by mail-wr1-f70.google.com with SMTP id z15so724207wrw.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JnelCP0BeqCKzB5HUK/Y879g+TjBn3kcCBi0brqpess=;
        b=X4nWp7X3CgQGqee57oMUUtUDm7IpsAWHapAAqfx477TfMZUv8qXSypawihZHHD+/qE
         n4SNXju2kwV4Ih5DTbIeBZ5ZOFYTr8PkTCmrPyRGCLBfhm4EZSx9DvV9ds1dgMhzxb+B
         JlEPnF5btGVHV2pLLX6e+0bjwy+cCTdIOgbRUd037bbfLHytEDXhPhyXSDlA0cUM0rDm
         oUscpyRyykUpRhLdyQK4juGVosaylhXwvSmQN3Wo0B6V83HiZcus1kyG+jvQWIOY+6dH
         XQTRIOZ312aO85fTNryhWTXsnKIvFO9UWMI7EiwmDdBEFnQZUlMm/OYMvtOw0xBUqRN8
         +35Q==
X-Gm-Message-State: APjAAAUjB92iQjXugMlBObkjPBO6UvpHLjcuj+WwdtFRXKRo6F+0mJy+
        VMOJEaFe2CN0kLDV/8Zmr1rkOog+rxpPlEgjgryBMO+AMUMHqImlI0gEyLQ+OzIFandjrFyfTT7
        /YbmeIs6yodCh
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr14147897wru.233.1581508168428;
        Wed, 12 Feb 2020 03:49:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqzeI48yUIlfasjczSuSSNgiv99/Z58AUwqGUMZMkVGFbIwyZAB7OqaXkxrlubZ3ZIBd8MW2nw==
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr14147880wru.233.1581508168206;
        Wed, 12 Feb 2020 03:49:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id m9sm318916wrx.55.2020.02.12.03.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:49:27 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: remove duplicated KVM_REQ_EVENT request
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
References: <a95c89cdcdca4749a1ca4d779ebd4a0a@huawei.com>
 <87h802g42r.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1386ffda-37c7-aef6-2ff4-f2b753b51af1@redhat.com>
Date:   Wed, 12 Feb 2020 12:49:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87h802g42r.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 10:05, Vitaly Kuznetsov wrote:
> kvm_make_request() from kvm_set_rflags() as it is not an obvious
> behavior (e.g. why kvm_rip_write() doens't do that and
> kvm_set_rflags() does ?)

Because writing RFLAGS can change IF and therefore cause an interrupt to
be injected.

Paolo

