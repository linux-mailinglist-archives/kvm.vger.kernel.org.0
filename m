Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970421FC5F
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfEOVmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:42:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45301 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEOVmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:42:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id b18so1024474wrq.12
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 14:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C+PxQpUDPz7RN5nuhxoq8Ts5XlEFk2JWPP6rNJE24bI=;
        b=jvh6j7aYRO63pbqEm3+X3IiYQIEdQHGPLlWd8KfkLEmEvcoiNpcCJHhL7l+wqONPOf
         J7uqz8igvQ/ms3LzobEAZddxHL4zOutUgHVUuv4ygzE9q2buARh6sC0c5Cm/x6HxY677
         +tctJskwbs+jz1pqFjkVb/FJ+9YkykFr15ZJc/B2CK+zchH6DOlzs8WVmDBdBTaHDNNO
         vk+RH6d/LnpyDVqng4gUGy5gI3+tpbGCLG0CN2NXZU0cGPJEt+iDaJkrRImfJRNx61gI
         FKXnmpqQRk7D9PApcsMiCnZSnkYMIeigFOVBdumwpUrwW007pUqetGvTk0+GgY37u0pN
         1JXA==
X-Gm-Message-State: APjAAAV9z5vQrSCIc+H2jRfyh7/N1SbfDwYw9/JyX34W/YDBB5vT2nwP
        wAtymDLcbiwkF9+wySmhu7D4Ar1WWNI=
X-Google-Smtp-Source: APXvYqy708u+hidtMmdHsmtfKq/QkhVgTLHy38OtCIQB9yI43udRXuvE1DJgNpBEGB87beCE6WbnoA==
X-Received: by 2002:a5d:4945:: with SMTP id r5mr26386064wrs.328.1557956567414;
        Wed, 15 May 2019 14:42:47 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
        by smtp.gmail.com with ESMTPSA id q13sm3707765wrn.27.2019.05.15.14.42.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:42:46 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] vmware_backdoors: run with -cpu host
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org
References: <1557956157-40196-1-git-send-email-pbonzini@redhat.com>
 <6B5FAFDD-B593-4AFF-A0B1-EBE64C5BDDA6@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a7dac31-ef2c-40cd-d013-c2016d41ec54@redhat.com>
Date:   Wed, 15 May 2019 23:42:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6B5FAFDD-B593-4AFF-A0B1-EBE64C5BDDA6@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/19 23:40, Liran Alon wrote:
> 
>> On 16 May 2019, at 0:35, Paolo Bonzini <pbonzini@redhat.com>
>> wrote:
>> 
>> After KVM commit 672ff6cff80ca43bf3258410d2b887036969df5f, reading
>> a VMware pseudo PMC will fail with #GP unless the PMU is supported
>> by the guest. Invoke the test with PMU emulation to ensure that it
>> passes.
>> 
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Reviewed-by: Liran Alon <liran.alon@oracle.com>

> I think it will also
> be more intuitive if in addition, we will check in the kvm-unit-test
> itself the CPUID such that we will skip test in case PMU is not
> exposed by vCPU.

Yes, good idea.

Paolo
