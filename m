Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BB51760BD
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCBRJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:09:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727196AbgCBRJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583168985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT1LxWtW4Alz7bMFxQVRaqlYT59rz8oUaocc8kmU1Ic=;
        b=NHUkYQM38/BbKynTb00ntX3WZvYLDLH2yLuZ5sv607ZAzE5+AgRqwouovqHNIGECelALtk
        JAJ5rWPPEzZzwGQC/NeG43Nzrz3sXb9pe3KnQXgwvSbtv7OYn/7hLFPmMDVMheYmEC38r1
        5tDn3/W/O5m4j0a9Uopy0EUudkFrPcE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-oHUK7fedNiWKXfy86ofmmA-1; Mon, 02 Mar 2020 12:09:41 -0500
X-MC-Unique: oHUK7fedNiWKXfy86ofmmA-1
Received: by mail-wr1-f70.google.com with SMTP id l1so6132716wrt.4
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 09:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WT1LxWtW4Alz7bMFxQVRaqlYT59rz8oUaocc8kmU1Ic=;
        b=MeqBzRF9lhNwJH1V8EHj5boj43qF0wFHcUl04MEQZTf/jJ6kvBQvafhJZI0ZHjiklE
         kB5rKl5/rLrxDvnV4PmgLYi9xX0fKzrOpYa6DxipQ9n3DS+EcRTAnInPu+ghOdQNJ6qt
         0b/roNGvlNw12yVhLoqxr0CnOX5niBs+NhD+Ljn8hYTDtnAQdaGC6chDClYSvQ4Rttfm
         ZH3Vcl/q/i7tW9QDc98wJfibaooclVErtCEKoErCoMrP510gibQ6s5zH60REbvahsd1B
         uRDQdNH7njH+aRvcmaAYffw9pZ6rZZFb4KIjvQQHuPbvZNxvdzQPrGgqESa3d3xv87ki
         8n7Q==
X-Gm-Message-State: ANhLgQ3+ljFGpgnkrPRFWLoNF3W29fzapRfhNoBkBjNNmDbYLGjN4X5i
        U3yU9+f6TTYnFDSVXpqyEyeSBZrnfNmpL3KW/7GmTe2NPLUPT2GkEbInGp6pO2+XQ7lX4jXAeaQ
        Zx+c4cNjV8BL8
X-Received: by 2002:adf:ebca:: with SMTP id v10mr529124wrn.307.1583168980822;
        Mon, 02 Mar 2020 09:09:40 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtVkAdxBvARGR1a/1q4KckNRdJ1jfVeNZnf0QSzFxhNZ1uq7iVs/65BkCMwF7KIJkGDcxPAQw==
X-Received: by 2002:adf:ebca:: with SMTP id v10mr529103wrn.307.1583168980629;
        Mon, 02 Mar 2020 09:09:40 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id s15sm29549483wrp.4.2020.03.02.09.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 09:09:40 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     Jim Mattson <jmattson@google.com>, linmiaohe <linmiaohe@huawei.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
 <CALMp9eSaZ557-GaQUVXW6-ZrMkz8jxOC1S6QPk-EVNJ-f2pT5w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1ff3db1-1f5a-7bab-6c4b-f76e6d76d468@redhat.com>
Date:   Mon, 2 Mar 2020 18:09:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eSaZ557-GaQUVXW6-ZrMkz8jxOC1S6QPk-EVNJ-f2pT5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 18:01, Jim Mattson wrote:
>> And in fact, it's not used anywhere. So it should be
>> deprecated.
> I don't know how you can make the assertion that this ioctl is not
> used anywhere. For instance, I see a use of it in Google's code base.

Right, it does not seem to be used anywhere according to e.g. Debian
code search but of course it can have users.

What are you using it for?  It's true that cpuid->nent is never written
back to userspace, so the ioctl is basically unusable unless you already
know how many entries are written.  Or unless you fill the CPUID entries
with garbage before calling it, I guess; is that what you are doing?

Paolo

