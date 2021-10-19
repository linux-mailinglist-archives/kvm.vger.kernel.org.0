Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7463C433997
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhJSPET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:04:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231250AbhJSPES (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 11:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634655725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jhxQbCvPt9k7qjV8cpAQkgXwZ1CfLLc9Rp47cIV8fMc=;
        b=eLkuLh7LgT3/CW/XPbv7RvYuA0TNeV5r0lYO7PTuYyi+ukAfWyjxQ4QAgjwBKSIU4Zi77A
        kzzKpIvhJAIRwfmbiglmIjyMZk73Ebq3X++dWrcozilqGYDxsMZT2hO/q9Z4717310/GMt
        YpdNOAXhJKuLM0iRV/BniBpfJGGw3TM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-GpcvmPqsMRKy7NJrerq1mg-1; Tue, 19 Oct 2021 11:02:03 -0400
X-MC-Unique: GpcvmPqsMRKy7NJrerq1mg-1
Received: by mail-wm1-f70.google.com with SMTP id n9-20020a1c7209000000b0030da7d466b8so1268444wmc.5
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jhxQbCvPt9k7qjV8cpAQkgXwZ1CfLLc9Rp47cIV8fMc=;
        b=oHtjJZkGiauTRv2tHQxGK+NDsLlpyrDlFAKG2zmiSmLS3+7sunYLuQ4TKI96pIb2yr
         55daD/xK9vmVPuOErThzCSikfDvrSE5W2nMCMC832aI1g/wimB8YWrGXU3PyTZVGJHVn
         /xxukg6aoXN0xCrZdTYOWAycutYsWaEdRW52jomn/YmonZil9vObhX46fcB+OysHf5Rw
         r7p/Gm0vuLwtjLJ0sAsOd0F+I+uXVckMxIm7yRceQzrgzt1oamw69CIkQUYRfGG85DjQ
         iYYvoQtA7bICzCnIPZ6DywdzX9c+sVlMrELs9vo1i22MqV1naDukEr4OjukYSimbKxPn
         ffXQ==
X-Gm-Message-State: AOAM5322hvBEQIeGgmWOlwmhez1a/M+v/q93bKtbuRuyVbKjhHLzKeSt
        RMqClBZNtVOH02PdrvZpVe58S3AnAjqY1BfFDMsudismelcOyp5SCfVltIljYq2XyCgHAyIbE/N
        hJQnm4TCjMak1
X-Received: by 2002:a5d:6501:: with SMTP id x1mr43092280wru.77.1634655722241;
        Tue, 19 Oct 2021 08:02:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHgWKl7qyYHVtvsIGGKfTGDA74aQXfzBBZHNOVU1NZOwzuqKP3gXixuaOZtvUfNTwapsZn9Q==
X-Received: by 2002:a5d:6501:: with SMTP id x1mr43092239wru.77.1634655721906;
        Tue, 19 Oct 2021 08:02:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id n17sm15231642wrq.11.2021.10.19.08.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 08:02:01 -0700 (PDT)
Message-ID: <f7aa03ab-2067-be7f-06c0-1aad96e460a4@redhat.com>
Date:   Tue, 19 Oct 2021 17:02:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1] KVM: stats: Decouple stats name string from its field
 name in structure
Content-Language: en-US
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
References: <20211019000459.3163029-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211019000459.3163029-1-jingzhangos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 02:04, Jing Zhang wrote:
> There are situations we need to group some stats in a structure (like
> the VM/VCPU generic stats). Improve stats macros to decouple the
> exported stats name from its field name in C structure. This also
> removes the specific macros for VM/VCPU generic stats.

Do you have other uses in mind than generic stats?  I didn't like the 
"generic" macros very much either, but not being able to use "#" at all 
is also not nice.

Paolo

