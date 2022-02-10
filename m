Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB8C4B0D07
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbiBJL66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:58:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiBJL65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:58:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E4D6260C
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 03:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644494337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i/yiXC42RApJ9PXUMkcbUc4Ysh889sJZTdjISpYC8eM=;
        b=R40Iz2wIbbWAbelFT5wzI+LGk8pTAZ0nrLXMkoDQJqBZydOjNgNLEnFctW2Jd6xupuV53U
        Ag7TJ+zhD1+C7NJZHFAgO/G4+ln6FW/wVbL50RBRTuThjnkZIYT5TwRJGGTcRI35LDUxWe
        rRhRRWtK8Q1BrRngJ46Sa7MO5zI1IIA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-NivGsz3gOBawXXM7ADTayQ-1; Thu, 10 Feb 2022 06:58:56 -0500
X-MC-Unique: NivGsz3gOBawXXM7ADTayQ-1
Received: by mail-ed1-f71.google.com with SMTP id q11-20020a5085cb000000b0040f7eceaf7aso3204165edh.14
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 03:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i/yiXC42RApJ9PXUMkcbUc4Ysh889sJZTdjISpYC8eM=;
        b=eCX08leJSuWm5fG73WK3t9F+d3zjxt4dxf49oavRVLHl0FyN5A8r8MWNy9Oqsu3n0o
         e8ueRlYbwWeWqmCsBlHTMKW3R3WCOkuszPQHvDHQymxlsUiZQA1+muADNodClCKuLzTH
         93kXtdbhI3qOjL5a+0Unjpn+dRCOXM44dRlsZNaC394YnCskAmeqFwXMAb+Yq9nuOQMf
         3e+NJUU2bLCb3FZPNA+8BM90AnwH/xjFvDKfpFR8hEo5o1cgTTd/dKZESnhCcSpmbkHp
         9aM5A3jnrv6yEeVkYIW4ZLPQEHp6IGIUzNdji78S/OHNZnDOMVEpHEX0Xn9rJwj7BVmz
         JqhA==
X-Gm-Message-State: AOAM5314j7UcNebI8WxKYMcGWyssreQ78RryQE1LS8JnAa7JL+TibaEa
        9IQ73Tr9QVg1tM/mocnjuZAC4NBRfLWww5moy/WHYAVQSqhuu3kSR9GIw+gO9hR8JypqJq+wVVb
        QQJnnLF5aAXcV
X-Received: by 2002:a17:906:7306:: with SMTP id di6mr6060040ejc.521.1644494334937;
        Thu, 10 Feb 2022 03:58:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX6Jij1AIQnLPu771ecj6g/uugHnqAyd8Uzh9Slumm8IcBh/Bd5oGSt0nl0iQus6cFqRyPxA==
X-Received: by 2002:a17:906:7306:: with SMTP id di6mr6060011ejc.521.1644494334635;
        Thu, 10 Feb 2022 03:58:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j20sm1489328ejo.27.2022.02.10.03.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 03:58:53 -0800 (PST)
Message-ID: <40930834-8f54-4701-d3ec-f8287bc1333f@redhat.com>
Date:   Thu, 10 Feb 2022 12:58:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <YgGmgMMR0dBmjW86@google.com> <YgGq31edopd6RMts@google.com>
 <CALzav=d05sMd=ARkV+GMf9SkxKcg9c9n5ttb274M2fZrP27PDA@mail.gmail.com>
 <YgRmXDn7b8GQ+VzX@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgRmXDn7b8GQ+VzX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 02:11, Sean Christopherson wrote:
> In a vacuum, I 100% agree that guest_role is better than cpu_role or vcpu_role,
> but the term "guest" has already been claimed for "L2" in far too many places.
> 
> While we're behind the bikeshed... the resulting:
> 
> 	union kvm_mmu_role cpu_role;
> 	union kvm_mmu_page_role mmu_role;
> 
> is a mess.  Again, I really like "mmu_role" in a vacuum, but juxtaposed with
> 	
> 	union kvm_mmu_role cpu_role;
> 
> it's super confusing, e.g. I expected
> 
> 	union kvm_mmu_role mmu_role;

What about

	union kvm_mmu_page_role root_role;
	union kvm_mmu_paging_mode cpu_mode;

?  I already have to remove ".base" from all accesses to mmu_role, so 
it's not much extra churn.

Paolo

