Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424531B62B3
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgDWRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:51:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60107 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729889AbgDWRvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587664275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4I4TQXbu0COs/qS0TdMrpO0BMmwvUdkWqtKkxdiZtg=;
        b=eeW/zRdAVsH+9nh6dSZrOVKFK4yOAeFBtx8hmJ4dbRg07hlxfTvQ/3/hdegNDEPZtqpEe/
        1Gz+9wxlRXl8H+BRaTGQZsWJ6JrIFLFK0v3vSQuRcnyE/VpUyggiiiDvXumNAVC6Webclf
        7KmGFl9mtCnpsqNpLpdD2c1wX6Uze9s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-D2JV04i8O1uSBbQ92VRt2A-1; Thu, 23 Apr 2020 13:51:13 -0400
X-MC-Unique: D2JV04i8O1uSBbQ92VRt2A-1
Received: by mail-wm1-f71.google.com with SMTP id n17so2686432wmi.3
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 10:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4I4TQXbu0COs/qS0TdMrpO0BMmwvUdkWqtKkxdiZtg=;
        b=jCYnIgGyhYmcDmS3Wi4fH/dtWtfQeg8Z2Yxhgt+62JNO0qaCy9OwtFwNfDXQ0W2cDY
         j7NXLtlLJqto5Mc6U939QRNhKr7VCcbbbPCvGTLAhSaSfxhdBbgYCWrXv6rXcs4OnJXq
         oINqXmr22398x8KNOaqkDLIghZ1dLFFhZESoU8TJx0a6NNMG2KUbHVtajpC/mXbxqq5Q
         P3kRONJf2m543Y1bINVnEmtW1e3XqG8oEsPiYBnWMv6O8g2MltOS0UJP4t+ZPZ21dlWh
         HfpYWh1ZoUx2twtR0ffygEK2DPJKypGdmpfMTvCNdUtk5jRmn+UCK7P2ov2rmC5gzrEy
         HH2A==
X-Gm-Message-State: AGi0PuavaNjIip+mvfCfcy8hHx0r9dgp3hscFLl1E3MwBBzZ9rk3vJ/o
        M5SHvuiXv8sd/itLGcA/Rbik+Qlq5giszFwMXu3a8tXcOAZz3xUVaPlLittPVpKo+J26XIiGfNP
        S4IkuxrrEW7pz
X-Received: by 2002:a1c:9e51:: with SMTP id h78mr5726963wme.177.1587664272584;
        Thu, 23 Apr 2020 10:51:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypK/wZjFY48hmQMwIAV2fQ6VxIkFz+VgDCtd7gu1Ykeal53v56KplZrYM0/Je0GgoY4i5twzKQ==
X-Received: by 2002:a1c:9e51:: with SMTP id h78mr5726937wme.177.1587664272275;
        Thu, 23 Apr 2020 10:51:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id h137sm15720031wme.0.2020.04.23.10.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:51:11 -0700 (PDT)
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
Date:   Thu, 23 Apr 2020 19:51:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 19:42, Paraschiv, Andra-Irina wrote:
>>
>>>> - the initial CPU state: CPL0 vs. CPL3, initial program counter, etc.
> 
> The enclave VM has its own kernel and follows the well-known Linux boot
> protocol, in the end getting to the user application after init finishes
> its work, so that's CPL3.

CPL3 is how the user application run, but does the enclave's Linux boot
process start in real mode at the reset vector (0xfffffff0), in 16-bit
protected mode at the Linux bzImage entry point, or at the ELF entry point?

Paolo

