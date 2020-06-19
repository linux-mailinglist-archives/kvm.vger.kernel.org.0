Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3646201E7D
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 01:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgFSXHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 19:07:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25738 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729923AbgFSXHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 19:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592608073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GSUEEvPHg8lObb4w3f5YO1A3aV/mftn8qgOUKpTDcXY=;
        b=cAPD6/fSvoc25o8Ebdga7pDktT8Yllj7DyDYjvP29y2+5MSnqNPtG9zb9cCG/OTajWSt2s
        9g2gA277YLgEN93ixlDsgzFQv+AKXfEJztYXJUfuEi5Vu7nNPlZmz7vvmllk1gwganQ2Ct
        fbvEi+VQgYDlNw2AHcIcAvyrQknlqSI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-_blxFh2cOAWzHyic9mDWvw-1; Fri, 19 Jun 2020 19:07:51 -0400
X-MC-Unique: _blxFh2cOAWzHyic9mDWvw-1
Received: by mail-wm1-f72.google.com with SMTP id s134so1155538wme.6
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 16:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GSUEEvPHg8lObb4w3f5YO1A3aV/mftn8qgOUKpTDcXY=;
        b=BSfONiJfe9dzs8ATjapBPcMZxL7ZDrB3waeLy95SIWwtDopboIbDHOk8FZiCLDZmLf
         4HkQWx56TvkVIawADRxoHN2rSLdHdH+wt4yN1bOOKjP5LnxtNnOi39ySjYLCZnRZPjL9
         D+39/LnXu+XEY9i+I4RzupxtgWziTmcvUgJsg9Nu+M/Q2lupWlzxysc8SP6d0LblxyuD
         u9/SG5KW+Ox1ykV3VKG8Cu2Dhsl9m22iitn+L4/nLyUg+HExVJsSZIbJ2iNNKh3a5bmT
         cilmNJyrigDT+/F0tuXT/oqZ0WHXgWT7DXAGJAhv+7Q5KOW1N3JZ9JYqtgQCCl7LrVCP
         cJOA==
X-Gm-Message-State: AOAM5326l5HfQzYh3I0yHlUJJl6hpz+rn4JWSO89FzZGa5/I8iS+vXvJ
        62KBYIOTLiRE5RSNECRZ/6bWF+iZ249RFdKlBQcPISKcdb3unnRzgFU49hEk0p3ZuDI3qklEwRC
        2r+qack6E9NRI
X-Received: by 2002:a1c:544d:: with SMTP id p13mr6302403wmi.25.1592608070501;
        Fri, 19 Jun 2020 16:07:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu/JztVAYCCE55vZNqDpvaVxdrydq0oPQaM9B94p/nNj1BvYm/PY+IP5k5u5Z3b+ipgQzpGA==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr6302365wmi.25.1592608070215;
        Fri, 19 Jun 2020 16:07:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id m65sm7644751wmf.17.2020.06.19.16.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 16:07:49 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
Date:   Sat, 20 Jun 2020 01:07:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 23:52, Tom Lendacky wrote:
>> A more subtle issue is when the host MAXPHYADDR is larger than that
>> of the guest. Page faults caused by reserved bits on the guest won't
>> cause an EPT violation/NPF and hence we also check guest MAXPHYADDR
>> and add PFERR_RSVD_MASK error code to the page fault if needed.
>
> I'm probably missing something here, but I'm confused by this
> statement. Is this for a case where a page has been marked not
> present and the guest has also set what it believes are reserved
> bits? Then when the page is accessed, the guest sees a page fault
> without the error code for reserved bits?

No, for non-present page there is no issue because there are no reserved
bits in that case.  If the page is present and no reserved bits are set
according to the host, however, there are two cases to consider:

- if the page is not accessible to the guest according to the
permissions in the page table, it will cause a #PF.  We need to trap it
and change the error code into P|RSVD if the guest physical address has
any guest-reserved bits.

- if the page is accessible to the guest according to the permissions in
the page table, it will cause a #NPF.  Again, we need to trap it, check
the guest physical address and inject a P|RSVD #PF if the guest physical
address has any guest-reserved bits.

The AMD specific issue happens in the second case.  By the time the NPF
vmexit occurs, the accessed and/or dirty bits have been set and this
should not have happened before the RSVD page fault that we want to
inject.  On Intel processors, instead, EPT violations trigger before
accessed and dirty bits are set.  I cannot find an explicit mention of
the intended behavior in either the
Intel SDM or the AMD APM.

Paolo

