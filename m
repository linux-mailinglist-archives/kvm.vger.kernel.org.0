Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5915A82E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgBLLpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:45:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgBLLpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 06:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581507904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/XW9HBv8g40NKs9Q4i4eHubCeo+923+Sg7WFrBrwCY=;
        b=WqdO1Nhg+SRwWX5ZPPVRNkL5KL0OmbSX2h+uC0fP1XYajCpvgGzBqWD247/LnwiWSkOo7D
        dYglOttdkm546TsvPouCWrN+nEOPUHV+S09W+Sl4Rd5lsVCl2KBqjuVmwBDm4O8CHt05iN
        D9V5XjExkl/plYtiICtKWUhCeSbRkf0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-7GNSNTWrN6KhagNCu2UMeA-1; Wed, 12 Feb 2020 06:45:00 -0500
X-MC-Unique: 7GNSNTWrN6KhagNCu2UMeA-1
Received: by mail-wm1-f72.google.com with SMTP id b8so407878wmj.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:44:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z/XW9HBv8g40NKs9Q4i4eHubCeo+923+Sg7WFrBrwCY=;
        b=MNMp+blkpOPY3BT19EKxvpNO/UH5ppdZ8+eZ6jHWTjHkV9T6CHwL4LhXxyCar93sZ1
         fXp+Q/tusFOaGaDCekd7PKyFBl32XMsDujAuSFP0ZI3v0SwzCOcNhJDhmdiyhPDWiH3X
         g20WRMJ0UfB6qkt47vmH/HLrxHpywGMJrrJ6uWmDkD9xILpwcAQpe7UG+UkYuJOn5EJo
         hUnyV2olFxx3olDDfdXA/fa/katJ0efp+3fQvGdTdKnB6Lz8losyCMCv2d7QO3XkRnKc
         AICVMnlEcOOWLhrZoJ/g0xuBhQDTYxTxGCNSqbrlaSvg3Tx3K1ZyxAySuEDYj/ZIeBiO
         b8QQ==
X-Gm-Message-State: APjAAAXiTYeSs+ta2+XfdmryiK2X8vDe6tWOgcygMJBatOJR4b5ZIDtF
        YGA9gnVSHLXW4xN5iK4+9Rzn02bgdhRH8+TeRz3yAbGqvGQmUZ35WWshtAO2lnOlKYbVK8kX1zH
        EPBdXeDh33JWD
X-Received: by 2002:a1c:2786:: with SMTP id n128mr12005153wmn.47.1581507899077;
        Wed, 12 Feb 2020 03:44:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNLEvraETcWc9irlpjFpNKiOUzmnEDzoDdQ3QMWGLuFUihhVD3y/6Sc35cwcZEI+Ez97BY6w==
X-Received: by 2002:a1c:2786:: with SMTP id n128mr12005134wmn.47.1581507898813;
        Wed, 12 Feb 2020 03:44:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id l132sm451131wmf.16.2020.02.12.03.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:44:58 -0800 (PST)
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
 <2469b52e-9f66-b19b-7269-297dbbd0ca27@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a30f5513-d80b-a4e9-0279-995bf5c6417a@redhat.com>
Date:   Wed, 12 Feb 2020 12:45:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2469b52e-9f66-b19b-7269-297dbbd0ca27@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/20 23:46, Krish Sadhukhan wrote:
>>
>> +
>> +static inline void l2_vmcall(struct svm_test_data *svm)
>> +{
>> +    __asm__ __volatile__("vmcall");
> Is it possible to re-use the existing vmcall() function ?

Technically the AMD opcode is "vmmcall".  Using vmcall() still makes
sense as it tests KVM's emulation of the Intel opcode.

> Also, we should probably re-name the function to 'l2_guest_code' which
> is used in the existing code and also it matches with 'l1_guest_code'
> naming.

Ok.  I also removed the "inline" which is really not used since we take
the address of the function.

Paolo

