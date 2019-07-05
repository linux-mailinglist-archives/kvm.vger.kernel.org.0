Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC1E606C5
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfGENma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:42:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55824 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfGENma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:42:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so8913469wmj.5
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 06:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4iYb0bYihJJMXivPTPv/aHyJFdI8X6+6Oc7sOAPuN1M=;
        b=LXDyZdQpMeCzONffHQSp6xnmiCzf1ljEHCalVhg/i7sPcN0uN5H6X38PKvjbrpqcOm
         ThoRldFWtMd8FQEvdXxYdCtdhIz8mwSOZj8qG+Lae8oWItzI0/JyQ4k06se2c1ZA6ZWX
         bf0IEb5Hq3mQDt2w5wUjHw23piIhOrgcYgJzNHja8IZ6owVQlPTU4vL4am89UHt04Hxu
         SfTswf2uI9djS6xFXbjyocSE604xafbwsssQ1YS9lex78/UP3f/TRZ5MtVkiUROz/+Du
         2U0c7RjQr1dFDI6rZw6/QmwcUmUX/mi1jp37vFDC/8s0pQp2Peo5tfMeUi2Tw2okAExV
         FHUw==
X-Gm-Message-State: APjAAAVSsVfYEu2OrFJyu/zjD7C6ECvV0sehC2F8uikoId9iVQWqMVw1
        TUjZsHX+nujvkqjjHJuASSk+yQ==
X-Google-Smtp-Source: APXvYqwByfMM85jOStUZAupRZVHqj/o4S1sAo5LiNDj2LzVzhMiMpbI+BtNslxzqagrl2r99Avs0hQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr3748628wmg.86.1562334147882;
        Fri, 05 Jul 2019 06:42:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id j189sm8346421wmb.48.2019.07.05.06.42.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:42:26 -0700 (PDT)
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
 <HK2PR02MB4145BBA5B72DD70AC622FD0E80F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7614bc43-d9b1-7287-deef-1494f61d0b58@redhat.com>
Date:   Fri, 5 Jul 2019 15:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <HK2PR02MB4145BBA5B72DD70AC622FD0E80F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 15:32, Wanpeng Li wrote:
> -bool __read_mostly pi_inject_timer = 0;
> -module_param(pi_inject_timer, bool, S_IRUGO | S_IWUSR);
> +int __read_mostly pi_inject_timer = -1;
> +module_param(pi_inject_timer, int, S_IRUGO | S_IWUSR);

Use "bint" instead of "int" please, so that it accepts 0/1 only and
prints as Y/N.

Paolo
