Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B62B2C8701
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgK3OnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:43:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgK3OnO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606747307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n7FeUibbReJ1gM5EGPZRonIL/+Uv7TtKGQkvjaCTCcQ=;
        b=XMyQ1bzCIr5KB9x8bl/y9R4xgwJa+cBYFiIGUPGNsr5rryrVD+yc+f5CBspu5T6C9EmIO/
        z/Ij81pGbSrJ1nzF0PWXqEjZsvqcoDG+PdKE0PFbtj2Il0QxEYpBYBnahC2fDe9e9Kjc7a
        GJCwH1G5eM3Cr1K3CznL6qLr3fRUkJs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-hde2UMxMObWAvM8sIqfgwQ-1; Mon, 30 Nov 2020 09:41:45 -0500
X-MC-Unique: hde2UMxMObWAvM8sIqfgwQ-1
Received: by mail-ej1-f71.google.com with SMTP id 2so5871928ejv.4
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 06:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n7FeUibbReJ1gM5EGPZRonIL/+Uv7TtKGQkvjaCTCcQ=;
        b=iKpiq21jZjuWXit3dJrkNyytexdyFhh5r5FttvGzyhxN5PIcrSckpOLDP5aLsb3rGQ
         DQZpwwtPw0OZfsKZFkpfsXGgOobckNt/iLMZ8QD18T3mQVHQVEOG95H7hjzU5KsEVChK
         +TVISUFAML9FuaeYBsdRJFkrk/IwW5l2guWJlBT6IpwL6pgGH8EYvYZoq4a4cU7eMIgz
         TCiPY7XPAH2st2lqTbpC9iHHynxNDZG8aMDC5lxHfJ5kuC4OX2pDVVqkcns3LGT3Bd0q
         u/WpdiljEhYehAiQRC07jucr9XgGpn+QxIqSASMgMyactwEkuGO2Oey1Jho0cZFUhToI
         gLNg==
X-Gm-Message-State: AOAM532fttcHXCIoDGpjGYLLOEw+NJPsYeGHirmG5iB8Aj/H0KDic26C
        m2BF903bGDF+7W6f/JuDBzwC615isuPNQk2Riu1tTDXs8ThP9dUvumOkuVwL/n23TDtGcfgUD2C
        6sCbTlCc0fmTK
X-Received: by 2002:a50:fa92:: with SMTP id w18mr21765494edr.44.1606747303797;
        Mon, 30 Nov 2020 06:41:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ/QxihozNr0KBWUjMwea/F1FYvr85clicY2eNCGmdatOCBCrnXAfUrCzTcxDRtSmqzRBLow==
X-Received: by 2002:a50:fa92:: with SMTP id w18mr21765476edr.44.1606747303629;
        Mon, 30 Nov 2020 06:41:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gt11sm5746859ejb.67.2020.11.30.06.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 06:41:42 -0800 (PST)
Subject: Re: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     cavery@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        vkuznets@redhat.com, wei.huang2@amd.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com
References: <aadb4690-9b2b-4801-f2fc-783cb4ae7f60@redhat.com>
 <20201129094109.32520-1-Ashish.Kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f27e877e-b82b-ec9e-270e-cf8f23130b0b@redhat.com>
Date:   Mon, 30 Nov 2020 15:41:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129094109.32520-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/20 10:41, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> This patch breaks SEV guests.
> 
> The patch stores current ASID in struct vcpu_svm and only moves it to VMCB in
> svm_vcpu_run(), but by doing so, the ASID allocated for SEV guests and setup
> in vmcb->control.asid by pre_sev_run() gets over-written by this ASID
> stored in struct vcpu_svm and hence, VMRUN fails as SEV guest is bound/activated
> on a different ASID then the one overwritten in vmcb->control.asid at VMRUN.
> 
> For example, asid#1 was activated for SEV guest and then vmcb->control.asid is
> overwritten with asid#0 (svm->asid) as part of this patch in svm_vcpu_run() and
> hence VMRUN fails.
> 

Thanks Ashish, I've sent a patch to fix it.

Would it be possible to add a minimal SEV test to 
tools/testing/selftests/kvm?  It doesn't have to do full attestation 
etc., if you can just write an "out" instruction using SEV_DBG_ENCRYPT 
and check that you can run it that's enough.

Paolo

