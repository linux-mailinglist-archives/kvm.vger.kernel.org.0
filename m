Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391BB1EEA6F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgFDSmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:42:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726262AbgFDSmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591296173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W7PupmSHGY+zNvP6Gsjnrcdsr5C4naMtTGEaoTGjHh8=;
        b=ArI6kwJYWNAzl85zqrE9YDIe/XMRs6xiMHhXtJ9eRQn+dFNkaI2HXa1x/smhBXWM/f/j1U
        mUbTz2R1tq/gRODq7rXJL1ghO2gNrnaACLcdnrc3GIuZy91FW+Tt08S3Yw7zukhU4Muf20
        AsB7ycQT3DvwlHsgk1gPqNXi7ALvzaM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-U85juU9BNTiHrgKGNt1oDw-1; Thu, 04 Jun 2020 14:42:52 -0400
X-MC-Unique: U85juU9BNTiHrgKGNt1oDw-1
Received: by mail-wr1-f71.google.com with SMTP id f4so2765850wrp.21
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 11:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W7PupmSHGY+zNvP6Gsjnrcdsr5C4naMtTGEaoTGjHh8=;
        b=NJD0KIODckX14H2UCz1luZhvNMgsTwVNuf85Wz4ZfF2V4QEUMZ2resBUmZgWtNDU3d
         /3GNoUjyIiTuswzRmsGLr0KngLHkR4JQvv0x9GXgl12NtKohyos/K8eHYjoigJ8szmwj
         16wR0RphKD8aPFawrQT/Zeoyh6T/FqZ9IwDHOQiDlmg+6C2XfPSmE+nDX4VCaf3a9Qza
         1qo1gnVtt3xYsZB61Crq74MAyiQVl9JDzLdSqOqvu5Cs1yuODOOB3EJ7BaQkuEZloH2V
         y4Ue1NkX87h9SzezsftgM7sM58zN3dKWDcO5okBPPxXTPdA1sRWK8Oh/IPAAxrPDXyrM
         ni4g==
X-Gm-Message-State: AOAM530TqFMf61HISTik2LsyNGTG1orz7ZPcblGoih2gNp64f0jCuD/W
        Dmc5N7n0J3qflmNKFIWUO3tOQDgVWTUSrsI9YzyYuXjevSb3MqdZ80/rHpOXL2cg7mGGOibIE2Q
        ITd9vJPyblbuw
X-Received: by 2002:adf:aa97:: with SMTP id h23mr6126374wrc.251.1591296171160;
        Thu, 04 Jun 2020 11:42:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznAX0ROdSeZrRHnaqmouzsaV5mjG/PqHDp86o5qQ8VbvXbtz0L3ZbFDZfNb08OYjvzvJAqpQ==
X-Received: by 2002:adf:aa97:: with SMTP id h23mr6126361wrc.251.1591296170873;
        Thu, 04 Jun 2020 11:42:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id m129sm8974449wmf.2.2020.06.04.11.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 11:42:50 -0700 (PDT)
Subject: Re: [PATCH 0/3] avoid unnecessary memslot rmap walks
To:     Anthony Yznaga <anthony.yznaga@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, steven.sistare@oracle.com
References: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d440118-4325-6f68-75e7-dd5a74c4a7eb@redhat.com>
Date:   Thu, 4 Jun 2020 20:42:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/20 22:07, Anthony Yznaga wrote:
> While investigating optimizing qemu start time for large memory guests
> I found that kvm_mmu_slot_apply_flags() is walking rmaps to update
> existing sptes when creating or moving a slot but that there won't be
> any existing sptes to update and any sptes inserted once the new memslot
> is visible won't need updating.  I can't find any reason for this not to
> be the case, but I've taken a more cautious approach to fixing this by
> dividing things into three patches.
> 
> Anthony Yznaga (3):
>   KVM: x86: remove unnecessary rmap walk of read-only memslots
>   KVM: x86: avoid unnecessary rmap walks when creating/moving slots
>   KVM: x86: minor code refactor and comments fixup around dirty logging
> 
>  arch/x86/kvm/x86.c | 106 +++++++++++++++++++++++++----------------------------
>  1 file changed, 49 insertions(+), 57 deletions(-)
> 

Queued, thanks.

Paolo

