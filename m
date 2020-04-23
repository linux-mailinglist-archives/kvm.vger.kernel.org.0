Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B41B661E
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgDWVXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 17:23:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22938 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725817AbgDWVXs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 17:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587677026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GME9K6gm6v8gYGOvcDVyFYD6bYiOC6Ecfzu2bX9gykg=;
        b=MpYljXUirD0P6zJ8xCZPyWfdNq5OfvzgP6nXsANfXtFFHGQmziwijRBAEUtnJ4taaURpVh
        BBYBeZUWnaeK3bAgX3giWsUIkcOQkUhrnQvevQNAv4tG2LUjhAu2QBAT7mof0G0Q9zo2fn
        +OuTnP7lf9FEyYtGi6z8Rh7EYqq55rI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-FB6OY3f_OyqfWy-qfyX9NA-1; Thu, 23 Apr 2020 17:23:41 -0400
X-MC-Unique: FB6OY3f_OyqfWy-qfyX9NA-1
Received: by mail-wr1-f72.google.com with SMTP id g7so3465067wrw.18
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 14:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GME9K6gm6v8gYGOvcDVyFYD6bYiOC6Ecfzu2bX9gykg=;
        b=bM70xgjXsJE8n30ft4YF8ctUkqcUh8PuaEIJurPt9dCQZ5ckeYPXU+BxDr6aH3MKmH
         NlamM8fgNWTP3qwqWNkMWdUxbpYKc2R0KX/8aiX32ce4VeGjpWCyKMtrgzI1roOjvZIL
         x/UnKW9dtL4ZUcdYjjT5+VV6Xc0YQX8GUT/aRZvyjYOQeVhhgSh/6c5f+lWdFSLrcTFv
         2eoWTdS9sM+1jmd9lxI89JqlEmYTvtoHAxcpvG0zn82DLEklmob1o8/abjgv4v9/myeu
         pcHiWutv5oK+oCMe+BcsAQvrXQ4z643dj6XqxNZjroM7Uue6xQmQutNfFP1JbLjTRkHL
         WTtA==
X-Gm-Message-State: AGi0PuZXS9jYD0b+yHBMLXQ2GnzQ84G/r9hQIz3/uar/+OzI1R5+j6jz
        PgWluvx+6GrWN1luEMtxj5vQ5MK2W0hnG9DVOdMA3ajMQ2t3Mz/m5ZuDQF/OSpIEWwxsb7PHJLE
        kio0++HduhVRH
X-Received: by 2002:adf:fed2:: with SMTP id q18mr7873196wrs.157.1587677020667;
        Thu, 23 Apr 2020 14:23:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypK9HVF9X78wFTCG3KcFP8e/vt1baUvG9UKepQljp7AYsjXHP/zNhyfa5tbiypWwlPxMVaGzxA==
X-Received: by 2002:adf:fed2:: with SMTP id q18mr7873170wrs.157.1587677020427;
        Thu, 23 Apr 2020 14:23:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id 1sm78163wmi.0.2020.04.23.14.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 14:23:39 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] SVM: move guest past HLT
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, wei.huang2@amd.com, cavery@redhat.com
References: <20200423170653.191992-1-pbonzini@redhat.com>
 <20200423194605.GQ17824@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <63b67ae0-0264-0d10-b043-7e8390e42335@redhat.com>
Date:   Thu, 23 Apr 2020 23:23:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423194605.GQ17824@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 21:46, Sean Christopherson wrote:
>>  
>> +        /* The guest is not woken up from HLT, unlike Intel.  Fix that up.  */
> The comment about "unlike Intel" isn't correct, or at least it's not always
> correct.  Intercept NMIs/interrupts don't affect vmcs.GUEST_ACTIVITY, i.e.
> if the guest was in HLT before the exit then that's what will be recorded
> in the VMCS.
> 
> https://lkml.kernel.org/r/20190509204838.GC12810@linux.intel.com

Ok, I'll change it to "The guest is not woken up from HLT and RIP still
points to it".

On Intel indeed it is not woken up either but vmx_tests.c has

                if (vmx_get_test_stage() >= 2)
                        vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);

Then it's not surprising that, when I fixed a bunch of nested AMD things
to behave the same as in vmx/vmx.c, SVM broke and needed this patch.

Paolo

