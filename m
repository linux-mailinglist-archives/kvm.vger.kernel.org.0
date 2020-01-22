Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 591E9145A05
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAVQkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 11:40:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVQkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 11:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579711234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NqHfG4M0oTw1WAYPW8dVqwjrZnqacof+6SuwGnZ6EOk=;
        b=TBzblJJxFPRAy/wcndUUMBma196RLlHuWWAc5dl5/wuYkxTQPG4FGmbk9uaEKd2I98UfgJ
        BljABra0TcN88p63+SkKisKkqK1PHhX39OaiL5TLDpgFCZuOfLOqFdw/NwtWM4JEslepb1
        BNyFfqE3IDbJldVg7BgSbohPd0a6OqU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-7SkI-GXLNwqYXTD9w25-sA-1; Wed, 22 Jan 2020 11:40:32 -0500
X-MC-Unique: 7SkI-GXLNwqYXTD9w25-sA-1
Received: by mail-wr1-f69.google.com with SMTP id t3so49249wrm.23
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NqHfG4M0oTw1WAYPW8dVqwjrZnqacof+6SuwGnZ6EOk=;
        b=F5vwt6RpKS7QVIbxt47mcPglWZPte7LWONFpQpM9gaFhOLc312jfn9HXcPrACFBno9
         JOch5BKYVZbkEbZLvYT5FIJ5pd8+5G1V20M5zBvBnIZfiPkH/5rXsH/+xgnqbkZt+Pi5
         1TBO+uU580Gg+uBwVfZnP7KRVAmj1IgO/PIvdnFBXWOLgFuOnoqAZJeRqYE/OPAQdrSt
         tQCGo7112ikLZk/5HyVGUMtJhciqMAqUDIKRLYVgF5SFtE1KTbXEgxooqQz25zw498ig
         rGbeJJSmPmPBiLqirg/Ljin9acm3dp0MZ3+OB8RVxCIl2hY/Xf2PLLRRISj3paVB+1Aq
         qoyA==
X-Gm-Message-State: APjAAAUTsXKEZMtuAWbjCBF68DIXDZCChImwySUoNknaU6Qw8OaBlkYF
        idLZWeqC+6U+HvZK3MsH1v1kjI/In3BY+fL+y5L6mSFilgMYDfgbMWdevMMnOl3qaK/Je7rrGAE
        CnTPmIMTRDrLa
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr3620356wmi.146.1579711230723;
        Wed, 22 Jan 2020 08:40:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzlxcCPkPXf8/I59g7+C0rJdwAgIk/Qu1HaZIoBEn1yWRSeks0GxcFaBr6+ZpRZJtcz+Ttzgg==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr3620339wmi.146.1579711230491;
        Wed, 22 Jan 2020 08:40:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id q3sm59194052wrn.33.2020.01.22.08.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 08:40:29 -0800 (PST)
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
 <20200122054724.GD18513@linux.intel.com>
 <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
 <87eevrsf3s.fsf@vitty.brq.redhat.com> <20200122155108.GA7201@linux.intel.com>
 <87blqvsbcy.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com>
Date:   Wed, 22 Jan 2020 17:40:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87blqvsbcy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 17:29, Vitaly Kuznetsov wrote:
> Yes, in case we're back to the idea to filter things out in QEMU we can
> do this. What I don't like is that every other userspace which decides
> to enable eVMCS will have to perform the exact same surgery as in case
> it sets allow_unsupported_controls=0 it'll have to know (hardcode) the
> filtering (or KVM_SET_MSRS will fail) and in case it opts for
> allow_unsupported_controls=1 Windows guests just won't boot without the
> filtering.
> 
> It seems to be 1:1, eVMCSv1 requires the filter.

Yes, that's the point.  It *is* a hack in KVM, but it is generally
preferrable to have an easier API for userspace, if there's only one way
to do it.

Though we could be a bit more "surgical" and only remove
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES---thus minimizing the impact on
non-eVMCS guests.  Vitaly, can you prepare a v2 that does that and adds
a huge "hack alert" comment that explains the discussion?

Paolo

