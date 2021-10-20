Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58516435510
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhJTVPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:15:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhJTVOw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 17:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634764357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeczdObYg8cyKwh8+dZN9f0RdXdMWBDIfAGwpPc0UAo=;
        b=B8g38IG6wyRmhFEalINJCYEAg7mIHpGz7OtJ3u8bjWgh70WBYmtGZJQfQlVfy+KCaEvl26
        uJ96v30KHJHXwkFElutSh+EQtn2hgeuxDo9d9iYEMwnlsqPPUwqyk9oTCSYleN0XMIb3oj
        +gvibJaMZrlOWF3HpHQ9OvCkbLmEwRk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-0ghmXCjoMM6g5gM505ylGg-1; Wed, 20 Oct 2021 17:12:35 -0400
X-MC-Unique: 0ghmXCjoMM6g5gM505ylGg-1
Received: by mail-wm1-f69.google.com with SMTP id u14-20020a05600c19ce00b0030d8549d49aso2707663wmq.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qeczdObYg8cyKwh8+dZN9f0RdXdMWBDIfAGwpPc0UAo=;
        b=4h3M5XMoyseSVqxT36YEUyvB4+NjgIBwmx9QE/s3t+ZCNhuL76rQEKw57rzCTRzM8E
         xebAeBIA6Ko3u8pjWamMrryjrTpitG6soJM9U0/WHD3MVd4Gv9ZZGAnHmG3zefhp2pVs
         iMNJPla/8zNXKGt6oqqxk8imdHydvt8hO+Md0wE1w55sgljxskwNQLDBn+mYq2AiF/4R
         yIofuxVrSkKjyIN+KMvXWWjiKwBfpatJdCbC+Pirpz8HqRKDhkduVZwceYqTX3YNKg0b
         KmXecQvzA/wnTwYvlaQDw1kYPgPMNg5r/SYmjsNtHG3lIr8gYGzk4ZUm/kN6nRuuUGJ7
         ENwQ==
X-Gm-Message-State: AOAM530CcTba/IS0qo3wz5Ig8uTbeQRv7Rihvv6mZ5MQt3O+DsFE3Y/e
        kZr4QQH8P7B1SS4F8NFVR+cpvA0eZjcfMLWYCODL8TXdUUfl2h21Vr0pv5KlAimbzTLQrSUW4Sb
        amul1hzMlChNb
X-Received: by 2002:adf:f48d:: with SMTP id l13mr2091616wro.94.1634764354458;
        Wed, 20 Oct 2021 14:12:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzt3AKnDyTF/uEfpz/AYtNNyBEtgpnNcoEDTLn/NfxtjWPMBWvgybrsMKYz66nkmMyEV8ZG9g==
X-Received: by 2002:adf:f48d:: with SMTP id l13mr2091591wro.94.1634764354222;
        Wed, 20 Oct 2021 14:12:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id g8sm3008116wrx.26.2021.10.20.14.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 14:12:33 -0700 (PDT)
Message-ID: <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com>
Date:   Wed, 20 Oct 2021 23:12:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a
 function
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
References: <20211020192732.960782-1-pbonzini@redhat.com>
 <20211020192732.960782-3-pbonzini@redhat.com>
 <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 22:46, Jim Mattson wrote:
>> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
>> +       vmcs_write(GUEST_LIMIT_TR, 0x67);
> Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
> doesn't the VMware backdoor test assume there's room for an I/O
> permission bitmap?
> 

Yes, but this is just for L2.  The host TR limit is restored to 0x67 on 
every vmexit, and it seemed weird to run L1 and L2 with different limits.

Paolo

