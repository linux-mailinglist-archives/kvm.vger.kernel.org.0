Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF73DFFA7
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 12:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbhHDKxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 06:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237591AbhHDKxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 06:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628074398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6KanqtDGf5yMoMf0Yr0/h3HuP/VnRTg0lfzUasPTQcw=;
        b=WLvQbrGvTBqJEUa0DNugxk8ZOr5UV+AWdT6oRCssoXGvljH+ju1b5buX8D8IPKGi+4lW+Y
        KjUJvaanKRtyjiD0gEFjXjKB8aogNe4G/oBFK5zhQq9Po64JctP/FH37UE0edVi73UXNSF
        vf7tSu26nREI/lz2RZ6geRqJpeYs6oM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-o8K8Br5lOX2Vtr59gI2BiA-1; Wed, 04 Aug 2021 06:53:17 -0400
X-MC-Unique: o8K8Br5lOX2Vtr59gI2BiA-1
Received: by mail-wm1-f72.google.com with SMTP id 21-20020a05600c0255b02902571fa93802so1550432wmj.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 03:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6KanqtDGf5yMoMf0Yr0/h3HuP/VnRTg0lfzUasPTQcw=;
        b=a19uh+ehlPlny7Qtjo2bxucYpFN/t3y/rNS/pNX0WVvhALr86f2LTid1Y2VutQq282
         XJ9IHyTM8KVF3wSZMnOsaOJgpSs1v8P49BKTRFTIcg+YWgjYJqK8Pig827f1VljLbpEp
         d/aFHtLspd3rD8vQVq5q0m6NbcMrxGWlq2MiK/TPoGjNTpmuFFxkhqWfaemvNL7WQEoH
         Tmv2LF4y+MXvw7dHVLVY9cfqJmc/EGnHsUuiwbpxjEp5NSw/axrlUoNQvpXNzYIpTo7p
         MKjLGO/YR1wXoCssKfuo3sfMzbrz6F0lWKYzUlrnvoH0EdM90Tt7A22eVyuAXpVKGRqi
         pyfw==
X-Gm-Message-State: AOAM530XMjz8FoibL8TQCMs8CbmlZMGpTULI5bXDqQevEsdTnX6mLudW
        Ra/xGRU+oPGGWC4PpqDYGq+rWYPjyRh6a629gnW5ZE+dO6m+Inyhpp00KLfoDiSn0eqqIRpatnd
        ziavpZ+6h7c8r
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr9309316wmg.46.1628074395308;
        Wed, 04 Aug 2021 03:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjtjf0U1T/UySuCXKrvBA+Akcv6vU4ZionNIPodF9VTA/UUHbVay0Z2xl6itwUausCAMPYaw==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr9309296wmg.46.1628074395109;
        Wed, 04 Aug 2021 03:53:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id h16sm2114466wre.52.2021.08.04.03.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 03:53:14 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: improve the code readability for ASID
 management
To:     Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210802180903.159381-1-mizhang@google.com>
 <YQlz4YDu/W8+YsZl@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3226fb50-94c3-49d2-de9a-d4fea81b5b0a@redhat.com>
Date:   Wed, 4 Aug 2021 12:53:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQlz4YDu/W8+YsZl@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/21 18:50, Sean Christopherson wrote:
> This patch missed sev_asid_free().
> 
> And on a very related topic, I'm pretty sure the VMCB+ASID invalidation logic
> indexes sev_vmcbs incorrectly.  pre_sev_run() indexes sev_vmcbs by the ASID,
> whereas sev_asid_free() indexes by ASID-1, i.e. on free KVM nullifies the wrong
> sev_vmcb entry.  sev_cpu_init() allocates for max_sev_asid+1, so indexing by
> ASID appears to be the intended behavior.  That code is also a good candidate for
> conversion to nr_asids in this patch.

It's also missing this (off by one for SEV guests, pointless extra work for
SEV-ES):

index da5b9515a47b..7fbce342eec4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -147,7 +147,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
  	min_asid = sev->es_active ? 1 : min_sev_asid;
  	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
  again:
-	asid = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
+	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
  	if (asid > max_asid) {
  		if (retry && __sev_recycle_asids(min_asid, max_asid)) {
  			retry = false;


Queued both Mingwei's patch and yours, thanks (to 5.14-rc in order to avoid conflicts).

Paolo

