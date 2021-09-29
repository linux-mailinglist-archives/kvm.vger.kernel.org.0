Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232E541C35B
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 13:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhI2LWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 07:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245694AbhI2LWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 07:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632914436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QT1rFRDBhzmSS+/lGbt19+2aAndXLLtwvTkh1G4vaX8=;
        b=Cswm0QeTk1WyNE2MH8WI8CGhXf65dnA/VfUHKIf2ze+V5LPhmLiXdgR2ruGoAq5US1Kddo
        qJPXiNc9wzcWTXGBrkl9wce/0sk4BPwxN10ZqX+5sGEUqc39tJ49lULzqjRKqot4v3ilTP
        OOI+GYCqUQKmmVUsJ8hfRC19DKBvUGI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-z05M6g0aP_6zw1T8pqkdZA-1; Wed, 29 Sep 2021 07:20:34 -0400
X-MC-Unique: z05M6g0aP_6zw1T8pqkdZA-1
Received: by mail-ed1-f70.google.com with SMTP id e21-20020a50a695000000b003daa0f84db2so1986452edc.23
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 04:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QT1rFRDBhzmSS+/lGbt19+2aAndXLLtwvTkh1G4vaX8=;
        b=KgbaBbriInmIGqfc0tCF5diKk2Tyye74jHXuhUV+Ffy3L/dKb4b/8NUwiV9W4iFTHS
         YL7qpilk93Po5PUUnhykZLZX7PgS7g9aJHl4HsIZkaRLN4CnPygXSneQpsyeRNbvhxQf
         2Tt/hBSlFn/OBZ0eG47Xejy6WROfPkzAO7pWXMA603V/YEskk2bl524gDI9lCOBJHxtS
         /nWgbWVlkUxvzh4RHaoC37YciMtffEnAcM/7UwIa9xPfsyozc3SK923nqnO130WoxiIG
         Oe5qnD3L3LYyna52+sPH6cuVgMOeBYCxTXWHo+bp/Ufu3OFBEln4lkl+vGP2peg4qyZE
         Vp6A==
X-Gm-Message-State: AOAM531QBMDxytysR7sDVv5lvsEcInjcPGmWTL/Zxyx5ICeBhEwCmMsY
        ThmreOZdc8xjWKe/qi1Q4pKXY6Vq3ACDJgIj5YT+hlgAO+PiGaTWiYpimnNiYxUAnJ1Hmw6Ntor
        cp2c/vpU34F+7
X-Received: by 2002:a50:d9cc:: with SMTP id x12mr14222004edj.44.1632914433624;
        Wed, 29 Sep 2021 04:20:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGsZ/Prx5O98qPZ8PyofLqYoLSSiZlZikvftKjUT4ZzCknxR+J5Y+KhHMLF54Y/OqTNkUIVA==
X-Received: by 2002:a50:d9cc:: with SMTP id x12mr14221990edj.44.1632914433453;
        Wed, 29 Sep 2021 04:20:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l16sm1352795eds.46.2021.09.29.04.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:20:32 -0700 (PDT)
Message-ID: <b352c9db-6d1d-ceb9-e313-b96794f8b82f@redhat.com>
Date:   Wed, 29 Sep 2021 13:20:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Content-Language: en-US
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210928185343.GA97247@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210928185343.GA97247@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/21 20:53, Marcelo Tosatti wrote:
>> +KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
>> +structure is populated with the value of the host's timestamp counter (TSC)
>> +at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
>> +does not contain a value.
> If the host TSCs are not stable, then KVM_CLOCK_HOST_TSC bit (and
> host_tsc field) are ambiguous. Shouldnt exposing them be conditional on
> stable TSC for the host ?
> 

Yes, good point.

Paolo

