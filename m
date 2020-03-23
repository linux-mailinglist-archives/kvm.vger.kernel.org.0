Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC55C190250
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 00:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCWX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 19:56:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42815 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgCWX4j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 19:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585007798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLT9PP21JpSVg8g9Ca0QcaUFbJS8dx+sxPNM6+3EIvA=;
        b=EwWFwfg2uxzXYF0Rv46gQmUstqeoXVU0aKIS7Al+ui1+MffDiNSuvqVTPnR1pKgIVjG0sT
        R1bB8yJJdHpnR7bRFGHamG8j4yTG4jD3JfPDwRB5Lo1YL3WIlAlEbWE6bkKI9jvR7lo4SN
        w1CPlrOhO4LEJAhi08KASx4mhBddWok=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-uCI97mkkPJqdSRKhNMzrHw-1; Mon, 23 Mar 2020 19:56:36 -0400
X-MC-Unique: uCI97mkkPJqdSRKhNMzrHw-1
Received: by mail-wr1-f71.google.com with SMTP id l17so7907337wro.3
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 16:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLT9PP21JpSVg8g9Ca0QcaUFbJS8dx+sxPNM6+3EIvA=;
        b=jM0cb0vr5ek2np0VxVSBxmCNizAPCZ3hxbG+KqifwFGokBX4CfsV+Mcf2iIiYWkjpf
         hAOpVzugqNx5yGnZGdHMRjKiSktmnwUD5BlKWu0amGCoblgcQz0WdojpUKwX8A/31kNi
         MO7AjU934ztKhSP6HXyDYh61DX/D9U0sYW0C95EhdTfK5oYFfQ9f+yB0IqsIS8I88POd
         eM3/2yi8KIUVrMlXtTpaiRBlUbI3lfDxC4MJDk9Z1kqO4+VbZ8gk97iNSuAp73Yqwzoa
         e7IGNse6B0SVNK/pXwuuY63ia2gdJuXaymwzEK3cyD6ELJD74XC7YSteaNc499RS1w7+
         Y2HA==
X-Gm-Message-State: ANhLgQ1Ntfqz6P4oIeybpLg4e2SLEFX6bZrziW6cYRzWipEqdrqBPMS9
        psAowfOQgexAEU9SUJr0S4E8IBARQ2AE/aRUpbB8VS3JY2KsKOYaRQJG/GP3/hDlIBvwVf0JrIa
        aM17u0//xRu+p
X-Received: by 2002:adf:a54a:: with SMTP id j10mr33957039wrb.188.1585007795333;
        Mon, 23 Mar 2020 16:56:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtA2yqwy0OwlfJUMK17zDbiP8PQ7IbBWxWzAUrDpK93gZxWeKy0DQaWOZHLglMy/9Tmdrqomw==
X-Received: by 2002:adf:a54a:: with SMTP id j10mr33957012wrb.188.1585007795099;
        Mon, 23 Mar 2020 16:56:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id t16sm23019727wra.17.2020.03.23.16.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 16:56:34 -0700 (PDT)
Subject: Re: [PATCH v3 05/37] KVM: x86: Export kvm_propagate_fault() (as
 kvm_inject_emulated_page_fault)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-6-sean.j.christopherson@intel.com>
 <87sghz844a.fsf@vitty.brq.redhat.com>
 <20200323162433.GM28711@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7012fd88-5590-e50d-cee2-d14fb54ce742@redhat.com>
Date:   Tue, 24 Mar 2020 00:56:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200323162433.GM28711@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 17:24, Sean Christopherson wrote:
>> We don't seem to use the return value a lot, actually,
>> inject_emulated_exception() seems to be the only one, the rest just call
>> it without checking the return value. Judging by the new name, I'd guess
>> that the function returns whether it was able to inject the exception or
>> not but this doesn't seem to be the case. My suggestion would then be to
>> make it return 'void' and return 'fault->nested_page_fault' separately
>> in inject_emulated_exception().
> Oooh, I like that idea.  The return from the common helper also confuses me
> every time I look at it.
> 

Separate patch, please.  I'm not sure it makes a great difference though.

Paolo

