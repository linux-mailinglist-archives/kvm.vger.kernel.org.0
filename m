Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62EEE17AABC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCEQnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:43:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgCEQnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 11:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583426587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9DAtl+FSyCFHYDQsK2Du0TBkiXUFV5Bx439VCb735M=;
        b=aRoSg00ucfvzVmgREdk8RzkyjamRl4oidgaNGtZWn14eQYy6B3aUn24wVgQR3gU/4Em8gk
        Kx+FRa0zsFYbrZX6secQxrgKc9b15uGrU8ieuKkLMvh8skJlt0v7xIwz4BFVro8G51ujiW
        vgIPmwsNipPlv7itW8KBTV9tislXtOU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-yZSvHHpkN826uOk0PF9ckg-1; Thu, 05 Mar 2020 11:43:02 -0500
X-MC-Unique: yZSvHHpkN826uOk0PF9ckg-1
Received: by mail-wr1-f71.google.com with SMTP id f10so2528611wrv.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 08:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9DAtl+FSyCFHYDQsK2Du0TBkiXUFV5Bx439VCb735M=;
        b=boPWPIiamxqUe+Vapu86JvCRbXbcnDQbHA7zQg4PZffbfKhSQy9EmnHC7wnpbc6ctZ
         x1HmZd/xPOMLgUXQIHjyxyyU6wqTKaps/yvZ/KDrt4I3DJddISBWd3xuLDZUXHa+wxQj
         RR4VG5WuF+aHt92KtfvIUrpvgybcuP2QaMW9yqMCf5HFWVoevhBGkfY6w5oUCiRB5sHG
         /owdUI+5oBcBaNgEOdh+zytVpz4zpAHyNuFM+39r61GG/cEaNaOt/LAzVzzQQNXDiECG
         3jCYlYF6o39V0YjTszC+zuomvzzXi2iG8zRiTAIhLBOg85KWC6ZENDMMjqYdyEoit/ak
         tE1w==
X-Gm-Message-State: ANhLgQ3Y1vi/+/y+fbi07W6ZIL2KkXFYxxKwI2K0o6smhguq6/Hd/a70
        xdiSZOeYFuPCSbQs8JsZstGOQsUpa+PqRmwHg84GXklc5sWdGsxKpgVuWMv3Zd1jNoRZibMh+gw
        r8Em423YSKGoc
X-Received: by 2002:a5d:4004:: with SMTP id n4mr9624731wrp.48.1583426581723;
        Thu, 05 Mar 2020 08:43:01 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuczSqaBpycmHn4lDUE/pzvhjBs8yMsn8vI4F0+nvjWjdCvFBpk6DqMYK0U/zOcUaFc2Q1epA==
X-Received: by 2002:a5d:4004:: with SMTP id n4mr9624713wrp.48.1583426581431;
        Thu, 05 Mar 2020 08:43:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id t1sm49390231wrs.41.2020.03.05.08.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:43:00 -0800 (PST)
Subject: Re: [PATCH v2 0/7] KVM: x86: CPUID emulation and tracing fixes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6071310f-dd4b-6a6d-5578-7b6f72a9b1be@redhat.com>
Date:   Thu, 5 Mar 2020 17:42:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 02:34, Sean Christopherson wrote:
> 
> In theory, everything up to the refactoring is non-controversial, i.e. we
> can bikeshed the refactoring without delaying the bug fixes.

Even the refactoring itself is much less controversial.  I queued
everything, there's always time to unqueue.

Paolo

> v2:
>   - Use Jan's patch to fix the trace bug. [Everyone]
>   - Rework Hypervisor/Centaur handling so that only the Hypervisor
>     sub-ranges get the restrictive 0xffffff00 mask, and so that Centaur's
>     range only gets recognized when the guest vendor is Centaur. [Jim]
>   - Add the aforementioned bug fixes.
>   - Add a patch to do build time assertions on the vendor string, which
>     are hand coded u32s in the emulator (for direct comparison against
>     CPUID register output).
>   - Drop the patch to add CPUID.maxphyaddr emulator helper. [Paolo]
>   - Redo refactoring patches to land them after all the bug fixes
>     and to do the refactoring without any semantic changes in the
>     emulator.

