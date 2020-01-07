Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7583132F43
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 20:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgAGTTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 14:19:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40607 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 14:19:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so322752pgt.7
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 11:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TU5y0uOd04v29R1ldy4aCdHRn60AIShQAfhIrYqvct4=;
        b=KuhBgkhmzY+be0c7oA/ma8hxZhuoHjFirs176QvXXz/8TxiRr6YQ8GknYwFMLw1MtL
         G5mycKgbz64sOLtaaTynzyLMeFAlctWwoDdtIulNgI4aCVpmcAoiQHuYr8f0bWNv+jqv
         HMu/z7+GvtaFoAMV6thwF4A7WTUJ9Rh4KO08NaZEOaHv52TRRWsWMRLudoMK6W0PHaJx
         OIPAG5RU+91Q4CX0/TyPnG7ydKx5ImuveytiD5wUcjBK9KGUXWJ4XHpEaDPSpM9CljDW
         OiMqRWyN7ID3K0FkcOD4TS+Ieou2h7qp9XyN6u4X/M1xbFRYfk3/iyRYvjiQYb5MpBaN
         fy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TU5y0uOd04v29R1ldy4aCdHRn60AIShQAfhIrYqvct4=;
        b=L1wIFkeTjTAZcWiKoUjMC5QPgCpHgRoxo63RwKVeSRj2quMBaX+v98UrT23SoU2FrH
         Dhqb0cPatiaidpmIyDGcyHV/GxciZetNB3adYuN1NetwgD1c07XAQSajeGZ8e84sy8eQ
         sj8Ncm8NcVMm1kIcud934KGi1L6UO9X4xMlfv7wDiCtIjVBPDZ5siW24353uTUCBMopW
         GrTgXY4pAWRECJ31wP/1hURJiqhWLsEWJZdeI9AMzYpnoxlhiBmcAWqczfNaj823b9bA
         jJv4V3rcBafi+P1fRquf1RUsrX2bpHjLPt+HeNsz8K3jiwheg3gmZg1XQFWDXYYevLqg
         1giQ==
X-Gm-Message-State: APjAAAXwN/j6n9CTOcRCihg1ShppDa/uRflfmxnOYVQXQlz4mQ/JUnPU
        MkzJd8jRTEfqEa6r93JKAoS4RA==
X-Google-Smtp-Source: APXvYqz3hHvhtKQxlmnApv3yxgqZQM3teHJBcT4UloZ5gm4T7Df1KmGi/QM9c96hmThP+tfqKucIyA==
X-Received: by 2002:a62:f94d:: with SMTP id g13mr825176pfm.60.1578424749010;
        Tue, 07 Jan 2020 11:19:09 -0800 (PST)
Received: from gnomeregan01.cam.corp.google.com ([2620:15c:6:14:50b7:ffca:29c4:6488])
        by smtp.googlemail.com with ESMTPSA id i2sm485165pgi.94.2020.01.07.11.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 11:19:08 -0800 (PST)
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
 <e012696f-f13e-5af1-2b14-084607d69bfa@google.com>
 <20200107190522.GA16987@linux.intel.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <08a36944-ad5a-ca49-99b3-d3908ce0658b@google.com>
Date:   Tue, 7 Jan 2020 14:19:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107190522.GA16987@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi -

On 1/7/20 2:05 PM, Sean Christopherson wrote:
> On Mon, Dec 16, 2019 at 11:05:26AM -0500, Barret Rhoden wrote:
>> On 12/13/19 12:19 PM, Sean Christopherson wrote:
>>> Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
>>> unlikely THP itself will support 1GB pages any time soon, but having the
>>> logic there wouldn't hurt anything.
>>>
>>
>> Cool.  This was my main concern - I didn't want to break THP.
>>
>> I'll rework the series based on all of your comments.
> 
> Hopefully you haven't put too much effort into the rework, because I want
> to commandeer the proposed changes and use them as the basis for a more
> aggressive overhaul of KVM's hugepage handling.  Ironically, there's a bug
> in KVM's THP handling that I _think_ can be avoided by using the DAX
> approach of walking the host PTEs.
> 
> I'm in the process of testing, hopefully I'll get a series sent out later
> today.  If not, I should at least be able to provide an update.

Nice timing.  I was just about to get back to this, so I haven't put any 
time in yet.  =)

Please CC me, and I'll try your patches out on my end.

Thanks,

Barret



