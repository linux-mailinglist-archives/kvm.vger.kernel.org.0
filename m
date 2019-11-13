Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A801FB7AC
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 19:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfKMSdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 13:33:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44690 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726564AbfKMSdl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 13:33:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573670020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YViUuCyqAWYmlgZIZCpAbQbISPMVKXMOPDNBVlmFZCk=;
        b=IMqN99JgqsIna7J06FmTREhEYvGtxDrL3OCJ6YQKpLro9NtDWRk2+QJOlYOlXnpED8KAmQ
        WaklC69t+x3lOdk+twrZ8/vqImbKple/eBBx1DtonYY+PHKLH5Y5tMNlijmeWMu8dbqMtD
        ucCIVU5QwJq4xX5Pi0EeSUzyCjOPB9Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-HzzF6JoUO7CZIpf0tdULUA-1; Wed, 13 Nov 2019 13:33:39 -0500
Received: by mail-wr1-f71.google.com with SMTP id e3so2141323wrs.17
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 10:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lVOhJPf9GSOQQjGFFHeta0KGsKrjystXekCjo1ib0Wk=;
        b=l0HNbi8tKKCH7WfOnK+no/SNZV0orjU0beLAxPF8Nwv/QKZEnDO7oKzIC5Ev25CLjE
         Dwq8zLBTt1birVauETxjw/hJlhjk7l2zh2uP90LiLBIkSKOfaGZCvZJllPv/1QlWWxA+
         TnZ6QKv4WgyJO+4NUnW2HiSnySvZsRu9utKk6cD41ED2XMpxzNibFyd1WUGeVxuSAduT
         Teu3dxKS24tfQoedjySCQtOhYtFZRAZqICz51XnkFz2D4mHaR9pMdtnYvy2XPeCDubFT
         AOggpzkdUCzpzcIfB1P2hgvXOP3m6SQebBOQNwbOZ41fM6QsicMv/aXW9kp1HiikrreR
         fYfw==
X-Gm-Message-State: APjAAAVhtE3v/NplkvQ9B4BOT6r6AE/MGVAKZispe76pOyfBrs2noHPt
        jziBGrKf/rnMfq2L2Yvdamp1b4wBqHpbHH+L3Cbm1SkYPC+2W/cAbibVvGDU5780JGlPHZ5MbTy
        50WCG2FLhTm6X
X-Received: by 2002:a1c:80c7:: with SMTP id b190mr4204120wmd.3.1573670018335;
        Wed, 13 Nov 2019 10:33:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyR1i+Ci0i2jOPtXGGJwsiqFYOI8TIbUFgzvoVt4nRS/4fN52m1rHKQTdCnvLVUlotn56DbGA==
X-Received: by 2002:a1c:80c7:: with SMTP id b190mr4204095wmd.3.1573670018016;
        Wed, 13 Nov 2019 10:33:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id 200sm3781427wme.32.2019.11.13.10.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 10:33:37 -0800 (PST)
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <DEF550EE-F476-48FB-A226-66D34503CF70@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fa4a67e8-50db-a42a-3186-072327ea538a@redhat.com>
Date:   Wed, 13 Nov 2019 19:33:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <DEF550EE-F476-48FB-A226-66D34503CF70@gmail.com>
Content-Language: en-US
X-MC-Unique: HzzF6JoUO7CZIpf0tdULUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 19:10, Nadav Amit wrote:
>=20
>> On Nov 12, 2019, at 1:21 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> CVE-2018-12207 is a microarchitectural implementation issue
>> that could allow an unprivileged local attacker to cause system wide
>> denial-of-service condition.
>>
>> Privileged software may change the page size (ex. 4KB, 2MB, 1GB) in the
>> paging structures, without following such paging structure changes with
>> invalidation of the TLB entries corresponding to the changed pages. In
>> this case, the attacker could invoke instruction fetch, which will resul=
t
>> in the processor hitting multiple TLB entries, reporting a machine check
>> error exception, and ultimately hanging the system.
>>
>> The attached patches mitigate the vulnerability by making huge pages
>> non-executable. The processor will not be able to execute an instruction
>> residing in a large page (ie. 2MB, 1GB, etc.) without causing a trap int=
o
>> the host kernel/hypervisor; KVM will then break the large page into 4KB
>> pages and gives executable permission to 4KB pages.
>=20
> It sounds that this mitigation will trigger the =E2=80=9Cpage fracturing=
=E2=80=9D problem
> I once encountered [1], causing frequent full TLB flushes when invlpg
> runs. I wonder if VMs would benefit in performance from changing
> /sys/kernel/debug/x86/tlb_single_page_flush_ceiling to zero.
>=20
> On a different note - I am not sure I fully understand the exact scenario=
.
> Any chance of getting a kvm-unit-test for this case?

No, for now I only have a test that causes lots of 2 MiB pages to be
shattered to 4 KiB.  But I wanted to get and post a test case in the
next week.

Paolo

> [1] https://patchwork.kernel.org/patch/9099311/
>=20

