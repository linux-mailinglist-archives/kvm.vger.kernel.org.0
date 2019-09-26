Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C569BEDBC
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 10:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfIZIrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 04:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbfIZIra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 04:47:30 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D35F3CBC3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 08:47:30 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id z1so630849wrw.21
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 01:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8sMY5q6l3mF3MnC4LaV1CwEHtIX4Pg8v11/M3gsxiM0=;
        b=UvQxq91VJ/IzONwOIn7ScwNY2fUgdz1FiUuOzdAtuAnc2hBT34pqIxi/EB3JWfC/Nl
         Adl6e3XAL+ckPX+I1SLa4AL+XQ4D4D1D0iGz4jOtUcFuq3cT1nvNC0S/14ID7JtvYuPe
         CwEIOrDPrJwBv5yGgB4WWNJRL64koU69XEez9ZrvQMPY+9OiyIzEfib/Vp0IRvVkS8bj
         Hz7Np9Cv+6/cBRMIQ9h8cMWboFtO6xFXmjnmOIWRWxedvDLmRsMfzGuY1oZwuiIYrXgF
         zbf9+5IONqSFBAoqimL1qR8DVjC4Lb74LFaMA7vztXEsP4YT9DsHOtRvjS9nxQd5G7my
         vQBg==
X-Gm-Message-State: APjAAAWiPb8RYmgoOhoII0eI9+Rh8z69fEVJwMbBYM4XLZmMiO2tTzW7
        nFz/fz0JGymnsjz1kSj6sY+sw8zoqPRcSo8/xksG3+4Yyfmr038be9zEQVbgM/TzP9BC1w9KRrb
        3pzQ3tqdwmw8I
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr2056731wrs.109.1569487648675;
        Thu, 26 Sep 2019 01:47:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGFhpAK8LbmdFJpPLj3W5J0QQOgqf6Ni+nvcQa5RxARPuNcIwbVlLvACuv1F81FD2xncWRRQ==
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr2056706wrs.109.1569487648429;
        Thu, 26 Sep 2019 01:47:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id n14sm811301wro.83.2019.09.26.01.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:27 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        sean.j.christopherson@intel.com, jmattson@google.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <87a7b09y5g.fsf@vitty.brq.redhat.com>
 <8A53DB10-E776-40CC-BB33-0E9A84479194@oracle.com>
 <5bcc595a-fffd-616c-9b68-881c0151fe3d@redhat.com>
 <AED9AA6A-5E62-4F67-A148-14966B71EB08@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c2d3f1df-c8c0-6259-3da3-fb5143c2c0ec@redhat.com>
Date:   Thu, 26 Sep 2019 10:47:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AED9AA6A-5E62-4F67-A148-14966B71EB08@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 01:57, Liran Alon wrote:
> Paolo, I have noticed that all the patches of these series were merged to origin/master
> besides the last one which adds the patch itself.
> 
> Have you missed the last patch by mistake?

No, I was sidetracked by the HOST_EFER failure; I immediately checked if
(for whatever reason) it was caused by the refactoring part of this
series, and pushed those 7 patches because it wasn't.

I will push patch 8 shortly, since I have the HOST_EFER failure covered
and have now tested the new INIT testcases properly.

Paolo
