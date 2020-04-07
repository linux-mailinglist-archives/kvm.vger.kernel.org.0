Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645AF1A0D4B
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgDGMFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 08:05:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728209AbgDGMFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 08:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586261107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xs2PYMoagJh94p0hVD/QmfuH7llxM6LPUQDf48wdDxQ=;
        b=EqZsysOkguTejfj4QS4T/a/A/hbl5Y573qX/ZnelLpwbbg78v8v0bFjWg94B6njxy7ZIIb
        rM7f6D613Z9FncWwt37t9VZr3+v0JfzfMTig4iqD3v3N5sv0cN4yAmJOInu00cdlGxZoqL
        ofUhJpLFMX3rRTLmhxMtV6OubgBI1sc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-738dHHDfO5SBsagQkKHqzQ-1; Tue, 07 Apr 2020 08:04:59 -0400
X-MC-Unique: 738dHHDfO5SBsagQkKHqzQ-1
Received: by mail-wm1-f69.google.com with SMTP id s9so500977wmh.2
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 05:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xs2PYMoagJh94p0hVD/QmfuH7llxM6LPUQDf48wdDxQ=;
        b=eCM7ZezurvJLVAJt0zijaEtn2bduzZysYtVW4vvvQFZWNMbvI3R88dn3CfT/sz+JDR
         leu3w3wFG3vyl4FRDAlW0dI83HhsbDQ9Q6S0REtl2g4iSXaIBpDNVhiIqRDg/wSr8Nbd
         U1UwrWS8Fc7XL/P4B6WQjtdqJ+gXQL/yBhriDqQqyjK9h+2JydY/05Y0hx1MGd26mhuh
         6Bj0EfEx1hYgPMOqey12SOcnPXLpOoUauQ5GNwAHGrRZD4+m+2kNbp/CSD1NhDnsDXvx
         CV3fn4tE7ADmcuBkfZjesrYNu2f9NTC8xgb9mcFiVeHkqcfsAXMb1eWEqVn3iU8TBYRI
         Z7Jg==
X-Gm-Message-State: AGi0PuZ7RCaCX26IpG4T3N/cGw9/dSpU1Z1UHyraFi+lmfcf1i/yi4yi
        yyc7E959Zcoq22DgMBQixHv/JO2gZ+8MJuaXlNsU9jaTmDLedzEiFVqP+AeWmJvHhq+pf37PFFV
        ePiMbkt+6/pHB
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr2068569wmj.139.1586261098266;
        Tue, 07 Apr 2020 05:04:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypIxvMFy1wzXFEuNpmyuAGAymcuopHHwSE4i0SJNeaS+clSzuREQQnSpHRy9z4S008CNZ2pTlw==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr2068545wmj.139.1586261098042;
        Tue, 07 Apr 2020 05:04:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f4sm13282639wrp.80.2020.04.07.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 05:04:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
In-Reply-To: <20200407110115.GA14381@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com> <20200407110115.GA14381@MiWiFi-R3L-srv>
Date:   Tue, 07 Apr 2020 14:04:56 +0200
Message-ID: <87r1wzlcwn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Baoquan He <bhe@redhat.com> writes:

>
> The trace is here. 
>
> [  132.480817] RIP: 0010:crash_vmclear_local_loaded_vmcss+0x57/0xd0 [kvm_intel] 

This is a known bug,

https://lore.kernel.org/kvm/20200401081348.1345307-1-vkuznets@redhat.com/

-- 
Vitaly

