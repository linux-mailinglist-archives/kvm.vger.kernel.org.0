Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA43671F40
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjARORo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjARORY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:17:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF4C49948
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674050235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Car+8VfBF19EiXiyQTE5lMeyb0q46IdI4jy+cnvVts=;
        b=dmnFt+0/TB485HbU5sDCzlFctho/dlDckslX1PGhSDLYZioUMyuz1wFvn7KWkSuZwTG3kF
        E5C0RL8OY+UA7W9u28f2ozKumM03iv27DYULO+FqJ53+n8W6EMYkLGqIQAy3LyW3xe7TLu
        G1+nakFIA+paRaEjvoV2Maajr4CJB8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-Kew91hy1Mg21BF1tCDx-Kw-1; Wed, 18 Jan 2023 08:57:14 -0500
X-MC-Unique: Kew91hy1Mg21BF1tCDx-Kw-1
Received: by mail-wm1-f69.google.com with SMTP id z22-20020a05600c0a1600b003db00dc4b69so1246167wmp.5
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:57:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Car+8VfBF19EiXiyQTE5lMeyb0q46IdI4jy+cnvVts=;
        b=FShaw+BdHASeygQsxrkxqDdXrOYdqxMvgbk7Qv5yUQgj/7FggOnEc5IMM8os8rMENA
         uhcjP4zC0FTDUULCTbVnUHglF/MOmPD6OYtK7YEsxhvO2oGLeFX0/4Or6zvgDMBZlrwf
         oKs2k4HDsRudxMZ7j77vHHTcWhT4aSnjQ1hnOcDvkTz5tfnv3IU2nCpWUzViU/22/e7E
         V5DeKgAmS5z2HCPF/RcsxZRrYpn1fU4jbzReO93JWoVVJHWqdR8a95enCBQSlYJuB28c
         ThrMTzeK1o5PCWJKlOcIVlVVHy0a6M8FSg12x/Zz1aLLkzLcLepVKDLXKjFNMxpfhBQV
         lY3A==
X-Gm-Message-State: AFqh2kqnGg2tcJApjB2labvAEZRjipA27Zca0QwzkhhgTjLTMkRDcIKo
        QuPzfqyOmnZhoXQIvw6DItelGYMicwYUj6+rlVZscRHcimc8uRYLihlDdvYWQEe2ZgTWjQvZv15
        8b5uVvHksHK8f
X-Received: by 2002:adf:f791:0:b0:29d:f817:42c1 with SMTP id q17-20020adff791000000b0029df81742c1mr6522122wrp.54.1674050233100;
        Wed, 18 Jan 2023 05:57:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4E20dcs+xcKeqkBQk0O5xMtmy881BRbTEvOX6Aeo0C7+epFLMA6tj0bvSXJkQL2rDMRA62g==
X-Received: by 2002:adf:f791:0:b0:29d:f817:42c1 with SMTP id q17-20020adff791000000b0029df81742c1mr6522112wrp.54.1674050232835;
        Wed, 18 Jan 2023 05:57:12 -0800 (PST)
Received: from ?IPV6:2003:cb:c705:800:1a88:f98a:d223:c454? (p200300cbc70508001a88f98ad223c454.dip0.t-ipconnect.de. [2003:cb:c705:800:1a88:f98a:d223:c454])
        by smtp.gmail.com with ESMTPSA id b11-20020a05600018ab00b002be2279f100sm5088437wri.96.2023.01.18.05.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 05:57:12 -0800 (PST)
Message-ID: <312d9d5d-0a40-1336-7bb5-728243dd16a9@redhat.com>
Date:   Wed, 18 Jan 2023 14:57:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
 <7cdc03500a6affccac189164636427b348af2811.camel@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <7cdc03500a6affccac189164636427b348af2811.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.01.23 12:08, Huang, Kai wrote:
> +Dave, Oscar and Andrew.
> 
> Hi Memory hotplug maintainers,
> 
> Sorry to CC, but could you help to review this Intel TDX (Trusted Domain
> Extensions) patch, since it is related to memory hotplug (not modifying any
> common memory hotplug directly, though)?  Dave suggested it's better to get
> memory hotplug guys to help to review sooner than later.
> 
> This whole series already has linux-mm@kvack.org in the CC list.  Thanks for
> your time.

Hi,

I remember discussing that part (notifier) already and it looked good to 
me. No objection from my side.

-- 
Thanks,

David / dhildenb

