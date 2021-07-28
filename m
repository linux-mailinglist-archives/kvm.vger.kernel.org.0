Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC093D8E0B
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhG1MmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234979AbhG1MmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 08:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627476133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCPHopCE1hY7njeyMH2koaQTnBKZzSMK8BkCg7MoVNM=;
        b=jDYY5YPzp/wr+aU5a8tEdD38roZ6qZQsnbqyF5htr+pMn8GRMr4r/5tS7+P3a6x4JqYoCg
        FgvgO38C+vU0UCX82r+hZyoY7PtCO0M66jH3NYi8DMTThUQfn/ekwV58QV3YRIFZqVUQGi
        rKDAqbXvmkRIgaMO5sq29thtk1s02OM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-L94Phc_mNIm7nukeLgk1yA-1; Wed, 28 Jul 2021 08:42:12 -0400
X-MC-Unique: L94Phc_mNIm7nukeLgk1yA-1
Received: by mail-ed1-f72.google.com with SMTP id c16-20020aa7d6100000b02903bc4c2a387bso1158378edr.21
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 05:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UCPHopCE1hY7njeyMH2koaQTnBKZzSMK8BkCg7MoVNM=;
        b=Msj0lWQbhGMP9M/k/wOUBWAVveSvajU+RSt7FV/NQEUP2ITGJOWjVSjU1eenf0tCJ2
         54B7c4zV89wlHCOiw7ObxuxDNsV4YLpJI/Q0TsglWQuqAt3cFDliD66hL/afIxA3NRPW
         g0PDvxdBry4SfT+ww1wdeKgpCYSD/mKjZ0X8snD84+MMwKmtTnEe6IuEWz1Y/UvbOOba
         Qlob8QzmdjwRzFZDueCdyn4xLJaGxshnm+jX+CZWnSfPBHZ0QVtdkmlz8deqo7PLpfhF
         9zTXFK0M1YGXwEWfurZUKCV5YMT8UrqyaeLtdXaJWFxwclgiHGnFNgoBuSwEHeBW5Ytv
         91wQ==
X-Gm-Message-State: AOAM533aspk5FKJkgX4IbxnEEOLiyoEGGHUBaAtOIqSaOioZl/ian7b7
        1fykjdx6c4zeSZxgvWxM6LJu4VEAD3KD6ZbbssqC+XgFQtkrzwpzFAgcTr/qXkDoEbdCC4TJarh
        X0xqT3VtKIIJb
X-Received: by 2002:a17:906:b7d2:: with SMTP id fy18mr1122680ejb.0.1627476131172;
        Wed, 28 Jul 2021 05:42:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjfrSHl8H0yzmTq3L8x3NALFbGYSkj8pioh8YGHJnzlWxvb+vJ9JNgulrteGa1OYK5wR0P0A==
X-Received: by 2002:a17:906:b7d2:: with SMTP id fy18mr1122662ejb.0.1627476131036;
        Wed, 28 Jul 2021 05:42:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n17sm2590448edr.84.2021.07.28.05.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 05:42:10 -0700 (PDT)
Subject: Re: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
To:     David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com>
 <YOY5QndV0O3giRJ2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40bb3dd8-346e-81ee-8ec1-b41a46a8cbdf@redhat.com>
Date:   Wed, 28 Jul 2021 14:42:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOY5QndV0O3giRJ2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 01:31, David Matlack wrote:
>> +
>> +8.35 KVM_CAP_STATS_BINARY_FD
>> +----------------------------
>> +
>> +:Architectures: all
>> +
>> +This capability indicates the feature that userspace can get a file descriptor
>> +for every VM and VCPU to read statistics data in binary format.
> This should probably be in a separate patch with a Fixes tag.

Generally this chapter (which is probably incomplete, though) only 
includes capabilities for which KVM_CHECK_EXTENSION can return a value 
other than 0 or 1.  So there is no need to include KVM_CAP_STATS_BINARY_FD.

Paolo

