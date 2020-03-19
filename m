Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448ED18BC5C
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgCSQY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:24:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32779 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbgCSQY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 12:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584635097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6aiYGJqqYB7OtONFqTHz/q1w4j91YXMiUtw0onvEckc=;
        b=iicMPz6uPKVvN4aVC+3nvpMmLtFg0F1ZnNJOvvcsLqN6Wh8hjCae+ninXQCR6hlAG4f/nI
        ia2MUJ4vtxw+BQ+nYHcss8mtAq4bbWN/GvXgMDXdCrZXXmHEMKNhPuayVQ7K9ByRBKMMkI
        oMm7xFa83dJwM5ixYwsdlzwkhvMInwE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-N7PJlBltPzmMpX_Ewe1Bbw-1; Thu, 19 Mar 2020 12:24:55 -0400
X-MC-Unique: N7PJlBltPzmMpX_Ewe1Bbw-1
Received: by mail-wr1-f72.google.com with SMTP id v6so1237874wrg.22
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 09:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6aiYGJqqYB7OtONFqTHz/q1w4j91YXMiUtw0onvEckc=;
        b=Io8KqUT8RWDIWv3iHfJrXqXZWpQ8g2FCcyIxp6abnDHDd+1mskxr6tVs6iN1MkHdSD
         CQbcbj/tSKgC8Um8q4aSOBhS9F04OW7dWKnHVzfnnxJozX1ktTUQqhwJQgsv3Sjmi94I
         eTQ5ICwjfyADWeZmXSW59YwjVUpHM+ZRjCn1tsVl1/HB69P2IghCNhQjZf/BzqZldTsb
         m435uJOrCxqZeWit7W9aEelGIGwf6okI+kfxf5arTuWfMXbzcyQESaN7K547rVME/isZ
         wlKD/un5jIVh/xZkja9nlHZJtxvGHyjFjf/isR6HubjcEpkzkz3I/7h5boqweH3gmpmQ
         oBfw==
X-Gm-Message-State: ANhLgQ1WQ4dRpR82qG6Nq4zMoc6UufVowxiE6yOd1RMmINQz43fgcU15
        G8eJKaauUG5Xt28KJu8/j6fbkDWf/GrpQcGVdEJEFwM3ja9Z0bfn3fejnVrlRYqzRtmOQgwjrOW
        KOAvRScyGWGvk
X-Received: by 2002:a5d:6908:: with SMTP id t8mr5390434wru.92.1584635093308;
        Thu, 19 Mar 2020 09:24:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtpBLc0nNDpfhkz/RUZ3FdCM6IUwSnyDZFcyfbsP0oZyHeZZFgMBwi09mfhvTHafLFEzBbiIQ==
X-Received: by 2002:a5d:6908:: with SMTP id t8mr5390399wru.92.1584635093053;
        Thu, 19 Mar 2020 09:24:53 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id m10sm3724369wmc.24.2020.03.19.09.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 09:24:52 -0700 (PDT)
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
 <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
 <20200217194959.GA14833@ashkalra_ubuntu_server>
 <101d137c-724a-2b79-f865-e7af8135ca86@redhat.com>
 <20200319161831.GA10038@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bffda827-2d9c-a6ae-f811-c6941fe03530@redhat.com>
Date:   Thu, 19 Mar 2020 17:24:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200319161831.GA10038@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/20 17:18, Ashish Kalra wrote:
>>> For the second case, we have been discussing this internally,
>>> and one option is to extend the KVM capabilites/feature bits to check for this ?
>> You could extend the hypercall to completely block live migration (e.g.
>> a0=a1=~0, a2=0 to unblock or 1 to block).  The KVM_GET_PAGE_ENC_BITMAP
>> ioctl can also return the blocked/unblocked state.
>>
> Currently i have added a new KVM para feature
> "KVM_FEATURE_SEV_LIVE_MIGRATION" to indicate host support for the SEV
> live migration feature and a custom KVM MSR "MSR_KVM_SEV_LIVE_MIG_EN"
> for the guest to enable SEV live migration. The MSR also has other
> flags for future SEV live migration extensions.

Ok, that would be fine too.  Thanks!

Paolo

