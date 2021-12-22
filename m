Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E747D3DC
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbhLVOof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 09:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237489AbhLVOoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 09:44:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6B8C061574;
        Wed, 22 Dec 2021 06:44:31 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so9501155eds.10;
        Wed, 22 Dec 2021 06:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M0W3ib0yUWKffn+66baA9u4RAHv05Mx8JpMmpcIbPy0=;
        b=jULZK8rXUozv+IugcKX4w+Q9gB9zc+Z+qUN6whcQsFy3N0GUaP27vOEvf0kIzE5Bct
         fmUEIuOZGQm5r9jxnkNwnMGvixhy8+EtOxsniaCTEHINIC5d+eb0dS8nVvdeqChzJpF+
         ME82UK3F219/29J++ZZinUq3kd7grrAvt8ABmSQKto4z9g1U2U1+emJSEUNLDagavAMm
         PdfbbnhzdIg3HM8ZLj+JutH5OzR+7ALwh5L+hlNNdmDD1quupnkR4hl8byHCewx9zyKd
         3oXV/L9NfSF4TSlRjdlwBcnUrIyQZWvrRv7PqOrDv9jETekCaSGH3ELCTHSKT6PZ/HUg
         xLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M0W3ib0yUWKffn+66baA9u4RAHv05Mx8JpMmpcIbPy0=;
        b=bSX71K6txwYc0g/K19UdW57ID4nSTat6HpCgAytqNBjdUos6jkOvfKZvK61g3HHE7o
         4//CXgDF2Ge8T/iq4SJTg4brFWiY9zzoWMT5clB7YOe1Cz4PKXl8+7v+nLiUAzkhuLwF
         s7tWNG8K69is8BSmrwRtit3230icNoogCyM+C39aSEldhpPsch51htdy+nAkbaJvRW1P
         P+6Dd/aYYM0vKQJ9Y5qMkWS+xv5ipkWY51duZfhDtokrmc/SQKdZC9Z+dCgdF+UQ4wh+
         mmSRh79UdPn3TenDfp7EunQuRIsHtMUagAnaFtViwmzaNac20JYUmHxIY2ct9VrV7c80
         yyTw==
X-Gm-Message-State: AOAM532hEzn7cFOEP/I8CxnQ3kpqSOy7cv7T+qsMqT4gY92lbkg624Ss
        pumezBdGd1X2gJP3HN+ST+w=
X-Google-Smtp-Source: ABdhPJxO3W6CToKsonK/WtJBwNfKsT/2zWqs8DdFQ3C5364BuUVNbBWKexbY13Xx/rw42Gq/ZB2vaQ==
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr3138872edb.228.1640184269744;
        Wed, 22 Dec 2021 06:44:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::4fa? ([2001:b07:6468:f312::4fa])
        by smtp.googlemail.com with ESMTPSA id 23sm807196ejg.213.2021.12.22.06.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 06:44:29 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a17363b8-41d7-af74-f66f-362bfc2c6c9e@redhat.com>
Date:   Wed, 22 Dec 2021 15:44:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: State Component 18 and Palette 1 (Re: [PATCH 16/19] kvm: x86:
 Introduce KVM_{G|S}ET_XSAVE2 ioctl)
Content-Language: en-US
To:     "Nakajima, Jun" <jun.nakajima@intel.com>
Cc:     "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <24CFD156-5093-4833-8516-526A90FF350E@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <24CFD156-5093-4833-8516-526A90FF350E@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 18:54, Nakajima, Jun wrote:
> Hi Paolo,
> 
> I would like to confirm that the state component 18 will remain 8KB and palette 1 will remain the same.

Great!  Can you also confirm that XCR0 bits will control which palettes 
can be chosen by LDTILECFG?

Thanks,

Paolo
