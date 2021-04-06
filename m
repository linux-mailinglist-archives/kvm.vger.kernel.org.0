Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045E03555A7
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbhDFNsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 09:48:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36319 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232463AbhDFNse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 09:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617716906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RmbkeXOU9aY5FvEDwAnTFfcMebHKvlLbf8MXeM95+E=;
        b=FgnTMkO9sBmU/SFuZhCXkaFigJHonIOpr86HUN0Qc7hmML8to/RvJ7IyT/icVBcsT7X57o
        C+u7PWwqbvEkkVvFyMMwXr1TYYa9ERPtT3HJ0FTNwkeizjoYcqRXuwDD6EmzXM9DFRi7Pf
        UfF1FP+2vr0Y+EDWnQPXojicgn2Cd/k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-1Hh4nPuLOzaQvekAJ7Nctw-1; Tue, 06 Apr 2021 09:48:24 -0400
X-MC-Unique: 1Hh4nPuLOzaQvekAJ7Nctw-1
Received: by mail-ej1-f72.google.com with SMTP id jx20so1940247ejc.4
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 06:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2RmbkeXOU9aY5FvEDwAnTFfcMebHKvlLbf8MXeM95+E=;
        b=LmmIvzHzDmHyR71s9vmGHobU8d+rtzwaduhdCI7p/SNJI0rWQyXykYlo7P2FlvNcZc
         G5VK25MaI9hM9AJjVZioYh7lnVkDXD2KITMZOe7m0Q7mPJx9wiz/S9Gx6ZsJ4GCBvS9N
         KgDgT+LwN9nNkcZFWdxWInw1aBXcmx8bo7//OTg63bFk0/chrQ2o68uXioWTxkB08CVR
         fM9838PfvdNVKBpg1Gew2900WfewrdNFtqKa9qjR7ZOJCddQwtRoRDI5LSiC7pNK3R/g
         kDjQ7ilFmQ0fiGkCGvclnVNt+DoDW9eojcm7AEj/izSxX0EpJPJZhR3WUk74PfZBuTSX
         YpLg==
X-Gm-Message-State: AOAM530OvXbmm0AsEiBB6B9hfQJikNY8y026oM5os6vqsIVHolAS/mtZ
        XYfzO3nywhsltn1HSb1RI0ZzY2oUZPC0BtkFUh+8pl+hRm2anx7NJk1URBOW+BKlRrBgoKO3bZ3
        GL+V6E3qjzS0K
X-Received: by 2002:a17:906:148a:: with SMTP id x10mr20569282ejc.92.1617716903332;
        Tue, 06 Apr 2021 06:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwodgB9kK5b4z87BtIiR33ibNjlyam8ylzMccz0Z+CJKdKbenfAf1nuSBw+a99c181oTWZWzA==
X-Received: by 2002:a17:906:148a:: with SMTP id x10mr20569256ejc.92.1617716903197;
        Tue, 06 Apr 2021 06:48:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v8sm13853900edc.30.2021.04.06.06.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 06:48:22 -0700 (PDT)
Subject: Re: [PATCH v11 00/13] Add AMD SEV guest live migration support
To:     Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <CAMkAt6oWF23YFiOGW_h+iyhjkaAp6uaMNjYKDXNxvNCWR=vyWw@mail.gmail.com>
 <CABayD+dDFMEBTzSxEax=wJLwg7-xQi2C5smPiOh=Ak6pi72ocw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00c9433e-99c9-4f7b-6944-4fb2136812d2@redhat.com>
Date:   Tue, 6 Apr 2021 15:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CABayD+dDFMEBTzSxEax=wJLwg7-xQi2C5smPiOh=Ak6pi72ocw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/21 20:27, Steve Rutherford wrote:
> On Mon, Apr 5, 2021 at 8:17 AM Peter Gonda <pgonda@google.com> wrote:
>>
>> Could this patch set include support for the SEND_CANCEL command?
>>
> That's separate from this patchset. I sent up an implementation last week.

And I was going to queue it today.

Paolo

