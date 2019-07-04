Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2609C5F7E7
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfGDMWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 08:22:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37302 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfGDMWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:22:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so5945396wme.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 05:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XKbnehwrHnUHczUaGoUWYJWgHNQXTFxulxqCc3Hc+74=;
        b=QiHoPcZVW9+g17ElBUdYlejJL6MRgiqf2+UVABaoj6VZel/+jkZRE/KPTIHK8tlZog
         cmfVRaWAZ5sEPlrDm8swJVRSIDDGwHDAO/+uGwJbFBfgRugnnoVfxb1wjKA4qYRvQ7I2
         3Z5NcR8esadoGy/+hjLrX/hee/rG8kPk7gqZzYz82mad66fR/GNJOGue8xffB1cfMH1O
         asOmNs4Uj3Ow0NZ6U1TGMC+9IKzXQ66iJarHfFvRtZ3d84xVhTzVE1IiYzY2kBEKdL+4
         vFmmMn+Xp1SI0Uf8EiEen4FhPywVuYjj6hjtBd+gUh1Qgt1iujNBLn7Bq8QOgTiAXMmx
         HgWg==
X-Gm-Message-State: APjAAAWJrm1dxrYCGdJme0EMAC+48h7y3er2RSad1pf3+KFLzcX/Y46H
        4E4ZPvERmZVdQ9KS4smpgGc+BA==
X-Google-Smtp-Source: APXvYqwj8nhEg9up1PX7rhJtJY7HWdQo+Hl8grcttWDYO0WeJw/d9esHC4Y09B4q6vNRUfhOC0su1A==
X-Received: by 2002:a1c:a503:: with SMTP id o3mr11839100wme.37.1562242921860;
        Thu, 04 Jul 2019 05:22:01 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id a84sm6182916wmf.29.2019.07.04.05.22.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:22:01 -0700 (PDT)
Subject: Re: [PATCH 0/4] kvm: x86: introduce CONFIG_KVM_DEBUG
To:     wang.yi59@zte.com.cn
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <201907041011168747592@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d3b2e72-ca07-2b85-d978-f026c608ff48@redhat.com>
Date:   Thu, 4 Jul 2019 14:22:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <201907041011168747592@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 04:11, wang.yi59@zte.com.cn wrote:
>> For MMU_DEBUG, the way to go is to add more tracepoints, but then
>> converting all pgprintk occurrences to tracepoints would be wrong.  You
>> can only find the "right" tracepoints when debugging MMU code.  I do
>> have a couple patches in this area, I will send them when possible.
> 
> Agreed. Hoping your patches.

I have now sent them, see "KVM: some x86 MMU cleanup and new tracepoints".

Paolo
