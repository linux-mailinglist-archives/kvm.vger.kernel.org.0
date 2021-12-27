Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F05480464
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhL0T3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 14:29:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232349AbhL0T3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Dec 2021 14:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640633380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXeuw5/VQou208uQgpTgJva1XF/iFx6NuY0yYdLIPAM=;
        b=VerxvA6yJeZAcC+JTFBFPdm2vmNeNAg3FgRCeU+YnB1Oar36Ar6m40fDhsTxQg0m9k4Ico
        aCgoEv8rOKuS65riAHE7YMJEZE+W5W6sr7Y12NSixv6AA12FNZzgJM9PI41TmQlO45nCyu
        zW4KVHnuhFYniWOCv1IzsLj1qa0Mz8M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-rv3-Xs7BOHGQhVfqD5jZ2w-1; Mon, 27 Dec 2021 14:29:39 -0500
X-MC-Unique: rv3-Xs7BOHGQhVfqD5jZ2w-1
Received: by mail-ed1-f71.google.com with SMTP id z3-20020a05640240c300b003f9154816ffso2521816edb.9
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 11:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GXeuw5/VQou208uQgpTgJva1XF/iFx6NuY0yYdLIPAM=;
        b=VYpLmzm0fQSHrHu/ExRTFODMqL4ScvcsIq56pF+U42fwu3RUZCxS7du+uFzZb+Sq0a
         OFX9lqEBNFG5AHXBlygBLULWS6wdzlojie2qRInbdZvuJrze6MpQtDDbw+evx6iy4lmn
         TwhQvIiRXowkwmVo8bkxA36KPqxS2FOfctARctNCLVpShQ/LAO5V7mqyMKhATlYhBoS8
         e1vPOFBqpF6aY4hqx5/MNP/VScBUqxzBLYsd9+b607cjXf7+2KdxajvWYcpVsdJuaffG
         DcCaPYUR3nbZKGL9EJD6dSOcfQSNyRB77xfI0yNqNi/HvFcrRKj4rHjGjRX/stWxfyTz
         tn5w==
X-Gm-Message-State: AOAM533ZFE5OeIEqyf2S08Ys5nqCSuJ96Q+8XYhCRbs5J3F4MeI4u7Z8
        V/Lp+s8njI1OBqlzTUtVPe5CkgUuSddRA6KeWM004LXzxxhcN9t4kOFbJOV01kdMGfbSlGT7uyA
        4rGlBBmtLAIcN
X-Received: by 2002:a17:906:58cf:: with SMTP id e15mr14661372ejs.343.1640633378223;
        Mon, 27 Dec 2021 11:29:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvH64YUKfWEKEQEA/Uc6NpU+N+4TFwpuSi74hwBNqKMn+Hyb+J7Dg7LDSADLd0E4kMs2bxmA==
X-Received: by 2002:a17:906:58cf:: with SMTP id e15mr14661361ejs.343.1640633377972;
        Mon, 27 Dec 2021 11:29:37 -0800 (PST)
Received: from [192.168.8.101] (dynamic-046-114-172-006.46.114.pool.telefonica.de. [46.114.172.6])
        by smtp.gmail.com with ESMTPSA id o22sm6556633edc.85.2021.12.27.11.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 11:29:37 -0800 (PST)
Message-ID: <0eba82cd-e8aa-7aeb-f414-0909da19ef0d@redhat.com>
Date:   Mon, 27 Dec 2021 20:29:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
 <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
 <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2021 18.25, Paolo Bonzini wrote:
> On 12/21/21 11:12, Thomas Huth wrote:
>> On 21/12/2021 10.58, Paolo Bonzini wrote:
>>> On 12/21/21 10:21, Thomas Huth wrote:
>>>> Instead of failing the tests, we should rather skip them if ncat is
>>>> not available.
>>>> While we're at it, also mention ncat in the README.md file as a
>>>> requirement for the migration tests.
>>>>
>>>> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
>>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>>
>>> I would rather remove the migration tests.  There's really no reason for 
>>> them, the KVM selftests in the Linux tree are much better: they can find 
>>> migration bugs deterministically and they are really really easy to 
>>> debug. The only disadvantage is that they are harder to write.
>>
>> I disagree: We're testing migration with QEMU here - the KVM selftests 
>> don't include QEMU, so we'd lose some test coverage here.
>> And at least the powerpc/sprs.c test helped to find some nasty bugs in the 
>> past already.
> 
> I understand that this is testing QEMU, but I'm not sure that testing QEMU 
> should be part of kvm-unit-tests.

It's the combination of QEMU (migration handling) + KVM in the kernel 
(register saving and restoring) that we are testing here. If you say that 
QEMU should not be involved at all, we could also say that all 
kvm-unit-tests should be converted to KVM selftests instead...

>  Migrating an instance of QEMU that runs 
> kvm-unit-tests would be done more easily in avocado-vt or avocado-qemu.

But we don't have the environment for compiling small, Linux-independent 
test kernels there, do we? So unless there is a way to write and compile 
small test kernels in that framework, I think kvm-unit-tests is the better 
fit for these kind of tests.

  Thomas

