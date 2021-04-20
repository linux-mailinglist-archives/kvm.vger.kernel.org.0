Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5DA365525
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhDTJTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDTJTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 05:19:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF137C06174A;
        Tue, 20 Apr 2021 02:18:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r12so57205265ejr.5;
        Tue, 20 Apr 2021 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EdCLib9feauaBtsAA4PP+2VZP75jl9er/fzSepd50Jk=;
        b=skmC3HkDpyGNGfZDYi+M367VKi9jGotM1zjxpDg1ja1yf8Y8Ap9o7tqnsA3kTXERuW
         wXlJkiTF7JVvuhp9bm7NYoqzNhrfVJXwBwCI+5utOi/U3Y7nCBdnhg3uJVsjOBeC6911
         kjkRIn03rRCAf7QTfD9RCc9iBEdmfNstpQ2jGBjIA/mv9M2SzDiqxuT2nbTM7B1wPN0A
         dq4ngAK8O97lUkPc5Fyi3Zvg+MISpkhc0G6WkAQPNIz5PUawyqaurqGjdmAv4TqCcz62
         NEUkA9RG+orFfxbbOAmn+X1gbbCgo8zaNoLORwsVrLzSUQZtdZlFNFkHlDyj4UA3wVkf
         bcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:references:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EdCLib9feauaBtsAA4PP+2VZP75jl9er/fzSepd50Jk=;
        b=IIhpmtoaMz4pE37vbJaJKyP+zozmPCakAkoLCeOq5kq5X+I1s5I785hy9RXYfD+O5b
         l1uKI37vnAD/xZ0TGv4x4NlO6c9uA4IsDaAyVu2tW6fyxVUDZUMWLWR4ac3OSQ0f2tbQ
         Ipkiyy+3T18b09Ek7a/JdJCC3vIh/m4TsOspH/wgCK0EJGiYjebLZ7SgrqaB579etVnp
         ptDCM4JxuSeHM2U+ztIYxmxZYP8Nk25HAa7C4w96FnF3cA7C8+yuyyA8lyKhRe8LNZYp
         Cj4iXN2yOHNIqNeDISvCXzgmqH+ue98ydcgZSUStJYgFYQhwdCCZg20QXdRCBxHV4P4E
         E1ew==
X-Gm-Message-State: AOAM533pOXHMeiD/CB6BbOlEodixvtzsSMbxf+gR/QUo4/ANCkVjaoYt
        aLWATlw0rI1RKeYAk8d/T/LWXZxQ/8M=
X-Google-Smtp-Source: ABdhPJwXDQbzF/vYu1BqYDPfcqXS94tnxjRvqPf99nheyHBI/eVCsp3atzCDFOhOXonjeKxMJl0SlQ==
X-Received: by 2002:a17:906:11ce:: with SMTP id o14mr26147286eja.113.1618910310484;
        Tue, 20 Apr 2021 02:18:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ca1sm15419691edb.76.2021.04.20.02.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:18:30 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <c7400111ed7458eee01007c4d8d57cdf2cbb0fc2.1618498113.git.ashish.kalra@amd.com>
 <8cade407-0141-3757-abd8-4399912741eb@redhat.com>
Subject: Re: [PATCH v13 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Message-ID: <f43f3608-8250-ab58-3db2-f2f698d3de22@redhat.com>
Date:   Tue, 20 Apr 2021 11:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8cade407-0141-3757-abd8-4399912741eb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 10:38, Paolo Bonzini wrote:
> On 15/04/21 17:54, Ashish Kalra wrote:
>> +    }
>> +
>> +    sev->handle = start->handle;
>> +    sev->fd = argp->sev_fd;
> 
> These two lines are spurious, I'll delete them.

And this is wrong as well.  My apologies.

Paolo

