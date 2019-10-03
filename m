Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31095CA15D
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfJCPuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 11:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfJCPuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 11:50:54 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8BB9368FF
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 15:50:53 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id k184so1305019wmk.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 08:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dk0aNdQXz53G0n9Tb1zT+SP0bhczdeQIv0e4Y/L1PB4=;
        b=ecpKjNmPzq6xACrCZA5r8fRRQ/pGPBb8fdKOx1/OtfSaBrNpvYpWKgLhVcTOshiPw8
         Az1yUYGR6ZvfNl57AQdJwj+f2JDMZp3LsGWz4rWZWAz2A1c7KEI7N4m/RB+KTh+Q/MeD
         SM2bp6sZwXsFlRX8uLOgx8Cdk5CJ1A5kqsdLGMKvvgvtjC4aPUZ2Wuv0mWtWYZEr04yN
         ZYOBQoFiu4OpILKqpaGUxL6hiWwxleatBgwR7engHUeg1mZwIGslOkvVfJw3zhsS8iJL
         tBJ+HQ/suQud0DMQ3T/ABI1rZDCKRUbIkqmfpdoXTDovgDqbm8S5QyrJ0C7M7sFWKiYG
         CU9g==
X-Gm-Message-State: APjAAAVBc/IRwJ1SYQy4HPBizD12to8xI1yP5jKpojbdvRlhjFaYZUZP
        IkAzV3qAonJ2UIJRUuHFpRh3m5xBsS8ZIjzkPHTB2dd+9rHIz9z2RkOo4PjZ4EeN4vJ5PPBFmEa
        tpDQJtyz2bUW4
X-Received: by 2002:a05:600c:1103:: with SMTP id b3mr7656888wma.3.1570117852381;
        Thu, 03 Oct 2019 08:50:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyyTTq1KRj0SEdnWQ7WCYfTtrUQZd+OAAW9EGTeyhKb1SxWiUABbHcl0VEgD9om8ZETiNdbGA==
X-Received: by 2002:a05:600c:1103:: with SMTP id b3mr7656870wma.3.1570117852120;
        Thu, 03 Oct 2019 08:50:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id f13sm3749326wmj.17.2019.10.03.08.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:50:51 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
 <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
 <20191003154233.GA4421@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
Date:   Thu, 3 Oct 2019 17:50:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154233.GA4421@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 17:42, Jerome Glisse wrote:
> All that is needed is to make sure that vm_normal_page() will see those
> pte (inside the process that is mirroring the other process) as special
> which is the case either because insert_pfn() mark the pte as special or
> the kvm device driver which control the vm_operation struct set a
> find_special_page() callback that always return NULL, or the vma has
> either VM_PFNMAP or VM_MIXEDMAP set (which is the case with insert_pfn).
> 
> So you can keep the existing kvm code unmodified.

Great, thanks.  And KVM is already able to handle VM_PFNMAP/VM_MIXEDMAP,
so that should work.

Paolo
