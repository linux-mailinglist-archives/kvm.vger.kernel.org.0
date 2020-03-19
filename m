Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A3718B0A5
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCSJ4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:56:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52190 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbgCSJ4u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 05:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584611809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kjiT/f6j1dtJ0M+LrqpZMacX0jJNaJL+Lx9QWE3AlSg=;
        b=fSh4x7AoZzsFNvnuSQauolsTMIvaJi0OqKHCisL6zxAsmGTQntoYYO+X40tld652BnRJQv
        QYs148CCnWLzzAYzGYSNwT0ZxigRrWECxqfp2f74HxuKSD6UHkBeDKl54QfNxw94WSQZbT
        EAMZgWMZbabBTcPnCT+0nOn3Vbc2uxY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-Yr-So8wMNIuQOaH1j0gyuw-1; Thu, 19 Mar 2020 05:56:47 -0400
X-MC-Unique: Yr-So8wMNIuQOaH1j0gyuw-1
Received: by mail-wm1-f69.google.com with SMTP id r23so491412wmn.3
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 02:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kjiT/f6j1dtJ0M+LrqpZMacX0jJNaJL+Lx9QWE3AlSg=;
        b=jEOEYWnu1L4eSJec2sOfR0/ZAwcMhx8doV0ymfZF6suLfk4ypofjBfpQU4B5WNVaXJ
         /QCDqAI+1bY76KA2yQVpMFrgACJgdLg+Qik3D7TBpovpfKPjkVVNSHABdoKtw1+3jaKY
         oRtbSiiwagNyTuF6lkSgGQBZ+Z0LI43b7vGM4OeQg0pl7ae5phm37KsPPeeqB9D2BKd+
         FlNCPVelOvoa50pT7BJnfJDB+FU0H6/DKj5odNzxG+sLZPDp1IhAayUvsD1y97Ip5nni
         4sxCxMjZu2nlfOmHarwGMJAZqRjtRr6/xlg5DX70Vpa3TNgBxGate/JTlsrDiznLk+xb
         sO3g==
X-Gm-Message-State: ANhLgQ0w47DhQy+J1cqx0S6eRJajjqEhlzvmHhgC4Qi2wBXLArDyKFyr
        OwyIhmfebX+fDU5vgVEehoH1Ta4WTD7ef+ZN153elMMehWYWJYqvW0YjcXCv2fHwPbBNchTvQU+
        yEHYboxDxr4EK
X-Received: by 2002:a1c:26c4:: with SMTP id m187mr2689733wmm.43.1584611805753;
        Thu, 19 Mar 2020 02:56:45 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtkzGOheVy9K8FX3czGp3WTrtHBqz4ZF32AJjg1xM5abjrG7P+JO8k413ESfXBAeQwhPTJBeg==
X-Received: by 2002:a1c:26c4:: with SMTP id m187mr2689721wmm.43.1584611805546;
        Thu, 19 Mar 2020 02:56:45 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id k133sm2590796wma.11.2020.03.19.02.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 02:56:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/8] nVMX: Refactor VM-Entry "failure"
 struct into "result"
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
 <20200312232745.884-3-sean.j.christopherson@intel.com>
 <5296f778-59d8-b402-b1ed-cea5f3a56eb4@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53f6926e-f771-fa96-6641-1a54c1f4843f@redhat.com>
Date:   Thu, 19 Mar 2020 10:56:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5296f778-59d8-b402-b1ed-cea5f3a56eb4@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/20 00:40, Krish Sadhukhan wrote:
>>
>> +    /* Did the test attempt vmlaunch or vmresume? */
>> +    bool vmlaunch;
>> +    /* Did the instruction VM-Fail? */
>> +    bool vm_fail;
> 
> 
> I still like the old name, "failure_early". To me, "vm_fail" and
> "failed_vmentry" sound similar and confusing.
> 
> The SDM calls this type of failure as "early failure" which is denoted
> by an (instruction) error number, in order to distinguish it from the
> failure that happens during guest state checking/loading. So, probably a
> better naming is "vm_early_failure" or "vm_fail_early". Or may be,
> "vm_instr_error" ?

This is actually what the SDM calls VMfailValid (we should never get to
VMfailInvalid in these tests), so vm_fail is appropriate.

failed_vmentry is what the SDM calls "VM-entry failure".

I agree that the names are similar and confusing, but there's some value
in keeping them close to the SDM.

Paolo

