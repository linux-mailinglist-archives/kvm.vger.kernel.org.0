Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEECE1DE110
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgEVHdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:33:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36991 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728344AbgEVHdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590132803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6EtbHbZKdks/ocBUdzOilBq6OTiCmy87fOc1ctWzSB8=;
        b=AjbbE9dKJ732ksfBT389+V3QpDQ51xBQGbn3xzVqmcmQ2BHNAV/MbKXe0p+LFtlPHMtCdM
        IBN8rer1MOXlD1mv1mVT3c7BCs9xT36/YQOWeKhzj023VvoO2gfDiuAkvGc4VlUeyUFnlo
        WqHSdZtsSBesLSu43yzQEzfe4OFMUYk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-DyIBQAV0Nl6rmpFcp63UNQ-1; Fri, 22 May 2020 03:33:21 -0400
X-MC-Unique: DyIBQAV0Nl6rmpFcp63UNQ-1
Received: by mail-wr1-f70.google.com with SMTP id h6so3173387wrx.4
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 00:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6EtbHbZKdks/ocBUdzOilBq6OTiCmy87fOc1ctWzSB8=;
        b=EE9FJ+Ag8Wk3zq8XUKFN7oN1EoOoEjjZYTnpmNf2eg9lTych3cdtTmRD4p/qQyfWTv
         H0GsvizdK7VtiF517YmXhUDgf0EnoO/6NcTi3eOLo6wEEVzjJsOwdwKezHBnY1y5YlHJ
         7HgCqeamR1VPFTp9e5Rg57LP2I2rAFS53mDnA/KxMwkNTe4cS1fUdlI3XKe8uRdLVCc+
         PvL1L578yB+bCCB0xhJBHOrurd6IipHSa/PldhBXiZWwDf0zDlf0zmVxRGM2+0CjEf9X
         1eRE8rO77NQ6Sxm1+/C7anEUFEBItqE6l+NUQSyIRw0rh0tt1gU4SvoqKLFmFLu4YDHZ
         CP2Q==
X-Gm-Message-State: AOAM530p40tokkXIQp7RxPGk0VcxHk9igJP31SuANKuFyFY+nMVnOaSp
        9QUo3Ew6SQvOFucRSLoye0ZzYuFVJZs30rLU3n59WBtDa5fxV1EH9ODIBSPfpCtx6hQHAj927vF
        vEosqcjjDK21Z
X-Received: by 2002:adf:82c3:: with SMTP id 61mr2352146wrc.326.1590132800741;
        Fri, 22 May 2020 00:33:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHE+96FYxJjwlkKncGlD0w505R5oIT+cQodzUqCD8Ml+XOl1XFdP5KV9lsIxGty7UQKdEwtQ==
X-Received: by 2002:adf:82c3:: with SMTP id 61mr2352119wrc.326.1590132800484;
        Fri, 22 May 2020 00:33:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:71e6:9616:7fe3:7a17? ([2001:b07:6468:f312:71e6:9616:7fe3:7a17])
        by smtp.gmail.com with ESMTPSA id l13sm8583790wrm.55.2020.05.22.00.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 00:33:19 -0700 (PDT)
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com> <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com> <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
 <20200515204341.GF17572@linux.intel.com>
 <943cfc2f-5b18-e00a-f5a2-4577472a1ff5@redhat.com>
 <87y2plqqpa.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e79fe0d3-0a73-ed84-7021-150d03a80f93@redhat.com>
Date:   Fri, 22 May 2020 09:33:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87y2plqqpa.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 16:59, Vitaly Kuznetsov wrote:
>> However, interrupts for 'page ready' do have a bunch of advantages (more
>> control on what can be preempted by the notification, a saner check for
>> new page faults which is effectively a bug fix) so it makes sense to get
>> them in more quickly (probably 5.9 at this point due to the massive
>> cleanups that are being done around interrupt vectors).
>>
> Actually, I have almost no feedback to address in v2 :-) Almost all
> discussion are happening around #VE. Don't mean to rush or anything but
> if the 'cleanups' are finalized I can hopefully rebase and retest very
> quickly as it's only the KVM guest part which intersects with them, the
> rest should be KVM-only. But 5.9 is good too)

Yeah, going for 5.9 would only be due to the conflicts.  Do send v2
anyway now, so that we can use a merge commit to convert the interrupt
vector to the 5.8 style.

Paolo

