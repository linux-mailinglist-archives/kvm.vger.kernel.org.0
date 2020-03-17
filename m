Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB20D188C48
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQRko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:40:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25325 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgCQRko (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3YlvCm1lBNLjiNpS/n2yOjJThq/QHDMua9Olu9Cwy6g=;
        b=OcS5SJSkUIKWxtsFEL/OIcElz8KLEB4/bS3qcffss86Q5hB2yQqKya8nCUtH9k0cv0Cwr1
        Mm0TpPmMvqIkFwOFqeG4shbw7D8yk61jWfJwOFsQOxwIZLNiMcK9iyrjX4H9ZYftAkZP2b
        aWy65svJE1RoFfBhzxdsCwOSg0GKmzI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-2O54L8iHNJedQwk2AFNOfA-1; Tue, 17 Mar 2020 13:40:41 -0400
X-MC-Unique: 2O54L8iHNJedQwk2AFNOfA-1
Received: by mail-wm1-f69.google.com with SMTP id y7so52244wmd.4
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3YlvCm1lBNLjiNpS/n2yOjJThq/QHDMua9Olu9Cwy6g=;
        b=VfGWC3nG93eEFketlD060dMLDaicQvTpntbhrG4bIfhzo82tPlXzrR4uk7SX4IXjvJ
         pFs60R7e9BcdpyV17XSOG8uiNoW+SMR9yTPDsaFqNoORzzKkO9Fpt9spWnWZTYrG2V03
         i7a8jfHogHOhKT8YsZ0X/MrlIHwaoefd479lGnm6EYsjeAcBq9EwnoUtVqlCNJ6GwPcI
         T2XdcNF1q1uIV9ySQF9U0JxE0yQb/pOhy7X+DrKe9k4f1O6LWl8u/cZo8Nb7Sp6lpOgi
         bwHqnJXA8XrA/qjKUkVNR1LNpgb8BaP7tz1BZVn6bV8scRzdbbhBCBZ0nuatHipVLcGR
         49UQ==
X-Gm-Message-State: ANhLgQ3CzQ7Xen5Zo2nbEpdc0u2/hM8hOZDXwEFMncyTZZTcYcC1hgaR
        JPui37K/3hF0/ljU2kBJhF6BTIALlFeFIG4k1JrlcatOgr0kT2jl6KDJPQxisYbHRx1adDaqE4U
        GdZOm9wG6n2mv
X-Received: by 2002:a1c:1b4c:: with SMTP id b73mr140306wmb.17.1584466840406;
        Tue, 17 Mar 2020 10:40:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs92iD8sXBzTaC2wszHXrLF6Lp91CBQvFML4Ry1JpAZwSbj6GU/EyKGYKgxJ+6i26ac5kJdBQ==
X-Received: by 2002:a1c:1b4c:: with SMTP id b73mr140298wmb.17.1584466840157;
        Tue, 17 Mar 2020 10:40:40 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id d21sm5274133wrb.51.2020.03.17.10.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:40:39 -0700 (PDT)
Subject: Re: [PATCH 06/10] KVM: nVMX: Convert local exit_reason to u16 in
 ...enter_non_root_mode()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-7-sean.j.christopherson@intel.com>
 <87pndgnyud.fsf@vitty.brq.redhat.com>
 <20200317052922.GQ24267@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6ad902e-f2ce-2df6-5f48-c9eb6e5c75d8@redhat.com>
Date:   Tue, 17 Mar 2020 18:40:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317052922.GQ24267@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 06:29, Sean Christopherson wrote:
>>>  
>>>  	load_vmcs12_host_state(vcpu, vmcs12);
>>> -	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
>>> +	vmcs12->vm_exit_reason = VMX_EXIT_REASONS_FAILED_VMENTRY | exit_reason;
>> My personal preference would be to do
>>  (u32)exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY 
>> instead but maybe I'm just not in love with implicit type convertion in C.
> Either way works for me.  Paolo?
> 

Flip a coin? :)  I think your version is fine.

Paolo

