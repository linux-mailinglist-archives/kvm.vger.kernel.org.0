Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796FF4D1E4A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348682AbiCHROq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348670AbiCHROn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:14:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A44722BD0
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:13:46 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw13so40572458ejc.9
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U1ORBeqJC6fQUGgkgeSP1sHe0LHXhoV2o6IOKLiQIsM=;
        b=IPojLBRjlZStqJME3O2TCiz+OuaYsot/H7h5SvvY5ZCEIUgaFilW5LD/456LlI1IBD
         6ihoqK9XKgnzZ5ZMi8PDrmCUNrxhKDMiPpH1PEKXx5tznAklAdP1RdAk5Zq2ABWkPu9y
         Xq11gtZIfRbGaZ4ONewHFuckoKsjUN4VZCqOfQFmIPjz2ZxZbt7+JmHPBf/zCaFs9zz+
         yxvVgtlTWjkDtIUCaQNwv8oZjGAkgrKwnrB9zKM8sk/ZDtW0+NTInKoTKPnXS9tNobv/
         7QYmMujLiAY+FuAftaCCu/Xe8FAYGisGpMlNY2fyhpdZyOC92qll4jXoNwoFRW9W8gDG
         7WZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U1ORBeqJC6fQUGgkgeSP1sHe0LHXhoV2o6IOKLiQIsM=;
        b=qTi8qJaK8XmYJ7JVklN11FzL+U6aXTBBTbt1zK97lOsrHu+eKT1xGQgXdfB3K+CQxC
         tQxixwJnaXBcrNeexi7hzQ6AMqTa1/qpE3AN1k3cAWOt7u8K5eF0frbC/hpa5wHdD2yI
         C5KPA5IYv6I5v0WtpAMjgV77nC6FPmDrOmWprXl8JOVmfvPlXaPMw7W9WCpHKyfOxY/x
         1f6IP6Py2osoeNSo2RRdw8gTSVEaQCobKA8rpDhYLXJLFOMBNffRKqFEFDe4FAdWrQtl
         AiKILttSe7i1k2Kvs+Qnk3q+2Fn+jwkujr119/QWMTwec7E89KeGelursuSLlwnqnqpu
         hSQQ==
X-Gm-Message-State: AOAM5315fqNSYJpyzm7czpFSWtXmPFl/Eq6dKRsm9BctdSSZj9UNVBWF
        MvSzlOEv6uUBGDnfYtxIf7g=
X-Google-Smtp-Source: ABdhPJz3ZkeIfzh71QwEOb4JV31mRYxVvZc6S1LkySDWpxe6jKOSS3xkctWCSlB1Trr3WFxkxVqI/Q==
X-Received: by 2002:a17:907:6297:b0:6da:6388:dc58 with SMTP id nd23-20020a170907629700b006da6388dc58mr14238948ejc.472.1646759624795;
        Tue, 08 Mar 2022 09:13:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z11-20020a50e68b000000b00412ec8b2180sm8012111edm.90.2022.03.08.09.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:13:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5a0d39d9-48b9-5849-daf7-19fbadd75f8c@redhat.com>
Date:   Tue, 8 Mar 2022 18:13:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220303154127.202856-1-dwmw2@infradead.org>
 <db8515e4-3668-51d2-d9af-711ebd48ad9b@redhat.com>
 <ec930edc27998dcfe8135a01e368d89747f03c41.camel@infradead.org>
 <adbaebac-19ed-e8b7-a79c-9831d2ac055f@redhat.com>
 <42ed3b0c3a82627975eada3bcc610d4e074cb326.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <42ed3b0c3a82627975eada3bcc610d4e074cb326.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 17:59, David Woodhouse wrote:
>>> Incremental diff to the 'oneshot timers' patch looks like the first
>>> hunk of this. I'm also pondering the second hunk which actively
>>> *cancels*  the pending timer on serialization.
>> 
>> Hmm, why so?
>
> Don't know yet. But as I added the save/restore support to Joao's patch
> I had *assumed* that it would fail when the delta was negative, and was
> kind of surprised when it worked in the first place. So I'm sticking
> with "Don't Do That Then" as my initial response to fix it.

Yes, I'm just talking about the second hunk.  The first is clear(ish).

> After a kexec, the deadline for the timer is past, and that's why it
> ends up getting restored with a negative delta. After a *few*  cycles of
> this it usually ends up with the timer callback never triggering.
> 
> I'll stick a negative delta into the KVM selftest included in the patch
> series, instead of the nice polite '100ms in the future' that it uses
> at the moment. That ought to trigger it too, and I can instrument the
> hrtimer code to work out what's going on. Either way, I think 'Don't Do
> That Then' will continue to be the right answer:)

Yep, let's keep both testcases through.

Paolo
