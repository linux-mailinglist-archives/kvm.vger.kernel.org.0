Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD916E9FD
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgBYPZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:25:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729501AbgBYPZl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 10:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582644340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHRKxD00cTyT09o9LKocptIN+yLA1rFAZrxjnmWX1Ls=;
        b=A9mYZegaqBmur605w4pDWZYwH52F9j+6BkW3vLJJfYc7sD+2mTMQl2XsI0fKlsmcWtC0R4
        d343SIWuE0TSvreI2J+0KSZ89v/iekf9zdzPhBkISgpYbN9Sb4eDzvZryUUkGs/83H805z
        F/EEnIkqehLH57dWlHloTOB1O4YX9Nc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-8XFhJLz4M_CVin5Ix3lNog-1; Tue, 25 Feb 2020 10:25:38 -0500
X-MC-Unique: 8XFhJLz4M_CVin5Ix3lNog-1
Received: by mail-wm1-f69.google.com with SMTP id u11so1170887wmb.4
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XHRKxD00cTyT09o9LKocptIN+yLA1rFAZrxjnmWX1Ls=;
        b=t0DDkk9ol/JnWTCw+zA9n4vvOniX/uvMfsd4raaFCMDm4WGrTmcol5cT76DbGBOq0Y
         9Dn//L8Av5y1zl85Q3zapqypM9mLLpcoSbak5057ZpJqf5Hp1eRwJxBUbQjleP4h39Zn
         TcVR+WU+72VddsghCsffnlWyxNdkQXZ2OUdtHExNyVPOoW+0NKVEcyRBA2vXgjNZ91Cn
         sfQ1+7nQrRXBGKKBLq1Xdpd8Avm3ojIlCYKzd9AQ1kYm8ifHY5sZK3d6x6GOYi0jY+F0
         Sk3O5VNI67YVZsMOGxvUATmac65zaMDwM5CtQFMg6iL7+j5Sjpdi9W0f4VHuAf8aDrcl
         uoHg==
X-Gm-Message-State: APjAAAVd7N/u9KU3ChpNBFw10vDLpS+Ao1kfPVNNuAQBIkvU+uiQbVd+
        98g9B57Ej0E3Ii9XMZUkqaKAFFs5Y3ocfnCYM6vSUpSdGWnvF/YBoyU6bX3QNiCOYtEw1Le7t1O
        GqIJ2Woh2gXOm
X-Received: by 2002:a1c:491:: with SMTP id 139mr5904257wme.117.1582644334821;
        Tue, 25 Feb 2020 07:25:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOEO5FTObReQwSnlZOzVoqdfjaEIdHk/sbsxSJs1qE1hoP1ta5zdOmm+8U8vuRcLcMmb2wTA==
X-Received: by 2002:a1c:491:: with SMTP id 139mr5904230wme.117.1582644334563;
        Tue, 25 Feb 2020 07:25:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id z21sm4445966wml.5.2020.02.25.07.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:25:33 -0800 (PST)
Subject: Re: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <87wo8ak84x.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a52b3d92-5df6-39bd-f3e7-2cdd4f3be6cb@redhat.com>
Date:   Tue, 25 Feb 2020 16:25:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87wo8ak84x.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 16:18, Vitaly Kuznetsov wrote:
> Would it be better or worse if we eliminate set_supported_cpuid() hook
> completely by doing an ugly hack like (completely untested):

Yes, it makes sense.

Paolo

