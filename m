Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31801467C0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 13:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAWMRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 07:17:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgAWMRC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 07:17:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579781821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eh4yN5hoXKIHr0Y4kKL2j19glvafCP0ncaEOaLM+6RU=;
        b=OIHqybvzlTzyp+dl7Qlc3mq4wr9yakzV8RgHfDgbYDCp6uTlNKOX1yiLU0ntwtD8zH9BiD
        smOr0uXKX0TuvJOs+fTtDm8TaQyzOxmFr5jizMsyTKdm08lduUT2Hnx9kRlGERAwYdRQ5Q
        LkvdKCihnR6ALUGBTygkBontmg7v1Ho=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-uyXLWDUFOjKEbim4x9cIvA-1; Thu, 23 Jan 2020 07:17:00 -0500
X-MC-Unique: uyXLWDUFOjKEbim4x9cIvA-1
Received: by mail-wr1-f72.google.com with SMTP id i9so1626315wru.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 04:16:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eh4yN5hoXKIHr0Y4kKL2j19glvafCP0ncaEOaLM+6RU=;
        b=ARTRhHZoOKloK+WwgNx+qVt10jFxkfGUSbNuhWH3YdCFw0aoFVnirZQEqnGOY6RztP
         LZ0hxB7Aux6sUp9et3aCS7AGqUJYme8sfWldtmnokgrwJtK12xP5VyxdqUqIpOrKt2yF
         NrBG6JK0/K5EI0W1k3U7AMQN1INbcML+ExQjIl/vtastkQttDBDQA/CCE5kuFBZ7ZcoZ
         udg0/Kp++/gGwfQRqNEz9aaNzdPQpI5gmjZjBvsJQhHG5qXOAAn1U2HA9JkvqJ7+uJ4Z
         qMkeSBf/HLA0sp/xLeJ8Yl6xYy2YRc7juExH2hU05ypOSmDrbOMJSGxqyASdw+AEhl4w
         SjYA==
X-Gm-Message-State: APjAAAX2lFKRDFkslf51pb1OApANSAawXB98lX5pD6LrNKoXD08s7nPb
        sCt+n5S1J/YapeK3muupXuF2yKLSuaBj2gT+4y6fEva1/ga1OtyOgHwMT8YU+vn8Zx1Xk3Hw9Pa
        +tXSsFZnZ8NRh
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr3888528wml.43.1579781817256;
        Thu, 23 Jan 2020 04:16:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjrSg8QS3n58Hsbb+jpFpGNeljke+sE5P4DKFi46EAMGGsbNN5r4mMO0nv0ERsa+/0bhSuTA==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr3888510wml.43.1579781817032;
        Thu, 23 Jan 2020 04:16:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id t25sm2489035wmj.19.2020.01.23.04.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 04:16:56 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and
 generation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1579623061-47141-1-git-send-email-pbonzini@redhat.com>
 <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
 <20200121210405.GA12692@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <533d3dd4-aa8e-07d0-2e8a-991fa758a366@redhat.com>
Date:   Thu, 23 Jan 2020 13:16:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121210405.GA12692@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 22:04, Sean Christopherson wrote:
>> Alternatively, BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK |
>> MMIO_SPTE_GEN_LOW_MASK) & SPTE_(MMIO and/or SPECIAL)_MASK)
> Or add both BUILD_BUG_ONs.

In the end I decided to revert MMIO_SPTE_GEN_HIGH_START to
PT64_SECOND_AVAIL_BITS_SHIFT (it makes sense since we use it for
shadow_acc_track_saved_bits_shift, and whether to use
shadow_acc_track_saved_bits_shift or MMIO_SPTE_GEN_HIGH_START depends on
the SPTE_SPECIAL_MASK bits) and use Ben's suggested BUILD_BUG_ON.

Paolo

