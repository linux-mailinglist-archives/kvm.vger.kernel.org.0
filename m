Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E988D60648
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfGENAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:00:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32855 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfGENAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:00:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so7448491wme.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 06:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LkjJN9pn3JzWHjcbg2XmZ5SMAe2wfwVxdSS9lT7yctY=;
        b=bstdnY2S9PvIX1JqIWVzLDt/WwBVDf2AKi9pu1Ii7hw5ZD8la/SUc11yosIa8s+xXT
         OisaG//a6ESPzyK2FnEwgdLf7NWMPnwo4TU0O7fLQcXuUjzGI5mKAhOCbx74VXMSTBRd
         Tphcm+hZ9r5vmWaAn/ry549x69kZwVf8bymh9Z3VIFXTlNUaV9BlbFQ7J80q7AF+7Sh+
         9GtzqOki8+BEpF/4z4mb/qjM37xO5iNdI+njYJsEtdkPbTBKxYgGRvg7pHXhiyzkCeir
         GSslwQ+Z5ai4N64Z97jgq5N6bVeVRO0LqtWy33Eo+u4i5MgFZrnHDQpFZWET/0wBQLAV
         k3VQ==
X-Gm-Message-State: APjAAAV64aCa3qYsBy+fX6nAtaXBtCNfKaNsTcoIX7G1Z5IaNmQdwQl6
        ddWRYRevNt76BQX0zdzHG6V1Vg==
X-Google-Smtp-Source: APXvYqy0PtZB/6YxP9lkmvnMNPYrehBnhSukC5m5JWWRYdRBvtZJYSigB53fBVEQSPMi4BkFUu/fIA==
X-Received: by 2002:a1c:4803:: with SMTP id v3mr3562900wma.49.1562331644991;
        Fri, 05 Jul 2019 06:00:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id m24sm7280293wmi.39.2019.07.05.06.00.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:00:44 -0700 (PDT)
Subject: Re: [PATCH v5 2/4] KVM: LAPIC: Inject timer interrupt via posted
 interrupt
To:     Wanpeng Li <wanpeng.li@hotmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1561110002-4438-3-git-send-email-wanpengli@tencent.com>
 <587f329a-4920-fcbf-b2b1-9265a1d6d364@redhat.com>
 <HK2PR02MB4145E122DC5AC2445137A10F80F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e57b9a2-28e3-13b9-969a-ef1e3f55067e@redhat.com>
Date:   Fri, 5 Jul 2019 15:00:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <HK2PR02MB4145E122DC5AC2445137A10F80F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 14:52, Wanpeng Li wrote:
>> Also, do you want to disable the preemption timer if pi_inject_timer and
>> enable_apicv are both true?
> 
> I have already done this in vmx_set_hv_timer().

Right, sorry!

Paolo
