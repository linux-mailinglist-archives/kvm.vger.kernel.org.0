Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E42A173184
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 08:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgB1HDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 02:03:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22544 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbgB1HDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 02:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582873421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OV9TVzYiK7fy5Df/XLhzIPFheh7WMpe9u5ayB8vjOrA=;
        b=EFqy5aQgOO4eQ3VP6zo/ox1e+0rHqtydSIfXAsfGGDn7TLA9SeClXCOmZAieCyKu2otCKT
        Xb52B522b6fwlV6kYhEesISxOt9jrm4uHQaCtelEZAfHDrD5qKjlDicZgra5pA5BFWrNYX
        M2/rRGRVFewQW1fRru77Sn3rfIeb7ao=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-S5jl9707OX6fDaGA65XW2A-1; Fri, 28 Feb 2020 02:03:39 -0500
X-MC-Unique: S5jl9707OX6fDaGA65XW2A-1
Received: by mail-wr1-f72.google.com with SMTP id p8so935188wrw.5
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 23:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OV9TVzYiK7fy5Df/XLhzIPFheh7WMpe9u5ayB8vjOrA=;
        b=E9ztkM0aPgkiNLOjQwrMP8vafbs20sNo+DmhKzqopCwmL/FhPiQ91bMlrlVdI6YmqN
         2lIYynTjcDTbow3/LSwOMGAbmNyZP4piYAP+lKOQWC4aXI4NH6lBd5sNHZymQT8igABZ
         osTW9NSZHA6FN8J6RH+auGzMfsOP3xhdDyFY4lQmjpm2AGyMe5v3QZ3wkCbpjSkdu2aE
         xK424A4PR33c3w2lrluWJkp9ZFE3d7e2yT76DlzteyyMCG8M7r+xnKLKehErCF7FivKk
         52czGGDuE+DMdpHB1j4U422dt4Ljp2Yc5oto+L+/SsRaPICDy+Vco1YFBTMqAj/yMbKA
         QIpA==
X-Gm-Message-State: APjAAAU0wHbAHET0uHJYgn74kwf8YywcADsaJsQTNGfX17M8N2b6i5X4
        /OJOu3We5iz9gc8hCU/jXJp7YVo+CKgW21cwe/Wm82VzTPlGJZ9NAqp6S9LfeatmePXecCDW3vu
        L7pVHi/PY6f5Z
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr3233341wru.127.1582873418474;
        Thu, 27 Feb 2020 23:03:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqztcbbkyVtgEGOtL0OapteA9GCHua/jgQhBMowijROGhgz2+TEXljndEJ+I7KchOoasqdeR1w==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr3233315wru.127.1582873418240;
        Thu, 27 Feb 2020 23:03:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:30cb:d037:e500:2b47? ([2001:b07:6468:f312:30cb:d037:e500:2b47])
        by smtp.gmail.com with ESMTPSA id b82sm834482wmb.16.2020.02.27.23.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 23:03:37 -0800 (PST)
Subject: Re: [PATCH 39/61] KVM: SVM: Convert feature updates from CPUID to KVM
 cpu caps
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-40-sean.j.christopherson@intel.com>
 <0f21b023-000d-9d78-b9b4-b9d377840385@redhat.com>
 <20200228002833.GB30452@linux.intel.com>
 <20200228003613.GC30452@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <052d2bdf-d2da-36c0-2fb5-563b5bf5f2ed@redhat.com>
Date:   Fri, 28 Feb 2020 08:03:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228003613.GC30452@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 01:36, Sean Christopherson wrote:
> Regarding NRIPS, the original commit added the "Support next_rip if host
> supports it" comment, but I can't tell is "host supports" means "supported
> in hardware" or "supported by KVM".  In other words, should I make the cap
> dependent "nrips" or leave it as is?
> 

The "nrips" parameter came later.  For VMX we generally remove guest
capabilities if the corresponding parameter is on, so it's a good idea
to do the same for SVM.

Paolo

