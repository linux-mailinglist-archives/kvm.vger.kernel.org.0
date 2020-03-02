Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567BA1761C8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCBSCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:02:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgCBSCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583172164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yD5hbojE45I5UYgGJAZzmvYTSa8iAlNKgqw5IjcBjbc=;
        b=GM7lcJba0ppfv5bsNuoAsgabEzDFuot8brN+fOrgMslVH0yxe3Yvfsy7FBk4E+iRuEwvcu
        V4LZxNoVXZ03h0e4JS53qogn2SvWW6SL0BRs7Slhw4xarv616hAZqQwLizTSYA94KJ5i69
        zey7OOw/jp50U38JI+JP80expNKjtPc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-gcyZU_tpPPO1le8-LuMURQ-1; Mon, 02 Mar 2020 13:02:42 -0500
X-MC-Unique: gcyZU_tpPPO1le8-LuMURQ-1
Received: by mail-wr1-f69.google.com with SMTP id w6so38402wrm.16
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 10:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yD5hbojE45I5UYgGJAZzmvYTSa8iAlNKgqw5IjcBjbc=;
        b=ezuc//eGOANF/RKgpE5foM13TnUORiYiZ0Zu59rSBSS0NHRmVWumavWswxqi6B8mWL
         KEqy8t43ojyhFC9AkRaSrrt/qIzlPfsex6AiUFiUi2ZAj3oWxPsv6wsWJy3zHipiJuJw
         kqJ3xko0COjuxY50oUCsidKfUB4Txa+zbReFvwj4eKeKuwhIh0Ylbt4PIlfmTTqV11bR
         WVDqTzi65bvG0EmRnDDKvRWRVb0pYscpD3j+V6sGhlwuNdeDPIHn1X1MKazfslaXB2jg
         4swwNsOpB48f4iuJRDXgEGHIYphGWv94POjrPhC8mxJYkjy4PWQcCtRv1Fh3merPEChc
         L3cw==
X-Gm-Message-State: ANhLgQ3ZFc/DY2DMhx4leyRdTc+/Y5I/XX3Yz160iP3minJ5eHoWjEZc
        rhANR+RObjhaQEjgMecjJ7czWip1+bT1FuURwbdpfeZxmobi4NwaAXUIsD9n5xzeUDGc4p+c3Fb
        VQXrUWrzKJRc7
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr254406wmi.108.1583172161674;
        Mon, 02 Mar 2020 10:02:41 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvnDdxXMDxb+073m/6FgQ+6hKR1fRUhw2fF6Rkr7smuqXbzAyvrEli0YvGlH3qZ+ybKBGn1qg==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr254378wmi.108.1583172161435;
        Mon, 02 Mar 2020 10:02:41 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id s14sm17033764wrv.44.2020.03.02.10.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:02:40 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     Jim Mattson <jmattson@google.com>
Cc:     linmiaohe <linmiaohe@huawei.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
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
 <a1ff3db1-1f5a-7bab-6c4b-f76e6d76d468@redhat.com>
 <CALMp9eQqFKnCLYGXdab-k=Q=h-H5x8VnV20F3HH9fDZTDuQcEQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e173c489-dee7-a86d-3ec4-6fe45938a2d8@redhat.com>
Date:   Mon, 2 Mar 2020 19:02:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQqFKnCLYGXdab-k=Q=h-H5x8VnV20F3HH9fDZTDuQcEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 18:44, Jim Mattson wrote:
> On Mon, Mar 2, 2020 at 9:09 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 02/03/20 18:01, Jim Mattson wrote:
>>>> And in fact, it's not used anywhere. So it should be
>>>> deprecated.
>>> I don't know how you can make the assertion that this ioctl is not
>>> used anywhere. For instance, I see a use of it in Google's code base.
>>
>> Right, it does not seem to be used anywhere according to e.g. Debian
>> code search but of course it can have users.
>>
>> What are you using it for?  It's true that cpuid->nent is never written
>> back to userspace, so the ioctl is basically unusable unless you already
>> know how many entries are written.  Or unless you fill the CPUID entries
>> with garbage before calling it, I guess; is that what you are doing?
> 
> One could use GET_CPUID2 after SET_CPUID2, to see what changes kvm
> made to the requested guest CPUID information without telling you.

Yeah, I think GET_CPUID2 with the same number of leaves that you have
passed to SET_CPUID2 should work.

Paolo

