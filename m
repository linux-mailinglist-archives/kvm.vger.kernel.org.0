Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37B16C470
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgBYOy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:54:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729489AbgBYOy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582642466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mK3STqvNpT3jDn9vLwtg+cXgS2sGksMMsz4/c3rFMHk=;
        b=Ok6IKozm1LXlmGQDgtQj/4G2VOtNn0u3hVRFjvoq1o8oZb6Zxu0mIPdiQ+wD4CEYKuWOo7
        3XV/NMJzXljg7BWMLf5IXy0nGIhnD78OU9Q12IjV9ZLnLjhX+u2hiPYGdSScJngeBRuNDj
        grd3Tf+/ROjO/8a9NiyVQusHQwmIhAg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-ikvqLke2N7qt9_VyxbP45Q-1; Tue, 25 Feb 2020 09:54:25 -0500
X-MC-Unique: ikvqLke2N7qt9_VyxbP45Q-1
Received: by mail-wm1-f70.google.com with SMTP id p2so1123368wmi.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mK3STqvNpT3jDn9vLwtg+cXgS2sGksMMsz4/c3rFMHk=;
        b=J+TszR14NjQgSLvxdzc3e6rse2FYpozH9Rxix8UMLfRLLM0JAoXBAvcwSHNl1p4GCU
         up8H4fXFA2qam6uTE1pvNXTNgQS1VMs1n4c1sZE0ErsVcqzcY9rvynCwRpMC+rfX9FTd
         MUkVf59actqEgFlnfFL7FAXxzEuz60KqxSvNtCGBfNqJ2SD5bZSuV175rY8xQa0NGneG
         lpAJFPNWyJl9/j7tLDpLaTiA2Xub43h45dPv/+OMuo3VQfm5PHP9ptvNXJhDcOeJGDRF
         AJpkZwTqhWnuevQncIl0IqGNFOgFctnicVwoZjwU06xfjWaJvSadcJfyUmqdwddOiGNb
         8x4A==
X-Gm-Message-State: APjAAAVAJWg+w8FG+lZLJD90GtheqDVTh7kujjbfiqwIROiiv7YZe5dF
        sBUNvaNPbVYrjMAezEuh41Hk31slYxLHotWF3B7dwc1hqOd/IxL6MCA+ECg2ruLTCazDPRfBaK1
        mKygDO4pANfsC
X-Received: by 2002:adf:ef8e:: with SMTP id d14mr15574546wro.316.1582642462671;
        Tue, 25 Feb 2020 06:54:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxNJivnFuLmBEUDYNzro50QPxzSsCchDfqLX6sY7HTC6bfACS5U6cknWPDlWhgge0XEZWwm3A==
X-Received: by 2002:adf:ef8e:: with SMTP id d14mr15574535wro.316.1582642462449;
        Tue, 25 Feb 2020 06:54:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id q3sm4200422wmj.38.2020.02.25.06.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:54:21 -0800 (PST)
Subject: Re: [PATCH 19/61] KVM: VMX: Add helpers to query Intel PT mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-20-sean.j.christopherson@intel.com>
 <87pne8q8c0.fsf@vitty.brq.redhat.com>
 <20200224221807.GM29865@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33a4d99d-98da-0bd8-0f9c-fc04bef54350@redhat.com>
Date:   Tue, 25 Feb 2020 15:54:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224221807.GM29865@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 23:18, Sean Christopherson wrote:
>>>  {
>>>  	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
>>> -	if (pt_mode == PT_MODE_SYSTEM)
>>> +	if (vmx_pt_mode_is_system())
>> ... and here? I.e. to cover the currently unsupported 'host-only' mode.
> Hmm, good question.  I don't think so?  On VM-Enter, RTIT_CTL would need to
> be loaded to disable PT.  Clearing RTIT_CTL on VM-Exit would be redundant
> at that point[1].  And AIUI, the PIP for VM-Enter/VM-Exit isn't needed
> because there is no context switch from the decoder's perspective.

How does host-only mode differ from "host-guest but don't expose PT to
the guest"?  So I would say that host-only mode is a special case of
host-guest, not of system mode.

Paolo

