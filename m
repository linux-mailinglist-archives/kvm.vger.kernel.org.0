Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B622F4B0B
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbhAMMLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:11:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbhAMMLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610539777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qsVJWxT5mrnDEwcErNsrh3qxgVOPhu3Lqdsl0w+tv/Y=;
        b=PyexRLFZzD63bNlK4pjNC986JLt9407+/cXpcRQjqn5hSxsGTEsbK24M3s+z4PhFpIu1U0
        xASL5cjpsgYCrxB87pN754Za4vKgHVRg3FQrZaow/py8TR1h4+c+xZ4OHMu1u6kfKiIDs+
        /ik8RUIRSunog6Mv2U0LsHODIJJDpGw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-7an0xYJ6PsOaL0N5MXdEiQ-1; Wed, 13 Jan 2021 07:09:35 -0500
X-MC-Unique: 7an0xYJ6PsOaL0N5MXdEiQ-1
Received: by mail-ej1-f72.google.com with SMTP id s22so779313eju.21
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:09:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qsVJWxT5mrnDEwcErNsrh3qxgVOPhu3Lqdsl0w+tv/Y=;
        b=VucS8AE8HIVLkhJqsiPtVT2/mwxJ+u4CZtDUKTtFurGPuS3hER1bLEjcC/XJQuPtuc
         FvfM5YjSMShzPBuSC3msUltN22xzSnyOZJz0VTI+zoWz7GGoCg2eiWuDn/n4vC6cudFF
         b4SNuzgtWGmncBiPTI73O7OzSKMlgc8XN01uSOIr77KxT8LB4PMV8Th8lKnLbMAG2+8U
         xLOhQMn0ohKrbqSPm6PBzwJDcLORGzLDTj1xPuSv25ctyRLliSsPsWGBGgtfR8FdCCWw
         RVA07EA4QqZqTWnT7dI/TP1jdw8SlQFIaLVih95uN3CD02fWdE89wzMQb8DXr0vQxy5C
         OJlA==
X-Gm-Message-State: AOAM530+EQwGlGX2ZqfBTNkY3xJlhvGtqUtmomCQalaa0j5dnnI0QffH
        3RQiD9Zl7401t/ONbmXiXDypxZdXhaoLvr7spwjQtKWP+1zG4Yt8fl5ACQeiV1fHAVi9Yehd4ZR
        Gpe1jxWmi9gdL
X-Received: by 2002:aa7:cb12:: with SMTP id s18mr1525649edt.125.1610539774047;
        Wed, 13 Jan 2021 04:09:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsjqq0gX44tN/pfJwyDCG9ATH5g5CBkozvl4PxI626jpOjMi1YxgYXzT0XN4k4ts0gxQEU0A==
X-Received: by 2002:aa7:cb12:: with SMTP id s18mr1525633edt.125.1610539773837;
        Wed, 13 Jan 2021 04:09:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id de12sm749238edb.82.2021.01.13.04.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:09:33 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: nSVM: Track the physical cpu of the vmcb vmrun
 through the vmcb
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com,
        sean.j.christopherson@intel.com
References: <20210112164313.4204-1-cavery@redhat.com>
 <20210112164313.4204-2-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7b4ae9a-0011-129f-2ec4-6dd3dfe223ff@redhat.com>
Date:   Wed, 13 Jan 2021 13:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112164313.4204-2-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 17:43, Cathy Avery wrote:
>   void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
>   {
> +	/*
> +	* Track the old VMCB so the new VMCB will be marked
> +	* dirty at its next vmrun.
> +	*/
> +

This comment is obsolete, otherwise looks good.

Paolo

