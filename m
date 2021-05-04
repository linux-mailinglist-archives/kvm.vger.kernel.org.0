Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E00937267F
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhEDHXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 03:23:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhEDHXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 03:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620112967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mhr4vtYbIV3+gcbn8jvNDanz77HnPGouREoZC9BXQoM=;
        b=JvBj6gvePKoX/KvhIHqKQ4VKrBUPGob4ypMrNv05E5pFbQ3rBL3OagFbfRcIo9ocWjsuA9
        SaJzPM1MxgfjCVyuF6SzyG+JYy+GMvwPOfqQm4arRoZCHve5lAscZcC0d+AC7D/x6u6Utw
        allHQEAIo8RwWeDYymgfvNYWP7SmLxo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-MatjjliSOcq5wMetfma9_w-1; Tue, 04 May 2021 03:22:45 -0400
X-MC-Unique: MatjjliSOcq5wMetfma9_w-1
Received: by mail-ej1-f72.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso2792775ejc.7
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 00:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mhr4vtYbIV3+gcbn8jvNDanz77HnPGouREoZC9BXQoM=;
        b=EFYD8V4o13cQmBRfUqjYOLWO54PaAPEgkovXunB5rrAgja+ROnao1c6igbwBBtaTqL
         br7sTYN5ent0+RgpbLyhMcvOS/mcpoa2J2rYojv79dcctLK0VFdP4YeDxuGLSb1p4sVO
         9bv4ZEHoaaQxg06S6tvE5UbFRf35a1ZUDFx7yAcCemtX2aj4SZBZwOpVbqXRYjk152US
         rRtUDuZK1QtqcES7mBCdZesGNawc/+F1l1Q1cyq1d423FC2/1hXQaEl3rvkr3jWsa4su
         Mijtd5hpD4SzilLOihmOsPiaCmg+rZxV57DSBiVb2EUJ4EtXOaHf8VynbUjr6o/xixwI
         vDLA==
X-Gm-Message-State: AOAM531tsI08r0+1GCtwErkG4RHfiITl8sJBIiJYOUrqcCyIRFFsz5KX
        nJi3tQybFzrAU3b2oP+THO73GCjzUutXXLvZYXRqGesGIwoWB2QL0WQBvxLi6Mr8LsyfwLCe9qV
        QFsteBJ0GuT1n
X-Received: by 2002:aa7:d146:: with SMTP id r6mr20887982edo.344.1620112964220;
        Tue, 04 May 2021 00:22:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg6GUPMEJ8U43lXv68gNhg8URZDrfW8WNW3qQKYNn5OC+cqrppm05kGj9FncYwc8cQ70hywA==
X-Received: by 2002:aa7:d146:: with SMTP id r6mr20887973edo.344.1620112964071;
        Tue, 04 May 2021 00:22:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q16sm14022935edv.61.2021.05.04.00.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 00:22:43 -0700 (PDT)
Subject: Re: [PATCH v2] selftests: kvm: remove reassignment of non-absolute
 variables
To:     Jim Mattson <jmattson@google.com>, Bill Wendling <morbo@google.com>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shuah Khan <shuah@kernel.org>, Jian Cai <caij2003@gmail.com>
References: <X9LJE6ElVfKECnno@google.com>
 <20201211012317.3722214-1-morbo@google.com>
 <CALMp9eSvMtaXndor9=h40utaefQs9BPKknV7nbWFQi0phr_TvA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <01ac0ff6-f35b-5bab-a355-edcb499cd2d2@redhat.com>
Date:   Tue, 4 May 2021 09:22:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eSvMtaXndor9=h40utaefQs9BPKknV7nbWFQi0phr_TvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 20:37, Jim Mattson wrote:
> On Thu, Dec 10, 2020 at 7:58 PM Bill Wendling <morbo@google.com> wrote:
>>
>> Clang's integrated assembler does not allow symbols with non-absolute
>> values to be reassigned. Modify the interrupt entry loop macro to be
>> compatible with IAS by using a label and an offset.
>>
>> Cc: Jian Cai <caij2003@gmail.com>
>> Signed-off-by: Bill Wendling <morbo@google.com>
>> References: https://lore.kernel.org/lkml/20200714233024.1789985-1-caij2003@gmail.com/
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

Queued, thanks.

Paolo

