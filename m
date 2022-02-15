Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F264B77F1
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbiBORcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:32:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiBORcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:32:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 699C427FDC
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644946356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUWKvRPFIUompZzXMUzAfR5oWcRMND1J2nAFRqd8Bt0=;
        b=K4UHKWWSQuB01rMPX5IKwDge90BqSiQMXQbpam5PoSTeLBae7L8MB21NgPDCPdFbU8sXyL
        FtePqNNkRq3BfQutTDLgcFx5qHlLpiGGiWiI/pHHVaEwtFCiidCrvqeyAvPkFsA0sihu//
        ch4OLx5CEMIk7zJyrTZ/3MvUJSz33WU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-sf9ZyM08P-qoa6hzaHdp5Q-1; Tue, 15 Feb 2022 12:32:31 -0500
X-MC-Unique: sf9ZyM08P-qoa6hzaHdp5Q-1
Received: by mail-ej1-f69.google.com with SMTP id ky6-20020a170907778600b0068e4bd99fd1so7642574ejc.15
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NUWKvRPFIUompZzXMUzAfR5oWcRMND1J2nAFRqd8Bt0=;
        b=H3PuphEDtQtsnuvc9ZT/4dl2GBe6J5TwOEmLs4k9ecXIv82JzKLzPF7CEQO2qhyKBW
         EkhLM5U/5W8tzuWsOw33251X8qoujO4aTKsSzjBw4C9x9tL4bu51rtolZiB+HynYpsWZ
         UXwYohY96ZfdqpotbM2zxpv8F9nNfo1NPuBcRohaUJyT/Ypc6+91bf/wj97xA+J0wE1o
         F5GlKZ+uRmW6g/UDZ0JpqUisHXxk0UE6A2iHZg83Zc9Yltt2BKeduo5oJ4xFIuaCTxmE
         swLi6dEkjLRbcl+IZor6cib9NmJ1jU3C0xLWcPS/POsTBTuoe9SSZ0wSvGuCG5hofoHq
         d8cQ==
X-Gm-Message-State: AOAM5337eYAM2UBh8ECVxsMc2xy2ZdMjAAdfhbl6dlOhHlIqKcTOr2UJ
        o5E5j/7qg4kGAajALHFXoc5wriiZ1gXDxJfLc5X/w/RF2+l8qzVbbsSKl285oW771XQi9pacD30
        mLZSgJOaUtnA0
X-Received: by 2002:a17:906:3851:: with SMTP id w17mr106298ejc.291.1644946350182;
        Tue, 15 Feb 2022 09:32:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtPCKGIL3qJS8NqQkXmxmpHleq/oZ6ds5M3l9NtEsk3cMPjgJjMZZ5EzwNcmYCNMtSo8cHrA==
X-Received: by 2002:a17:906:3851:: with SMTP id w17mr106282ejc.291.1644946349982;
        Tue, 15 Feb 2022 09:32:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o10sm8805382ejj.6.2022.02.15.09.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 09:32:29 -0800 (PST)
Message-ID: <6acb27b2-f976-f500-fa0d-2dd8d8926a63@redhat.com>
Date:   Tue, 15 Feb 2022 18:32:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org
References: <20220214212950.1776943-1-aaronlewis@google.com>
 <CALMp9eRojXiKrK-jUpYvZniJh6NtocXVpE-awQsiRV1NhSSXhQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRojXiKrK-jUpYvZniJh6NtocXVpE-awQsiRV1NhSSXhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 22:48, Jim Mattson wrote:
> On Mon, Feb 14, 2022 at 1:30 PM Aaron Lewis <aaronlewis@google.com> wrote:
>>
>> Add the capability KVM_CAP_ENABLE_CAP to x86 so userspace can ensure
>> KVM_ENABLE_CAP is available on a vcpu before using it.
> 
> That's a bit terse.
> 
> Maybe something like:
> 
> Follow the precedent set by other architectures that support the VCPU
> ioctl, KVM_ENABLE_CAP, and advertise the VM extension,
> KVM_CAP_ENABLE_CAP.
> 

Thanks, queued with updated changelog.

Paolo

