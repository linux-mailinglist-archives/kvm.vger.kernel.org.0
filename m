Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79225416DC7
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbhIXIcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244633AbhIXIck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 04:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632472266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSnZGJCbTcSJO6rG4phjkfI1j3OdPwdw6IlhGD/k0Oo=;
        b=bgDyA7Lovh1YWtEh0MKOkNqunUlaeV3k+FS+Xh0RAxSIsecWg9sy3rebqraOM8SsM35Zo1
        vi5Cnzt3qQc55KYl9ckMYjN74dqubiVIp2qZZX7yOqHTN5SNMNjhTBNa4E6nQ/c+pvrIT7
        lv0/aATCuEk6GTsH3qjZz7qEcJ0d3Zs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-cya7_B79O5WozlVoUgYpWA-1; Fri, 24 Sep 2021 04:31:03 -0400
X-MC-Unique: cya7_B79O5WozlVoUgYpWA-1
Received: by mail-ed1-f71.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so9445901ede.16
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 01:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSnZGJCbTcSJO6rG4phjkfI1j3OdPwdw6IlhGD/k0Oo=;
        b=eefLw3GqimOLstBTWpADlaxUpv6DGkFfsdaN4/1HKUGIFktfZ0b26gIAwTvIe0UdK9
         ntF3DC4E18aTtmFhdkYHUGR5aJujmHVncbEZ1OrpGo9nZvgaWgbY2DOrCZa1MyixjhaW
         8scFE9ojNVRec096jtyAxprlXVmNkgAaQt7VxRTxgnMrithS9gWVnAD0KYFrJy0ERgUS
         H0PrPsfmPn6wWUQMmSXE/GMj0OLNG/ANOd9+DHdRizlZs0xRIUWGrwfF1Et7PWHl6qVV
         eeLY0PcwAT328pXi7EQ4SEtqXCU3e1foieU6VUPTlYwktTIev08hd3q2/eWXM/xQs7xF
         AfOg==
X-Gm-Message-State: AOAM532n+IM/QgGzGxjuI1KUQupYOKEPcZkqHF6rVLxieA/9TgCxd0f7
        87kVoNHSiSgk/FXnFUjzMLd0TETzHxFmhcc09YfKPseiFH6wO0D/PyXi4dNKY+OYvQQHqmePOeB
        4ZPstgkX51Lob
X-Received: by 2002:a50:cf48:: with SMTP id d8mr3594342edk.293.1632472262402;
        Fri, 24 Sep 2021 01:31:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB6fhbrACM6SNmaKLXqckkt9a//IZZDZktY0WH+vM3AOK0/WS0xxZ16zy87K95z3GoU0t8WQ==
X-Received: by 2002:a50:cf48:: with SMTP id d8mr3594312edk.293.1632472262220;
        Fri, 24 Sep 2021 01:31:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id eg39sm5347244edb.16.2021.09.24.01.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 01:31:01 -0700 (PDT)
Message-ID: <82950bfb-4624-b90d-0533-f62aeeb1b7de@redhat.com>
Date:   Fri, 24 Sep 2021 10:30:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v7 3/6] KVM: x86: Report host tsc and realtime values in
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
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-4-oupton@google.com>
 <20210820124611.GA77176@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210820124611.GA77176@fuller.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/21 14:46, Marcelo Tosatti wrote:
> On Mon, Aug 16, 2021 at 12:11:27AM +0000, Oliver Upton wrote:
>> Handling the migration of TSCs correctly is difficult, in part because
>> Linux does not provide userspace with the ability to retrieve a (TSC,
>> realtime) clock pair for a single instant in time. In lieu of a more
>> convenient facility, KVM can report similar information in the kvm_clock
>> structure.
>>
>> Provide userspace with a host TSC & realtime pair iff the realtime clock
>> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
>> realtime value, advance the KVM clock by the amount of elapsed time. Do
>> not step the KVM clock backwards, though, as it is a monotonic
>> oscillator.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Oliver Upton <oupton@google.com>
> 
> This is a good idea. Userspace could check if host and destination
> clocks are up to a certain difference and not use the feature if
> not appropriate.
> 
> Is there a qemu patch for it?

Not yet, but Maxim had a patch for a similar series (though with a 
different userspace API).

Paolo

