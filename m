Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7300B1D5CD4
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 01:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgEOXe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 19:34:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726231AbgEOXe5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 19:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589585696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ww8QLIiQQKmoFAR3z2a2VR3cY+JHw4PRCxc1cMKOHAQ=;
        b=DSDPEJk2Emr0l0ICn+mG9I7tG9tXQg4qB7Wx6kiry57dsHhuQkSomSYkjjq9Mdy3GnB9FD
        QhbZu6Qf00e+Cbn8KWZ0Sb0AuVzuByLfGCPYcB+f2aOgwqTTQfl+/k5i8g8fBaQbI4clix
        R2pVDscNitfk5htzXW79GuMdKBvfc34=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-sr9qxkBpMLOLEGpDsGzEYA-1; Fri, 15 May 2020 19:34:54 -0400
X-MC-Unique: sr9qxkBpMLOLEGpDsGzEYA-1
Received: by mail-wr1-f72.google.com with SMTP id h12so1879982wrr.19
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 16:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ww8QLIiQQKmoFAR3z2a2VR3cY+JHw4PRCxc1cMKOHAQ=;
        b=kkFNCgV5rn6x8qRqC8RH8S54fikATiNpekT4ofOZhO37xqtFfqoolv5zlXnhfz3Cs9
         qZNrwu0pBqqQQWlxZTqMuZ/LkchXlLER1TiJ/YCgI2HIp9UWZILi8enhc5VYMFRKC4u8
         QcI0KwQpkBAeaVWfk4M/LqtOGGx/VycKPyFvyUEaK8iQDi4CBU+gLYjBE7ng77wTYXEH
         jEOQtoqUKE6ZZTlpO35lsiWGnW9HbwYdSmQ2+IMQXPYGI0P/t4YcorbYbethHa42cdby
         vEqghVFTp+Hq5FeRjoAkFFybGyA1Yt24GkUbPOnOd3S1a+ObpMFWwfRR8BuFZw0iMitf
         J3Pg==
X-Gm-Message-State: AOAM530mbKTjMMKgX428JU+Dm6uOmJ/HtVJ8eMI1L97ga6q+HqYK7dDW
        85h8piKAfD7SDfHpykshE56auBdeOWPv2/zALXYE4PGa1jlkydwdIrX8uZPayCXFPADj87gn5RQ
        R2NCtvrv3uejg
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr1418345wmh.169.1589585693145;
        Fri, 15 May 2020 16:34:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZj4YIhP4GuREU6k+98WfW4UHnwqCGWraIeCdKfv4yBPRiAOC6oBDMvet8oEbXMM0EmskY5A==
X-Received: by 2002:a1c:ed08:: with SMTP id l8mr1418324wmh.169.1589585692860;
        Fri, 15 May 2020 16:34:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7012:d690:7f40:fd4e? ([2001:b07:6468:f312:7012:d690:7f40:fd4e])
        by smtp.gmail.com with ESMTPSA id b65sm5934467wmc.30.2020.05.15.16.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 16:34:52 -0700 (PDT)
Subject: Re: [PATCH 2/7] KVM: SVM: extract load_nested_vmcb_control
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
 <20200515174144.1727-3-pbonzini@redhat.com>
 <73188a11-8208-cac6-4d30-4cf67a5d89bc@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cfb8bc6-72ca-f86b-f0c5-9c53b6914713@redhat.com>
Date:   Sat, 16 May 2020 01:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <73188a11-8208-cac6-4d30-4cf67a5d89bc@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/20 01:09, Krish Sadhukhan wrote:
>>
>>   }
>>   +static void load_nested_vmcb_control(struct vcpu_svm *svm, struct
>> vmcb *nested_vmcb)
> 
> 
> This function only separates a subset of the controls. If the purpose of
> the function is to separate only the controls that are related to
> migration, should it be called something like
> load_nested_state_vmcb_control or something like that ?

This function loads into svm->nested.  The others are loaded into
svm->vmcb.  They will be moved to this function later in the series,
when we add fields to svm->nested for all the controls that have to be
serialized in KVM_GET/SET_NESTED_STATE.

Paolo

