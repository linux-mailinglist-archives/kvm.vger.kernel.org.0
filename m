Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127B238EF9F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 17:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhEXP6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 11:58:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235210AbhEXP5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 11:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621871778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J8qJxDVQ1kylKNxI/QIRmzuDHoPUvchv3PrsNjGkPtA=;
        b=RtzUCCI9g79y398UdqB2WHkqvbhD6+CvULNXZJHkXmFaMyvMr857Cmq/Z0PZ9+lME/5HTy
        nkeBKjzKiZ2g5sHEX5eyEhp3kY9LL2EEAW8TZdKPc/zdVsLchNzFmxT2gKlDlxgqwAH3AV
        uw9i/wa6rPGL6YfjBwODAcRegJek+mQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-ozsW9z4BOWafN2h3_pQvPw-1; Mon, 24 May 2021 11:56:16 -0400
X-MC-Unique: ozsW9z4BOWafN2h3_pQvPw-1
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a0564020950b029038cbdae8cbaso15758413edz.6
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J8qJxDVQ1kylKNxI/QIRmzuDHoPUvchv3PrsNjGkPtA=;
        b=RUNKg6xFGxJS1CklVBZrCyVnHM46znZgz4rlozkcvV/wzHBy6XhISHmPQuNPiKCQU6
         4yHv6OexHyRo3Am6aPitm+bzMMHwbbwNsx5Tc01tnVvuLG5QvQddSB7rm9L6NjbB+mJF
         PgpUKOk/DkQvVH+m8FcejKavq1nk4HQhKROvUO7Z8AMBX5JhzzrukoIVid2wsAjZYbEb
         7XXzP/c1ZYJwmk0uS/MKCpymmYkJGV/2Fb9T2XlWxq6M6TrH5x0mKaNrCafYUZkU82uo
         /ZW8+34Z0JxYbNxrMaIPO8BWsvLMOdf8fdWIUG/gvGZ7gMMr19noTSJnwS/YZHxIVFSA
         aVtA==
X-Gm-Message-State: AOAM53167JDAxkqXZmeolmvqIBi8U7mi1N8Y1KYovDOpdqKDUeHW9ioD
        R+vNfu9zH6MQkY8t29cgRH1hdMnVZ+xyLOAN5O90OWy3exOtpzp2/BNj3AT170OguSeuEtethGQ
        ST6JkITKkbkVe
X-Received: by 2002:aa7:c9c9:: with SMTP id i9mr26499473edt.17.1621871775633;
        Mon, 24 May 2021 08:56:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxqIAdA2twCY/NYuWM5QhkC1u2I0/XA7NDRD7mYc3MYp9cHHNqJGAHpd6kL6COESUVJ4IpJQ==
X-Received: by 2002:aa7:c9c9:: with SMTP id i9mr26499455edt.17.1621871775453;
        Mon, 24 May 2021 08:56:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h9sm9168331ede.93.2021.05.24.08.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:56:14 -0700 (PDT)
Subject: Re: [PATCH v3 04/12] KVM: X86: Add a ratio parameter to
 kvm_scale_tsc()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, zamsden@gmail.com, mtosatti@redhat.com,
        dwmw@amazon.co.uk
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-5-ilstam@amazon.com>
 <cba90aa4-0665-a2d5-29e0-133e0aa45ad2@redhat.com>
 <YKvKwpRP6UcftcnQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e3ccebe-cd18-ed4f-d362-384de0ebfa4a@redhat.com>
Date:   Mon, 24 May 2021 17:56:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKvKwpRP6UcftcnQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 17:48, Sean Christopherson wrote:
> 
> 		if (msr_info->host_initiated) {
> 			offset = vcpu->arch.l1_tsc_offset;
> 			ratio = vcpu->arch.l1_tsc_scaling_ratio;
> 		} else {
> 			offset = vcpu->arch.tsc_offset;
> 			ratio = vcpu->arch.tsc_scaling_ratio;
> 		}
> 		msr_info->data = kvm_scale_tsc(vcpu, rdtsc(), ratio) + offset;

Looks good, indeed I didn't do this just out of laziness really (and 
instead got a typo).

Paolo

