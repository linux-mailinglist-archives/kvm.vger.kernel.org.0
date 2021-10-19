Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753AF433CDF
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhJSRCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:02:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhJSRCB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634662787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRL6nOjnZK6b2+TcoLEmu3K5pdW1k8luCFoncQ412YQ=;
        b=M7AgYvtHT7Trjh2iYCaOz3s2onFx9kKS3fUUdhe6KxCBQnNNL7xjnrHoxOo7Owup0zKbrj
        XnzVBeFnigkjcaA32CiRD/fJ0WMgXtk6i8hP+E579LsHESWroSqtkkDQa78FhIZbeJnTNb
        NFDNKvDOaYvP9EZdxo9CkQW7yTXzqxg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-WcWOmsNZMLWT0b-36qeLVg-1; Tue, 19 Oct 2021 12:59:46 -0400
X-MC-Unique: WcWOmsNZMLWT0b-36qeLVg-1
Received: by mail-ed1-f72.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso1043469edt.11
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yRL6nOjnZK6b2+TcoLEmu3K5pdW1k8luCFoncQ412YQ=;
        b=j6XXJTbHsrw6ZjNNGokYtR4V+QMrQjPIxc8eFSLrXwF7C7SOwRCsMIWa0ghYzhxSrk
         821TZueElIc+JSZV+K/egOxRG/vCJDvf8flQbkn9Dwe6rbyur8oA06tCZfdLhiJF6g02
         Vn3wAmZZk60aan4YEMR5hXjbGyxga/yoLs3CpG7V5vgREe3C+iVAKAP869MdnsCjv89i
         YEBIFopB7cudGdxBTVPsTvYBBcKVeJe6rl+J6Tu0rVBQq985DJj/DUego5sWBBjpyO/z
         XqqiqPht+nYcja6NJCbOeJ6iyMMZJZsbDlVErWznTDz1HQcs5P4zombAu7kXYrlt3Tx+
         yn/A==
X-Gm-Message-State: AOAM5315iIMt0J+gH69i20xGpH5JGh2rjtAzd5IpJhmIlSE/+7poUTiv
        TanPtUTxKYYXJXoQ99iaLlOnXmGhbOorzCizW5/wY6F+plAxMzT6GFSW4wUoYC5eUKfTQtwX7Ms
        25wsEmK7NqqyL
X-Received: by 2002:a17:907:1006:: with SMTP id ox6mr39717444ejb.146.1634662785135;
        Tue, 19 Oct 2021 09:59:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqI0DI3vHAHu36Mp/AOE/8zmn2909YkRm8xBz5go4Ysf4/It0HRvh0G4456fXpfkQ2JUaAcw==
X-Received: by 2002:a17:907:1006:: with SMTP id ox6mr39717415ejb.146.1634662784936;
        Tue, 19 Oct 2021 09:59:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id l19sm12897787edb.65.2021.10.19.09.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:59:44 -0700 (PDT)
Message-ID: <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
Date:   Tue, 19 Oct 2021 18:59:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 10:12, Wanpeng Li wrote:
> -	if (kvm_vcpu_wake_up(vcpu))
> -		return;
> +	me = get_cpu();
> +
> +	if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) && kvm_vcpu_wake_up(vcpu))
> +		goto out;

This is racy.  You are basically doing the same check that 
rcuwait_wake_up does, but without the memory barrier before.

Also here:

> +	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
> +		WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE);

it's better to do

	if (vcpu == ... && !WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE))
		goto out;

so that if the bug happens you do get a smp_send_reschedule() and fail 
safely.

Paolo

> +		goto out;
> +	}

