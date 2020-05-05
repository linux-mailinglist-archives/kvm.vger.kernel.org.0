Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B501C5484
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgEELg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:36:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEELgZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 07:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588678582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x2FjQAZY3rz08zRV+CTT5963v5ngAxHKCBr7Wo/WiIQ=;
        b=QzTqzvWLIVzImUYmPhRJ4yp4OI1BWNxWgp3KgukBfKTs9wVQn/Q/VkEqwmr2COfLj71FtT
        gu4MFE2Co1hCk0LQQrFFsnWuGiL6BlKhG1TxoljCb7Sw1CuK42f2QPnMIFfIpVS8CoB8kT
        sIZADDD8KSAivQDQS3wW0Ivl3/vmgS0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-6QrBmDGhOoWMDYN6Wd3ewQ-1; Tue, 05 May 2020 07:36:18 -0400
X-MC-Unique: 6QrBmDGhOoWMDYN6Wd3ewQ-1
Received: by mail-wr1-f72.google.com with SMTP id e14so65958wrv.11
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 04:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x2FjQAZY3rz08zRV+CTT5963v5ngAxHKCBr7Wo/WiIQ=;
        b=TmvcUGp8wO6D282459JP1u7ShP6N9dWZUCe9Li5KSqlr+L45TSsNFzJwqk7Oicb3Xl
         Wa/abxzXmzhDv7CPpKK5i3b4DD/fUgn1H4SO8oc1iqJ8XYjmonG+OJKgLxPakyeL2l5+
         f3k66NE+BHUWL3A6bwCxqHBvqyyNzzI+yekBFqIHpt0iQ/EgOYaIHkHLZzI3rRs7UQvg
         8xAVGHlvMRkyvwwG3n2aXbZh3T18jhlSkMQTYtsmlza8u7CAoglvOjLsvY6frJzYcoh/
         EvXmdVOPa1A8ym5Y6q1kgED+KSb+BYpVIACYyR2qmc1p4iz72z6aSZmjF4wB1vIhFuAf
         EfWg==
X-Gm-Message-State: AGi0PubAWZK5jGDUn7a6q+7/MXEjdU5jSooaS0SujflhA76y/GbFFXWd
        jgMlLGBEkh8+O7CW4Rc+BgJpRvDOLWvHmtUm8zTGGhca/nS57xa7NpyCa5P7y+PKSqFOMlGumZB
        54+465732D1Ra
X-Received: by 2002:a5d:5112:: with SMTP id s18mr3415016wrt.426.1588678576957;
        Tue, 05 May 2020 04:36:16 -0700 (PDT)
X-Google-Smtp-Source: APiQypJl60n9MQpiFkNCbieDx9axKTRmRnusJD4ycTvR5+jsKe4L9ARtHDkdV2u7AzEdxcAHwg3gog==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr3414988wrt.426.1588678576724;
        Tue, 05 May 2020 04:36:16 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id t16sm3262550wmi.27.2020.05.05.04.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 04:36:16 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: cleanup and fixes for debug register
 accesses
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200504155558.401468-1-pbonzini@redhat.com>
 <20200504185530.GE6299@xz-x1>
 <06dcafe8-8278-a818-ad76-36f3bbbcc0a2@redhat.com>
 <20200504234904.GG6299@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d09671ef-0a9d-c854-7715-d3077e09e734@redhat.com>
Date:   Tue, 5 May 2020 13:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504234904.GG6299@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 01:49, Peter Xu wrote:
>> The guest debugging test would basically cover the gdbstub case, which
>> is different from kvm-unit-tests.  It would run similar tests to
>> kvm-unit-tests, but #DB and #BP exceptions would be replaced by
>> KVM_EXIT_DEBUG, and MOVs to DR would be replaced by KVM_SET_GUEST_DEBUG.
>>
>> It could also cover exception payload support in KVM_GET_VCPU_EVENTS,
>> but that is more complicated because it would require support for
>> exceptions in the selftests.
>
> Yep, I guess the in-guest debug test will still need the exception support,
> though I also guess we don't need that when we have the kvm unit test

We can still use it in order to test for example live migration with
pending debug exceptions (KVM_GET_VCPU_EVENTS), but it's less important
indeed.

Paolo

