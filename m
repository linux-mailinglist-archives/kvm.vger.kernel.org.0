Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF12912294A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 11:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfLQK4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 05:56:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58525 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727322AbfLQK4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 05:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576580165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YXF+elRVzXLhdr+9giyG2zztECFyS+Gyw0f0P8IQWyw=;
        b=VFNazy65Rv/7Mt8zKs5BqS39tn3Q/+Ex3+b5Vsx20F+CnyqOTQSAw+KANUkMatCjF/81cn
        vVM7TG2/FkLKRRK6WW5ovHd6r2AF47nSG4z1F8PhGeXvHdvXsv+oru7IULXX0UF1c7I3rT
        FuZcuoKj87vv31Tf0LMTAlxCobW5uos=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-TcuOxKI7NUiSHW7RWaSaBQ-1; Tue, 17 Dec 2019 05:56:04 -0500
X-MC-Unique: TcuOxKI7NUiSHW7RWaSaBQ-1
Received: by mail-wr1-f69.google.com with SMTP id b13so3791067wrx.22
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 02:56:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YXF+elRVzXLhdr+9giyG2zztECFyS+Gyw0f0P8IQWyw=;
        b=h6AU9sv0e461ouozesJI2uOYd7n3dY97CXeGmHu2GVgX3lrjSRaFKIxp2waFfaSFLm
         hedcTbJ4YmE6ZFGG1IKeYfo5sS2fD3rg7ESCiWZRrE/rhpBKAlaIU1wRYUyLbG7zG6QO
         gxJ2JpskV2OMSb7mgLmD346hYqlxPlSCzKyFqRlMY4xHc9XknMI9iN+wHdbjNNAWpd9B
         nmzYTDHZV9+JjSy5XuZSxJ7InwyqB/jmukedveMF8m+73HmgHyUuyvzmPmCtAVfbrv67
         vwESKcwvXoR0sE9V3y4qd+vKkselsixhgoskcSmQYN/YCmOrIOX8P+6RxGTXfSDSZSht
         TIaQ==
X-Gm-Message-State: APjAAAVjZZtOQ/nY3qQjkOvW+3nMyirJGKlj4Whwdkw463qiPLD0+WjA
        CuwKvJXEw2P+dMJKITd5VQYW/DqG4K3Ff2dw3gMHNEQNII0yoWIDEO1j0c5GbonIlVsaEAFLnKe
        GSnHyJLIMquZU
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr4797633wmi.128.1576580163176;
        Tue, 17 Dec 2019 02:56:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzhVwQPSft1lYsyzJYqBKH6IW8RBxNYDvnvQNIdlJaW/TJ0sT8jL6G84FbJcBD8AYDdWre6Q==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr4797603wmi.128.1576580162924;
        Tue, 17 Dec 2019 02:56:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id v8sm24693464wrw.2.2019.12.17.02.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 02:56:02 -0800 (PST)
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, paulus@ozlabs.org,
        jhogan@kernel.org, drjones@redhat.com,
        Marc Zyngier <maz@kernel.org>
References: <20191212024512.39930-4-gshan@redhat.com>
 <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
 <f101e4a6-bebf-d30f-3dfe-99ded0644836@redhat.com>
 <30c0da369a898143246106205cb3af59@www.loen.fr>
 <b7b6b18c-1d51-b0c2-32df-95e0b7a7c1e5@redhat.com>
 <87r214aazb.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a9ad4ce5-6f1d-7471-5765-331d3f7a4b03@redhat.com>
Date:   Tue, 17 Dec 2019 11:56:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87r214aazb.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/19 10:14, Vitaly Kuznetsov wrote:
>> Well, I would like to receive Vitaly's comments here. Vitaly, it seems it's
>> more realistic to fix the issue from kvm_stat side according to the comments
>> given by Marc?
>>
> Sure, if we decide to treat tracepoints as ABI then fixing users is
> likely the way to go. Personally, I think that we should have certain
> freedom with them and consider only tools which live in linux.git when
> making changes (and changing the tool to match in the same patch series
> is OK from this PoV, no need to support all possible versions of the
> tool). 

I'd agree with that, plus trace-cmd since it has a KVM plugin,
especially since KVM has for example debugfs stats unlike other
subsystems (and we're tracing debugfs stats as stable userspace API, and
planning to move them somewhere out of debugfs).  But I wouldn't
complain either if architecture maintainers feel differently.

Paolo

> Also, we can be a bit more conservative and in this particular case
> instead of renaming fields just add 'exit_reason' to all architectures
> where it's missing. For ARM, 'esr_ec' will then stay with what it is and
> 'exit_reason' may contain something different (like the information why
> the guest exited actually). But I don't know much about ARM specifics
> and I'm not sure how feasible the suggestion would be.

