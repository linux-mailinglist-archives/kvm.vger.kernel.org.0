Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAA35F7DF
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfGDMVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:21:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38815 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfGDMVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:21:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so5952972wmj.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 05:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p51cT7dzlq8xphDFpP7MetqkRfgJhlWs4fveKbRUFTc=;
        b=HeJAzlD/BW+EvYW5SqKDCc8nKRwDlrA4NyjekFoJgqyv1Lc/Sg4ymbgc4w7s2c1Ikp
         8Sds0SwKwDuxDEYAjFCgLFjM6HJK768nG3+Q1pn6mCu+hkN4buYvEqIS/Vv+TmvFodC2
         pRLpmX7xbF8YdZ+NjS760gm35qiFF2RJ1MIcsA07Tt/6ZEjdXbx/JQFwgHtYEg8l+8rV
         K4dBAAvrrUf5WGHf+kHNe879/I1Fj2YlBY8DiEdS4zEgNysEttNdnudXXIObM9bsPLDk
         E/HlQ7SpOf7NnUEkpFw1eXOv6koGl6U/KKdcAXMrBzw/GFwlL2FyDZxuuJkfFh/P9a+C
         qudg==
X-Gm-Message-State: APjAAAX/q8w4wQSZhL8iA5Mv2hqi/+doeRgGHmyvUHvFXclKu6IbpCPG
        sfDhsLimbU2x9djAhB1ZAPb+bA==
X-Google-Smtp-Source: APXvYqymRv46MPwfBgNEn4/QnkXgzBPjr6a1e0Jk/WiVbrINOBFS3BjhNaPz27PVxdh0GVVoC/H6AQ==
X-Received: by 2002:a1c:6c14:: with SMTP id h20mr305514wmc.168.1562242871349;
        Thu, 04 Jul 2019 05:21:11 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id f2sm4532451wrq.48.2019.07.04.05.21.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:21:10 -0700 (PDT)
Subject: Re: [PATCH 2/4] kvm: x86: allow set apic and ioapic debug dynamically
To:     wang.yi59@zte.com.cn
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <201907041000221336892@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3d427319-83db-878c-1141-7587f41e8366@redhat.com>
Date:   Thu, 4 Jul 2019 14:21:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <201907041000221336892@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 04:00, wang.yi59@zte.com.cn wrote:
> Do you mean we can remove ioapic_debug and apic_debug totally? If so,
> I would like to send a v2 patch to delete these two macros. :-)
> 

Yes, please.

Paolo
