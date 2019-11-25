Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5AB108E13
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 13:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfKYMho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 07:37:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727194AbfKYMhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 07:37:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574685462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=lpzbkQ3i1d0GuVy4yh5saM/LJxonFfXBJE0iTKqBGXg=;
        b=IG933hyIfdQdnX/f5PdQo248fMS7H82y5VUr3pDTh3esU7uaXPuKzYZLbs7/DmGPmBYcK2
        yzrlQ1lU4DM/HAf4dElnT1RbDlwQFrvnHZmXAzUHBGVGCOb+am7Q/CwDBRA6h/SFbDCWOm
        lk6J+Il8KgBiqI2RK/rnmpagj78SzJM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-6_gZ2yjIMBC_8k0Vcmg4EA-1; Mon, 25 Nov 2019 07:37:41 -0500
Received: by mail-wr1-f71.google.com with SMTP id z10so8771869wrr.5
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 04:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4GPngNhpXwxQp8IbDin9g/AOQ0Xg3tlEruKrqGu/Ho=;
        b=T9i+W362bvIn6JhHMyyrZfuFSe/R+hqpD38yYQFoRzVbivGuhlvvaF89NTm2cHDR+Y
         bXhk+eBB4/09sAn74YuVI59t+wf7B+H4O19iWphVk57+s0Ny9ppqlrpYT+yjE0s2D2NN
         b3VIKjd1skqW+WM8FwMbLEmDnb+WMMhUTu3sOMP04/Fkc3/eYNKhUYhfu6sMqCbsMK99
         oamqqGwDTdtcd2vCudTV3YKT+1kGyIzuCEt//VOrRlcSB0LVxy4DVobM9HLWxNaPk1Y1
         AdokoWv1Gq0P8L0xgRE7MRTJsdPvYRJexA4UkiYcNGhlZ4HwVHKm3l0YEJ8GyHjO4Vbt
         bzcA==
X-Gm-Message-State: APjAAAUDRQWep9YVNQ29Nms8amASDnYr3gOL9CHU4a+LLlLuHz0FnKOb
        4KMWil/qkcCzF74j96A2VgQSXDDS/cCJerA9s6rlEH3Ds3el4CSfltJ7ofJqdld1kGZZsC3RA+H
        CCxmAQNdBskIF
X-Received: by 2002:a05:6000:103:: with SMTP id o3mr33411605wrx.80.1574685459824;
        Mon, 25 Nov 2019 04:37:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLgqh/0zfq+akrX99Er2Qdl9YBHqD7kFPiGY0DtDEGWff0/FakB+oikEsHfqh07QGQlYhkCQ==
X-Received: by 2002:a05:6000:103:: with SMTP id o3mr33411582wrx.80.1574685459537;
        Mon, 25 Nov 2019 04:37:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id z11sm11604272wrg.0.2019.11.25.04.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 04:37:38 -0800 (PST)
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
To:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
References: <20191122234355.174998-1-jmattson@google.com>
 <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
 <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fd0033a2-6fd8-ff02-64b8-9c6e30a99e65@redhat.com>
Date:   Mon, 25 Nov 2019 13:37:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 6_gZ2yjIMBC_8k0Vcmg4EA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/11/19 01:22, Jim Mattson wrote:
>> I suggest to also add a comment in code to clarify why we allow setting
>> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX even though we expose a
>> vCPU that doesn=E2=80=99t support Intel TXT.
>> (I think the compatibility to existing workloads that sets this
>> blindly on boot is a legit reason. Just recommend documenting it.)
>>
>> In addition, if the nested hypervisor which relies on this is
>> public, please also mention it in commit message for reference.
>
> It's not an L1 hypervisor that's the problem. It's Google's L0
> hypervisor. We've been incorrectly reporting IA32_FEATURE_CONTROL as 7
> to nested guests for years, and now we have thousands of running VMs
> with the bogus value. I've thought about just changing it to 5 on the
> fly (on real hardware, one could almost blame it on SMM, but the MSR
> is *locked*, after all).

Queued, thanks.

Paolo

