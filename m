Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C00D47C4FD
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 18:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhLURZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 12:25:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231187AbhLURZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 12:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640107535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpMAKTPI9NtZbIkMOT0OjSfsB3dq7tMKVr95wUp0KCk=;
        b=bf/I8JURNARNAmEapJbL2CXWXo5/WFDSadaTZRdVTCNYrAU1QGWvQPEkuCXhFEI1BpU7Kq
        Tua2FJEk879ZQzY97FxqKYzrYotaZQNuxedMSrpx5JDgzmccYLvxk3UotdFqIuaaqyNji7
        NqUT6FL9Nro5A3IabtC1tq2+yqs9NKQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538--DHMnGU1PZeF2qCdcMVgTw-1; Tue, 21 Dec 2021 12:25:33 -0500
X-MC-Unique: -DHMnGU1PZeF2qCdcMVgTw-1
Received: by mail-wm1-f71.google.com with SMTP id a203-20020a1c7fd4000000b0034574187420so1551522wmd.5
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 09:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bpMAKTPI9NtZbIkMOT0OjSfsB3dq7tMKVr95wUp0KCk=;
        b=X1LcaDfmKVY8KL/Hn5F34nc4gHGojHfa54O/QpVmXgEzMIvD5l2Oh5L8RDVAeh+/a4
         xO525dCx8f6a7doYPzBzKeLCw4ruIEpCLuFcysHf9batT30yDQlmO75r94oA5ESy8M3M
         YcADvDcajGuyPdPhfHR0jjO7TfknXWymxSKGj7oWA6SrTc5YQT8VuA7ewi9Bja4eWxmO
         1PbGn0PX/A30KCum+X3k3Ra3TLIloJ8mKxYKMi6biTXtVMLzCP2JPGdT+nkkEJvpRNle
         xT7IbfD0P6KPYO68pVNBpZ0p0ivVv6sOtg0jfWQ9kb7/30W4F2CbrUB/ta1i2UIDnucd
         RTrg==
X-Gm-Message-State: AOAM531sK+tQeEO0R9y9TdIF0d2WdNMURkexcOcTJ3KO7DyNUlqOlFl7
        P2xYPnA1gFDWhWYgnat37lSrdw/DSs3jbT57IlWehaKM60+ZBfweY8vlig9jWEUnyqd81Jlwhet
        /Z0F8jPMuuJRV
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr3563596wmj.117.1640107532497;
        Tue, 21 Dec 2021 09:25:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxn98hSTsTiU6xkhBq04DmmPCoKBPrX0VAlZIsbWZ8NWz/sDBAVPuXIc3JRaD2wYbHKO7989Q==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr3563585wmj.117.1640107532312;
        Tue, 21 Dec 2021 09:25:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c7sm22285422wrq.81.2021.12.21.09.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:25:31 -0800 (PST)
Message-ID: <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
Date:   Tue, 21 Dec 2021 18:25:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
 <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 11:12, Thomas Huth wrote:
> On 21/12/2021 10.58, Paolo Bonzini wrote:
>> On 12/21/21 10:21, Thomas Huth wrote:
>>> Instead of failing the tests, we should rather skip them if ncat is
>>> not available.
>>> While we're at it, also mention ncat in the README.md file as a
>>> requirement for the migration tests.
>>>
>>> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>
>> I would rather remove the migration tests.  There's really no reason 
>> for them, the KVM selftests in the Linux tree are much better: they 
>> can find migration bugs deterministically and they are really really 
>> easy to debug. The only disadvantage is that they are harder to write.
> 
> I disagree: We're testing migration with QEMU here - the KVM selftests 
> don't include QEMU, so we'd lose some test coverage here.
> And at least the powerpc/sprs.c test helped to find some nasty bugs in 
> the past already.

I understand that this is testing QEMU, but I'm not sure that testing 
QEMU should be part of kvm-unit-tests.  Migrating an instance of QEMU 
that runs kvm-unit-tests would be done more easily in avocado-vt or 
avocado-qemu.

Paolo

