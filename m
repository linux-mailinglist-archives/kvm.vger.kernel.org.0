Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55D5391D0A
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhEZQbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 12:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234484AbhEZQbo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 12:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622046612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKseMqEyU9vMlSVhMpCe0qu9Lfmtxe6btXv0lsnEZ5E=;
        b=iw88gnSuAjUDmG1Z2+XNK4c1ZPCQy6rMKp3cZCb6aBKskFOkP8OMKP5gqE20VXVjLsd+6a
        tpt/YbQRvBar0OaunlOIf1+9hkibFGZOyao1wIXU01wwv/OhPZXI0QkrEoqASVzBRwz+k/
        PHm7n7V7diowhQw8TVMxOGgolnIkqPw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-eOSmSjVkOPKZP_01-qYpmw-1; Wed, 26 May 2021 12:30:08 -0400
X-MC-Unique: eOSmSjVkOPKZP_01-qYpmw-1
Received: by mail-ej1-f70.google.com with SMTP id dt6-20020a170906b786b02903dc2a6918d6so602179ejb.1
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mKseMqEyU9vMlSVhMpCe0qu9Lfmtxe6btXv0lsnEZ5E=;
        b=kdqlsm1W9SmCDCoWC4okGSwJklglebTUSUjac3BWWadyWtUK0WLmxY5v+6WLcpypj9
         Tk74en7CFbxJycViZcsgZeIO0SoCDqwWG+cKPYO4CbMeoz+c/XGnXyNiki9+Ms/sdMcP
         cLK8WomP0Ab7lLDDOc1HliOO/Whf4BMhlMQkdEjyPkDrI1OCba51/JgaM7cy+++YHyg/
         Q1ODoZ+vMKiSpMW+ri5w9CFhGPEMuNW2r7Sl7dnpSs9WpQXnZCnuNsdx/tJY2FmVxgg3
         rrZoH9EDf13tKNdBKNFL8dULRpryYtKr4l7zngQfjw5LbDBISUBgM9wpqCLIp8WLF7+Z
         M2XA==
X-Gm-Message-State: AOAM530q7nqPphQNOPf4RUMlICPpc/Wm5R434k4JmPKQ9mmtbIF6m0kS
        +D9XEAX69yAg+VlzkzGPUCXYIqeJN2hyYpdxlatHVmCfVYoEZgQJMFJex2Xy+mfTVQapS09Yd4f
        XMv1bBHPrJARdUDgfaPveSUXX2olKS1We524LfHjTHf5lQc9a850Ztfp7i4tEm0jr
X-Received: by 2002:a17:906:1444:: with SMTP id q4mr34703944ejc.459.1622046605813;
        Wed, 26 May 2021 09:30:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfjTd0ATZ28BI6ZQRvwlDRMIHePtiPaN95IKdIhB2z+UP+qRArZCituwXQiXtiMFZ4p00YBA==
X-Received: by 2002:a17:906:1444:: with SMTP id q4mr34703818ejc.459.1622046604662;
        Wed, 26 May 2021 09:30:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x10sm12735679edd.30.2021.05.26.09.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 09:30:03 -0700 (PDT)
Subject: Re: Writable module parameters in KVM
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
 <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
 <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
 <YK5s5SUQh69a19/F@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <927cbe06-7183-1153-95ea-f97eb4ff12f6@redhat.com>
Date:   Wed, 26 May 2021 18:30:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YK5s5SUQh69a19/F@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 17:44, Sean Christopherson wrote:
>> Sure, making them writable is okay.
>
> making a param writable (new or existing) must come with strong
> justification for taking on the extra complexity.

I agree.  It's the same for every change, and it's the reason why most 
parameters are read-only: no justification for the extra complexity. 
But if somebody has a usecase, it can be considered.

> Making 'npt' writable is probably feasible ('ept' would be beyond messy), but I
> strongly prefer to keep it read-only.  The direct impacts on the MMU and SVM
> aren't too bad, but NPT is required for SEV and VLS, affects kvm_cpu_caps, etc...
> And, no offense to win98, there's isn't a strong use case because outside of
> personal usage, the host admin/VMM doesn't know that the guest will be running a
> broken kernel.

Making 'npt' writable would be beyond messy too; allowing select VMs to 
disable EPT/NPT might be simpler, but not that much.  I can't say 
offhand if the code would be ugly or not.

Paolo

