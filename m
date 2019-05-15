Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107331FC5B
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEOVmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:42:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35506 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfEOVmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:42:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so1442054wmj.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 14:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cK3Y9KxZ958VjTN9/j0HmLvhqtWrqpj1Eiv0iIXluz8=;
        b=TAl8tGMrP8MP4J/lQVxtI+mihemL7oR/nea7jSBvL0QWyPxOHlICTd3MR9l6cZarVG
         NAMGAmY3Wqgsb5k/3YiCwH9vx4uWjCLrJ2q1rX0PSUw5w1JPnwkLPHOEXf7iWnFJYy83
         6m0wAOtV8frQXhwAbREkPg8X2m+m0CdvP8g0FTeKnOqfVFGx9/OlivU0ZgO22xLABEdS
         3HPYg7hG2mLj7S8c/5gE+XXExjYDWed0xuqzNoT15Nedqjhq8zyIT/BTfvkG8SoRgPxb
         NWlPzLmsbCkRKyFtEG1yGoxj3LVad4H3h8QZxMAz2J0H4xepBdqfYVVs2ibsUKpN+bbO
         bkKw==
X-Gm-Message-State: APjAAAXCyx6QvjGKhYPCYLnWi7H6tYE3ia3lL+Imd2SmFCpqlDHxypOy
        nnbLbZRZlogRe3PWDIu/mRPikL7c2TfWlw==
X-Google-Smtp-Source: APXvYqxmP3hKGokzzdV6R/wU044EEKCdMwU8XI2vejExX4Tlo4rebHLW3WTheFhtyMVcTqUqCtPCxA==
X-Received: by 2002:a05:600c:492:: with SMTP id d18mr10215934wme.59.1557956537037;
        Wed, 15 May 2019 14:42:17 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
        by smtp.gmail.com with ESMTPSA id y7sm7019701wrg.45.2019.05.15.14.42.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:42:16 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.2
To:     Marc Zyngier <marc.zyngier@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20190503124427.190206-1-marc.zyngier@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bd20863-f03c-9621-d3ae-10c4da28764d@redhat.com>
Date:   Wed, 15 May 2019 23:42:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 14:43, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-v5.2

Pulled, thnaks.  Note that capabilities had to be renumbered to avoid
conflicts.

Paolo
