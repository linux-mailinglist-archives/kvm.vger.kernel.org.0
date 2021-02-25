Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F0F3257D7
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhBYUjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:39:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232403AbhBYUib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 15:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614285424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A2DCIpl4t4oP1eDrLAD1K46exhLy3YbNX0Rf8/i1+pw=;
        b=LJzpCz5teZdwEkeNMvWh60Qf+GJF/P3tj7/NT3imj3zGphx9VjH3+nQ1gpslrIsM6hY50c
        f/otw9HxRtliF1iAOxFsock+bgds8lOrhu9QwY21QXmlwrnXrw1jmwgL2dbPEPrBH3fJG2
        UzoIZGk2XM6aKwJI8k927r2FcfIMyOg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-gVstCY3IMSi6o99jb2iDgQ-1; Thu, 25 Feb 2021 15:37:02 -0500
X-MC-Unique: gVstCY3IMSi6o99jb2iDgQ-1
Received: by mail-wr1-f71.google.com with SMTP id h30so3601750wrh.10
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A2DCIpl4t4oP1eDrLAD1K46exhLy3YbNX0Rf8/i1+pw=;
        b=KJBnqBX97lIOkNm+O2a9OBf/zU030gfYOzlUqdxr/7yP9OF8cyjBLcKpPQ86Xm07zs
         XG4Wwf5JmjwPvpXof2T7SPnu855X+ZWQumXFMLaZ+kUCqBiCnW/DKkF6Wdcq8BLPI7Lm
         EckRYpVvZ4xTgx9/BeYFeutlisxeLCoZHA0Cnt6xN4BAEBnIQ5vcS+MuuhqI4aJznUlt
         pY3IqoS5I5/fUWIMUhxUuw4i/H4EXc+Bh8t/bPp7UArr8PzA/7XEor17ztxg2m0l0leY
         1cFos+As+iXIR6LoggGvjTrPkpkL6dPc77kJNszsyC8VefzgVV/U0ZmPUL7kGmPDO0tH
         h/Hg==
X-Gm-Message-State: AOAM532vZ//JRdcb4V0QF3D2Gg3i0N9fGrSZFhnjYD0h4EMKvl2O4On5
        Vs9xOCqCOVaU4UbR4emAcBhA1GP2Lb+8JY/dHXYUVQGltvD0YNETEa60bTqJpcdW4XDb6Hy9fYS
        HstKINbPgldLh
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr158746wmq.154.1614285421009;
        Thu, 25 Feb 2021 12:37:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXZvXWhSI3vb50fZVQvv9A84mo6VgUnsNq9wE8PRfGBQ3ihQ561J2mp2VhvnoXByW5vkEnvA==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr158729wmq.154.1614285420836;
        Thu, 25 Feb 2021 12:37:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o3sm3000691wmq.46.2021.02.25.12.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 12:36:59 -0800 (PST)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        natet@google.com
Cc:     Ashish.Kalra@amd.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        seanjc@google.com, srutherford@google.com, thomas.lendacky@amd.com,
        x86@kernel.org, Tobin Feldman-Fitzthum <tobin@ibm.com>,
        DOV MURIK <Dov.Murik1@il.ibm.com>
References: <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b194254-1774-e54f-b801-c2d0c0ead07c@redhat.com>
Date:   Thu, 25 Feb 2021 21:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/21 18:53, James Bottomley wrote:
> 
> https://lore.kernel.org/qemu-devel/8b824c44-6a51-c3a7-6596-921dc47fea39@linux.ibm.com/
> 
> It sounds like this mechanism can be used to boot a vCPU through a
> mirror VM after the fact, which is very compatible with the above whose
> mechanism is  simply to steal a VCPU to hold in reset until it's
> activated.

Yes, and it's much cleaner because, for example, the extra vCPU need not 
participate in the ACPI hotplug stuff and can even use a simplified run 
loop.

Paolo

