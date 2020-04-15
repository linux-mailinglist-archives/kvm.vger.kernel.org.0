Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B151AAB01
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392526AbgDOOws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:52:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S371060AbgDOOwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 10:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HcURD5RLU4AHJzLsroTnnqfqtIhRpKSmMCjT+ORb04=;
        b=iz2oc9m0op8uAIvDZaEq0riNW9VZkNTpA2qEXy748PCEyA9lHN7C1NBali083qUt+bwNbt
        Fgv1MjkYeGPee28/14PZMMWCgCnU/0HwfEdRirLBI7pUDOTBe7aMDcpL4SWbouL8izHXNO
        x2JUrYfLA8hCvmQDTCA0TtHmEQOvJ4A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-PJPiKI9DP9-9HrAndFtj8g-1; Wed, 15 Apr 2020 10:52:38 -0400
X-MC-Unique: PJPiKI9DP9-9HrAndFtj8g-1
Received: by mail-wr1-f70.google.com with SMTP id j16so14247wrw.20
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HcURD5RLU4AHJzLsroTnnqfqtIhRpKSmMCjT+ORb04=;
        b=s4l1nRKPGMetkSJgUxvXgNckRX5m6OvV0YEcOIX9lFriJ6rF5r2RKoqXeq1bSGEsy2
         0HV9T2uu0xcAknxvB67S8Vjrim1IVk8z0LkTEY1kCAGxtclVHeFXdhG5HUAlbL3PHFl9
         cSfY/LALOVCs58YsKwh/0c53D4SbuNM/WXKPKXdpRmfoAW261XSe1xtpZ85SZG+mVtFz
         syMZesD4VlBhuOElFRV/206v79CZxpYe2a+fiTCEsg2AW3r86YNJK9jbVpjNpILd9sF4
         DGyhybSUsrayjzR8xs/jHEsJv338f4vVISM/1gyM2upt4djek+MwakJEWh0Xwk3O7y1S
         rBkg==
X-Gm-Message-State: AGi0Pua06wRmoLIrtdCesPw1X5ze4VEdEBWvVuP8xtXJyX8vLMauMOs3
        OwFoEaVoBecyUnxVsx4sj6PId5q4qbJ/5vDCLIzdOzwiZHvz/1TYY9Cu7jXpZzYVH5GC7RMvXp4
        ylRCH41nvdkpF
X-Received: by 2002:a05:600c:20c6:: with SMTP id y6mr5478277wmm.131.1586962357331;
        Wed, 15 Apr 2020 07:52:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypJpmTfXvAfh6VQ7NYsROjF39AkmtViNfPLXAcTjNMlDROjb6qcLhhfNyYsa+WbDh/+5TjzYXg==
X-Received: by 2002:a05:600c:20c6:: with SMTP id y6mr5478267wmm.131.1586962357128;
        Wed, 15 Apr 2020 07:52:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id p10sm22950455wrm.6.2020.04.15.07.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:52:36 -0700 (PDT)
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
To:     Eric Northup <digitaleric@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Northup <digitaleric@google.com>
References: <20200415012320.236065-1-jcargill@google.com>
 <20200415023726.GD12547@linux.intel.com>
 <20200415025105.GE12547@linux.intel.com>
 <CAPC9edWgcrC+mc1pQSYmJjPs17VZ-Af1LJ+s6PaeY=9fPA89NQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c351cec8-fb35-c34f-edbf-2117fa147082@redhat.com>
Date:   Wed, 15 Apr 2020 16:52:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAPC9edWgcrC+mc1pQSYmJjPs17VZ-Af1LJ+s6PaeY=9fPA89NQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 07:27, Eric Northup wrote:
>>>   Return the host's L2 cache and TLB information for CPUID.0x80000006
>>>   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
>>>   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
>>>   directly into KVM_SET_CPUID2 (without breaking the guest).
> This is a much better commit message, thanks.
> 

Queued, thanks.

Paolo

