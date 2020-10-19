Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1D292AD4
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgJSPuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730060AbgJSPuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603122608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ty3fQUKhXBYaOFrkQdMkSNwWJaJQlG2vHLExq4dp6RE=;
        b=hOx8jdhtJOuOZOEH4IHMedt1ZXwiLS3jjP2zcsys2gt1KNAZAUykXmMY6ySN06Qkhln0Jw
        STGgQkYN314DVNYRS0pylEI0eJTbuY5tZDz32V5aYSQOK/xbARklyZKWJsaMxLSRXPYtXT
        iq6ms7+ktDpA5x/gBU2cDn9ExWuvjiA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-pIaD1YOoPfCyi1Gx20Q9dw-1; Mon, 19 Oct 2020 11:50:06 -0400
X-MC-Unique: pIaD1YOoPfCyi1Gx20Q9dw-1
Received: by mail-wm1-f72.google.com with SMTP id r19so81105wmh.9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ty3fQUKhXBYaOFrkQdMkSNwWJaJQlG2vHLExq4dp6RE=;
        b=jOBimjVWzaP25/T2Dc+r3luy1aOpEJA7bB0/DLt5azlKRPaZ4JUivN1b75mDSXzqHA
         H38S9mq9/pNb9D4A4Hx7kE66PP8Y9L/sF/E5R28XVFVIxwSc2QgwHFlKMhGeX/z4os6i
         VpyEfU9hK2r9t8HS5XL8AaGDzTfcla2XaY4zbIprZxqzSxz5OnBwQHZ72W/42AREubbh
         V+yUM/NWWwIruMRHrazCh4gMqihk5XmOp4vFPfxF/hNo8o4OuSfQJjxSCxCVIbID/qHt
         T+erMqdv5xBMiw27C5RIDvsNm9+Wov7jCJGRwp0GjAikXRNOsKW5NPFoxrJ3sOS3gjch
         6TJQ==
X-Gm-Message-State: AOAM533q2elPYYtJwCVnHEdcWyy5Caa6TpAH5bcQPpKlJFiV3QXjzodB
        rMnSbMnfAFNBPxnjBLPxshZXoQJpFlTXLcG3oCMJH4jkVQaBOt184tvpb+mCU+rFEthC5iiRHE6
        NfpErb7TfoW2f
X-Received: by 2002:a5d:4ed2:: with SMTP id s18mr231484wrv.36.1603122605689;
        Mon, 19 Oct 2020 08:50:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTR9iZFcc8IIQX9dGK47DUaftCuX1iqMBs11sOiu81jGa42Cgb3n3WCC85QiisviGSCa5o2A==
X-Received: by 2002:a5d:4ed2:: with SMTP id s18mr231457wrv.36.1603122605454;
        Mon, 19 Oct 2020 08:50:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 4sm170402wrn.48.2020.10.19.08.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:50:04 -0700 (PDT)
Subject: Re: [PATCH 2/4] kvm x86/mmu: Make struct kernel_param_ops definitions
 const
To:     Ben Gardon <bgardon@google.com>, Joe Perches <joe@perches.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1601770305.git.joe@perches.com>
 <ed95eef4f10fc1317b66936c05bc7dd8f943a6d5.1601770305.git.joe@perches.com>
 <CANgfPd8_Crt0VO3phV7ec55ghSLiJzmzTypNvnZAYq=uJL8r8Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc79b272-0d32-a08c-d8ee-3d601bd47d5d@redhat.com>
Date:   Mon, 19 Oct 2020 17:50:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8_Crt0VO3phV7ec55ghSLiJzmzTypNvnZAYq=uJL8r8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/20 19:14, Ben Gardon wrote:
> Reviewed-by: Ben Gardon <bgardon@google.com>

Queued, thanks.

Paolo

